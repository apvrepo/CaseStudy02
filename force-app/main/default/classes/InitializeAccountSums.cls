/* @Description  This InitializeAccountSums class needs to be executed to initialize 
the Account Sums fields after deployment

Instructions:
1-Open Developer Console
2-Click 'Debug'  --> 'Open Execute Anonymous Window' 
3- Copy and paste the following code: 

InitializeAccountSums batch = new InitializeAccountSums();
Database.executeBatch(batch, 200); // Adjust the batch size as needed 

4- Click 'Execute' button

*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025          Initial Creation                                                    
*******************************************************************************************/

public class InitializeAccountSums implements Database.Batchable<SObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query all account records
        return Database.getQueryLocator([
            SELECT Id, Decision_Makers__c, Business_Users__c, OpportunitiesSum__c, AccountContactRelationSum__c, ContactsSum__c,
            (SELECT Id FROM Opportunities), 
            (SELECT Id, Roles FROM AccountContactRelations), 
            (SELECT Id FROM Contacts)
            FROM Account
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account account : scope) {
            Integer opportunityCount = account.Opportunities.size();
            Integer accountContactRelationCount = account.AccountContactRelations.size();
            Integer contactCount = account.Contacts.size();
            Integer decisionMakersCount = 0;
            Integer businessUsersCount = 0;
            
            for (AccountContactRelation acr : account.AccountContactRelations) {
                if (acr.Roles != null && acr.Roles != '') {
                    List<String> roles = acr.Roles.split(';');
                    for (String role : roles) {
                        if (role.equals('Decision Maker')) { // Besluitvormer  --> Decision Maker
                            decisionMakersCount++;
                        } 
                        if (role.equals('Business User')) { // Zakelijke gebruiker --> Business User
                            businessUsersCount++;
                        }
                    }
                }
            }
            
            account.OpportunitiesSum__c = opportunityCount;
            account.AccountContactRelationSum__c = accountContactRelationCount;
            account.ContactsSum__c = contactCount;
            account.Decision_Makers__c = decisionMakersCount;
            account.Business_Users__c = businessUsersCount;
            
            accountsToUpdate.add(account);
        }
        
        if (!accountsToUpdate.isEmpty()) {
            Database.SaveResult[] saveResults = Database.update(accountsToUpdate, false);
            
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        System.debug('InitializeAccountSums.execute() - Failed Record Error: ' + error.getMessage());
                    }
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Optionally, perform any post-processing tasks here
        System.debug('InitializeAccountSums batch job finished.');
    }
}