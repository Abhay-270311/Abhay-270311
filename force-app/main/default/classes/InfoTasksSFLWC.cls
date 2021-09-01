public class InfoTasksSFLWC {
    
    /*

Create Wrapper Classes for Below Responses
{ "reason" : "INVALID_USER_AUTHENTICATION", "message" : "Failed to authenticate principal, password was invalid"}
{ "expand" : "attributes", "link" : { "rel" : "self", "href" : "http://localhost:8095/crowd/rest/usermanagement/1/user?username=my_username" }, "name" : "my_username", "first-name" : "My", "last-name" : "Username", "display-name" : "My Username", "email" : "user@example.test", "password" : { "link" : { "rel" : "edit", "href" : "http://localhost:8095/crowd/rest/usermanagement/1/user/password?username=my_username" } }, "active" : true, "attributes" : { "link" : { "rel" : "self", "href" : "http://localhost:8095/crowd/rest/usermanagement/1/user/attribute?username=my_username" }, "attributes" : [] }}
{ "username" : "my_username", "password" : "my_password", "validation-factors" : { "validationFactors" : [ { "name" : "remote_address", "value" : "127.0.0.1" } ] }}
{ "restriction-type": "property-search-restriction", "property": { "name": "name", "type": "STRING" }, "match-mode": "EXACTLY_MATCHES", "value": "admin"}

Create LWC
List of all object - drop down
On select of object display list of the fields - Multi Select
A button to show permissions of the selected fields
Data table to display selected field permissions


Use Case: SF to Rally Two way Integration
If a case is created in Sf -> Create new ticket in Rally [ Create free account with Rally /Atlassian]
If the Ticket is created in Rally -> Create new case in SF
New filed in SF Case -> To store the Rally Ticket Id
New filed in Rally User story -> to store sf case Id
You can use Rest from SF to Rally and Web hook from Rally to SF ( rest resource)

Use Case: Need a mechanism to track the expected close date on opportunity
Create New fields on Opportunity
Expected End Date: Date
Notification Sent Count: Number(2)
Create a metadata to store below values
No. of days to start sending custom notifications
Counter for maximum notification sent count against the opportunity


Create a batch 
Fetch all the opportunity which had expected date set and it is falling in the range specified in metadata
For eligible opportunities create custom notification for the opportunity owner to take action
Increase the count for notification sent on opportunity
Create a Scheduler
Run the batch job from schedule
Set the scheduler to run everyday at 1 AM in the morning


Use Case: Generate excel from opportunity data using LWC action
Create LWC:
On click it should show the Loading Icon with message as 'Your excel is getting generated...'
The Excel should get generated and available for download
Once excel is available the spinner /loading icon will be hidden
On click of download image the excel should get down loaded
Excel Format: [If possible try giving background color to Field Name cells]


Sr.No.
	
Field Name
	
Value


1
	
Opportunity Name
	
Test Opportunity


2
	
Amount
	
$20,000


3
	
Expected Close Date
	
2021-07-12


like wise any 10 fields...
IMP : Create a function which will accept object name and fields (List of string), this will make the function generic for any object; Field Labels should be capitalized and as per field data type the value should be formatted
Create Action on Opportunity using above LWC
     */ 

}