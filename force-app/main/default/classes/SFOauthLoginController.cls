public class SFOauthLoginController {
    /*
     <iframe src="https://login.salesforce.com/secur/logout.jsp" width="0" height="0" style="display:none;"></iframe>
          <iframe src="https://test.salesforce.com/secur/logout.jsp" width="0" height="0" style="display:none;"></iframe>
          <iframe src="{{ instance_url }}/secur/logout.jsp" width="0" height="0" style="display:none;"></iframe>
*/
    public string token {get;set;}
    public string code {get;set;}
    public static String CLIENTID = '3MVG9fe4g9fhX0E4qTEidjuXsWA4HdrLWMQtHxQxrTryZGScd3BRxGXD75_luOvFLK3r9AxTWpbGwxBKGkoa2';
    public static String CLIENTSECRET = '98CFD12BC850C74B3201B89B0F093EFF07EBE8B3A4AFFF069F0632AA5044D92E';
    public static String RED_URI = 'https://spartancode-dev-ed--c.visualforce.com/apex/SFOauthLogin';
    public SFOauthLoginController(){
        token = 'https://login.salesforce.com/services/oauth2/authorize?client_id=' + CLIENTID +
            '&redirect_uri=' + RED_URI +
            '&response_type=code';
        system.debug('URL ' + ApexPages.currentPage().getparameters());
        code = ApexPages.currentPage().getparameters().get('code');
        System.debug('Code ' + code);
        code = ApexPages.currentPage().getparameters().get('refresh_token');
        System.debug('Code ' + code);
    }
    public PageReference callLogin(){
        String endpointUrl1='https://login.salesforce.com/services/oauth2/authorize?client_id=' + CLIENTID +
            '&redirect_uri=' + RED_URI +
            '&response_type=token';
        pageReference pag=new pageReference(endpointUrl1);
        pag.setRedirect(true);
        return pag;
    }
}