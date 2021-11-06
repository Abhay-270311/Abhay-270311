import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
    @api showMe;
    @api parentVar = false;
    @api showGrandChild;
    childVar = 'Default';
    constructor(){
        super();
        console.log('Child Constructor..');
    }

    connectedCallback(){
        console.log(this.showMe);
        console.log('Child connectedCallback..  ' + this.showGrandChild);
        this.showGrandChild = true;
        this.showMe = true;
        this.parentVar = true;
        console.log(this.showMe);
    }

    renderedCallback(){
        console.log('Child renderedCallback..');
    }
    /*handleCustomEvent(event){
        console.log('Child ', JSON.stringify(event.detail));
    }*/

    handleChildClick(event){
        console.log('Child handleChildClick..');
        this.template.querySelector('c-grand-child').setVarButton();
        //eval("$A.get('e.force:refreshView').fire();");
        
    }

    handleCustomChildTwoEvent(event){
        console.log('Child2 Event handleChildClick..');
        this.showGrandChild = true;
        this.parentVar = true;
        this.showMe = false;
        this.showMe = true;
        this.template.querySelector('c-grand-child').setVarButton();
        this.childVar = 'Updated';
    }
}