public class BoxAuthenticationUsingJWT{
    /*
* 
"https://api.box.com/oauth2/token" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "client_id=[CLIENT_ID]" \
-d "client_secret=[CLIENT_SECRET]" \
-d "code=[CODE]" \
-d "grant_type=authorization_code"

KsiEC9ARvRrsIKZaJRj00xLR0JHy7FVA
--------------------------------------------------------------
String clientId = '7eyaaxpy6byao53cgafl0yhindl2391j';
String clientSecret = 'cezjP0r6unwf1h4aWBOtsXNWOGl9znRx';
String code = 'qkOs4wJLE7xeKPLNwxVeO90dlatOYTGn';
Http channelReq = new Http();
HttpRequest req = new HttpRequest();
string endpointUrl='https://api.box.com/oauth2/token';
req.setHeader('Content-type','application/x-www-form-urlencoded');
req.setbody('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=7eyaaxpy6byao53cgafl0yhindl2391j&redirect_uri=https://spartancode-dev-ed--c.visualforce.com/apex/InfoTrails'
);
req.setMethod('POST');
req.setEndpoint(endpointUrl);
req.setTimeout(120000);
//Send request to Box
HTTPResponse res=channelReq.send(req);
System.debug('*response body:'+res.getBody());
string Response=res.getBody();
System.debug(Response);
* 
*/
    public static String jsonstr = '{' +
  '"boxAppSettings": {' +
    '"clientID": "9ss9sfbxp0snfisbudkneb3y5m2pxscs",' +
    '"clientSecret": "5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX",' +
    '"appAuth": {' +
      '"publicKeyID": "rx05f840",' +
      '"privateKey": "-----BEGIN RSA PRIVATE KEY-----\nMIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIIhyWXZj/swECAggA\nMBQGCCqGSIb3DQMHBAh8qJE+iq3n4ASCBMiKmw0L3oFp/Q3S8M3/BNBUZMKVK2qc\n9zNw9HnVkjR6CB4ftjX8NYjUfP2gr0xtXix67WTupcYFVVYlP0xZlnNwkkj1yGee\nWlUK9nejrU90v9AuOn+BZPdhIrYzL4XhFbTgNculRPDw29ug4a5xIgjUwGsm/hRU\nfeFYZmYxtb1zfDYRiz1B+dM0rQJv5LQlYWsoeDe3tOSW4P1zDCA4wsrwdf2dtll8\n5tt6gu6fU7XPqrII3XJVZEySUrLoiYUJq45vzFyVax9q+ChoqrzaB7XF2pK+gIMZ\n3YSJHWByauDkCZ2T4xMlIoaFnRZr71HRmb8xdY/ygobX+0hK3kL4ltbfrJgksrhb\nmvVERbwDD0XGvpOo1Hc7pT5QrstIsJmQRc14m4LZVDHmcvFCWGU8Q1DT/IpVSEZF\nCYgQQ27yTKxp3QY9FOkMo8lEqIitbMWbwkZAGoaHciSRYowQNv5nAdR6mZYdZJLC\nF3wVk/UUYvkZAdzkkNTm/a7+C36l2Tl9SPFNa8biLFipZ+bvY0wa2K9SWUc5eS3g\n0PANaRcvLxSldzohdx2eyCCbAOoxHbRfYOTQ0akd02K8JzDwMOcE2lSdMm/Ct9pz\nTiUZJO2WkWrRC/chN4KjEeA3kokSKxK9I8l4lM6jw96DX9Qn3U3z80OLpnlSel+d\nLyhSUIGYRd137dNYGy7KlIurdY6OaHn42Z8IvPa9sU8cOvunkfEXgb3scU268sp2\nIsVQuFkIfthkibJWsr0Rj1Atb+2pIHTGARQCCBNQfAoKr74uD7eutZqRgFdoPGGD\nyXUc32yzu8ymp/ymjuqgdRAKk0YKsEmr+Bov5ETg42FSkESLWqG+oVNERRQtzqxM\nbjVlYDyu1T0a9O+LeQFPeW/HYPjZ2MJkMcPd5YL49MG9iuZRdgC1v3e/aq4DIshF\nNOS+k+hD3juesn8bg3PPZmkXlUSGuhUIaabYuLYzBp5KsBUXewr9fbM7LmF5dQmv\nJdnMsNr9guiJanBmvh2M7QAXte1vXr5HVRPiWZMw+DCeQRhatSBnX183rioQpjmD\nGf187g03XyuTh++GQCYfD0Dww5rub09nUXefc0AdK+2pww770oE2Rv7bqGRm9aQc\nVYufPzj7mX56ogtyNPWy4Ftf+csv9YoSvxwhJjgfthgJ3L7I7tyUeLBm+C4eQytn\ndz8MzhkkjkQ3HqaayknEFDYygX7LJSnOMS9m3IuJDnuUk7NBwhD6Qw09eoBWyRTe\nlVGZTIMRV3AaHiGCrZBn8xevXwPdrzPTl0Af+jpRelNej6asMyBiAuYtWn2vNVlv\nD6k56NNj/kZmV24ImXS2g4YNQXhcmmiuXPE+yF4ZSiSdti6M28Qn+lGCuCE0oH9p\nr0yF72lIBUbTYrYfe1vgR/PrPruEk4iXuDnPUJPSCXgUpOegzY8dJrLezfx0zjE2\neejjIuqPc2PjviDbZnhrao2bwLBK1LFGx8HfktiZcvwiXtjKD0cfDr5Oo+xyZRn/\nKznXShbBNoDMFcWnt9//puCpvI4PJe/JU2hwnM9x4ChR5nFbV2fTG7co7xBLRf6x\nlp3GFSbBzDANeToEJEnmNgd1gxWvQlhR3jabEsT/etOvSi/U+5TM/VMu6Zt+Pf+C\nbI0=-----END RSA PRIVATE KEY-----\n",' +
      '"passphrase": "196a164605dc8312951b5f19957ba49e"' +
    '}' +
  '},"enterpriseID": "821720131"' +'}';

