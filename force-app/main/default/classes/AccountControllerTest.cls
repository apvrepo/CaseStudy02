/* @Description  This is a Test Class for the Apex Class AccountController.cls
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025         Initial Creation                                                
*******************************************************************************************/

@IsTest
public class AccountControllerTest {

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
    static void testGetAccounts() {
        List<Account> accounts = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 199];
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : accounts){
            accountIdSet.add(acc.Id);
        }
        
        List<Account> results = new List<Account>();
        
        Test.startTest();
        results = AccountController.getAccounts();
        Test.stopTest();
        
        System.assertEquals(results.size(), accounts.size(), 'Should match');
        
    }
    
    @IsTest
    static void testGetSingleAccountRelatedContacts() {
        List<Account> account = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 1];

        List<Contact> contacts = TestDataFactory.createContacts(4, account);
        List<Contact> results = new List<Contact>();
        
        Test.startTest();
        results = AccountController.getSingleAccountRelatedContacts(account[0].Id);
        Test.stopTest();
        
        System.assertEquals(contacts.size(), results.size(), 'Contacts count should be 4');
    }
    
        @IsTest
    static void testGetSingleAccountRelatedOportunitties() {
        List<Account> account = [SELECT Id, Name, TickerSymbol, AnnualRevenue, Business_Users__c, Decision_Makers__c, OpportunitiesSum__c, ContactsSum__c, AccountContactRelationSum__c FROM Account LIMIT 1];

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(4, account);
        List<Opportunity> results = new List<Opportunity>();
        
        Test.startTest();
        results = AccountController.getSingleAccountRelatedOportunitties(account[0].Id);
        Test.stopTest();
        
        System.assertEquals(opportunities.size(), results.size(), 'Opportunities count should be 4');
    }
}