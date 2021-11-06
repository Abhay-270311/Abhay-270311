import { LightningElement } from 'lwc';
export default class ChinldNav extends LightningElement {
    handleChild2Click(event){
        this.dispatchEvent(new CustomEvent('clickchildnav', 
        {detail: {origin: 'Grand Child'}, bubbles:true, composed: true}));
    }
}