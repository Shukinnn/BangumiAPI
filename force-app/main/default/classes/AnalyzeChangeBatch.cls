global with sharing class AnalyzeChangeBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    global Database.Querylocator start(Database.BatchableContext BC) {
        String soql = 'SELECT Id,EpCommentMap__c,CommentAverage__c FROM Anime__c WHERE CommentAverage__c >= 10.0 AND NumberOfEpisode__c > 3';
        //String soql = 'SELECT Id,EpCommentMap__c,CommentAverage__c FROM Anime__c WHERE Id = \'a005j00000QK9sqAAD\'';
        return Database.getQueryLocator(soql);
    }

    global void execute(
        Database.BatchableContext BC,
        List<Anime__c> animeList
    ) {

        try {
            List<Anime__c> animeListToUpsert = new List<Anime__c>();

            for (Integer j = 0; j < animeList.size(); j++) {
                Anime__c thisAnime = animeList[j];
                String 	inputString = animeList[j].EpCommentMap__c;

                // 使用分号和逗号分割字符串
                String[] parts = inputString.split(';');
                
                // 创建映射来存储数据和对应的编号
                Map<Integer, Integer> dataToIndexMap = new Map<Integer, Integer>();
                for (String part : parts) {
                    String[] values = part.split(',');
                    Integer index = Integer.valueOf(values[0]);
                    Integer data = Integer.valueOf(values[1]);
                    dataToIndexMap.put(data, index);
                }
                
                // 获取数据并计算与前一项的差值，同时保存正负号
                List<Integer> dataList = new List<Integer>(dataToIndexMap.keySet());
                System.debug(dataList);
                List<Integer> changes = new List<Integer>();
                
                for (Integer i = 1; i < dataList.size(); i++) {
                    Integer dataCurrent = dataList[i];
                    Integer dataPrevious = dataList[i - 1];
                    Integer change = dataCurrent - dataPrevious;
                    changes.add(change);
                }
                
                // 找到正数变化最大的数据
                Integer maxPositiveChangeIndex = null;
                Integer maxPositiveChange = 0;
                
                for (Integer i = 0; i < changes.size(); i++) {
                    Integer change = changes[i];
                    if (change > maxPositiveChange) {
                        maxPositiveChange = change;
                        maxPositiveChangeIndex = i + 1; // 添加1来获得对应的数据的索引
                    }
                }
                
                // 找到负数变化最小的数据
                Integer maxNegativeChangeIndex = null;
                Integer maxNegativeChange = 0;
                
                for (Integer i = 0; i < changes.size(); i++) {
                    Integer change = changes[i];
                    if (change < maxNegativeChange) {
                        maxNegativeChange = change;
                        maxNegativeChangeIndex = i + 1; // 添加1来获得对应的数据的索引
                    }
                }
                
                // 打印结果
                if (maxPositiveChangeIndex != null) {
                    Integer maxPositiveChangeData = dataList[maxPositiveChangeIndex];
                    Integer maxPositiveChangeIndexOriginal = dataToIndexMap.get(maxPositiveChangeData);
                    thisAnime.ChangeUP__c = maxPositiveChange;
                    thisAnime.ChangeEUP__c = maxPositiveChangeIndexOriginal;
                    System.debug('正数变化最大的数据是 ' + maxPositiveChangeData + '，对应的原始索引是 ' + maxPositiveChangeIndexOriginal + '，变化值为 ' + maxPositiveChange);
                } else {
                    System.debug('没有找到正数变化最大的数据。');
                }
                
                if (maxNegativeChangeIndex != null) {
                    Integer maxNegativeChangeData = dataList[maxNegativeChangeIndex];
                    Integer maxNegativeChangeIndexOriginal = dataToIndexMap.get(maxNegativeChangeData);
                    thisAnime.ChangeDown__c = maxNegativeChange;
                    thisAnime.ChangeEDown__c = maxNegativeChangeIndexOriginal;
                    System.debug('负数变化最小的数据是 ' + maxNegativeChangeData + '，对应的原始索引是 ' + maxNegativeChangeIndexOriginal + '，变化值为 ' + maxNegativeChange);
                } else {
                    System.debug('没有找到负数变化最小的数据。');
                }
                


    
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