public class SFJira {
    
    public class sfjirawrapper{
        string id;
        string key;
    }
	// API Token - kCKISgwguoSCpiMou8f851D7
    public static void callJira(String methodType){
	HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http h = new Http();
        // Configure the request
        //req.setEndpoint('https://sfdevabhay.atlassian.net/rest/api/2/issue/SFJIR-1');
        if(methodType == 'POST'){
            req.setEndpoint('callout:jirenc/rest/api/2/issue/');
        }else if(methodType == 'PUT'){
            req.setEndpoint('callout:jirenc/rest/api/3/issue/SFJIR-4');
        }else {
          req.setEndpoint('callout:jirenc/rest/api/2/issue/SFJIR-1?fields=summary,priority,description');  
        }
        
        req.setMethod(methodType);
        req.setTimeout(120000);
        String username = 'alalpotu@gmail.com';
    	String password = 'kCKISgwguoSCpiMou8f851D7';
        // Add basic authentication to header
        // Create blob of user:pass
        Blob headerValue = Blob.valueOf(username + ':' + password);
        // Base 64 Encode the blob and prepend "Basic "
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        // Add the basic auth string to the Request Header
        //req.setHeader('Authorization', authorizationHeader);    
        if (methodType == 'POST' || methodType == 'PUT' ) {
            req.setHeader('Content-Type', 'application/json');
            //req.setHeader('Accept', 'application/json');
            if(methodType == 'PUT'){
                /*req.setBody('{"field": {' +
        '"priority": {' +
            '"name": "High"' +
        '}}}');*/
                req.setBody('{"update":{"summary":[{"set":"Big block via REST API 55"}]}}');
            } else {
            	req.setBody('{"fields":{' +
                       '"project":' +
                       '{' +
                          '"key": "SFJIR"' +
                       '},' +
                       '"summary": "REST Name Create POST Request",' +
                       '"description": "Creating of an issue using project keys and issue type names using the REST API",' +
                       '"issuetype": {' +
                          '"name": "Bug"' +
                        '}}}');

            }
        } 
		res = h.send(req);
    	system.debug(res.getBody());
        //sfjirawrapper wrapperinstance = (sfjirawrapper )JSON.deserialize(res.getBody(), sfjirawrapper.class); // Jsonstring is the above JSON
		//System.debug(wrapperinstance);
        // Configure standard headers
       // req.setHeader('Accept', '*/*');
        // This tells the API that we are sending and receiving the data as a JSON object 
       // req.setHeader('Content-Type', 'application/json');
       // req.setBody('{"text" : "' + description + '"}');
    }
}