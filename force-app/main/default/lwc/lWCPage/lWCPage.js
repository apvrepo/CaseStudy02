
/* @Description  This LWCPage is a Custom Lightning Web Component that displays a list of Account records.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                     
*******************************************************************************************/

import { LightningElement, wire, track, api } from 'lwc';
import getAccountData from '@salesforce/apex/AccountHelper.getAccounts';
import { NavigationMixin } from 'lightning/navigation';
// Import custom labels
import tickerSymbolLabel from "@salesforce/label/c.TickerSymbolLabel";
import annualRevenueLabel from "@salesforce/label/c.AnnualRevenueLabel";
import businessUsersLabel from "@salesforce/label/c.BusinessUsersLabel";
import decisionMakersLabel from "@salesforce/label/c.DecisionMakersLabel";


export default class LWCPage extends NavigationMixin(LightningElement) {
    @track loaded = false;
    @track accounts;
 // Expose the labels to use in the template.
 label = {
    tickerSymbolLabel,
    annualRevenueLabel, 
    businessUsersLabel, 
    decisionMakersLabel
  };


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