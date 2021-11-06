import { LightningElement, track } from 'lwc';

export default class CustomDatatableDemo extends LightningElement {

    @track data = [];
    //have this attribute to track data changed
    //with custom picklist or custom lookup
    @track draftValues = [];

    lastSavedData = [];

    connectedCallback() {
        this.columns = [
            { label: 'Name', fieldName: 'Name', editable: true },
            { label: 'Account Number', fieldName: 'AccountNumber', editable: true },
            { label: 'Phone', fieldName: 'phone', type: 'phone', editable: true },
            {
                label: 'Rating', fieldName: 'Rating', type: 'picklist', typeAttributes: {
                    placeholder: 'Choose rating', options: [
                        { label: 'Hot', value: 'Hot' },
                        { label: 'Warm', value: 'Warm' },
                        { label: 'Cold', value: 'Cold' },
                    ] // list of all picklist options
                    , value: { fieldName: 'Rating' } // default value for picklist
                    , context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
                }
            },
            {
                label: 'Parent', fieldName: 'ParentId', type: 'lookup', typeAttributes: {
                    placeholder: 'Select Parent Account',
                    uniqueId: { fieldName: 'Id' }, //pass Id of current record to lookup for context
                    object: "Account",
                    icon: "standard:account",
                    label: "Account",
                    displayFields: "Name, AccountNumber",
                    displayFormat: "Name (AccountNumber)",
                    filters: "",
                    valueId: { fieldName: 'ParentId' }
                }
            }
        ];

        //sample data
        this.data = [{ 'Id': '12345', 'Name': 'Acme', 'AccountNumber': 'CD355119-A', 'Rating': 'Hot', phone: 12537 }, { 'Id': '34567', 'Name': 'Mace', 'AccountNumber': 'CD355120-A', 'Rating': 'Cold', phone: 1978234 }];
        //save last saved copy
        this.lastSavedData = JSON.parse(JSON.stringify(this.data));
    }

    updateDataValues(updateItem) {
        let copyData = [... this.data];
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });

        //write changes back to original data
        this.data = [...copyData];
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    //listener handler to get the context and data
    //updates datatable
    picklistChanged(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem = { Id: dataRecieved.context, Rating: dataRecieved.value };
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    handleSelection(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem = { Id: dataRecieved.key, ParentId: dataRecieved.selectedId };
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    //handler to handle cell changes & update values in draft values
    handleCellChange(event) {
        this.updateDraftValues(event.detail.draftValues[0]);
    }

    handleSave(event) {
        console.log('Updated items', this.draftValues);
        //save last saved copy
        this.lastSavedData = JSON.parse(JSON.stringify(this.data));

        //pass this.draftValues either to updateRecord LWC service to
        //update changed records
        //(https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.reference_update_record)
        // or use a wire function to update data through apex 
        //(https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.apex)

        //WRITE YOUR UPDATE LOGIC HERE

        //once data is updated, do following
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated',
                variant: 'success'
            })
        );
        // Clear all draft values
        this.draftValues = [];

        // Refresh data in the datatable with below command
        //if you are datatable is being loaded with wired function
        //(https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.apex)
        // return refreshApex(this.data);
    }

    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
}