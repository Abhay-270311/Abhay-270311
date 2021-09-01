public class InfoBoxIntegrationSteps {
/*
 * For Reading file xlsx in javascript/lwc use sheet.js
 * https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.13.5/xlsx.full.min.js  --> Sheet Js ; modify var XLSX to have windlow.xlsx added
 * refer https://docs.sheetjs.com/ for code sample 
 * Return data in content version with base 64 encode
 1. Create Free account with Box
 2. Login to Box and click on Developer Console
 3. Create new App (OAuth, JWT etc). Here I created oAuth
 4. Give the redirect URL from SF; Allow Domains; Get Client Id, Client Secret; Employee Id, Enterprise Id
 5. In Salesforce Make sure you add URLs to whitelist 
	a. If using LWC then make sure you add the urls to CSP secure content to allow self-src, content-src etc
 6. Authentication using oAuth
	Make request to get Code:https://app.box.com/api/oauth2/authorize?response_type=code
	Make Request to get Access token/refresh token:https://app.box.com/api/oauth2/token?code=<code received in auth request>
	Make sub sequence request to get refresh token when prev token is expired:https://app.box.com/api/oauth2/token

 7. Get file
	Make request to get Folder if required
	Make request to get files in folder
	
	For files get need two request:
	1st request return the file location in response header : 
		https://api.box.com/2.0/files/<file Id>/content
		res.getHeader('Location')
	2nd request to location url return the response with file content
	
 */
}