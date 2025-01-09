/* @Description  This is a Test Class for the Apex Class AccountHelper.cls
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025         Initial Creation                                                
*******************************************************************************************/

@IsTest
public class AccountHelperTest {
    @testSetup 
    static void setup() {   
        /* 
'Besluitvormer' --> 'Decision Maker'
'Zakelijke gebruiker' --> 'Business User'
*/          
        // Create test data
        List<Account> accounts = TestDataFactory.createAccounts(4);   
    }
    
    
    @IsTest
    static void testUpdateAccountRolesCounts() {
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        // List<Contact> contacts = [   SELECT Id, Name, CreatedDate, AccountId FROM Contact WHERE AccountId = :accountIdSet];
        List<Contact> contacts = TestDataFactory.createContacts(4, accounts);  
        List<AccountContactRelation> acrList = [SELECT Id, AccountId, Roles FROM AccountContactRelation WHERE AccountId IN :accountIdSet];
        
        for (Account acc : accounts) {
            System.assertEquals(0, acc.Decision_Makers__c, 'Decision Makers count should be 0');
            System.assertEquals(0, acc.Business_Users__c, 'Business Users count should be 0');
        }
        
        // Map AccountContactRelation by AccountId
        Map<Id, List<AccountContactRelation>> acrMap = new Map<Id, List<AccountContactRelation>>();
        for (AccountContactRelation acr : acrList) {
            if (!acrMap.containsKey(acr.AccountId)) {
                acrMap.put(acr.AccountId, new List<AccountContactRelation>());
            }
            acrMap.get(acr.AccountId).add(acr);
        }
        // Assign roles
        for (Account acc : accounts) {
            if (acrMap.containsKey(acc.Id)) {
                for (AccountContactRelation acr : acrMap.get(acc.Id)) {
                    acr.Roles = 'Besluitvormer';
                }
            }
        }
        
        Test.startTest();
        update acrList;
        Test.stopTest();
        
        // Verify the results
        accounts = [SELECT Id, Decision_Makers__c, Business_Users__c FROM Account WHERE Id IN :accounts];
        for (Account acc : accounts) {
            System.assertEquals(4, acc.Decision_Makers__c, 'Decision Makers count should be 4');
            System.assertEquals(0, acc.Business_Users__c, 'Business Users count should be 0');
        }
    }
    
