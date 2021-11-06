import { LightningElement, api } from 'lwc';

export default class GrandChild extends LightningElement {
    @api showbutton;
    constructor(){
        super();
        console.log('Grand Child Constructor');
    }

    connectedCallback(){
        console.log('Grand Child connectedCallback ' + this.showbutton);
    }

    renderedCallback(){
        console.log('Grand Child renderedCallback');
    }

    handleClick(){
        let event1 = new CustomEvent('grandchild', 
        {detail: {origin: 'Grand Child'}, bubbles:true, composed: true});
        this.dispatchEvent(event1);
    }
    @api setVarButton(){
        this.showbutton = !this.showbutton;
        console.log('setVarButton');
    }
}