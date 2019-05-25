/*** 
* Class: CopyDocumentsAsAttachmentstTest
* Description: Unit test for CopyDocumentsAsAttachmentstTest
* Author: Elmar Chen
* Create Time: 06/23/2015 14:37:49
*
**********************************************************************
*
*   Date            Author                 Change
*   06/23/15        Elmar Chen             Initial Creation                          
*
*
*********************************************************************/

@isTest
private class CopyDocumentsAsAttachmentstTest {
    
    @isTest static void test_deepCloneProject() {
        List<Project__c> prjs = TestDataFactory.createProject(2, true, null);
        
        Project__c prj = prjs[0];
        Project__c masterPrj = prjs[1];
        
        List<Milestone__c> ms = TestDataFactory.createMilestone(20, true, new Map<String, Object>{
            'Project__c' => masterPrj.Id,
            'Estimated_Hours__c' => 600
        });
        List<Work_Task__c> wts = TestDataFactory.createWorkTask(20, true, new Map<String, Object>{
            'Project__c' => masterPrj.Id,
            'Description__c' =>'Description__c'
        });


        //List<UserProfileFeed> items = TestDataFactory.createObjects(UserProfileFeed.SObjectType, 20, true,  
        //    new Map<String, Object>{
        //        'Type' => 'ContentPost',
        //        'ContentData' => 'item.contentdata',
        //        'contentdescription' => 'item.contentdescription',
        //        'contentfilename' => 'item.contentfilename',
        //        'ParentId' => masterPrj.Id
        //    }
        //);
    Test.startTest();
        CopyDocumentsAsAttachments.deepCloneProject(prj.Id, masterPrj.Id);
    Test.stopTest();
        ms= [SELECT Estimated_Hours__c FROM Milestone__c WHERE Project__c = :prj.Id];
        wts = [SELECT Description__c FROM Work_Task__c WHERE Project__c = :prj.Id];
        //items = [SELECT Type, ContentData, contentdescription, contentfilename 
        //    FROM UserProfileFeed WHERE ParentId=:prj.Id with UserId =:UserInfo.getUserId()];
        System.assertEquals(20, ms.size()); 
        System.assertEquals(20, wts.size());
        //System.assertEquals(20, items.size());
    }
    
}