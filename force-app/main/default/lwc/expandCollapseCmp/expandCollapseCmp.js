import { LightningElement,api } from 'lwc';

export default class ExpandCollapseCmp extends LightningElement {
    @api titleLc;
    utilityIconTop = "utility:chevronright";
    showExpanded = false;
    actionHandler(event){
      if(this.utilityIconTop == 'utility:chevronright'){
          this.utilityIconTop = "utility:chevrondown";
      } else {
          this.utilityIconTop = "utility:chevronright";
      }

        this.showExpanded = !this.showExpanded;
    }
}