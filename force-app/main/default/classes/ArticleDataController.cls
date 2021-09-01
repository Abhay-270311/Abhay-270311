public without sharing class ArticleDataController {
    
    @AuraEnabled(cacheable =true)
    public static list<articles> callNewsPoint(){ 
        
        /** Tip: Currently this query is all hardcoded. Use custom settings/labels to store parameters in actual implementations! **/
        String endpoint ='https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=83521c49abfc4b698b98cd46918d78af';
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        HTTPResponse res = h.send(req);
        ArticleWrapper artWrap = (ArticleWrapper) JSON.deserialize(res.getBody(), ArticleWrapper.class);
     
        list<articles> artRecs= new list<articles>();
        integer i;
        /** arousel works best with 5 images so limiting to 5 articles in the Widget **/
        for(i=0;i<5;i++){
          artRecs.add(artWrap.articles[i]);
        }
        return artRecs;

   }

   // Test variable used for holding the values of the Continuation.state requests
   @TestVisible
   private static String continuationLabel1;
   @TestVisible
   private static String continuationLabel2;

   // The function to be called to fire the continuation
   @AuraEnabled(continuation=true ) // cacheable=true)
   public static Object startConinuation() {
       // Create the callout Request
       HttpRequest req1 = new HttpRequest();
       req1.setMethod('GET');
       req1.setEndpoint('https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=83521c49abfc4b698b98cd46918d78af');

      // HttpRequest req2 = new HttpRequest();
      // req2.setMethod('GET');
      // req2.setEndpoint('<some other URL or callout:NamedCredential here>');

       // Create the continuation with a 40s timeout
       Continuation con = new Continuation(40);
       con.ContinuationMethod = 'continuationCallback';
        
       // Store the references to the requests and make them accessible for a test-context
       continuationLabel1 = con.addHttpRequest(req1);
       //continuationLabel2 = con.addHttpRequest(req2);

       return con;
   }

   // The function that will process the callback of the Continuation
   @AuraEnabled(cacheable=false)
   public static Object continuationCallback(List<String> labels, Object state) {
       // Get the response of the first HttpRequest
       HttpResponse response1 = Continuation.getResponse(labels[0]);
       Integer statusCode1 = response1.getStatusCode();
       // TODO: handle the different status codes for statusCode1
        
       // Get the response of the second HttpRequest
      // HttpResponse response2 = Continuation.getResponse(labels[1]);
      // Integer statusCode2 = response2.getStatusCode();
       // TODO: handle the different status codes for statusCode2
       ArticleWrapper artWrap = (ArticleWrapper) JSON.deserialize(response1.getBody(), ArticleWrapper.class);
       system.debug('artWrap112' + artWrap);
       return 'MyResponse:: '  + statusCode1;
   }
 
/**Below is the Wrapper Model created from sample JSON response using JSON2Apex link shared in Blog **/   
  public class ArticleWrapper{
		@AuraEnabled public Integer totalResults{get;set;}
		@AuraEnabled public list<articles> articles {get;set;}
		@AuraEnabled public String status{get;set;}
  }
  
  public class source{
		@AuraEnabled public String id{get;set;}
		@AuraEnabled public String name{get;set;}
  }
 
	public class articles{
		@AuraEnabled public String title{get;set;}
		@AuraEnabled public String url{get;set;}
		@AuraEnabled public String urlToImage{get;set;}
		@AuraEnabled public String description{get;set;}
		@AuraEnabled public String publishedAt{get;set;}
		@AuraEnabled public String author{get;set;}
		@AuraEnabled public String content{get;set;}
		@AuraEnabled public source source{get;set;}
	}
}