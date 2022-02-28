@isTest
global class AccountHttpCalloutMock implements HttpCalloutMock {
    public static final String BODY = '{"Name":"GenePoint","Type":"Customer - Channel","BillingStreet":"345 Shoreline Park\nMountain View, CA 94043\nUSA",'+
        								'"BillingCity":"Mountain View","BillingState":"CA","BillingPostalCode":"220000""BillingCountry":"USA",'+
        								'"Industry":"Biotechnology","Phone":"(650) 867-3450"}';
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(BODY);
        response.setStatusCode(200);
        return response; 
    }
}