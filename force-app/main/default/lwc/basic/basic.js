import { LightningElement, track } from 'lwc';
export default class Basic extends LightningElement {
    uName = ' Abhay';
    @track users = ['abhay','tejswini','vinod','adarsh'];
    displayName = true;
// you can call apex
//access all events
//set and define variable to be used in template
    connectedCallback() {
       console.log('Component Loaded11...');
    }

    changeUserNameHandler(event){
        this.uName = ' Chaitanya';
        console.log(event.target.title);
        this.displayName = !this.displayName;
        console.log('test');
    }
}