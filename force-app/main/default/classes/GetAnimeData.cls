global with sharing class GetAnimeData implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    Integer round = 0;

    global Database.Querylocator start(Database.BatchableContext BC) {
        String soql = 'SELECT Id, BangumiID__c FROM Anime__c WHERE NumberOfEpisode__c = NULL';
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

                BangumiAPI bangumiAPI = new BangumiAPI();
                String response = bangumiAPI.animeDataAPI(bangumiID);
                Map<String, Object> animeData = (Map<String, Object>) JSON.deserializeUntyped(
                    response
                );

                Integer eps = (Integer)animeData.get('eps');
                Map<String, Object> ratingMap = (Map<String, Object>) animeData.get('rating');
                Decimal score = (Decimal) ratingMap.get('score');
                
                thisAnime.NumberOfEpisode__c = eps;
                thisAnime.AnimeScore__c = score;

                animeListToUpsert.add(thisAnime);
            }

            upsert animeListToUpsert;

        } catch (Exception e) {
            throw e;
        }
    }

    global void finish(Database.BatchableContext BC) {
        round++;
        System.debug(round);
    }

}