import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
export default class OauthWebServeFlow extends LightningElement {
    currentPageReference = null; 
    urlStateParameters = null;
 
    /* Params from Url */
    urlId = null;
    urlLanguage = null;
    urlType = null;
 
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
 
    setParametersBasedOnUrl() {
       this.urlId = this.urlStateParameters.id || null;
       this.urlLanguage = this.urlStateParameters.lang || null;
       this.urlType = this.urlStateParameters.type || null;
    }
}