import { LightningElement, track } from 'lwc';
const columns = [
     {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text'},
     {label: 'Confidence', fieldName: 'confidence', type: 'percent', cellAttributes:
     { iconName: { fieldName: 'trendIcon' }, iconPosition: 'right' }},
     {label: 'Amount', fieldName: 'amount', type: 'currency', typeAttributes: { currencyCode: 'EUR', step: '0.001'}},
     {label: 'Contact Email', fieldName: 'contact', type: 'email'},
     {label: 'Contact Phone', fieldName: 'phone', type: 'phone'},
];

const data = [{
                    id: 'a',
                    opportunityName: 'Cloudhub',
                    confidence: 0.2,
                    amount: 25000,
                    contact: 'jrogers@cloudhub.com',
                    phone: '2352235235',
                    trendIcon: 'utility:down'
                },
                {
                    id: 'b',
                    opportunityName: 'Quip',
                    confidence: 0.78,
                    amount: 740000,
                    contact: 'quipy@quip.com',
                    phone: '2352235235',
                    trendIcon: 'utility:up'
                }];

export default class SelectedDataTableRows extends LightningElement {
    data = data;
    columns = columns;
    selRows = [];

    getSelectedName(event) {
        //console.log('@@');
        const selectedRows = event.detail.selectedRows;
        console.log('@@ ' , selectedRows.length);
        this.selRows = [];
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++){
            console.log("You selected11: ", i , '  - ' + selectedRows[i].opportunityName);
            let isFound = this.selRows.findIndex(rdata1 => rdata1.id == selectedRows[i].id);
            console.log(' --> ' + isFound);
            if ( this.selRows.length > 0 ){
                this.selRows.push(selectedRows[i]);
                //Console.log("You selected: " + selectedRows[i].opportunityName);
            } else{
                this.selRows.push(selectedRows[i]); 
            }
        }

        alert('You Selected ' ,this.selRows.length, ' records' );
    }
}