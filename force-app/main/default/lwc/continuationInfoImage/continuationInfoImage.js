import { LightningElement } from 'lwc';
import contImageurl from '@salesforce/resourceUrl/continuation';
import startContinuation from '@salesforce/apexContinuation/ArticleDataController.startConinuation';

export default class ContinuationInfoImage extends LightningElement {
    contImg = contImageurl;
    iconName = 'utility:chevronright'; //utility:chevrondown
    areaHide = false;
    areaExpanded = false;
    sldsContent = "slds-summary-detail__content slds-collapsed";
    connectedCallback(){
        console.log(this.contImg);
    }
    
    showSummaryHandler(event){
        console.log(event.target.dataset.name);
        this.areaHide  = !this.areaHide;
        this.areaExpanded  = !this.areaExpanded;
        if(this.iconName == 'utility:chevronright'){
            this.iconName = "utility:chevrondown";
        } else {
            this.iconName = "utility:chevronright";
        }


        if(this.sldsContent == 'slds-summary-detail__content slds-collapsed'){
            this.sldsContent = "slds-expanded";
        } else {
            this.sldsContent = "slds-summary-detail__content slds-collapsed";
        }

    }
    // Continucation call code below
    result;
    isLoading = true;
    checkResp;
    conCallHandler(event){
        console.log('Inside...');
        startContinuation()
            .then(result => {
                console.log('Inside111...');
                this.result = result;
                this.isLoading = false;
                this.checkResp = 'received';
            }).catch(error => {
                // TODO: handle error
                this.isLoading = false;
            });
            this.checkResp = 'Checking';
    }
    callAnotherHandler(event){
        this.checkResp = 'Temp Action Check';
    }
}