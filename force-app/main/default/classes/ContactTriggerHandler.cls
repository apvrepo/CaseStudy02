/* @Description  This ContactTriggerHandler class executes the logics based on the ContactTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                    
*******************************************************************************************/

public without sharing class ContactTriggerHandler extends TriggerHandler {

    private List<Contact> newContactList;
    private List<Contact> oldContactList;
    private Map<Id, Contact> oldContactMap;
    private Set<Id> accountIdsToUpdate;
    private static final String RELATED_OBJECT_NAME = 'Contact';

    public ContactTriggerHandler() {
        this.newContactList = Trigger.isDelete ? null : (List<Contact>) Trigger.new;
        this.oldContactList = Trigger.isInsert ? null : (List<Contact>) Trigger.old;
        this.oldContactMap = Trigger.isInsert ? null : (Map<Id, Contact>) Trigger.oldMap;
        this.accountIdsToUpdate = new Set<Id>();

        if (Trigger.isInsert) {
            processInsert();
        } else if (Trigger.isUpdate) {
            processUpdate();
        } else if (Trigger.isDelete) {
            processDelete();
        }
    }

    private void processInsert() {
        for (Contact contact : newContactList) {
            accountIdsToUpdate.add(contact.AccountId);
        }
    }

    private void processUpdate() {
        for (Contact contact : newContactList) {
            Contact oldContact = oldContactMap.get(contact.Id);
            if (oldContact.AccountId != contact.AccountId) {
                accountIdsToUpdate.add(oldContact.AccountId);
                accountIdsToUpdate.add(contact.AccountId);
            }
        }
    }

    private void processDelete() {
        for (Contact contact : oldContactList) {
            accountIdsToUpdate.add(contact.AccountId);
        }
    }

    public override void afterInsert() {
        AccountHelper.updateAccountRelatedObjectsCounts(accountIdsToUpdate, RELATED_OBJECT_NAME);
    }

    public override void afterUpdate() {
        AccountHelper.updateAccountRelatedObjectsCounts(accountIdsToUpdate, RELATED_OBJECT_NAME);
    }

    public override void afterDelete() {
        AccountHelper.updateAccountRelatedObjectsCounts(accountIdsToUpdate, RELATED_OBJECT_NAME);
    }
}