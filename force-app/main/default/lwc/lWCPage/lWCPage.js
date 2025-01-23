
/* @Description  This LWCPage is a Custom Lightning Web Component that displays a list of Account records.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                     
*******************************************************************************************/

import { LightningElement, wire, track, api } from 'lwc';
import getAccountData from '@salesforce/apex/AccountController.getAccounts';
import { NavigationMixin } from 'lightning/navigation';
import getStandardLabels from '@salesforce/apex/AccountController.getStandardLabels';


export default class LWCPage extends NavigationMixin(LightningElement) {
    @track loaded = false;
    @track accounts;

  @track labels;
  @track tickerSymbolLabel;
  @track annualRevenueLabel;
  @track businessUsersLabel;
  @track decisionMakersLabel;

  @wire(getStandardLabels)
  wiredLabels({ error, data }) {
      if (data) {
          this.labels = data;
          this.tickerSymbolLabel = data['TickerSymbol'];
          this.annualRevenueLabel = data['AnnualRevenue'];
          this.businessUsersLabel = data['Business_Users__c'];
          this.decisionMakersLabel = data['Decision_Makers__c'];
      } else if (error) {
          console.error(error);
      }
  }


    // LIFECYCLE HOOKS:
    connectedCallback() { }

    renderedCallback() { }

    // Wire the Apex method to fetch character data
    @wire(getAccountData)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.loaded = true;
        } else if (error) {
            console.error(error);
        }
    }

    navigateToAccount(event) {
        const accountId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

}