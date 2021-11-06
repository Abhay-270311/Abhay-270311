import { LightningElement,wire,track } from 'lwc';
import getaccounts from '@salesforce/apex/AccountController.getaccount';
import getOpps from '@salesforce/apex/AccountController.getOpps';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

let selacc = ""
const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        
    }, 
    {
        label: 'Amount',
        fieldName: 'Amount',
        type: 'currency',
        cellAttributes: 
        { class: 'slds-text-color_success slds-text-title_caps'}
    },
    {
        label: 'StageName',
        fieldName: 'StageName',
        type: 'text'
    },
    {
        label: 'Edit Oppty.',
        type: "button", 
        cellAttributes: { alignment: 'center' },
        typeAttributes: {  
        label: 'Edit',  
        name: 'Edit',  
        title: 'Edit',  
        disabled: false,  
        value: 'edit'
        
    }
    }  

    
    ];

export default class AccountRelatedOpps extends LightningElement {
@track recId;
@track accselect;
@track searchData;
@track bShowModal = false;
@track isEditForm = false;
@track emptyData = "true";
@track columns = columns;

refreshTable;


    @wire(getaccounts) accounts;
    changeHandler(event){
        this.accselect = event.target.value;
        selacc = this.accselect;
        getOpps(
            {id : this.accselect}
        ).then(
                result => {
                    if(result.length == 0){
                    this.emptyData = "";
                    this.searchData = "";
                    window.console.log('if'+this.searchData);
                    }
                    else{
                    this.searchData = result;
                    
                    window.console.log('else'+JSON.stringify(this.searchData));
                    this.emptyData = "true";
                    }
                }

                
            )
        
    }
    closeModal() {
        this.bShowModal = false;
    }
    callRowAction(event){

        

        this.bShowModal = true;
        this.isEditForm = true;

        // assign record id to the record edit form
        this.recId =  event.detail.row.Id;
        

        }

        handleSubmit(event) {
            window.console.log('test');
        // prevending default type sumbit of record edit form
        event.preventDefault();

        // querying the record edit form and submiting fields to form
        this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
        window.console.log('test2');
        // closing modal
        this.bShowModal = false;
        window.console.log('selacc'+selacc);

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!!',
            message: 'Opportunity updated Successfully!!!',
            variant: 'success'
        }));
        
        

        // showing success message
        

    }

    handleSuccess() {

        window.console.log('In handle success');
        getOpps(
            {id : selacc}
        ).then(
                result => {
                    if(result.length == 0){
                    this.emptyData = "";
                    this.searchData = "";
                    window.console.log('if'+this.searchData);
                    }
                    else{
                    this.searchData = result;
                    //this.refreshTable = result;
                    window.console.log('else2'+JSON.stringify(this.searchData));
                    this.emptyData = "true";
                    }
            }     
        )

        window.console.log('good'+JSON.stringify(this.refreshTable));


        
        //return refreshApex(this.refreshTable);
    }

        //eval("$A.get('e.force:refreshView').fire();"); 
}