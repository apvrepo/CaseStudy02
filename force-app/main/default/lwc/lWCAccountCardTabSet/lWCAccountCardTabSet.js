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
// Import custom labels
import createdDateLabel from "@salesforce/label/c.CreatedDateLabel";
import contactRelationsLabel from "@salesforce/label/c.ContactRelationsLabel";
import contactsLabel from "@salesforce/label/c.ContactsLabel";
import opportunitiesLabel from "@salesforce/label/c.OpportunitiesLabel";

export default class LWCAccountCardTabSet extends NavigationMixin(LightningElement) {
    @api account;
    @track accountContactRelationsSum;
    @track accountContactsSum;
    @track accountOpportunitiesSum;
    @track contacts;
    @track opportunities;
    @track section = '';

    // Expose the labels to use in the template.
    label = {
        createdDateLabel,
        contactRelationsLabel,
        contactsLabel,
        opportunitiesLabel
    };

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
        return this.label.contactRelationsLabel + ' (' + (aRASum) + ')';
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

        return this.label.contactsLabel + ' (' + (cASum) + ')';
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
        return this.label.opportunitiesLabel + ' (' + (oASum) + ')';       // this.opportunities.length 
    }

}