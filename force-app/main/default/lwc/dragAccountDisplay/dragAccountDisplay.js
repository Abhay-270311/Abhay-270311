/* eslint-disable no-console */
import { LightningElement, wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';
import getAccountLocations from '@salesforce/apex/AccountHelper.getAccountLocations';


let i=0;
let accountId; //store id from the div
let selectedAccount; //store selected account

export default class DragAccountDisplay extends LightningElement {
    
    //get page reference
    @wire(CurrentPageReference) pageRef;
    
    constructor() {
        super();
        //register dragover event to the template
        this.template.addEventListener('dragover', this.handleDragOver.bind(this));
    }
    
    //retrieve account records from database via Apex class
    @wire(getAccountLocations) accounts;

    //when drag is start this method fires
    handleDragStart(event) {
        event.dataTransfer.dropEffect = 'move';
        
        //retrieve AccountId from div
        accountId = event.target.dataset.item;
        //console.log('event.target.dataset.item=' + event.target.dataset.item);

        //loop the array, match the AccountId and retrieve the account record
        for(i=0; i<this.accounts.data.length; i++) {
            if(accountId!==null && accountId === this.accounts.data[i].Id){
                selectedAccount = this.accounts.data[i];               
            }                                                         
        } 

        //fire an event to the subscribers
        fireEvent(this.pageRef, 'selectedAccountDrop', selectedAccount);
    }

    handleDragOver(event){
        event.dataTransfer.dropEffect = 'move';
        event.preventDefault();       
    }    
}