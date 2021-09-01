import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunityData from '@salesforce/apex/LWCCommonData.getoptyData';
import getRestCalloutData from '@salesforce/apex/LWCCommonData.getRestCalloutData';



const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [{
        label: "Name",  
        fieldName: "recordLink",  
        type: "url",  
        typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_self" }
    }   ,
    { label: 'StageName', fieldName: 'StageName', type: 'picklist' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Closed Date', fieldName: 'CloseDate', type: 'date' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class AccOptyHierarchy extends NavigationMixin(LightningElement) {
    data = [];
    columns = columns;
    record = {};
    showRecordEdit = false;
    optyRecordId = '';
    cancelLabel = 'Cancel';
    confirmLabel = 'Confirm';
    title = 'Edit Opportunity';
    // eslint-disable-next-line @lwc/lwc/no-async-await
    async connectedCallback() {
        getOpportunityData().then(result => {
            /*const tempOppList = [];  
            for (var i = 0; i < result.length; i++) {  
                let tempRecord = Object.assign({}, result[i]); //cloning object  
                tempRecord.recordLink = "/" + tempRecord.Id;  
                tempOppList.push(tempRecord);  
            }  
            this.data = tempOppList;*/
            this.data = result;
            this.data.forEach(function(value,index){
                value.recordLink = '/' + value.Id;
            });

            console.log('Data : ', this.data);

        }).catch(error => {
            console.log(error.body.message);
        });

         
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        //const fields = event.detail.fields;
        //fields.LastName = 'My Custom Last Name'; // modify a field
        this.template.querySelector('lightning-record-form').submit();
     }

     handleSuccess(event) {
        let messageT = {
            _title: "Opportunity updated",
            message: "Record ID: " + event.detail.id,
            variant: "success",
        };
        const toastElement = this.template.querySelector('c-show-my-toast');
        toastElement.showToastDisplayHandler(messageT);
    } 

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'edit':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    deleteRow(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    showRowDetails(row) {
        this.optyRecordId = row.Id;
        this.showRecordEdit = true;
        console.log('----->', this.optyRecordId);
        //this.record = JSON.parse(JSON.stringify(row));
        // View a custom object record.
        /*this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Opportunity', // objectApiName is optional
                actionName: 'view'
            }
        });*/
    }

    getRestDataHandler(event){
        getRestCalloutData().then(result => {
            console.log('result -< ', result);
        }).catch(error => {
            console.log(error.body.message);
        });
        console.log('111');
    }

    // for modal
    content = '<p><h3>The</h3></p><h2> modal content</h3></p><p> <lightning-icon icon-name="standard:opportunity" size="small" class="slds-m-right_xx-small"></lightning-icon></p>';
    header = 'The modal header';
    showModelHandler(event){
        this.handleShowModal();
    }

    handleHeaderChange(event) {
        this.header = event.target.value;
    }

    handleContentChange(event) {
        this.content = event.target.value;
    }

    handleShowModal() {
        const modal = this.template.querySelector('c-modal');
        modal.show();
    }

    handleCancelModal() {
        this.showRecordEdit = false;
        const modal = this.template.querySelector('c-modal');
        modal.hide();
    }

    handleCloseModal() {
        this.showRecordEdit = false;
        const modal = this.template.querySelector('c-modal');
        modal.hide();
    }

    //********************* Toast */
    showToastHandler(event){
        let messageT = {
            _title: "Sample Title",
            message: "Sample Message Body",
            variant: "success",
        };
        const toastElement = this.template.querySelector('c-show-my-toast');
        toastElement.showToastDisplayHandler(messageT);
    }
}