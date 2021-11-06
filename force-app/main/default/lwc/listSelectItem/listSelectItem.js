import { LightningElement, track } from 'lwc';
import getOpportunityData from '@salesforce/apex/LWCCommonData.getoptyData';
const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    {
        label: "",
        name: "selectbox" ,
        fieldName: "Id",  
        type: "button-icon",  
        typeAttributes: { variant: { fieldName: 'variant1' }, iconName:{ fieldName: 'iconName1' } }
    }, 
    {
        label: "Name",  
        fieldName: "Name",  
        type: "text",  
    }   ,
    { label: 'StageName', fieldName: 'StageName', type: 'picklist' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Closed Date', fieldName: 'CloseDate', type: 'date' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class ListSelectItem extends LightningElement {
    @track data = [];
    columns = columns;
    record = {};
    showRecordEdit = false;
    optyRecordId = '';
    cancelLabel = 'Cancel';
    confirmLabel = 'Confirm';
    title = 'Edit Opportunity';
    showdata = true;
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
            //this.data = [{"Id":"0065g000002aawGAAQ","Name":"SF2SF","StageName":"Perception Analysis","CloseDate":"2021-04-20","variant1":"brand","iconName1":"utility:check"},{"Id":"0065g00000AEWvgAAH","Name":"Master","StageName":"Prospecting","CloseDate":"2021-08-01","variant1":"brand","iconName1":"utility:add"},{"Id":"0065g00000AEWvhAAH","Name":"Parent1","StageName":"Prospecting","CloseDate":"2021-08-27","variant1":"brand","iconName1":"utility:check"},{"Id":"0065g00000AEWviAAH","Name":"Parent3","StageName":"Prospecting","CloseDate":"2021-08-27","variant1":"brand","iconName1":"utility:add"}];
            let cnt = 1;
            this.data.forEach(function(value,index){

                value.variant1 = 'brand';
                if( cnt % 2 == 0)
                    value.iconName1 = 'utility:add';                   
                else
                    value.iconName1 = 'utility:check';

                cnt++; 
            });

            console.log('Data : ', this.data);

        }).catch(error => {
            console.log(error.body.message);
        });

         
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
        //this.showdata = false;
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(event.detail);
        console.log('Row CCC --> ', JSON.stringify(row));
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'edit':
                this.showRowDetails(row);
                break;
            default:
        }

        
        let _rw = JSON.parse(JSON.stringify(row));
       /* let objIndex = this.data.findIndex((obj => obj.Id == _rw.Id));

        _rw.iconName1 = 'utility:check';
        this.data[objIndex] = _rw;
        console.log('Row -- ' + JSON.stringify(this.data[objIndex]));
        let newarray = this.data;
        console.log('Row -- ' + JSON.stringify(newarray[objIndex]));
        newarray.forEach
        this.data = newarray;*/
        
        this.data.forEach(ele => {
                if(ele.Id === _rw.Id){
                    if(ele.iconName1.includes('check') )
                        ele.iconName1 = 'utility:add';
                    else
                        ele.iconName1 = 'utility:check';
                }
            });
        
        //this.data[objIndex]['iconName1'] = 'utility:check';
        //console.log(JSON.stringify(element));
        //this.data[objIndex] = JSON.parse(JSON.stringify(element));
        this.data = [...this.data];
        //this.showdata = true;
        //console.log('Row -- ' + JSON.stringify(this.data));
        
    }

    deleteRow(row) {
        const { id } = row;
        console.log('Id -- ', id);
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
}