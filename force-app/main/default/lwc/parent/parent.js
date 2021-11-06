import { LightningElement } from 'lwc';

export default class Parent extends LightningElement {
    utilityIconTop = "utility:add";
    prevLocation = window.location.history;
    currLocation = window.location.href;
    showExpanded = false;
    displayflag = true;
    actionHandler(event){
        console.log(event.target.title);
        if(this.utilityIconTop == 'utility:add'){
          this.utilityIconTop = "utility:dash";
        } else {
          this.utilityIconTop = "utility:add";
        }
        this.showExpanded = !this.showExpanded;
    }
    constructor(){
        super();
        console.log('Parent Child Constructor');
    }

    connectedCallback(){
        console.log('Parent Child connectedCallback');
    }

    renderedCallback(){
        console.log('Parent Child renderedCallback');
    }

    handleCustomEvent(event){
        window.history.pushState({}, "", "#bhay");
        window.localStorage.setItem('test1',"From Window Storage Item");
        console.log('Parent- ', JSON.stringify(event.detail));
        if(event.detail.origin != undefined){
            console.log('origin ' + event.detail.origin);
        }
        if(event.detail.location === undefined){
            console.log('origin ' + event.detail.location);
        }
        console.log(' window.location.origin ' , window.location.origin); //+'/'+ (event.detail.location === undefined) ? '11111' : '2222'
        let var1 = {name: window.location.origin + ((event.detail.location === undefined) ? '/yes' : '/no') };
        console.log('Var1.name ' , var1.name);
    }
    storageItem = '';
    handleLinkClick(event){
        console.log(' href ', event.target.href);
        console.log(' title ', event.target.title);
        console.log(' Name ', event.target.name);
        console.log(' TextContent ', event.target.textContent);
        console.log(' qq.data.href ', event.target.dataset.href);
        console.log(' qqdata.name ', event.target.dataset.name);
        console.log('current ' + event.currentTarget.href);
        //console.log(' .data.href ', event.currentTarget.data.href);
        //console.log(' data.name ', event.currentTarget.data.name);
        //console.log(' TextContent ', event.target.textContent);
    }
    handleBtnClick(event){
        window.location.reload();
       this.storageItem =  JSON.stringify(window.history.state);//window.localStorage.getItem("test1");
       window.history.pushState({name:'addedTag'}, "", "#Abhay");
    }
}