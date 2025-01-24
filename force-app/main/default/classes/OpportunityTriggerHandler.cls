/* @Description  This OpportunityTriggerHandler class executes the logics based on the OpportunityTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                    
*******************************************************************************************/

public without sharing class OpportunityTriggerHandler extends TriggerHandler {

    private List<Opportunity> newOpportunityList;
    private List<Opportunity> oldOpportunityList;
    private Map<Id, Opportunity> oldOpportunityMap;
    private Set<Id> accountIdsToUpdate;
    private static final String RELATED_OBJECT_NAME = 'Opportunity';

    public OpportunityTriggerHandler() {
        this.newOpportunityList = Trigger.isDelete ? null : (List<Opportunity>) Trigger.new;
        this.oldOpportunityList = Trigger.isInsert ? null : (List<Opportunity>) Trigger.old;
        this.oldOpportunityMap = Trigger.isInsert ? null : (Map<Id, Opportunity>) Trigger.oldMap;
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
        for (Opportunity opp : newOpportunityList) {
            accountIdsToUpdate.add(opp.AccountId);
        }
    }

    private void processUpdate() {
        for (Opportunity opp : newOpportunityList) {
            Opportunity oldOpp = oldOpportunityMap.get(opp.Id);
            if (oldOpp.AccountId != opp.AccountId) {
                accountIdsToUpdate.add(oldOpp.AccountId);
                accountIdsToUpdate.add(opp.AccountId);
            }
        }
    }

    private void processDelete() {
        for (Opportunity opp : oldOpportunityList) {
            accountIdsToUpdate.add(opp.AccountId);
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