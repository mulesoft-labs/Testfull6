/*********************************************************************
*
*   File Name: ActivityCountHandlerTest.cls
*
*   File Description: Test class for ActivityCountHandler
*
**********************************************************************
*
*   Date            Author                 Change
*   07/29/14        Rob                  Initial Creation                          
*
*********************************************************************/
@isTest
private class ActivityCountHandlerTest 
{
    /**
    *Test Method for Task After Insert
    */
    static testMethod void TaskAfterInsertTest() 
    {
         Test.startTest();
         
         Account acc=createAccount();
         Contact Con=createContact(acc.id);
         Task tContact=createTaskContact(con.id);
         
         Lead l=createLead();
         Task tlead=createTasklead(l.id);
         
         Test.stopTest() ;
         system.assertEquals(acc.name, 'testName');
         System.assertNotEquals(acc.name,'Demo');
         
         System.assertEquals(Con.lastname, 'testLastName');
         System.assertNotEquals(Con.lastname,'Demo1');
        
         System.assertEquals(l.lastname, 'testlastName');
         System.assertNotEquals(l.lastname,'DemotestlastName');
    }
    
    /**
    *Test Method for Task After update
    */
    static testMethod void TaskAfterUpdateTest() 
    {
         Test.startTest();
         
         Account acc=createAccount();
         Contact Con=createContact(acc.id);
         Task tContact=createTaskContact(con.id);
         
         tContact.Call_Type__c='Connected - Call';
         Database.SaveResult resultContactUpdate = Database.update(tContact, true);
        
         Test.stopTest() ;
         system.assertEquals(acc.name, 'testName');
         System.assertNotEquals(acc.name,'Demo');
         
         System.assertEquals(Con.lastname, 'testLastName');
         System.assertNotEquals(Con.lastname,'Demo1');
        
    }
    
    /**
    *Test Method for Task After Delete
    */
    static testMethod void TaskAfterDeleteTest() 
    {
         Test.startTest();
         
         Account acc=createAccount();
         Contact Con=createContact(acc.id);
         Task tContact=createTaskContact(con.id);
         
         delete tContact;
         
         Test.stopTest() ;
         system.assertEquals(acc.name, 'testName');
         System.assertNotEquals(acc.name,'Demo');
         
         System.assertEquals(Con.lastname, 'testLastName');
         System.assertNotEquals(Con.lastname,'Demo1');
         
    }
    
    /**
    *Test Method for Task After UnDelete
    */
    static testMethod void TaskAfterUndeleteTest() {
         Test.startTest();
         
         Account acc=createAccount();
         Contact Con=createContact(acc.id);
         Task tContact=createTaskContact(con.id);
         
         delete tContact;
         undelete tContact;
         
         Test.stopTest() ;
         
         system.assertEquals(acc.name, 'testName');
         System.assertNotEquals(acc.name,'Demo');
         
         System.assertEquals(Con.lastname, 'testLastName');
         System.assertNotEquals(Con.lastname,'Demo1');
        
    }
    
    /**
    *Create Test Account data
    */
    private static Account createAccount()  
    {
        Account testAccount= new Account();
        testAccount.Name= 'testName'; 
        testAccount.BillingCountry='US';
        Database.SaveResult resultaccount = Database.insert(testAccount, true);
        return testAccount;
    }
    
    /**
    *Create Test Contact data
    */
    private static Contact createContact(id accid)  
    {
        Contact testContact= new Contact();
        testContact.LastName= 'testLastName'; 
        testContact.accountid=accid;
        testContact.LeadSource='Operations & Support';
        testContact.Contact_Status__c='Qulaified';
        Database.SaveResult resultContact= Database.insert(testContact, true);
        return testContact;
    }
    
    /**
    *Create Test Task data for contact
    */
    private static Task createTaskContact(id conid) 
    {
        Task testTask= new Task();
        testTask.subject= 'testsubject'; 
        testTask.whoid=conid;
        testtask.Call_Type__c='AE Connect';
        testtask.RecordTypeId=getRecordtypeId();
        Database.SaveResult resultContact= Database.insert(testTask, true);
        return testtask;
    }
    
    /**
    *Create Test Task data for Lead
    */
    private static Task createTasklead(id lid)  
    {
        Task testTask= new Task();
        testTask.subject= 'testsubject'; 
        testTask.whoid=lid;
        testtask.Call_Type__c='AE Connect';
        testtask.RecordTypeId=getRecordtypeId();
        Database.SaveResult resultTask= Database.insert(testTask, true);
        return testtask;
    }
    
    /**
    *Create Test lead data
    */
    private static Lead createLead()    
    {
        Lead testLead= new Lead();
        testLead.lastName= 'testlastName'; 
        testLead.Company='TestCompany';
        testLead.LeadSource='Operations & Support';
        testLead.Territory__c='NA';
        testLead.status='Qulaified';
        testLead.Country = 'US';
        Database.SaveResult resultContact= Database.insert(testLead, true);
        return testLead;
    }
    
    /**
    *Get record type id for Task
    */
    private static id getRecordtypeId() 
    {
        return [Select Id, Name,DeveloperName  From RecordType Where sObjectType = 'Task' and isActive = true and DeveloperName='Call_log'].id;
    }
    
}