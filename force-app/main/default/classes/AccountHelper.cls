/**********************************************************************************
* Name             AccountHelper.cls
* Author          Andres Pereyra
* Date            26/08/24
* Description     This is an Apex Class which is used by two LWC components via wire service 
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
            SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, 
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
            SELECT Id, Name
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY Name ASC
        ];
    }
    
    
}