public class BoxAuthJWT{
    
    public static String getAccessToken(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint('https://api.box.com/oauth2/token');
        req.setMethod('POST');
        
        req.setHeader('ContentType','application/x-www-form-urlencoded');
        
        String header = '{"alg":"RS256","typ":"JWT"}';
        String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));
        //AutomationUser_1542891_aB4VDmtyS5@boxdevedition.com
        String claim_set = '{"iss":"9ss9sfbxp0snfisbudkneb3y5m2pxscs"';
        claim_set += ',"box_sub_type":"enterprise","sub":"821720131"';
        claim_set += ',"aud":"https://api.box.com/oauth2/token"';
        claim_set += ',"exp":"' + datetime.now().addHours(1).getTime()/1000; // One hour
        claim_set += '","jti": "AHcq1oZ7E1jwqOuv"}';
        
        String claim_set_encoded = EncodingUtil.base64Encode(blob.valueof(claim_set));
        
        String signature_encoded = header_encoded + '.' + claim_set_encoded;
        
        String key = 'MIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIIhyWXZj/swECAggA\nMBQGCCqGSIb3DQMHBA' +
            'h8qJE+iq3n4ASCBMiKmw0L3oFp/Q3S8M3/BNBUZMKVK2qc\n9zNw9HnVkjR6CB4ftjX8NYjUfP2gr0xtXix67WTupcYFVV' + 
            'YlP0xZlnNwkkj1yGee\nWlUK9nejrU90v9AuOn+BZPdhIrYzL4XhFbTgNculRPDw29ug4a5xIgjUwGsm/hRU\nfeFYZmYxt' +
            'b1zfDYRiz1B+dM0rQJv5LQlYWsoeDe3tOSW4P1zDCA4wsrwdf2dtll8\n5tt6gu6fU7XPqrII3XJVZEySUrLoiYUJq45vzFy' +
            'Vax9q+ChoqrzaB7XF2pK+gIMZ\n3YSJHWByauDkCZ2T4xMlIoaFnRZr71HRmb8xdY/ygobX+0hK3kL4ltbfrJgksrhb\nmvV' +
            'ERbwDD0XGvpOo1Hc7pT5QrstIsJmQRc14m4LZVDHmcvFCWGU8Q1DT/IpVSEZF\nCYgQQ27yTKxp3QY9FOkMo8lEqIitbMWbwk' +
            'ZAGoaHciSRYowQNv5nAdR6mZYdZJLC\nF3wVk/UUYvkZAdzkkNTm/a7+C36l2Tl9SPFNa8biLFipZ+bvY0wa2K9SWUc5eS3g\n0' +
            'PANaRcvLxSldzohdx2eyCCbAOoxHbRfYOTQ0akd02K8JzDwMOcE2lSdMm/Ct9pz\nTiUZJO2WkWrRC/chN4KjEeA3kokSKxK9I8' +
            'l4lM6jw96DX9Qn3U3z80OLpnlSel+d\nLyhSUIGYRd137dNYGy7KlIurdY6OaHn42Z8IvPa9sU8cOvunkfEXgb3scU268sp2\nI' +
            'sVQuFkIfthkibJWsr0Rj1Atb+2pIHTGARQCCBNQfAoKr74uD7eutZqRgFdoPGGD\nyXUc32yzu8ymp/ymjuqgdRAKk0YKsEmr+B' +
            'ov5ETg42FSkESLWqG+oVNERRQtzqxM\nbjVlYDyu1T0a9O+LeQFPeW/HYPjZ2MJkMcPd5YL49MG9iuZRdgC1v3e/aq4DIshF\nN' +
            'OS+k+hD3juesn8bg3PPZmkXlUSGuhUIaabYuLYzBp5KsBUXewr9fbM7LmF5dQmv\nJdnMsNr9guiJanBmvh2M7QAXte1vXr5HVR' +
            'PiWZMw+DCeQRhatSBnX183rioQpjmD\nGf187g03XyuTh++GQCYfD0Dww5rub09nUXefc0AdK+2pww770oE2Rv7bqGRm9aQc\nV' +
            'YufPzj7mX56ogtyNPWy4Ftf+csv9YoSvxwhJjgfthgJ3L7I7tyUeLBm+C4eQytn\ndz8MzhkkjkQ3HqaayknEFDYygX7LJSnOMS' +
            '9m3IuJDnuUk7NBwhD6Qw09eoBWyRTe\nlVGZTIMRV3AaHiGCrZBn8xevXwPdrzPTl0Af+jpRelNej6asMyBiAuYtWn2vNVlv\nD' +
            '6k56NNj/kZmV24ImXS2g4YNQXhcmmiuXPE+yF4ZSiSdti6M28Qn+lGCuCE0oH9p\nr0yF72lIBUbTYrYfe1vgR/PrPruEk4iXuD' +
            'nPUJPSCXgUpOegzY8dJrLezfx0zjE2\neejjIuqPc2PjviDbZnhrao2bwLBK1LFGx8HfktiZcvwiXtjKD0cfDr5Oo+xyZRn/\nK' +
            'znXShbBNoDMFcWnt9//puCpvI4PJe/JU2hwnM9x4ChR5nFbV2fTG7co7xBLRf6x\nlp3GFSbBzDANeToEJEnmNgd1gxWvQlhR3j' +
            'abEsT/etOvSi/U+5TM/VMu6Zt+Pf+C\nbI0=';
        //key = key.replace('\\n','');
        blob private_key = EncodingUtil.base64Decode(key);
        signature_encoded = signature_encoded.replaceAll('=','');
        signature_encoded = signature_encoded.replaceAll('\\+','-');
        signature_encoded = signature_encoded.replaceAll('\\/','_');
        String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
        blob signature_blob =   blob.valueof(signature_encoded_url);
        
        String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));
        
        String JWT = signature_encoded + '.' + signature_blob_string;
        
        JWT = JWT.replaceAll('=','');
        JWT = JWT.replaceAll('\\+','-');
        JWT = JWT.replaceAll('\\/','_');
        
        String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        req.setBody('grant_type=' + EncodingUtil.urlEncode(grant_string, 'UTF-8') + '&assertion=' + EncodingUtil.urlEncode(JWT, 'UTF-8'));
        res = h.send(req);
        String response_debug = res.getBody() +' '+ res.getStatusCode();
        System.debug('Response =' + response_debug );
        if(res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    // Move to the value.
                    parser.nextToken();
                    // Return the access_token
                    
                    System.debug('parser get text is '+parser.getText());
                    return parser.getText();
                }
            }
        }
        return 'error';
    }
    public static void connectWithBox(){
        //replace with your app client id
        String clientId = '9ss9sfbxp0snfisbudkneb3y5m2pxscs'; 
        //replace with your app client secret
        String clientSecret = '5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX'; 
        String endpoint = 'https://api.box.com/oauth2/token';
        String iss = clientId;
        String aud = endpoint;
        
        String sub = '821720131'; //replace Enterprise Id

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

        String jwtClaims = '{"iss":"' + iss +'","jti":"AutomationUser_1542891_aB4VDmtyS5@boxdevedition.com","box_sub_type":"enterprise","sub":"' + sub + '","aud":"' + aud + '","exp":' + exp + '}';
        system.debug(jwtClaims);
        String jwtRequest = System.encodingUtil.base64Encode(Blob.valueOf(jwtHeader)).replace('+', '-').replace('/', '_') + '.' + System.encodingUtil.base64Encode(Blob.valueOf(jwtClaims)).replace('+', '-').replace('/', '_');

        String signature = System.encodingUtil.base64Encode(Crypto.signWithCertificate('RSA-SHA256', Blob.valueOf(jwtRequest), 'jwt'));//.replace('+', '-').replace('/', '_');
        String signedJwtRequest = jwtRequest + '.' + signature;

        // The JWT is fully constructed, now it's time to make the call to get the access token.

        String payload = 'grant_type=' + System.EncodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer', 'UTF-8');
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
}