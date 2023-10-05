global with sharing class AnalyzeData implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    global Database.Querylocator start(Database.BatchableContext BC) {
        //String soql = 'SELECT Id,EpCommentMap__c,CommentAverage__c FROM Anime__c WHERE CommentAverage__c >= 10.0 AND NumberOfEpisode__c > 3';
        String soql = 'SELECT Id,EpCommentMap__c,CommentAverage__c FROM Anime__c WHERE Id = \'a005j00000QK9sqAAD\'';
        return Database.getQueryLocator(soql);
    }

    global void execute(
        Database.BatchableContext BC,
        List<Anime__c> animeList
    ) {

        try {
            List<Anime__c> animeListToUpsert = new List<Anime__c>();

            for (Integer i = 0; i < animeList.size(); i++) {
                Anime__c thisAnime = animeList[i];
                String 	inputString = animeList[i].EpCommentMap__c;

                String[] parts = inputString.split(';');
                // 创建一个映射来存储数据和对应的编号
                Map<Integer, Integer> dataToIndexMap = new Map<Integer, Integer>();
                for (String part : parts) {
                    String[] values = part.split(',');
                    Integer index = Integer.valueOf(values[0]);
                    Integer data = Integer.valueOf(values[1]);
                    dataToIndexMap.put(data, index);
                }
                // 获取数据并排序
                List<Integer> dataList = new List<Integer>(dataToIndexMap.keySet());

                Double mean = animeList[i].CommentAverage__c;
                Double sumOfSquaredDifferences = 0.0;
        
                for (Integer data : dataList) {
                    Double difference = (Double)data - mean;
                    sumOfSquaredDifferences += difference * difference;
                }

                Double variance =  sumOfSquaredDifferences / dataList.size();
                thisAnime.Variance__c = variance;

                dataList.sort();
                // 获取最大的三个数据及其对应的编号
                List<Integer> maxThreeData = new List<Integer>();
                List<Integer> maxThreeIndices = new List<Integer>();
                
                Integer dataListSize = dataList.size();
                for (Integer j = 1; j <= 3 && j <= dataListSize; j++) {
                    Integer data = dataList[dataListSize - j];
                    Integer index = dataToIndexMap.get(data);
                    maxThreeData.add(data);
                    maxThreeIndices.add(index);
                }

                // List<Integer> dataList2 = new List<Integer>(dataToIndexMap.keySet());
                // Integer maxChangeIndex = null; // 存储变化最大的数据的索引
                // Integer maxChange = 0; // 存储最大的变化值
                // for (Integer j = 1; j < dataList2.size(); j++) {
                //     Integer dataCurrent = dataList2[j];
                //     Integer dataPrevious = dataList2[j - 1];
                //     Integer change = Math.abs(dataCurrent - dataPrevious);
                    
                //     if (change > maxChange) {
                //         maxChange = change;
                //         maxChangeIndex = j;
                //     }
                // }
                // if (maxChangeIndex != null) {
                //     Integer maxChangeData = dataList[maxChangeIndex];
                //     Integer maxChangeIndexOriginal = dataToIndexMap.get(maxChangeData);
                //     thisAnime.ChangeE__c = maxChangeIndexOriginal;
                //     thisAnime.Change__c = maxChange;
                //     System.debug('变化最大的数据是 ' + maxChangeData + '，对应的原始索引是 ' + maxChangeIndexOriginal + '，变化值为 ' + maxChange);
                // } 

                thisAnime.TOP1c__c = maxThreeData[0];
                thisAnime.TOP1e__c = maxThreeIndices[0];
                thisAnime.TOP2c__c = maxThreeData[1];
                thisAnime.TOP2e__c = maxThreeIndices[1];
                thisAnime.TOP3c__c = maxThreeData[2];
                thisAnime.TOP3e__c = maxThreeIndices[2];
                thisAnime.ENDc__c = dataList[0];
                thisAnime.ENDe__c = dataToIndexMap.get(dataList[0]);            
                animeListToUpsert.add(thisAnime);
            }
            upsert animeListToUpsert;

        } catch (Exception e) {
            throw e;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('处理结束');
    }

}