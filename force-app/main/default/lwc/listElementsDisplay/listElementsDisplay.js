import { LightningElement, track } from 'lwc';
export default class ListElementsDisplay extends LightningElement {
    @track itemsList = [{"itemIndex":1, "itemName": "List Item One"},
    {itemIndex:2, itemName: "List Item Two"},
    {itemIndex:3, itemName: "List Item Three"},
    {itemIndex:4, itemName: "List Item Four"},
    {itemIndex:5, itemName: "List Item Five"},
    {itemIndex:6, itemName: "List Item Six"},
    {itemIndex:7, itemName: "List Item Seven"},
    {itemIndex:8, itemName: "List Item Eight"},
    {itemIndex:9, itemName: "List Item Nine"},
    {itemIndex:10, itemName: "List Item Ten"}
    ];

    className = "row slds-box1 margin-cls";
    varianeName = '';
    iconName = "utility:add";
    divIdSelect = '';
    cnt = 0;
    @track selectedIndexList = [];
    handleClick(event){
        let itemKey = event.target.dataset.id;
        let clsName = this.className;
        if(this.selectedIndexList.length != 0 && this.selectedIndexList.includes(itemKey)){
            this.selectedIndexList.splice(this.selectedIndexList.indexOf(itemKey),1);
            clsName = this.className;
            event.target.iconName = "utility:add";
            event.target.variant = "";
            if(this.cnt > 0)
                this.cnt--;
        } else {
            this.cnt++;
            clsName = this.className + ' dark-background';
            this.selectedIndexList.push(itemKey);
            event.target.iconName = "utility:check";
            event.target.variant = "inverse"; 
        }
        console.log(event.target.dataset.id);
        console.log(event.target.getAttribute("data-id"));
        let elementSelected1 = '[data-id=\'' + event.target.dataset.id + '\']';
        console.log('elementSelected ' , elementSelected1);
        this.divIdSelect = '[data-divid=\'' + event.target.dataset.id + '\']'; //event.target.dataset.id;
        console.log(this.divIdSelect);
        let elementSelected = this.template.querySelector(`${this.divIdSelect}`).setAttribute('class', clsName);
        

    }
}