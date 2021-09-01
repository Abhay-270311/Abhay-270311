import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class SamlSPLoginNavigate extends NavigationMixin(LightningElement) {
    navigateHandler(event){
        // Navigate to a URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://d5g000004wvfieam-dev-ed.my.salesforce.com/idp/login?app=0sp5g000000Kyoa'
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }
    navigateHandlerD(event){
        // Navigate to a URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://d5g000004wvfieam-dev-ed.my.salesforce.com/idp/login?app=0sp5g000000Kyoz'
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }
}