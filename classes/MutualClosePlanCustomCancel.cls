public with sharing class MutualClosePlanCustomCancel {

    String recordId = null;
    boolean whoParent = true;
    List<Mutual_Close_Plan__c> mcpList = new List<Mutual_Close_Plan__c>();
    public MutualClosePlanCustomCancel(ApexPages.StandardController controller) {
         recordId = ApexPages.currentPage().getParameters().get('Id');
         whoParent = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isParentOpp'));
         System.debug('whoParent set to = ' + whoParent);
         System.debug('recordId = ' + recordId);
    }
    
    public pageReference CancelMutualClosePlan() {
        
        System.debug ('Record Id = ' + recordId);
        PageReference newReturnURL;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        
         mcpList = [SELECT Opportunity__c, Action_Owner__c, Mutual_Close_Action_Name__c from Mutual_Close_Plan__c where Id=:recordId];
         String oppId = null;
 
         if(mcpList.size() > 0)
         {
             oppId = mcpList[0].Opportunity__c;
             System.debug ('Size in Cancel  > 0');
             //if(mcpList[0].Action_Owner__c=='' && mcpList[0].Mutual_Close_Action_Name__c==''){
                 delete mcpList[0];   
                 System.debug('In Cancel MCP deleted'); 
             //}
         }
         
         System.debug('In Cancel oppId = ' + oppId);
         
         if(whoParent == true)
             newReturnURL = new PageReference(sfdcURL + oppId);
         else
             newReturnURL = new PageReference(sfdcURL);
             
         return newReturnURL;
    
    }
    
}