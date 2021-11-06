import { LightningElement,api } from 'lwc';

export default class ExpandCollapseCmp extends LightningElement {
    @api titleLc;
    utilityIconTop = "utility:chevronright";
    @api
    showExpanded = false;
    @api
    showRight = false;
    @api
    showLeft = false;
    actionHandler(event){
      if(this.utilityIconTop == 'utility:chevronright'){
          this.utilityIconTop = "utility:chevrondown";
      } else {
          this.utilityIconTop = "utility:chevronright";
      }

        this.showExpanded = !this.showExpanded;
    }
}