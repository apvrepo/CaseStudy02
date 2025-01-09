/* @Description  This AccountTriggerHandler class executes the logics based on the AccountTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                     
*******************************************************************************************/

public without sharing class AccountTriggerHandler extends TriggerHandler {

    private List<Account> newAccountList;
    
    public AccountTriggerHandler() {
        this.newAccountList = trigger.new;
    }
    
}