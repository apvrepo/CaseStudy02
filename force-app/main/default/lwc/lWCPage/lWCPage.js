
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
import { refreshApex } from '@salesforce/apex';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';

export default class LWCPage extends NavigationMixin(LightningElement) {
    @track loaded = false;
    @track accounts;
    @track error;
    wiredAccountsResult

    TICKER_SYMBOL_LABEL = '';
    ANNUAL_REVENUE_LABEL = '';
    BUSINESS_USER_LABEL = '';
    DECISION_MAKER_LABEL = '';
    CREATED_DATE_LABEL = '';
    CONTACT_RELATIONS_LABEL = '';
    CONTACTS_LABEL = '';
    OPPORTUNITIES_LABEL = '';

    @track channelName = '/event/Account_Change_Event__e';
    @track subscription = {};

    // Wire the Apex method to fetch account data
    @wire(getAccountData)
    wiredAccounts(result) {
        this.wiredAccountsResult = result;
        if (result.data) {
            this.accounts = result.data;
            this.loaded = true;
        } else if (result.error) {
            this.accounts = undefined;
            console.error(result.error);
        }
    }
    // Wire the Apex method to fetch standard labels
    @wire(getStandardLabels)
    wiredLabels({ error, data }) {
        if (data) {
            this.TICKER_SYMBOL_LABEL = data['TickerSymbol'];
            this.ANNUAL_REVENUE_LABEL = data['AnnualRevenue'];
            this.BUSINESS_USER_LABEL = data['Business_Users__c'];
            this.DECISION_MAKER_LABEL = data['Decision_Makers__c'];
        } else if (error) {
            console.error(error);
        }
    }

    // Handles subscribe button click
    handleSubscription() {
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
            // Refresh the wired accounts data
            refreshApex(this.wiredAccountsResult)
                .then(() => {
                  //  console.log('Account data refreshed successfully');
                })
                .catch((error) => {
                  //  console.error('Error refreshing accounts:', error);
                });
        };
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
         //   console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    // LIFECYCLE HOOKS:
    connectedCallback() {
        this.handleSubscription()
    }

    renderedCallback() { }

    disconnectedCallback() {
        this.handleUnsubscription();
    }

    // Unsubscribe during disconnectedCallback
    handleUnsubscription() {
        if (this.subscription && this.subscription.channel) {
            unsubscribe(this.subscription, (response) => {
               // console.log('Unsubscribed from channel:', response);
            }).catch((error) => {
              //  console.error('Error during unsubscription:', error);
            });
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