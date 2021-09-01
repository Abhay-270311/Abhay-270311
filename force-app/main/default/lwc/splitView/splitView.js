import { LightningElement, track, api } from 'lwc';
import optyData from '@salesforce/apex/LWCCommonData.getoptyData';

export default class SplitView extends LightningElement {
    maindivclass = "slds-split-view_container slds-is-open";
    subdivclass = "slds-button slds-button_icon slds-button_icon slds-split-view__toggle-button slds-is-open";
    buttonname = 'leftopen';
    areaexpanded = "true";
    rowcount = 0;
    utilityIconTop = "utility:add";
    showExpanded = false;
    actionHandler(event){
        console.log(event.target.title);
        if(this.utilityIconTop == 'utility:add'){
          this.utilityIconTop = "utility:dash";
        } else {
          this.utilityIconTop = "utility:add";
        }
        this.showExpanded = !this.showExpanded;
    }
    
    @track result = [];
    originalarr = [];
    @api 
    get getOptyList(){
        return this.result;
    }

    connectedCallback(){
        optyData().then(data => {
            this.result = data;
            this.rowcount = this.result.length;
        }).catch(error => {
            console.log(error.body.message);
        });
    }

    expandHandler(event){
        if(event.target.dataset.name == 'leftopen'){
            this.maindivclass = "slds-split-view_container slds-is-closed";
            this.subdivclass = "slds-button slds-button_icon slds-button_icon slds-split-view__toggle-button slds-is-closed";
            this.buttonname = 'rightclosed';
            this.areaexpanded = "false";

        } else{
            this.maindivclass = "slds-split-view_container slds-is-open";
            this.subdivclass = "slds-button slds-button_icon slds-button_icon slds-split-view__toggle-button slds-is-open";
            this.buttonname = 'leftopen';
            this.areaexpanded = "true";
            console.log(this.iconname);
        }
    }

    filterDataHandler(event){
        console.log(event.target.value);
        const searchstr = event.target.value;
        if(this.originalarr.length == 0){
            this.originalarr = [...this.result];
        } else if (this.originalarr.length > this.result.length){
            this.result = [...this.originalarr];
        }
        this.rowcount = this.result.length;
        //const filterdata = [...JSON.parse(JSON.stringify(this.result))];
        console.log(' count0 :: ' +searchstr.toUpperCase());
        if(searchstr.length >= 3){
            //console.log(filterdata);
            //let newarray = [];
            this.result = this.result.filter(optrecord => 
                optrecord.Name.toUpperCase().includes(searchstr.toUpperCase(),0) ||
                optrecord.StageName.toUpperCase().includes(searchstr.toUpperCase(),0)
                /*optrecord.Amount >= parseInt(searchstr) || 
                optrecord.Type.toUpperCase().includes(searchstr.toUpperCase(),0)*/
                
                );
            //this.result = newarray;
            //console.log(newarray);
            this.rowcount = this.result.length;
        }
        
    }

}