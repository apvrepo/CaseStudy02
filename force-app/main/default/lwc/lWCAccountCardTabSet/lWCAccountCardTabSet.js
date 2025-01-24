/* @Description  This LWCAccountCardTabSet is a Custom Lightning Web Component that displays 
accordion sections in the 'LWCPage' Account records.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                     
*******************************************************************************************/

import { LightningElement, wire, track, api } from 'lwc';
import getContactsData from '@salesforce/apex/AccountController.getSingleAccountRelatedContacts';
import getOpportunitiesData from '@salesforce/apex/AccountController.getSingleAccountRelatedOportunitties';
import { NavigationMixin } from 'lightning/navigation';
import getStandardLabels from '@salesforce/apex/AccountController.getStandardLabels';



export default class LWCAccountCardTabSet extends NavigationMixin(LightningElement) {
    @api account;
    @api labels;
    @track accountContactRelationsSum;
    @track accountContactsSum;
    @track accountOpportunitiesSum;
    @track contacts;
    @track opportunities;

    CREATED_DATE_LABEL = '';
    CONTACT_RELATIONS_LABEL = '';
    CONTACTS_LABEL = '';
    OPPORTUNITIES_LABEL = '';

    // Wire the Apex method to fetch standard labels
    @wire(getStandardLabels)
    wiredLabels({ error, data }) {
        if (data) {
            this.CREATED_DATE_LABEL = data['CreatedDate'];
            this.CONTACT_RELATIONS_LABEL = data['AccountContactRelation'];
            this.CONTACTS_LABEL = data['Contact'];
            this.OPPORTUNITIES_LABEL = data['Opportunity'];
        } else if (error) {
            console.error(error);
        }
    }

    // LIFECYCLE HOOKS:
    connectedCallback() {
        this.accountContactRelationsSum = this.account.AccountContactRelationSum__c;  //  this.account.AccountContactRelations;
        this.accountContactsSum = this.account.ContactsSum__c;
        this.accountOpportunitiesSum = this.account.OpportunitiesSum__c;
    }

    renderedCallback() { }


    handleSectionToggle(event) {
        this.section = event.detail.openSections;
    }


    navigateToRecord(event) {
        const recordId = event.target.dataset.id;
        const objectApiName = event.target.dataset.object;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: 'view'
            }
        });
    }

    loadRelatedContacts(event) {
        const accountId = event.target.dataset.id;
        getContactsData({ accountId: accountId })
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error(error);
            });
    }


    loadRelatedOpportunities(event) {
        const accountId = event.target.dataset.id;
        getOpportunitiesData({ accountId: accountId })
            .then(result => {
                this.opportunities = result;
            })
            .catch(error => {
                console.error(error);
            });
    }

    showEditModal(event) {
        const contactRelationId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contactRelationId,
                objectApiName: 'AccountContactRelation',
                actionName: 'edit'
            }
        });
    }

    get contactRelationsAccordionLabel() {
        let aRASum;
        if (this.accountContactRelationsSum != null) {
            aRASum = this.accountContactRelationsSum;
        } else if (this.account.AccountContactRelations != null) {
            aRASum = this.account.AccountContactRelations.length;
        } else {
            aRASum = 0;
        }
        return this.CONTACT_RELATIONS_LABEL + ' (' + (aRASum) + ')';
    }

    get contactsAccordionLabel() {
        let cASum;
        if (this.contacts != null) {
            cASum = this.contacts.length;
        } else if (this.accountContactsSum != null) {
            cASum = this.accountContactsSum;
        } else {
            cASum = 0;
        }

        return this.CONTACTS_LABEL + ' (' + (cASum) + ')';
    }

    get oppurtunitiesAccordionLabel() {

        let oASum;
        if (this.opportunities != null) {
            oASum = this.opportunities.length;
        } else if (this.accountOpportunitiesSum != null) {
            oASum = this.accountOpportunitiesSum;
        } else {
            oASum = 0;
        }
        return this.OPPORTUNITIES_LABEL + ' (' + (oASum) + ')';       // this.opportunities.length 
    }

}

