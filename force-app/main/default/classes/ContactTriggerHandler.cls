/* @Description  This ServiceTerritoryMemberTriggerHandler class executes the logics based on the ServiceTerritoryMemberTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      01/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                     
*******************************************************************************************/

public without sharing class ContactTriggerHandler  extends TriggerHandler {

        private List<Contact> newContactList;
    
    public ContactTriggerHandler() {
        this.newContactList = trigger.new;
    }
    /*
        // Instance of the Apex Class 'ServiceTerritoryMemberHelper':
    private ServiceTerritoryMemberHelper serviceTerritoryMemberHelper = new ServiceTerritoryMemberHelper();
    
    public override void beforeInsert() {
        serviceTerritoryMemberHelper.validateDates(newServiceTerritoryMemberList);
    }
    */
}