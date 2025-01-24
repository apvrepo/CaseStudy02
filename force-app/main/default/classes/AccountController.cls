/**********************************************************************************
* Name             AccountController.cls
* Author          Andres Pereyra
* Date            26/08/24
* Description     This is an Apex Class which is used mainly by two LWC components via wire service 
***********************************************************************************
* MODIFICATION LOG
* Version            Developer          Date               Description
* ------------------------------------------------------------------------------
* 1.0                Andres Pereyra     03 January 2025           Initial Creation 
* *********************************************************************************/

public without sharing class AccountController {
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
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getStandardLabels() {
        Map<String, String> labels = new Map<String, String>();
        // sObject Labels
        labels.put('Opportunity', Schema.SObjectType.Opportunity.label);
        labels.put('Contact', Schema.SObjectType.Contact.label);
        labels.put('AccountContactRelation', Schema.SObjectType.AccountContactRelation.label);
        // Field Labels
        labels.put('CreatedDate', Schema.SObjectType.Contact.fields.CreatedDate.label);
        labels.put('TickerSymbol', Schema.SObjectType.Account.fields.TickerSymbol.label);
        labels.put('AnnualRevenue', Schema.SObjectType.Account.fields.AnnualRevenue.label);
        labels.put('Business_Users__c', Schema.SObjectType.Account.fields.Business_Users__c.label);
        labels.put('Decision_Makers__c', Schema.SObjectType.Account.fields.Decision_Makers__c.label);
        return labels;
    }
    
}