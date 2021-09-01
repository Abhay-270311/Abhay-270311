import { LightningElement, wire, track } from "lwc";
import callNewsPoint from "@salesforce/apex/ArticleDataController.callNewsPoint";

export default class NewsApp extends LightningElement {
  
  /**Getting Data from the Server Side Controller.Ideally do the error handling for the returend data using error attribute **/
  //@wire(callNewsPoint)
  //newsarticles;

  @track newsarticles;
  getNewsHandler(event){
    callNewsPoint().then(result => {
        this.newsarticles = result;
        this.showToast('success', 'Data Is Successfully received in NewsApp');
    }).catch(error => {
        this.showToast('error', 'There is Error in NewsApp');
    });
  }

  showToast(errorType, errorMessage){
    let messageT = {
        _title: "News app data Title",
        message: errorMessage,
        variant: errorType,
    };
    const toastElement = this.template.querySelector('c-show-my-toast');
    toastElement.showToastDisplayHandler(messageT);
  }

}