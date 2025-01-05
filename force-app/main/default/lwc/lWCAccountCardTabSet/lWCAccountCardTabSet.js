import { LightningElement, wire, track, api } from 'lwc';
import getContactsData from '@salesforce/apex/AccountHelper.getSingleAccountRelatedContacts'; 
import { NavigationMixin } from 'lightning/navigation';



export default class LWCAccountCardTabSet extends  NavigationMixin(LightningElement)  {
@api accountId; 
@api accountContactRelations;
@track contacts;


@track loadedOportunities = false;
@track  section = '';


 // LIFECYCLE HOOKS:
 connectedCallback() { 
    this.loadedOportunities = true;
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

get contactRelationsAccordionLabel() {
    return 'Contact Relations ('+(this.accountContactRelations ? this.accountContactRelations.length : 0) + ')';
}

get contactsAccordionLabel() {
    return 'Contacts ('+(this.contacts ? this.contacts.length : 0) + ')';
}

get oppurtunitiesAccordionLabel() {
    return 'Opportunities ('+(this.opportunities ? this.opportunities.length : 0) + ')';        
}



}