    public static void accessTokenRequest(){
        
        Http channelReq = new Http();
        HttpRequest req = new HttpRequest();
        string endpointUrl='https://api.box.com/oauth2/token' ;//?'+
            //'grant_type=authorization_code' +
           // '&client_id=7eyaaxpy6byao53cgafl0yhindl2391j' +
           // '&client_secret=cezjP0r6unwf1h4aWBOtsXNWOGl9znRx' +
           // '&code=PDO1wc5brEt05vfP3E9Mtix6yJnzMvcV'
            //'&redirect_uri=https://spartancode-dev-ed--c.visualforce.com/apex/InfoTrails'
           // '&response_type=token'
          //  ;
       req.setHeader('Content-Type','application/x-www-form-urlencoded');
        //req.setHeader('client_id','7eyaaxpy6byao53cgafl0yhindl2391j');
        //req.setHeader('client_secret','cezjP0r6unwf1h4aWBOtsXNWOGl9znRx');
        //req.setHeader('code','KsiEC9ARvRrsIKZaJRj00xLR0JHy7FVA');
        //req.setHeader('grant_type','authorization_code');
       // req.setbody('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=7eyaaxpy6byao53cgafl0yhindl2391j&redirect_uri=https://spartancode-dev-ed--c.visualforce.com/apex/InfoTrails'
//);
        req.setMethod('POST');
        req.setEndpoint(endpointUrl);
        req.setTimeout(120000);
        req.setbody('grant_type=authorization_code&client_id=7eyaaxpy6byao53cgafl0yhindl2391j&client_secret=cezjP0r6unwf1h4aWBOtsXNWOGl9znRx&code=bSPJ72idOIxjiJxZwXaTaO0vTWNcvF57');
        //Send request to Box
        req.setHeader('Accept','application/json');
        HTTPResponse res=channelReq.send(req);
        System.debug('*response body:'+res.getBody());
        string Response=res.getBody();
        System.debug(Response);
        
    }
    public static void connectWithBox(){
        
        /* KEy value pair generated from JWT App
         {
  "boxAppSettings": {
    "clientID": "9ss9sfbxp0snfisbudkneb3y5m2pxscs",
    "clientSecret": "5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX",
    "appAuth": {
      "publicKeyID": "rx05f840",
      "privateKey": "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIIhyWXZj/swECAggA\nMBQGCCqGSIb3DQMHBAh8qJE+iq3n4ASCBMiKmw0L3oFp/Q3S8M3/BNBUZMKVK2qc\n9zNw9HnVkjR6CB4ftjX8NYjUfP2gr0xtXix67WTupcYFVVYlP0xZlnNwkkj1yGee\nWlUK9nejrU90v9AuOn+BZPdhIrYzL4XhFbTgNculRPDw29ug4a5xIgjUwGsm/hRU\nfeFYZmYxtb1zfDYRiz1B+dM0rQJv5LQlYWsoeDe3tOSW4P1zDCA4wsrwdf2dtll8\n5tt6gu6fU7XPqrII3XJVZEySUrLoiYUJq45vzFyVax9q+ChoqrzaB7XF2pK+gIMZ\n3YSJHWByauDkCZ2T4xMlIoaFnRZr71HRmb8xdY/ygobX+0hK3kL4ltbfrJgksrhb\nmvVERbwDD0XGvpOo1Hc7pT5QrstIsJmQRc14m4LZVDHmcvFCWGU8Q1DT/IpVSEZF\nCYgQQ27yTKxp3QY9FOkMo8lEqIitbMWbwkZAGoaHciSRYowQNv5nAdR6mZYdZJLC\nF3wVk/UUYvkZAdzkkNTm/a7+C36l2Tl9SPFNa8biLFipZ+bvY0wa2K9SWUc5eS3g\n0PANaRcvLxSldzohdx2eyCCbAOoxHbRfYOTQ0akd02K8JzDwMOcE2lSdMm/Ct9pz\nTiUZJO2WkWrRC/chN4KjEeA3kokSKxK9I8l4lM6jw96DX9Qn3U3z80OLpnlSel+d\nLyhSUIGYRd137dNYGy7KlIurdY6OaHn42Z8IvPa9sU8cOvunkfEXgb3scU268sp2\nIsVQuFkIfthkibJWsr0Rj1Atb+2pIHTGARQCCBNQfAoKr74uD7eutZqRgFdoPGGD\nyXUc32yzu8ymp/ymjuqgdRAKk0YKsEmr+Bov5ETg42FSkESLWqG+oVNERRQtzqxM\nbjVlYDyu1T0a9O+LeQFPeW/HYPjZ2MJkMcPd5YL49MG9iuZRdgC1v3e/aq4DIshF\nNOS+k+hD3juesn8bg3PPZmkXlUSGuhUIaabYuLYzBp5KsBUXewr9fbM7LmF5dQmv\nJdnMsNr9guiJanBmvh2M7QAXte1vXr5HVRPiWZMw+DCeQRhatSBnX183rioQpjmD\nGf187g03XyuTh++GQCYfD0Dww5rub09nUXefc0AdK+2pww770oE2Rv7bqGRm9aQc\nVYufPzj7mX56ogtyNPWy4Ftf+csv9YoSvxwhJjgfthgJ3L7I7tyUeLBm+C4eQytn\ndz8MzhkkjkQ3HqaayknEFDYygX7LJSnOMS9m3IuJDnuUk7NBwhD6Qw09eoBWyRTe\nlVGZTIMRV3AaHiGCrZBn8xevXwPdrzPTl0Af+jpRelNej6asMyBiAuYtWn2vNVlv\nD6k56NNj/kZmV24ImXS2g4YNQXhcmmiuXPE+yF4ZSiSdti6M28Qn+lGCuCE0oH9p\nr0yF72lIBUbTYrYfe1vgR/PrPruEk4iXuDnPUJPSCXgUpOegzY8dJrLezfx0zjE2\neejjIuqPc2PjviDbZnhrao2bwLBK1LFGx8HfktiZcvwiXtjKD0cfDr5Oo+xyZRn/\nKznXShbBNoDMFcWnt9//puCpvI4PJe/JU2hwnM9x4ChR5nFbV2fTG7co7xBLRf6x\nlp3GFSbBzDANeToEJEnmNgd1gxWvQlhR3jabEsT/etOvSi/U+5TM/VMu6Zt+Pf+C\nbI0=\n-----END ENCRYPTED PRIVATE KEY-----\n",
      "passphrase": "196a164605dc8312951b5f19957ba49e"
    }
  },
  "enterpriseID": "821720131"
}
*/
        //replace with your app client id
        String clientId = '9ss9sfbxp0snfisbudkneb3y5m2pxscs'; 
        //replace with your app client secret
        String clientSecret = '5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX'; 
        String endpoint = 'https://api.box.com/oauth2/token';
        String iss = clientId;
        String aud = endpoint;
        String sub = '821720131'; //replace Enterprise Id
        
        jsonstr = jsonstr.replace('\n','\\n');
        
        Config cg = (Config) JSON.deserialize(jsonStr, Config.Class);
        //system.debug(cg);
        //Long exp = DateTime.now().addhours(-8).addSeconds(30).getTime(); // Datetime.now is returning fiff time than what need JWT token 
        Auth.Jwt jwt = new Auth.Jwt();
        jwt.setValidityLength(60);
        String jwtRequestd = jwt.toJSONString();
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jwtRequestd);
        Long exp = (Long)m.get('exp');
        system.debug(jwtRequestd);
        
