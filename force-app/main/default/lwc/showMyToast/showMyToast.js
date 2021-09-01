import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowMyToast extends LightningElement {
    @api
    showToastDisplayHandler(messageT){
        const evt = new ShowToastEvent({
            title: messageT._title,
            message: messageT.message,
            variant: messageT.variant,
        });
        this.dispatchEvent(evt);
    }
    

}