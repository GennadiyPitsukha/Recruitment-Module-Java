public class AccountRestService {
    public static Http http = new Http();
    public static HTTPResponse response;
    public static HttpRequest request;
 
    public class NewAccountRequestWrapper {
        public String id {get; set;}
        public String name {get; set;}
        public String phone {get; set;}
        public String type {get; set;}
        public String billingStreet {get; set;}
        public String billingCity {get; set;}
        public String billingState {get; set;}
        public String billingPostalCode {get; set;}
        public String billingCountry {get; set;}
        public String industry {get; set;}
    }
 
    public static HTTPResponse getAccount(Id accountId) {
        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:EnotCorp/services/apexrest/Account/' + accountId);
        response = http.send(request); 
        System.debug(response.getBody());
        return response;
    }
 
    public static HTTPResponse addAccount(NewAccountRequestWrapper newAccount) {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:EnotCorp/services/apexrest/Account');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
        response = http.send(request); 
        System.debug(response.getBody());
        return response;
    }
 
    public static HTTPResponse deleteAccount(Id accountId) {
        request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('callout:EnotCorp/services/apexrest/Account/' + accountId);
        response = http.send(request); 
        System.debug(response.getBody());
        return response;
    }
    
     public static HTTPResponse updateAccount(NewAccountRequestWrapper updatedAccount) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        request.setEndpoint('callout:EnotCorp/services/apexrest/Account/' + updatedAccount.id);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(updatedAccount));
        response = http.send(request); 
        System.debug(response.getBody());
        return response;
    }
    
        public static HTTPResponse upsertAccount(NewAccountRequestWrapper upsertedAccount) {
        request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('callout:EnotCorp/services/apexrest/Account');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(upsertedAccount));
        response = http.send(request); 
        System.debug(response.getBody());
        return response;
    }
}