/**********************************************************************************
* Name             AccountHelper.cls
* Author          Andres Pereyra
* Date            26/08/24
* Description     This is an Apex Class which is used mainly by two LWC components via wire service 
***********************************************************************************
* MODIFICATION LOG
* Version            Developer          Date               Description
* ------------------------------------------------------------------------------
* 1.0                Andres Pereyra     03 January 2025           Initial Creation 
* *********************************************************************************/

public without sharing class AccountHelper {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c,
            (SELECT Id, CreatedDate, Contact.Name FROM AccountContactRelations ORDER BY Contact.Name ASC)
            FROM Account
            ORDER BY Name ASC
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getSingleAccountRelatedContacts(Id accountId) {
        return [
            SELECT Id, Name, CreatedDate, AccountId
            FROM Contact
            WHERE AccountId = :accountId
            ORDER BY Name ASC
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getSingleAccountRelatedOportunitties(Id accountId) {
        return [
            SELECT Id, Name, Amount, AccountId
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY Name ASC
        ];
    }
    
    public void updateAccountRolesCounts(List<AccountContactRelation> accountContactRelationRecordsToProcess) {
        Set<Id> accountIds = new Set<Id>();
        
        // Collect account IDs from the records to process
        for (AccountContactRelation acr : accountContactRelationRecordsToProcess) {
            if (acr.AccountId != null) {
                accountIds.add(acr.AccountId);
            }
        }
        
        // Query the related AccountContactRelations for the affected accounts
        List<Account> accountsList = [
            SELECT Id, Decision_Makers__c, Business_Users__c,
            (SELECT Id, Roles FROM AccountContactRelations)
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        // Update the custom fields on the Account
        for (Account account : accountsList) {
            Integer decisionMakersCount = 0;
            Integer businessUsersCount = 0;
            
            for (AccountContactRelation acr : account.AccountContactRelations) {
                if (acr.Roles!= null && acr.Roles != '') {
                    // Split the Roles field by semicolon and check each value
                    List<String> roles = acr.Roles.split(';');
                    for (String role : roles) {
                        if (role.equals('Decision Maker')) { // Decision Maker
                            decisionMakersCount++;
                        } 
                        if (role.equals('Business User')) { // Business User
                            businessUsersCount++;
                        }
                    }
                }
            }   
            account.Decision_Makers__c = decisionMakersCount;
            account.Business_Users__c = businessUsersCount;
        }
        
        // Perform the DML operation to update the accounts
        if (!accountsList.isEmpty()) {
            Database.SaveResult[] saveResults = Database.update(accountsList, false);
            
            List<Database.Error> failedRecordsErrors = new List<Database.Error>();
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    failedRecordsErrors.addAll(saveResult.getErrors());
                }
            }
            if (!failedRecordsErrors.isEmpty()) {
                for (Database.Error error : failedRecordsErrors) {
                    System.debug('AccountHelper.updateAccountCounts() - Failed Record Error: ' + error.getMessage());
                }
            }
        }
    }
    
    
    public void updateAccountRelatedObjectsCounts(Set<Id> accountIds, String relatedObjectName) {
        
        if (accountIds.isEmpty()) {
            return;
        }
        // Query the affected accounts and their related objects
        String query = 'SELECT Id, ';
        if (relatedObjectName == 'Opportunity') {
            query += 'OpportunitiesSum__c, (SELECT Id FROM Opportunities) ';
        } else if (relatedObjectName == 'AccountContactRelation') {
            query += 'AccountContactRelationSum__c, (SELECT Id FROM AccountContactRelations) ';
        } else if (relatedObjectName == 'Contact') {
            query += 'ContactsSum__c, (SELECT Id FROM Contacts) ';
        }
        query += 'FROM Account WHERE Id IN :accountIds';
        
        List<Account> accountsList = Database.query(query);
        
        /// Update the custom fields on the Account
        for (Account account : accountsList) {
            if(relatedObjectName == 'Opportunity'){ 
                account.OpportunitiesSum__c = account.Opportunities.size();
            } else if (relatedObjectName == 'AccountContactRelation'){
                account.AccountContactRelationSum__c = account.AccountContactRelations.size();
            } else if (relatedObjectName == 'Contact'){
                account.ContactsSum__c = account.Contacts.size();
                account.AccountContactRelationSum__c = account.Contacts.size();
            }
        }
        
        // Perform the DML operation to update the accounts
        if (!accountsList.isEmpty()) {
            Database.SaveResult[] saveResults = Database.update(accountsList, false);
            
            List<Database.Error> failedRecordsErrors = new List<Database.Error>();
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    failedRecordsErrors.addAll(saveResult.getErrors());
                }
            }
            if (!failedRecordsErrors.isEmpty()) {
                for (Database.Error error : failedRecordsErrors) {
                    System.debug('AccountHelper.updateAccountRelatedObjectsCounts() - Failed Record Error: ' + error.getMessage());
                }
            }
        }
    }
}