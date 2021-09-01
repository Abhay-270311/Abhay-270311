import { LightningElement } from 'lwc';

export default class GrandChild extends LightningElement {
    constructor(){
        super();
        console.log('Grand Child Constructor');
    }

    connectedCallback(){
        console.log('Grand Child connectedCallback');
    }

    renderedCallback(){
        console.log('Grand Child renderedCallback');
    }
}