import { LightningElement, track } from 'lwc';
export default class GetAccounts extends LightningElement {
    @track accList = [{Name: "Account1", Id: "A-101", Status: "Pending", Website: "www.account101.com"}, 
    {Name: "Account2", Id: "A-102", Status: "In Progress", Website: "www.account102.com"}];
}