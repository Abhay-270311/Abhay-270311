import { LightningElement,api } from 'lwc';

export default class LoopNestedChild extends LightningElement {
    @api roomInformation;
    @api hotelInfoid;
    utilityIconTop = "utility:add";
    utilityIconInner = "utility:add";
    showhiderooms = false;
    actionBodyClass = 'slds-p-horizontal_small slds-is-collapsed';
      actionLabel = 'Show Content';
      actionHandler(event){
        console.log(event.target.title);
        if(this.utilityIconTop == 'utility:add'){
          this.utilityIconTop = "utility:dash";
        } else {
          this.utilityIconTop = "utility:add";
        }
        if(event.target.title == 'Show Content'){
            
            this.actionLabel = 'Hide Content';
            this.actionBodyClass = 'padding-left-css  slds-is-expanded';
        } else {
            this.actionLabel = 'Show Content';
            this.actionBodyClass = 'padding-left-css  slds-is-collapsed';
        }
      }

      showDataHandler(event){
        if(this.utilityIconInner == 'utility:add'){
          this.utilityIconInner = "utility:dash";
        } else {
          this.utilityIconInner = "utility:add";
        }
        this.showhiderooms = !this.showhiderooms;
      }
}