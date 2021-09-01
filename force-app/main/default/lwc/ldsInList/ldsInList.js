import { LightningElement } from 'lwc';

export default class LdsInList extends LightningElement {
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
}