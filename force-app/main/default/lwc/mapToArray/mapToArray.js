import { LightningElement, track } from 'lwc';
import getMapData from '@salesforce/apex/LWCCommonData.getAccttContacts';
import getMapWrapper from '@salesforce/apex/DisplayAccountContactsController.getMapWrapper';

export default class MapToArray extends LightningElement {
    @track dataList = [];
    @track accMapData = [];
    @track accContactData = [];

    /* get using wrapper*/
    @track dataWrapper = [];

    utilityIconTop = "utility:add";
    showExpanded = false;
    actionHandler(event){
        if(this.utilityIconTop == 'utility:add'){
          this.utilityIconTop = "utility:dash";
        } else {
          this.utilityIconTop = "utility:add";
        }
        this.showExpanded = !this.showExpanded;
    }


    connectedCallback(){
        getMapData().then(result => {
            //console.log('length ');
            let newArr = [];
           // console.log('Array.from ' , Array.from(result,([key,value]) =>({key, value})));
            this.convertMapToArray(result);
            let conArray;
            const tempList = [];
            
            conArray = Object.keys(result).map(key=> ({ key: key, ...result[key] }));
            //console.log('length ' + conArray.length);
            
            conArray.forEach(element => {
                
                //tempList.push({id: element.key, contacts: element});
                let innerArr = [];
                for (const key in element) {
                        if(element[key].key === undefined){
                            const element1 = element[key];
                            //console.log(element1);
                            innerArr.push({id: element1.Id, FirstName: element1.FirstName, LastName: element1.LastName});
                        }
                        

                }
                tempList.push({id: element.key, contacts: innerArr});

            });

            this.dataList = tempList;
        }).catch(error => {
            console.log('Error ' , error);
        });

        getMapWrapper().then(result => {
            this.dataWrapper = result;
        }).catch(error => {
            console.log('Error ' , error);
        });
    }

    convertMapToArray(result){
        var data = result;
            this.accMapData = result;
            var mainArr = [];
            for(let key in data){
                let arr = [];
                let newArr = [];
                //console.log(key);
                for(let key1 in result[key]){
                    let arrContact = [];
                    arrContact.push(result[key][key1]['FirstName']);
                    arrContact.push(result[key][key1]['LastName']);
                    arr.push({ value: arrContact, key: result[key][key1]['Id'] });
                }
                mainArr.push({value: arr, key:key});
                
            }
            console.log('Final Data');
            this.accContactData = JSON.parse(JSON.stringify(mainArr));
    }
}