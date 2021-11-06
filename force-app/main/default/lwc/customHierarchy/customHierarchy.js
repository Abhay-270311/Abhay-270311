import { LightningElement } from 'lwc';
import { sendEventToJIRA } from 'c/utils';
import getHierarchy from '@salesforce/apex/GetHierarchy.printHierarchy';
export default class CustomHierarchy extends LightningElement {
    data = [];
    selectedItemValue;

    handleOnselect(event) {
        this.selectedItemValue = event.detail.name;
    }
    connectedCallback() {
        getHierarchy().then(result => {     
            //let arr = [];
            //arr.push(JSON.parse(result));
            this.data = result;
            sendEventToJIRA({param1: 'First',
            param2: 'Second',
            param3: 'Third',
            param4: 'Fourth',
            param5: 'Fifth'
            });
        });
    }
}