        system.debug(jwt.getValidityLength());
        // Start constructing the header and claims
        String jwtHeader = '{"typ":"JWT","alg":"RS256"}';
        String jtikey = encodingUtil.base64Encode(Blob.valueOf(math.random()+''));
       // String jwtClaims = '{"iss":"' + iss +'","jti":"' + UserInfo.getUserId() + '","sub":"' + sub + '","aud":"' + aud + '","exp":' + exp + '}';
        // box_subject_id   "kid":"rx05f840","box_sub_type":"enterprise",
 		String jwtClaims = '{"iss":"' + iss +'","jti":"AutomationUser_1542891_aB4VDmtyS5@boxdevedition.com","box_sub_type":"enterprise","sub":"' +
            sub + '","aud":"' + aud + '","kid":"rx05f840"' 
            + ',"exp":' + exp + '}';
        system.debug(jwtClaims);
        String jwtRequest = encodingUtil.base64Encode(Blob.valueOf(jwtHeader)).replace('+', '-').replace('/', '_') + '.' + encodingUtil.base64Encode(Blob.valueOf(jwtClaims)).replace('+', '-').replace('/', '_');
        system.debug('jwtRequest ' + jwtRequest);
       // String pvtKey = '-----BEGIN ENCRYPTED PRIVATE KEY-----MIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIIhyWXZj/swECAggAMBQGCCqGSIb3DQMHBAh8qJE+iq3n4ASCBMiKmw0L3oFp/Q3S8M3/BNBUZMKVK2qc9zNw9HnVkjR6CB4ftjX8NYjUfP2gr0xtXix67WTupcYFVVYlP0xZlnNwkkj1yGeeWlUK9nejrU90v9AuOn+BZPdhIrYzL4XhFbTgNculRPDw29ug4a5xIgjUwGsm/hRUfeFYZmYxtb1zfDYRiz1B+dM0rQJv5LQlYWsoeDe3tOSW4P1zDCA4wsrwdf2dtll85tt6gu6fU7XPqrII3XJVZEySUrLoiYUJq45vzFyVax9q+ChoqrzaB7XF2pK+gIMZ3YSJHWByauDkCZ2T4xMlIoaFnRZr71HRmb8xdY/ygobX+0hK3kL4ltbfrJgksrhbmvVERbwDD0XGvpOo1Hc7pT5QrstIsJmQRc14m4LZVDHmcvFCWGU8Q1DT/IpVSEZFCYgQQ27yTKxp3QY9FOkMo8lEqIitbMWbwkZAGoaHciSRYowQNv5nAdR6mZYdZJLCF3wVk/UUYvkZAdzkkNTm/a7+C36l2Tl9SPFNa8biLFipZ+bvY0wa2K9SWUc5eS3g0PANaRcvLxSldzohdx2eyCCbAOoxHbRfYOTQ0akd02K8JzDwMOcE2lSdMm/Ct9pzTiUZJO2WkWrRC/chN4KjEeA3kokSKxK9I8l4lM6jw96DX9Qn3U3z80OLpnlSel+dLyhSUIGYRd137dNYGy7KlIurdY6OaHn42Z8IvPa9sU8cOvunkfEXgb3scU268sp2IsVQuFkIfthkibJWsr0Rj1Atb+2pIHTGARQCCBNQfAoKr74uD7eutZqRgFdoPGGD\nyXUc32yzu8ymp/ymjuqgdRAKk0YKsEmr+Bov5ETg42FSkESLWqG+oVNERRQtzqxM\nbjVlYDyu1T0a9O+LeQFPeW/HYPjZ2MJkMcPd5YL49MG9iuZRdgC1v3e/aq4DIshF\nNOS+k+hD3juesn8bg3PPZmkXlUSGuhUIaabYuLYzBp5KsBUXewr9fbM7LmF5dQmv\nJdnMsNr9guiJanBmvh2M7QAXte1vXr5HVRPiWZMw+DCeQRhatSBnX183rioQpjmD\nGf187g03XyuTh++GQCYfD0Dww5rub09nUXefc0AdK+2pww770oE2Rv7bqGRm9aQc\nVYufPzj7mX56ogtyNPWy4Ftf+csv9YoSvxwhJjgfthgJ3L7I7tyUeLBm+C4eQytn\ndz8MzhkkjkQ3HqaayknEFDYygX7LJSnOMS9m3IuJDnuUk7NBwhD6Qw09eoBWyRTe\nlVGZTIMRV3AaHiGCrZBn8xevXwPdrzPTl0Af+jpRelNej6asMyBiAuYtWn2vNVlv\nD6k56NNj/kZmV24ImXS2g4YNQXhcmmiuXPE+yF4ZSiSdti6M28Qn+lGCuCE0oH9p\nr0yF72lIBUbTYrYfe1vgR/PrPruEk4iXuDnPUJPSCXgUpOegzY8dJrLezfx0zjE2\neejjIuqPc2PjviDbZnhrao2bwLBK1LFGx8HfktiZcvwiXtjKD0cfDr5Oo+xyZRn/\nKznXShbBNoDMFcWnt9//puCpvI4PJe/JU2hwnM9x4ChR5nFbV2fTG7co7xBLRf6x\nlp3GFSbBzDANeToEJEnmNgd1gxWvQlhR3jabEsT/etOvSi/U+5TM/VMu6Zt+Pf+C\nbI0=\n-----END ENCRYPTED PRIVATE KEY-----';
       // String signature = encodingUtil.base64Encode(Crypto.signWithCertificate('RSA-SHA256', Blob.valueOf(jwtRequest), 'JWT')).replace('+', '-').replace('/', '_');
        