    @IsTest
    static void testUpdateAccountRolesCountsNegative() {
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        // List<Contact> contacts = [   SELECT Id, Name, CreatedDate, AccountId FROM Contact WHERE AccountId = :accountIdSet];
        List<Contact> contacts = TestDataFactory.createContacts(4, accounts);  
        List<AccountContactRelation> acrList = [SELECT Id, AccountId, Roles FROM AccountContactRelation WHERE AccountId IN :accountIdSet];
        
        for (Account acc : accounts) {
            System.assertEquals(0, acc.Decision_Makers__c, 'Decision Makers count should be 0');
            System.assertEquals(0, acc.Business_Users__c, 'Business Users count should be 0');
        }
        
        // Map AccountContactRelation by AccountId
        Map<Id, List<AccountContactRelation>> acrMap = new Map<Id, List<AccountContactRelation>>();
        for (AccountContactRelation acr : acrList) {
            if (!acrMap.containsKey(acr.AccountId)) {
                acrMap.put(acr.AccountId, new List<AccountContactRelation>());
            }
            acrMap.get(acr.AccountId).add(acr);
        }
        // Assign roles
        for (Account acc : accounts) {
            if (acrMap.containsKey(acc.Id)) {
                for (AccountContactRelation acr : acrMap.get(acc.Id)) {
                    acr.Roles = 'Utilitaire koper'; //  'Utility Buyer'
                }
            }
        }
        
        Test.startTest();
        update acrList;
        Test.stopTest();
        
        // Verify the results
        accounts = [SELECT Id, Decision_Makers__c, Business_Users__c FROM Account WHERE Id IN :accounts];
        for (Account acc : accounts) {
            System.assertEquals(0, acc.Decision_Makers__c, 'Decision Makers count should be 0');
            System.assertEquals(0, acc.Business_Users__c, 'Business Users count should be 0');
        }
    }
    
    
    @IsTest
    static void testUpdateAccountRelatedObjectsCountsBulk() {
        // Create test data
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        for (Account acc : accounts) {
            System.assertEquals(0, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 0');
            System.assertEquals(0, acc.ContactsSum__c, 'ContactsSum__c count should be 0');
            System.assertEquals(0, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 0');
        }
        
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        
        Test.startTest();
        List<Contact> contacts = TestDataFactory.createContacts(180, accounts);
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(180, accounts);
        Test.stopTest();
        
        List<AccountContactRelation> acrList = [SELECT Id, AccountId, Roles FROM AccountContactRelation WHERE AccountId IN :accountIdSet];
        
        // Verify the results
        accounts = [SELECT Id, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account WHERE Id IN :accounts];
        for (Account acc : accounts) {
            System.assertEquals(180, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 180');
            System.assertEquals(180, acc.ContactsSum__c, 'ContactsSum__c count should be 180');
            System.assertEquals(180, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 180');
        }
    }
    
    @IsTest
    static void testUpdateAccountRelatedObjectsCountsBulkDelete() {
        // Create test data
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        for (Account acc : accounts) {
            System.assertEquals(0, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 0');
            System.assertEquals(0, acc.ContactsSum__c, 'ContactsSum__c count should be 0');
            System.assertEquals(0, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 0');
        }
        
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        List<Contact> contacts = TestDataFactory.createContacts(180, accounts);
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(180, accounts);
        
        Test.startTest();
        if(!contacts.isEmpty() && !opportunities.isEmpty()){
            delete opportunities;
            delete contacts;
        }
        Test.stopTest();
        
        // Verify the results
        accounts = [SELECT Id, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account WHERE Id IN :accounts];
        for (Account acc : accounts) {
            System.assertEquals(0, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 0');
            System.assertEquals(0, acc.ContactsSum__c, 'ContactsSum__c count should be 0');
            System.assertEquals(0, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 0');
        }
    }
    
    @IsTest
    static void testUpdateAccountIdOnRelatedObjectsCounts() {
        // Create test data
        List<Account> accounts = [SELECT Id, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        for (Account acc : accounts) {
            System.assertEquals(0, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 0');
            System.assertEquals(0, acc.ContactsSum__c, 'ContactsSum__c count should be 0');
            System.assertEquals(0, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 0');
        }
        
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        
        List<Contact> contacts = TestDataFactory.createContacts(10, accounts);
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(10, accounts);
        
        Test.startTest();
        for(Integer i = 0; i < contacts.size() -1 ; i++){
            contacts[i].AccountId = contacts[i+1].AccountId;
        }
        for(Integer j = 0; j < opportunities.size() -1 ; j++){
            opportunities[j].AccountId = opportunities[j+1].AccountId;
        }
        
        update contacts;
        update opportunities;
        Test.stopTest();
        
        List<AccountContactRelation> acrList = [SELECT Id, AccountId, Roles FROM AccountContactRelation WHERE AccountId IN :accountIdSet];
        
        // Verify the results
        accounts = [SELECT Id, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account WHERE Id IN :accounts];
        for (Account acc : accounts) {
            /*     System.assertEquals(10, acc.OpportunitiesSum__c, 'OpportunitiesSum__c count should be 10');
System.assertEquals(10, acc.ContactsSum__c, 'ContactsSum__c count should be 10');
System.assertEquals(10, acc.AccountContactRelationSum__c, 'AccountContactRelationSum__c count should be 10'); */
        }
    }
    @IsTest
    static void testGetAccounts() {
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        
        List<Account> results = new List<Account>();
        
        Test.startTest();
        results = AccountHelper.getAccounts();
        Test.stopTest();
        
        System.assertEquals(results.size(), accounts.size(), 'Should match');
        
    }
    
    @IsTest
    static void testGetSingleAccountRelatedContacts() {
        List<Account> account = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 1];

        List<Contact> contacts = TestDataFactory.createContacts(4, account);
        List<Contact> results = new List<Contact>();
        
        Test.startTest();
        results = AccountHelper.getSingleAccountRelatedContacts(account[0].Id);
        Test.stopTest();
        
        System.assertEquals(contacts.size(), results.size(), 'Contacts count should be 4');
    }
    
        @IsTest
    static void testGetSingleAccountRelatedOportunitties() {
        List<Account> account = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 1];

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(4, account);
        List<Opportunity> results = new List<Opportunity>();
        
        Test.startTest();
        results = AccountHelper.getSingleAccountRelatedOportunitties(account[0].Id);
        Test.stopTest();
        
        System.assertEquals(opportunities.size(), results.size(), 'Opportunities count should be 4');
    }
}