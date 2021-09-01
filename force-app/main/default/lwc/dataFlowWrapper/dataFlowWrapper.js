import { LightningElement, track, api } from 'lwc';
import getStudentData from '@salesforce/apex/DataFlowAuraController.getStudentData'; //
import setStudentData from '@salesforce/apex/DataFlowAuraController.setStudentData';
import sendDataAsList from '@salesforce/apex/DataFlowAuraController.setStudentDataList';
import SN_FIELD from '@salesforce/schema/Opportunity.StageName';
import getOptRecords from '@salesforce/apex/DataFlowAuraController.getOptData';

export default class DataFlowWrapper extends LightningElement {
    // if you use @track only then the property become reactive in case of @api it is not reactive
    @api studentDataVar = [{sFirstName: 'A', sLastName: 'Lalpotu' , sId : 'A01', isSelected : false},
    {sFirstName: 'N', sLastName: 'Sharma' , sId : 'A02', isSelected : false}
];

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

@track dataUpdated = true;
@track studentData = [];
@track stageNamePickList = SN_FIELD;
@track optList = [];
@track options = SN_FIELD;
value = 'Prospecting';
uppercaseItemName;

/*@api
get studentData() {
    return this.studentDataVar;
}

set studentData(value) {
   this.studentDataVar = value;
   console.debug('value ' + value);
}*/
setFirstName(event){
    /*console.log('Info : ' + event.target.name);
    console.log('Info : ' + event.target.value);
    console.log('Info : ' + event.target.label);
    console.log('Info : ' + event.target.title);
    console.log('Test Attribute ' + event.target.getAttribute("data-name"));*/

   let myId =  this.studentDataVar.findIndex(item => item.sId === event.target.name);
   console.log('Found Index ' + myId);
   if(event.target.label === 'First Name'){
    this.studentDataVar[myId]['sFirstName'] = event.target.value;
   } else if(event.target.label === 'Last Name'){
    this.studentDataVar[myId]['sLastName'] = event.target.value;
   }else if(event.target.label === 'Basic option'){
    this.studentDataVar[myId]['isSelected'] = event.target.checked;
   }
   //Basic option
    /*for(let key in this.studentDataVar){
        for(let key2 in this.studentDataVar[key]){
            if(event.target.name === this.studentDataVar[key][key2]){
                console.log(' TT -> ' + this.studentDataVar[key][key2]);
                this.studentDataVar[0]['sFirstName'] = event.target.value;
            }
            console.log( 'Object ' + key2 + ' : ' + this.studentDataVar[key][key2]);
        }
    }*/
}

    constructor(){
        super();
    }
    // Get the data to be displayed from apex
    connectedCallback(){
        getStudentData().then( result => {
            //this.studentData = result;
            this.studentDataVar= result;
        }).catch( error => {

        });

        getOptRecords().then( result => {
            //this.studentData = result;
            this.optList = result;
        }).catch( error => {

        });
    }

    OppNameChangeHandler(event){
        console.log(event.target.dataset.id);
        //Short cut way to find the selected element
        let element = this.optList.find(ele => ele.Id === event.target.dataset.id);
        element.Name = event.target.value;
        this.optList = [...this.optList];
        console.log(JSON.stringify(this.optList));
    }

    sendStudentData(event){
        console.log(this.studentDataVar);
        //console.log('::::' , JSON.stringify(this.stageNamePickList));
        // If you have wrapper list then it needs to be send stringified to apex and then deserialize in apex
       /* setStudentData({lstStudents:JSON.stringify(this.studentDataVar)}).then( result => {
            
        }).catch( error => {

        });*/

        let myList = this.optList;
        this.optList.forEach(function(element){
            element.Name = element.Name + 'JS';
        });
        this.optList = myList;
        // If you have list of sObject it can be sent as is to apex controller
        sendDataAsList({lstOpps:this.optList}).then( result => {
            
        }).catch( error => {
            console.log(error);
        });
    }

    setDataInArr(event){
        let frmData = [{}];
        frmData[0]['firstN'] = this.template.querySelector('[data-id="fName"]').value;
        frmData[0]['LastN'] = this.template.querySelector('[data-id="lName"]').value;
        console.log('frmData ' + JSON.stringify(frmData));
    }

    newRowHandler(event){
        this.dataUpdated = false;
        let sIdVar = 'A0' + (this.studentDataVar.length + 1);
        const newRow = {sFirstName: '', sLastName: '' , sId : sIdVar, isSelected : false};
        this.studentDataVar[this.studentDataVar.length] = newRow;
        //this.studentData.push(JSON.parse(JSON.stringify(newRow)));// due to proxy this needs to be stringified and parsed
        console.log(this.studentDataVar);
        this.dataUpdated = true;
    }

    removeRowHandler(event){
        this.dataUpdated = false;
        console.log('removeRowHandler Attribute ' + event.target.getAttribute("data-name"));
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.name;
        console.log('removeRowHandler Attribute ' + key);
        if(this.studentDataVar.length>1){
            this.studentDataVar.splice(key, 1);
        }else if(this.studentDataVar.length == 1){
            this.studentDataVar = [];
        }
        this.dataUpdated = true;
    }
}