        Blob pKey = EncodingUtil.base64Decode(cg.BoxAppSettings.appAuth.privateKey);
        Blob signature = Crypto.sign('RSA-SHA256', Blob.valueOf(jwtRequest), pKey);
        String signedJwtRequest = jwtRequest + '.' + EncodingUtil.base64Encode(signature);
        
        // The JWT is fully constructed, now it's time to make the call to get the access token.
        
        String payload = 'grant_type=' + EncodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer', 'UTF-8');
        payload += '&client_id='+clientId+'&client_secret='+clientSecret;
        payload += '&assertion=' + signedJwtRequest;
        
        
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(payload);
        
        res = httpObj.send(req);
        
        System.debug(res.getBody());
        
    }
    
    
    public static void usingClientIdSecret(){
        HttpRequest req = new HttpRequest();
        string endpointUrl='https://api.box.com/oauth2/token';
        req.setbody('grant_type=client_credentials'+
                    '&box_subject_type=enterprise'+
                    '&box_subject_id=821720131'+
                    '&client_id=9ss9sfbxp0snfisbudkneb3y5m2pxscs'+
                    '&client_secret=5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(endpointUrl);
        req.setTimeout(120000);
        //Send request to Box
        HTTPResponse res=performCallout(req);
        System.debug('*response body:'+res.getBody());
        string Response=res.getBody();
        System.debug(Response);
    }
    
    
    
    //static method to get access token from refresh token
    public static List<string> regenerateAccessToken(string clientId, string clientSecret, string refresh_token){
        list<string> tokenlist = new List<string>();
        HttpRequest req = new HttpRequest();
        string endpointUrl='https://api.box.com/oauth2/token';
        req.setbody('grant_type=refresh_token'+
                    '&refresh_token='+refresh_token+
                    '&client_id='+clientId+
                    '&client_secret='+clientSecret);
        req.setMethod('GET');
        req.setEndpoint(endpointUrl);
        req.setTimeout(120000);
        //Send request to Box
        HTTPResponse res=performCallout(req);
        System.debug('*response body:'+res.getBody());
        string Response=res.getBody();
        System.debug(Response);
        // Parse JSON response to get refresh_token values.
        JSONParser parser = JSON.createParser(Response);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'access_token') {
                    string newaccessToken=parser.getText();
                    tokenlist.add(newaccessToken);
                }if(fieldName == 'refresh_token') {
                    string newrefreshToken=parser.getText();
                    tokenlist.add(newrefreshToken);
                }
            }
        }
        system.debug('*****tokenlist:'+tokenlist);
        return tokenlist;
    }
    public static HttpResponse performCallout(Httprequest req){
        Http h1 = new Http();
        HttpResponse resp = new HttpResponse();
        if(!Test.isRunningTest()){
            resp= h1.send(req);
        }
        return resp;
    }
}