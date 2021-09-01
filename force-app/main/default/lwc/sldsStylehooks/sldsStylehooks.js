import { LightningElement } from 'lwc';

export default class SldsStylehooks extends LightningElement {
    content = `":host {
        --sds-c-button-brand-color-background: orange;
        --sds-c-button-brand-color-border: orange;
        /* Other CSS custom properties here */    
      }"`;

      actionBodyClass = 'slds-p-horizontal_small slds-is-collapsed';
      actionLabel = 'Show Content';
      actionHandler(event){
        if(event.target.label == 'Show Content'){
            
            this.actionLabel = 'Hide Content';
            this.actionBodyClass = 'slds-p-horizontal_small  slds-is-expanded';
        } else {
            this.actionLabel = 'Show Content';
            this.actionBodyClass = 'slds-p-horizontal_small  slds-is-collapsed';
        }
      }

    utilityIconTop = "utility:add";
    showExpanded = false;
    actionHandlerTop(event){
        console.log(event.target.title);
        if(this.utilityIconTop == 'utility:add'){
          this.utilityIconTop = "utility:dash";
        } else {
          this.utilityIconTop = "utility:add";
        }
        this.showExpanded = !this.showExpanded;
    }
}