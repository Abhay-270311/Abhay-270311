import { LightningElement, track, wire } from 'lwc';
import getAcctData from '@salesforce/apex/LWCCommonData.getAcctData';
import getoptyData from '@salesforce/apex/LWCCommonData.getoptyData';

export default class LookupHolder extends LightningElement {
    @track error;
    @track accounts = [];
    @track showAccLookup = true;
    @track opps = [];
    @track showOppLookup = true;
    @track selectedAccId;
    @track selectedOppId;


    @wire(getAcctData)
    wiredContacts({ error, data }) {
        console.log('Wired data');
        if (data) {
            console.log('Wired data 1', data);
        } else if (error) {
            console.log('Wired error data', error);
        }
    }

    @wire(getAcctData)
    wAccs({error,data}){
        if(data){
            console.log('Wired data 2', data);
            for(let i=0; i<data.length; i++){
                let obj = {value: data[i].Id, label: data[i].Name};
                this.accounts.push(obj);
            }
            this.showAccLookup = true;
        }else{
            console.log('Wired error data 2', error);
            this.error = error;
        }       
    }
    @wire(getoptyData)
    wOpps({error,data}){
        if(data){
            for(let i=0; i<data.length; i++){
                let obj = {value: data[i].Id, label: data[i].Name};
                this.opps.push(obj);
            }
            this.showOppLookup = true;
        }else{
            this.error = error;
        }       
    }
 
 //On Account lookup change
    handleAccSelection(event){
        let selectedOption = event.detail;
        this.selectedAccId = selectedOption.value;
    }
 
 
 //On Opportunity lookup change
    handleOppSelection(event){
        let selectedOption = event.detail;
        this.selectedOppId = selectedOption.value;
    }
}