import { LightningElement, track, wire } from 'lwc';
//import getsObjects from '@salesforce/apex/OHDE_ObjectData.getsObjects';
//import getCustomFields from '@salesforce/apex/OHDE_ObjectData.getCustomFields';
import deleteMetaCompList from '@salesforce/apex/OHDE_DependencyFinder.deleteMetaCompList';
import getObjectFields from '@salesforce/apex/OHDE_Utilities.getObjectFields';
import getObjectsList from '@salesforce/apex/OHDE_Utilities.getObjectsList';
import {exportCSVFile} from 'c/utils';

export default class Ohde_dependencyFinder extends LightningElement {
    csvData = [];
    // Code for CSV Generation
    headers = {
        fieldName:"Field Name",
        errType:"Component Type",
        errmessages:"Component Name"
    };

    downloadCSVDetails(){
        console.log("download triggered.")
        exportCSVFile(this.headers, this.csvData, "Dependency Detail")
    }
    //CSV download end
    error;
    value = 'Select an Object';
    options = [];
    renderCB = false;
    selectedObject;
    selectedField;
    recordsCount; 
    @track fields = [];
    fieldsCount;
    renderFieldsBox = false;
    @track mainData = [];
    renderMainData = false;
    @track mainUnionData = [];
    showSpinner = false;
    skipRead = true;
        //Get Objects Data 
    @wire(getObjectsList, { skipReadOnly: '$skipRead' })
    wiredObjects({ error, data }) {
        //console.log(JSON.parse(JSON.stringify(data)));
        console.log(data);
        console.log(error);
        if (data) {            
            this.error = undefined;
            data.forEach(asset => {
                let preparedAsset = {};
                preparedAsset.label = asset.objName;
                preparedAsset.value = asset.objAPIName;                
                this.options.push(preparedAsset);            
                this.renderCB = true;
            });
        } else if (error) {
            console.log(JSON.parse(JSON.stringify(error)));
            this.error = error;
            this.renderFieldsBox = false;
        }
    }
    // Get the fields for selected Object
    handleChange(event){
        this.renderMainData = false;
        this.showSpinner = true;
        this.fields = [];
        this.itemsList = [];
        this.selectedFieldsApiName = [];
        this.selectedObject = event.target.value;
        getObjectFields({objName : this.selectedObject})
        .then(data => {
            this.renderFieldsBox = true;  
            let cnt = 1;  
            data.forEach(asset => {
                 if(asset.isStandard === false){     
                    let preparedAsset = {};
                    let itemList = {itemIndex:cnt, itemName: asset.fieldName, itemApiName: asset.fieldApiName};
                    preparedAsset.label = asset.fieldName;
                    preparedAsset.value = asset.fieldApiName;                
                    this.fields.push(preparedAsset);
                    this.itemsList.push(itemList);
                    cnt++;
                }
            }); 
            this.renderCB = true;
            this.showSpinner = false;     
        })
        .catch(error => {
            this.showSpinner = false;
        });
    }
    
    handleFieldChange(evt){
        this.selectedField = evt.target.value;
    }
    // Get dependency for selecte object fields
    handleGetDependency(){
        this.showSpinner = true;
        //OHDE_DependencyFinder.deleteMetaCompList('CustomField', new List<String>{'Opportunity.TrackingNumber__c'}, 'Opportunity');
        this.mainData = [];
        this.renderMainData = false;
        let compData = [];
        this.csvData = []; // clear previous result
        compData.push(this.selectedObject + '.' + this.selectedField);
        this.selectedFieldsApiName = JSON.parse(JSON.stringify(this.selectedFieldsApiName));
        this.selectedFieldsApiName.forEach((item, index) => {
                this.selectedFieldsApiName[index] = this.selectedObject + '.' + item;
                });
        compData = [];
        compData = JSON.parse(JSON.stringify(this.selectedFieldsApiName));
        deleteMetaCompList({componentType : 'CustomField', compData, objectName : this.selectedObject})
        .then(data => {
            this.mainUnionData = JSON.parse(JSON.stringify(data));
            data.forEach(asset => {
                console.log('Assest' , asset.fieldName);
                this.renderMainData = true;
                this.mainData.push(asset.fielderrors);
                this.csvData.push({
                                    fieldName: asset.fieldName,
                                    errType:"",
                                    errmessages:""
                                });
                //Prepare CSV Data Array
                asset.fielderrors.forEach( (innerAsset) => {
                    //console.log(' INNER ASSET ',JSON.stringify(innerAsset));
                    this.csvData.push({
                                    fieldName: " ",
                                    errType:innerAsset.errType,
                                    errmessages: innerAsset.errmessages.join(' | ')
                                });
                });
       
            }); 
            this.resetSelFldArr();     
        })
        .catch(error => {
            this.resetSelFldArr();
            alert('Some Error Occured !!!');
        });
    }
    // Reset the selected fields array to remove object name prefix
    resetSelFldArr(){
        this.showSpinner = false;
        this.selectedFieldsApiName = JSON.parse(JSON.stringify(this.selectedFieldsApiName));
        this.selectedFieldsApiName.forEach((item, index) => {
                    this.selectedFieldsApiName[index] = item.split(".")[1];
                });
    }

    // Handle the field select
    @track itemsList = [];
    className = "row slds-box1 margin-cls";
    varianeName = '';
    iconName = "utility:add";
    divIdSelect = '';
    cnt = 0;
    @track selectedIndexList = [];
    @track selectedFieldsApiName = [];
    handleFieldClick(event){
        let itemKey = event.target.dataset.id;
        let itemNm = event.target.dataset.name;
        let clsName = this.className;
        if(this.selectedIndexList.length != 0 && this.selectedIndexList.includes(itemKey)){
            this.selectedIndexList.splice(this.selectedIndexList.indexOf(itemKey),1);
            this.selectedFieldsApiName.splice(this.selectedFieldsApiName.indexOf(itemNm),1);
            clsName = this.className;
            event.target.iconName = "utility:add";
            event.target.variant = "";
            if(this.cnt > 0)
                this.cnt--;
        } else {
            this.cnt++;
            clsName = this.className + ' dark-background';
            this.selectedIndexList.push(itemKey);
            this.selectedFieldsApiName.push(itemNm);
            event.target.iconName = "utility:check";
            event.target.variant = "inverse"; 
        }

        let elementSelected1 = '[data-id=\'' + event.target.dataset.id + '\']';
        this.divIdSelect = '[data-divid=\'' + event.target.dataset.id + '\']'; //event.target.dataset.id;
        let elementSelected = this.template.querySelector(`${this.divIdSelect}`).setAttribute('class', clsName);
    }
}