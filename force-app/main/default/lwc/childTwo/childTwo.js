import { LightningElement } from 'lwc';
export default class ChildTwo extends LightningElement {
handleCustomEvent(event){

        console.log('Child2  ', JSON.stringify(event.detail));
    }
}