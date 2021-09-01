/*
{"access_token":"ucvqxwTqtmle5RtZdHTw4usstYVjRqoU","expires_in":3778,"restricted_to":[],"refresh_token":"Eu7UJ2KwJ4DPSRQLRRLciW29VKX0tyD0gpV6IpV38fa1imoNx970Nps3Pc2n1Tdb","token_type":"bearer"}
*/
global class InfoTrails {
    public String str {get;set;}
    public InfoTrails(){
        str = 'Inside ###@@@';
        system.debug('Inside ###@@@');
        String receiptId = System.currentPageReference().getParameters().get('code');
        system.debug('Inside ###@@@ Receipt 00 ' + receiptId);
        if(receiptId!= '' && receiptId!= null){
            str = receiptId;
        }
        
        String token1 = System.currentPageReference().getParameters().get('access_token');
        system.debug('Inside ###@@@ Receipt 00 ' + receiptId);
        if(token1!= '' && token1!= null){
            str = token1;
        }
    } 
    
   
    public String save() {
        
        Http channelReq = new Http();
        HttpRequest req = new HttpRequest();
        string endpointUrl='https://account.box.com/api/oauth2/authorize?response_type=code&client_id=7eyaaxpy6byao53cgafl0yhindl2391j&redirect_uri=https://spartancode-dev-ed--c.visualforce.com/apex/InfoTrails';
        req.setHeader('Content-type','application/x-www-form-urlencoded');
                
        req.setMethod('GET');
        req.setEndpoint(endpointUrl);
        req.setTimeout(120000);
        //Send request to Box
        HTTPResponse res=channelReq.send(req);
        System.debug('*response body:'+res.getBody());
        string Response=res.getBody();
        
        System.debug(Response);
        return Response;
		//upsert coll;
		//PageReference pref = new ApexPages.StandardController(coll).view();
		//return pref;
	}
	/*
	 Recruitment App: https://trailhead.salesforce.com/en/content/learn/trails/build-platform-apps-in-lightning-experience 
	 
*/ 
    public string clientId;
     public String clientSecret;
     public String redirecturi {
      Set;
      get;
     }
     public string code {
      set;
      get;
     }
     public String folderId;
     public String accessToken {
      set;
      get;
     }
     public String folderInfo {
      Set;
      get;
     }

     /* public feedItemtrigger_Handler(){
          //'https://ap5.salesforce.com/apex/BoxResponsePage';
          redirectUri='https://ap4.developer--c.cs44.visual.force.com/apex/BoxResponse?core.apexpages.request.devconsole=1';
      }*/
     public PageReference requestCode() {
      clientId = '7eyaaxpy6byao53cgafl0yhindl2391j';
      clientSecret = '';
      redirectUri = 'https://spartancode-dev-ed--c.visualforce.com/apex/InfoTrails';
      String url = 'https://account.box.com/api/oauth2/authorize?';
      url = url + 'response_type=code&client_id=' + clientId + '&redirect_uri=' + redirectUri + '&state=annnd';
      PageReference p = new PageReference(url);
      return p;
     }

     public void getCodes() {
      code = ApexPages.currentPage().getParameters().get('code');
     }

     public void requestAccessToken() {
      //String clientId = BoxCCredentials__c.getValues('BoxTest').Client_Id__c;
      code = 'gxpmpMG9zJGbQO4snDxSnm4Ho12dgncu ';
      Http p = new Http();
      String url = 'https://api.box.com/oauth2/token';
      String body = 'grant_type=authorization_code';
      body = body + '&client_id=' + clientId;
      body = body + '&client_secret=' + clientSecret;
      body = body + '&code=' + code;
      HttpRequest request = new HttpRequest();
      request.setEndPoint(url);
      request.setMethod('POST');
      request.setBody(body);
      HttpResponse response = p.send(request);
      System.JSONParser jp = JSON.createParser(response.getBody());
      while (jp.nextToken() != null) {
       if (jp.getText() == 'access_token') {
        jp.nextToken();
        accessToken = jp.getText();
       }
      }
     }
}