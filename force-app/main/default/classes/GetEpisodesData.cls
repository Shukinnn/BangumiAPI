global with sharing class GetEpisodesData implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    Integer round = 0;

    global Database.Querylocator start(Database.BatchableContext BC) {
        String soql = 'SELECT Id, BangumiID__c,NumberOfEpisode__c FROM Anime__c WHERE NumberOfEpisode__c >= 1 AND NumberOfEpisode__c <= 30 AND TotalComment__c = 0';
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
                String 	bangumiID = animeList[i].BangumiID__c;
                Integer totalComment = 0;
                String EpCommentMap = '';

                BangumiAPI bangumiAPI = new BangumiAPI();
                String response = bangumiAPI.episodesDataAPI(bangumiID);
                Map<String, Object> animeData = (Map<String, Object>) JSON.deserializeUntyped(
                    response
                );
                
                List<Object> episodeList = new List<Object>();
                episodeList = (List<Object>) animeData.get('data');

                // for (Integer j = 0; j < animeList[i].NumberOfEpisode__c; j++) {     
                for (Integer j = 0; j < episodeList.size(); j++) {            
                    Map<String, Object> mapObj = (Map<String, Object>) episodeList[j];

                    Integer eps;
                    // Integer eps = (Integer) mapObj.get('ep');
                    Decimal epsValue =(Decimal) animeData.get('eps');
                    if (epsValue.scale() == 0) {
                        // 值是整数
                        eps = (Integer) mapObj.get('ep');
                        Integer comments = (Integer) mapObj.get('comment');
                        totalComment += comments;
                        EpCommentMap += eps + ',' + comments + ';';
                    }
                }
                
                thisAnime.EpCommentMap__c = EpCommentMap;
                thisAnime.TotalComment__c = totalComment;

                animeListToUpsert.add(thisAnime);
            }

            upsert animeListToUpsert;

        } catch (Exception e) {
            throw e;
        }
    }

    global void finish(Database.BatchableContext BC) {

        System.debug('数据获取完成');
    }

}