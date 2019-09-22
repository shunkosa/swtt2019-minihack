public with sharing class BillingAddressVerificationImpl implements Queueable, Database.AllowsCallouts {
    private List<Account> accounts;
    
    public BillingAddressVerificationImpl(List<Account> accounts) {
        this.accounts = accounts;
    }

    public void execute(QueueableContext context) {
        for (Account account : accounts) {
            verify(account);
        }
        update accounts;
    }

    private void verify(Account account) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:TDX19');
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json');
        request.setBody(buildRequestBody(account));
        Http http = new Http();
        HttpResponse response = http.send(request);

        //レスポンスはOKの前提
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        account.BillingAddressVerificationStatus__c = String.valueOf(result.get('status'));
    }

    private String buildRequestBody(Account account){
        Map<String, String> requestMap = new Map<String, String>();
        requestMap.put('street', account.BillingStreet);
        requestMap.put('city', account.BillingCity);
        requestMap.put('state', account.BillingState);
        requestMap.put('postal_code', account.BillingPostalCode);
        return JSON.serialize(requestMap);
    }
}
