/* @Description  This AccountContactRelationTriggerHandler class executes the logics based on the AccountContactRelationTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      03/01/2025         Initial Creation                                                   
*******************************************************************************************/

public without sharing class AccountContactRelationTriggerHandler extends TriggerHandler {
    
    private List<AccountContactRelation> newAccountContactRelationList;
    private List<AccountContactRelation> oldAccountContactRelationList;
    private Map<Id, AccountContactRelation> oldAccountContactRelationMap;
    private Set<Id> accountIdsToUpdate;
    private List<AccountContactRelation> accountContactRelationListToProcess;
    private static final String RELATED_OBJECT_NAME = 'AccountContactRelation';
    
    public AccountContactRelationTriggerHandler() {
        this.newAccountContactRelationList = Trigger.isDelete ? null : (List<AccountContactRelation>) Trigger.new;
        this.oldAccountContactRelationList = Trigger.isInsert ? null : (List<AccountContactRelation>) Trigger.old;
        this.oldAccountContactRelationMap = Trigger.isInsert ? null : (Map<Id, AccountContactRelation>) Trigger.oldMap;
        this.accountIdsToUpdate = new Set<Id>();
        this.accountContactRelationListToProcess = new List<AccountContactRelation>();

        if (Trigger.isInsert) {
            processInsert();
        } else if (Trigger.isUpdate) {
            processUpdate();
        }
    }

    private void processInsert() {
        for (AccountContactRelation acr : newAccountContactRelationList) {
            accountIdsToUpdate.add(acr.AccountId);
            accountContactRelationListToProcess.add(acr);
        }
    }

    private void processUpdate() {
        for (AccountContactRelation acr : newAccountContactRelationList) {
            AccountContactRelation oldACR = oldAccountContactRelationMap.get(acr.Id);
            if (oldACR != null && oldACR.Roles != acr.Roles) {
                accountContactRelationListToProcess.add(acr);
            }
            if (oldACR != null && oldACR.AccountId != acr.AccountId) {
                accountIdsToUpdate.add(oldACR.AccountId);
                accountIdsToUpdate.add(acr.AccountId);
            }
        }
    }
  
    public override void afterInsert() {
        AccountHelper.updateAccountRolesCounts(accountContactRelationListToProcess);
        AccountHelper.updateAccountRelatedObjectsCounts(accountIdsToUpdate, RELATED_OBJECT_NAME);
    }
    
    public override void afterUpdate() {
        AccountHelper.updateAccountRolesCounts(accountContactRelationListToProcess);
        AccountHelper.updateAccountRelatedObjectsCounts(accountIdsToUpdate, RELATED_OBJECT_NAME);
    }
    
}