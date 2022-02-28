@IsTest
private class TestAccountRestService {
        
    @IsTest 
    static void testGetCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result = AccountRestService.getAccount('0010900000U9InOAAV');
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');
        Map<String, Object> results = (Map<String, Object>) 
            JSON.deserializeUntyped(result.getBody());
        List<Object> accounts = results.values();
        System.assertEquals(1, accounts.size(), 'The array should only contain 1 item.');          
    }
    
    @IsTest 
    static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock());
        AccountRestService.NewAccountRequestWrapper newAccount = new AccountRestService.NewAccountRequestWrapper();
        newAccount.name = 'GenePoint';
        newAccount.phone = '(650) 867-3450';
        newAccount.type = 'Customer - Channel';
        newAccount.billingStreet = '345 Shoreline Park\nMountain View, CA 94043\nUSA';
      	newAccount.billingCity = 'Mountain View';
        newAccount.billingState = 'CA';
        newAccount.billingPostalCode = '220000';
        newAccount.billingCountry = 'USA';
        newAccount.industry = 'Biotechnology';
        HttpResponse response = AccountRestService.addAccount(newAccount);
        String contentType = response.getHeader('Content-Type');
        System.assertEquals(AccountHttpCalloutMock.BODY, response.getBody());
        System.assertEquals(200, response.getStatusCode());
    }
    
    @IsTest 
    static void testDeleteCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result = AccountRestService.deleteAccount('0010900000U9InOAAV');
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');
    }
    
    @IsTest 
	static void testPatchCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        AccountRestService.NewAccountRequestWrapper updatedAccount = new AccountRestService.NewAccountRequestWrapper();
        updatedAccount.id = '0010900000U9InOAAV';
        updatedAccount.name = 'GenePointTest';
        updatedAccount.phone = '9909990';
        HttpResponse result = AccountRestService.updateAccount(updatedAccount);
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');
    }
    
    @IsTest 
	static void testPutCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        AccountRestService.NewAccountRequestWrapper upsertedAccount = new AccountRestService.NewAccountRequestWrapper();
        upsertedAccount.name = 'GenePointTest1';
        upsertedAccount.phone = '33434333';
        HttpResponse result = AccountRestService.upsertAccount(upsertedAccount);
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');
    }
}