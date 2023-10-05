public class GetIndexData {
    public void getIndexIntro() {

        List<AnimeIndex__c> animeIndexList = new List<AnimeIndex__c>();

        for (String animeIndex : IndexCache.animeIndexStrings) {
            BangumiAPI bangumiAPI = new BangumiAPI();
            String response = bangumiAPI.indexIntroAPI(animeIndex);
            Map<String, Object> indexData = (Map<String, Object>) JSON.deserializeUntyped(
                response
            );
    
            AnimeIndex__c animeIndexIntro = new  AnimeIndex__c();
            String title = (String) indexData.get('title');
            String[] parts = title.split('月');
            String name = parts[0] + '月';
            animeIndexIntro.Name = name;
            animeIndexIntro.NumberOfAnime__c = (Integer) indexData.get('total');
            animeIndexIntro.IndexId__c = animeIndex;
    
            animeIndexList.add(animeIndexIntro);
        }

        System.debug(animeIndexList.size());
        insert animeIndexList;
    }
}