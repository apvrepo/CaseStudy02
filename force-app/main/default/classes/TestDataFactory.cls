/* @Description:   A framework is a highly optimized, reusable structure that serves as a building block. 
                 These building blocks provide common functionality that developers can override or 
                 specialize for their own needs. Reusable frameworks increase the speed of development, 
                 improve the clarity and efficiency of your code, and simplify code reviews and debugging. 
                 Which framework you use depends on your situation.

More Info:   https://trailhead.salesforce.com/content/learn/modules/success-cloud-coding-conventions/implement-frameworks-sc 
            https://trailhead.salesforce.com/content/learn/modules/apex_testing/apex_testing_data

*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      06/01/2025         Initial Creation                                                
*******************************************************************************************/

@IsTest
public class TestDataFactory {
    
    // USERS
    public static List<User> createUsers(Integer numUsers) {
        Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Integer randomInt = Integer.valueOf(Math.floor(Math.random() * 16003) + 1);
        
        List<User> uList = new List<User>();
        for ( Integer i=0; i < numUsers; i++ ) {
            User u = new User(); 
            u.LastName= 'Test';
            u.FirstName= 'User' + i;
            // u.Name= ;
            u.ProfileId = adminProfile.Id;
            u.IsActive= true;
            u.Alias = 'User' + i;
            u.EmailEncodingKey = 'UTF-8';
            u.Email = u.FirstName + '@gmail.com'; 
            u.Username= String.valueOf(u.FirstName + randomInt) + '@gmail.com';
            u.TimeZoneSidKey= 'Europe/Amsterdam';
            u.UserRoleId= null;
            u.LocaleSidKey= 'nl_NL';
            //  u.UserType= 'Standard';
            u.LanguageLocaleKey= 'en_US';
            u.UserPermissionsSFContentUser= true;
            u.UserPermissionsKnowledgeUser= true;
            u.UserPermissionsSupportUser= true;
            u.ContactId= null;
            // u.AccountId= null;
            u.DigestFrequency= 'D';
            u.DefaultGroupNotificationFrequency= 'N';
            u.JigsawImportLimitOverride= 300;
            uList.add(u);
        }
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(uList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory - Users - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }
        return uList;
    } 
    
    // ACCOUNTS
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accountsList = new List<Account>();
        for ( Integer i=0; i < numAccounts; i++ ) {
            Account a = new Account();
            a.Decision_Makers__c = 0;
            a.Business_Users__c = 0;
            a.OpportunitiesSum__c = 0;
            a.AccountContactRelationSum__c = 0;
            a.ContactsSum__c = 0;
            a.Name = 'TEST_ACCOUNT_' + i;
            accountsList.add(a);
        }
        // Perform the DML operation and capture the results    
        Database.SaveResult[] saveResults = Database.insert(accountsList, false);   
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();          
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory - Accounts - Failed Record Error:  ' + saveResult.getErrors());   
            }
        }
        return accountsList;
    }  
    
    // CONTACTS
    public static List<Contact> createContacts(Integer numContactsForAccount, List<Account> lstAccounts) {
        List<Contact> contactList = new List<Contact>();

        for(Account acc : lstAccounts){
            for ( Integer i=0; i < numContactsForAccount; i++ ) {
                Contact c = new Contact();
                c.LastName = 'TEST_CONTACT_' + i;
                c.AccountId = acc.Id;
                contactList.add(c);
            }   
        }

        // Perform the DML operation and capture the results    
        Database.SaveResult[] saveResults = Database.insert(contactList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();  
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory - Contacts - Failed Record Error:  ' + saveResult.getErrors());           
            }
        }
        return contactList;
    }       

    // OPPORTUNITIES    
    public static List<Opportunity> createOpportunities(Integer numOfOpportunities, List<Account> lstAccounts) {
        List<Opportunity> opportunityList = new List<Opportunity>();        
        for(Account acc : lstAccounts){
            for ( Integer i=0; i < numOfOpportunities; i++ ) {
                Opportunity o = new Opportunity();
                o.Name = 'TEST_OPPORTUNITY_' + i;   
                o.AccountId = acc.Id;
                o.Amount = 1000;
                o.StageName = 'Qualification';
                o.CloseDate = System.today();
                opportunityList.add(o);             
            }   
        }
        
        // Perform the DML operation and capture the results    
        Database.SaveResult[] saveResults = Database.insert(opportunityList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();  
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors()); 
                System.debug('TestDataFactory - Opportunities - Failed Record Error:  ' + saveResult.getErrors());           
            }
        }
        return opportunityList; 
    }    

}