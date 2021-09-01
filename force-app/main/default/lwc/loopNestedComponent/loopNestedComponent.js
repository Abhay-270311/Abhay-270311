import { LightningElement,track } from 'lwc';

export default class LoopNestedComponent extends LightningElement {
    @track hotelData = [
    {
        hotelName : 'Westin',
        id: 1,
        city: 'Pune',
        roomTypesQuantity: [{
            normal: 10,
            premium: 20,
            luxury: 30
        }],
        rating: 5

    },
    {
        hotelName : 'Radisson',
        id: 1,
        city: 'Nasik',
        roomTypesQuantity: [{
            normal: 10,
            premium: 20,
            luxury: 30
        }],
        rating: 4

    },
    {
        hotelName : 'Hyatt',
        id: 1,
        city: 'Mumbai',
        roomTypesQuantity: [{
            normal: 10,
            premium: 20,
            luxury: 30
        }],
        rating: 3

    }
];

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

get hotelInformation(){
    return this.hotelData ? this.hotelData : [];
}

}