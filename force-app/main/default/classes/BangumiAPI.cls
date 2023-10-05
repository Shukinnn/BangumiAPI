public with sharing class BangumiAPI {

    public String indexIntroAPI(String indexID) {

        String endPoint = 'https://api.bgm.tv/v0/indices/';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String url;

        url = endPoint + indexID;
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer 1jUgSddw6ABB0OIooO2A4TaZoDTFMPJeS25chWj3');
        request.setTimeout(120000); //APIの待ち時間:120s

        response = http.send(request);
        string responseBody = response.getBody();
        return responseBody;
    }

    //https://api.bgm.tv/v0/indices/45995/subjects?limit=50&offset=0
    public String animeIntroAPI(String indexID,String offset) {

        String endPoint = 'https://api.bgm.tv/v0/indices/';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String url;

        url = endPoint + indexID + '/subjects?limit=50&offset=' + offset;
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', '*/*');
        request.setHeader('Authorization', 'Bearer 1jUgSddw6ABB0OIooO2A4TaZoDTFMPJeS25chWj3');
        request.setTimeout(120000); //APIの待ち時間:120s

        response = http.send(request);
        string responseBody = response.getBody();
        return responseBody;
    }

        // https://api.bgm.tv/v0/subjects/365437
        public String animeDataAPI(String animeID) {

            String endPoint = 'https://api.bgm.tv/v0/subjects/';
    
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            String url;
    
            url = endPoint + animeID;
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer 1jUgSddw6ABB0OIooO2A4TaZoDTFMPJeS25chWj3');
            request.setTimeout(120000); //APIの待ち時間:120s
    
            response = http.send(request);
            string responseBody = response.getBody();
            return responseBody;
        }

        // https://api.bgm.tv/v0/episodes?subject_id=425591&limit=100&offset=0
        public String episodesDataAPI(String animeID) {

            String endPoint = 'https://api.bgm.tv/v0/episodes?subject_id=';
    
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            String url;
    
            url = endPoint + animeID + '&limit=100&offset=0';
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer 1jUgSddw6ABB0OIooO2A4TaZoDTFMPJeS25chWj3');
            request.setTimeout(120000); //APIの待ち時間:120s
    
            response = http.send(request);
            string responseBody = response.getBody();
            return responseBody;
        }
}
