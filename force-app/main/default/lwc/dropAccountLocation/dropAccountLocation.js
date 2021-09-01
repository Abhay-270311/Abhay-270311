/* eslint-disable no-console */
import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

let acct;
export default class DropAccountLocation extends LightningElement {
   
    @track mapMarkers = []; //holds account location related attributes
    @track markersTitle = ''; //title of markers used in lightning map.
    @track zoomLevel = 3;   //initialize zoom level
    @track center; //location will be displayed in the center of the map

    @wire(CurrentPageReference) pageRef;
    accountInfo;
    @track DroppedAccountName = '';
    @track accDroppedList = [];
    
    constructor() {
        super();
        //these are two must have events to be listended
        this.template.addEventListener('dragover', this.handleDragOver.bind(this));
        this.template.addEventListener('drop', this.handleDrop.bind(this));        
      }

    connectedCallback() {
        // subscribe to selectedAccountDrop event
        registerListener('selectedAccountDrop', this.handleSelectedAccountDrop, this);
    }

    disconnectedCallback() {
        // unsubscribe from selectedAccountDrop event
        unregisterAllListeners(this);
    }

    //method is called due to listening selectedAccountDrop event
     handleSelectedAccountDrop(accountInfo) {
        this.accountInfo = accountInfo;        
    }

    //when item is dropped this event fires
    handleDrop(event){
        console.log('inside handle drop');
        if(event.stopPropagation){
            event.stopPropagation();
        }
        event.preventDefault();
        
        //assigns account records
        acct = this.accountInfo;
        this.DroppedAccountName = acct.Name;
        if(this.accDroppedList.length > 0 ){
            let findAcc = this.accDroppedList.findIndex(element => element.Id === acct.Id);
            if(findAcc == -1){
                this.accDroppedList.push(acct);
            }
        } else {
            this.accDroppedList.push(acct);
        }
        
        //prepares information for the lightning map attribute values.
        this.markersTitle = acct.Name;        
        this.mapMarkers = [
            {
                location: {
                    Street: acct.BillingStreet,
                    City: acct.BillingCity,
                    State: acct.BillingState,
                    Country: acct.BillingCountry,
                },
                icon: 'custom:custom26',
                title: acct.Name,
            }                                    
        ];
        this.center = {
            location: {
                City: acct.BillingCity,
            },
        };
        this.zoomLevel = 6;
    }    

    //when item is dragged on the component this event fires
    handleDragOver(event){
        event.dataTransfer.dropEffect = 'move';
        event.preventDefault();       
    }    
}