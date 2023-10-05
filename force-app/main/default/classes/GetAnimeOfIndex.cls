public class GetAnimeOfIndex {
    public void getAnimeIntro(Integer i) {
        List<AnimeIndex__c> indexList = [SELECT Id,Name,NumberOfAnime__c,IndexId__c FROM AnimeIndex__c ORDER BY CreatedDate];
        System.debug(indexList.size());
        // for(AnimeIndex__c animeIndex :indexList){
            List<String> animeIdList = new List<String>();

            BangumiAPI bangumiAPI = new BangumiAPI();
            String response = bangumiAPI.animeIntroAPI(indexList[i].IndexId__c,'0');
            Map<String, Object> animeData = (Map<String, Object>) JSON.deserializeUntyped(
                response
            );
            List<Object> animeList = new List<Object>();
            animeList = (List<Object>) animeData.get('data');
            System.debug(animeList.size());

            String response2;
            List<Object> animeList2 = new List<Object>();
            if (indexList[i].NumberOfAnime__c > 50){
                response2 = bangumiAPI.animeIntroAPI(indexList[i].IndexId__c,'50');
                Map<String, Object> animeData2 = (Map<String, Object>) JSON.deserializeUntyped(
                    response2
                );
                animeList2 = (List<Object>) animeData2.get('data');
            }
            animeList.addAll(animeList2);

            List<Anime__c> myAnimeList = new List<Anime__c>();
            for (Object obj : animeList) {
                Map<String, Object> mapObj = (Map<String, Object>) obj;
                Anime__c anime = new Anime__c();

                anime.BangumiID__c = String.valueOf(mapObj.get('id'));
                anime.Name = (String) mapObj.get('name');
                anime.AirDate__c = 	(String) mapObj.get('date');
                anime.Index__c = indexList[i].Id;
                animeIdList.add(anime.BangumiID__c);
                myAnimeList.add(anime);
            }
            System.debug('myAnimeList.size()'+myAnimeList.size());
            upsert myAnimeList;

            String commaSeparatedIds = String.join(animeIdList, ',');
            indexList[i].AnimeIdList__c = commaSeparatedIds;
            update indexList[i];
            System.debug('animeIdList'+commaSeparatedIds);
            System.debug(animeIdList.size());

        // }

    }
}