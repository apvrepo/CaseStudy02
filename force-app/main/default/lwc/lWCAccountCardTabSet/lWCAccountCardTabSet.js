import { LightningElement, wire, track, api } from 'lwc';
import getContactsData from '@salesforce/apex/AccountHelper.getSingleAccountRelatedContacts'; 
import getOpportunitiesData from '@salesforce/apex/AccountHelper.getSingleAccountRelatedOportunitties'; 
import { NavigationMixin } from 'lightning/navigation';
// Import custom labels
import createdDateLabel from "@salesforce/label/c.CreatedDateLabel";
import contactRelationsLabel from "@salesforce/label/c.ContactRelationsLabel";
import contactsLabel from "@salesforce/label/c.ContactsLabel";
import opportunitiesLabel from "@salesforce/label/c.OpportunitiesLabel";

export default class LWCAccountCardTabSet extends  NavigationMixin(LightningElement)  {
@api account; 
@track accountContactRelationsSum;
@track accountContactsSum;
@track accountOpportunitiesSum;
@track contacts;
@track opportunities;
@track  section = '';

 // Expose the labels to use in the template.
 label = {
    createdDateLabel, 
    contactRelationsLabel,
    contactsLabel, 
    opportunitiesLabel
  };

// LIFECYCLE HOOKS:
connectedCallback() { 
    this.accountContactRelationsSum = this.account.AccountContactRelations; 
    this.accountContactsSum = this.account.ContactsSum__c;
    this.accountOpportunitiesSum = this.account.OpportunitiesSum__;
}

renderedCallback() { }


handleSectionToggle(event) {
    this.section = event.detail.openSections;
}


navigateToContactRelation(event) {
const contactRelationId = event.target.dataset.id;
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: contactRelationId,
        objectApiName: 'AccountContactRelation',
        actionName: 'view'
    }
});
}

navigateToContact(event) {
const contactId = event.target.dataset.id;
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: contactId,
        objectApiName: 'Contact',
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

navigateToOpportunity(event) {
const opportunityId = event.target.dataset.id;
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: opportunityId,
        objectApiName: 'Opportunity',
        actionName: 'view'
    }
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
return this.label.contactRelationsLabel + ' (' + (this.accountContactRelationsSum ? this.accountContactRelationsSum.length : 0)  + ')';
}

get contactsAccordionLabel() {
return this.label.contactsLabel + ' (' + (this.accountContactsSum ? this.accountContactsSum : 0) + ')'; // this.contacts.length
}

get oppurtunitiesAccordionLabel() {
return this.label.opportunitiesLabel + ' (' + (this.accountOpportunitiesSum ? this.accountOpportunitiesSum : 0) + ')';       // this.opportunities.length 
}



}