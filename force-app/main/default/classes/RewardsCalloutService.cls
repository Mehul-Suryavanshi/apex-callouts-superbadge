public class RewardsCalloutService{
    
    public static Integer submitUsersForRewardCallout(String jsonBody) {
        //Set Endpoint from Named Credential
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards');
        req.setMethod('POST');
        req.setBody(jsonBody);
        //Make HTTP Callout
        try{
            
        	HttpResponse response = http.send(req);
            return response.getStatusCode();
        } catch(Exception ex){
            return 500;
        }  
    }
}