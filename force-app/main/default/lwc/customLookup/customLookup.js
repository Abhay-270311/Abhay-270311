import { LightningElement, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/LWCCommonData.searchRecords';

export default class CustomLookup extends LightningElement {
    //objectName="Account" fieldName="Name" label="Account Search" placeholder="search Account" iconName="standard:account"
    @api objectName = 'Account';
    @api fieldName = 'Name';
    @api value;
    @api iconName = 'standard:account';
    @api label = 'Account Search';
    @api placeholder = 'search Account';
    @api className;
    @api required = false;
    @track searchString;
    @track selectedRecord;
    @track recordsList;
    @track message;
    @track showPill = false;
    @track showSpinner = false;
    @track showDropdown = false;
    @track showPillMulti = false;
    @track selPillData = [];

    connectedCallback() {
        if(this.value)
            this.fetchData();
    }

    searchRecords(event) {
        this.searchString = event.target.value;
        if(this.searchString) {
            this.fetchData();
        } else {
            this.showDropdown = false;
        }
    }

    selectItem(event) {
        if(event.currentTarget.dataset.key) {
    		var index = this.recordsList.findIndex(x => x.value === event.currentTarget.dataset.key)
            if(index != -1) {
                this.selectedRecord = this.recordsList[index];
                this.value = this.selectedRecord.value;
                if(this.selPillData.length > 0){
                    let foundItem = this.selPillData.findIndex(element => element.value === this.value);
                    console.log(foundItem);
                    if(foundItem === -1){
                        this.selPillData.push(JSON.parse(JSON.stringify(this.selectedRecord)));
                    }
                } else {
                    this.selPillData.push(JSON.parse(JSON.stringify(this.selectedRecord)));
                }
                
                this.showDropdown = false;
                this.showPill = true;
                this.showPillMulti = true;
            }
        }
    }

    removeItemFromArr(event){
        //this.showPillMulti = true;
        let foundItem = this.selPillData.findIndex(element => element.value === event.currentTarget.name);
        if(foundItem != -1){
            this.selPillData.splice(foundItem,1);
        }
       // this.showPillMulti = true;
    }

    removeItem() {
        this.showPill = false;
        
        this.value = '';
        this.selectedRecord = '';
        this.searchString = '';
    }

    showRecords() {
        if(this.recordsList && this.searchString) {
            this.showDropdown = true;
        }
    }

    blurEvent() {
        this.showDropdown = false;
    }

    fetchData() {
        this.showSpinner = true;
        this.message = '';
        this.recordsList = [];
        fetchRecords({
            objectName : this.objectName,
            filterField : this.fieldName,
            searchString : this.searchString,
            value : this.value
        })
        .then(result => {
            if(result && result.length > 0) {
                if(this.value) {
                    this.selectedRecord = result[0];
                    this.showPill = true;
                } else {
                    this.recordsList = result;
                }
            } else {
                this.message = "No Records Found for '" + this.searchString + "'";
            }
            this.showSpinner = false;
        }).catch(error => {
            this.message = error.message;
            this.showSpinner = false;
        })
        if(!this.value) {
            this.showDropdown = true;
        }
    }
}