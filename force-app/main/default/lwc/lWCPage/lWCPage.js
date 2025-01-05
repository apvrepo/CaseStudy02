import { LightningElement, wire, track } from 'lwc';
import getAccountData from '@salesforce/apex/AccountHelper.getAccounts';
import { NavigationMixin } from 'lightning/navigation';

export default class LWCPage extends NavigationMixin(LightningElement) {
    @track loaded = false;
    @track accounts;

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