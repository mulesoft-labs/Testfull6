/*********************************************************************
*
*   File Name: MutualClosePlanCustomCreate
*
*   File Description: This class creates new Mutual Close Plan
*
**********************************************************************
*
*   Date            Author          Change
*   09/6/14         Rob             Added funtionality for save&new 
*                                                         
*
*********************************************************************/
public with sharing class MutualClosePlanCustomCreate 
{
    
    ApexPages.StandardSetController c;
    public List<Mutual_Close_Plan__c> conSelectedList { get; set; }
    public List<Mutual_Close_Plan__c> conList = New List<Mutual_Close_Plan__c>();
    List<Opportunity> o = new List<Opportunity>();
    boolean isParentOpp = true;
    
    public MutualClosePlanCustomCreate(ApexPages.StandardSetController controller) 
    {
        this.c=controller;
        conSelectedList = New List<Mutual_Close_Plan__c>();
        this.conList = controller.getSelected();
        System.debug ('Con List = ' + conList.size());
        String parentId = ApexPages.currentPage().getParameters().get('id');
        //String parentId1 = ApexPages.currentPage().getParameters().get('parentId');
        System.debug ('parentId = ' + parentId);
        //System.debug ('parentId1 = ' + parentId1);
        if(conList.size() > 0)
        {
            System.debug ('ConList Has values');
            conSelectedList = [SELECT Opportunity__c, Id from Mutual_Close_Plan__c where Id IN:conList];
        }
        System.debug ('Selected Con List = ' + conSelectedList.size());
        if(conSelectedList.size() > 0)
        {
            System.debug ('ConSelectedList Has values');
        }
        o = [SELECT Id, name from Opportunity where Id=:parentId];
       
    }
    
    public pageReference NewMutualClosePlan() 
    {
        PageReference newMCPlanURL = null;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        System.debug('In Page Reference Class');
        Mutual_Close_Plan__c mcp = new Mutual_Close_Plan__c();
        String parentId;
        mcp.Action_Owner__c='';
        mcp.Mutual_Close_Action_Name__c='';
        mcp.Due_Date__c = Date.today();
        //If Parent SObject for Related List is Opportunity
        if (o.size()>0)
        {
            System.debug('In o != null');
            mcp.Opportunity__c = o[0].Id;
            parentId=o[0].Id;

        }
        
        insert mcp;
        //System.debug(conSelectedList[0].Id);
        newMCPlanURL = new PageReference(sfdcURL + mcp.Id + '/e?retURL=%2F' + mcp.Id);    
        String cancelMCPlanURL = sfdcURL + 'apex/Mutual_Close_Plan_custom_cancel_page?Id='+ mcp.Id + '&isParentOpp=' + isParentOpp;
        String saveMCPlanURL = sfdcURL + parentId;
        if (o.size()>0)
        {
            //newMCPlanURL.getParameters().put('parentId', o[0].id); 
            newMCPlanURL.getParameters().put('CF00N80000005ABBa_lkid', o[0].id); 
            newMCPlanURL.getParameters().put('CF00N80000005ABBa', o[0].Name); 
        }
      
        
        newMCPlanURL.getParameters().put('saveURL', saveMCPlanURL); 
        newMCPlanURL.getParameters().put('cancelURL', cancelMCPlanURL);
        newMCPlanURL.getParameters().put('nooverride', '1');
        //newMCPlanURL.setRedirect(true);
        //newMCPlanURL.setRedirect(true);
        
        System.debug('In MC PLan Custom Controller=' + mcp.Id);
        System.debug('MC URL (Custom Controller)='+ newMCPlanURL);
        System.debug('Cancel URL (Custom Controller) = ' + cancelMCPlanURL);
        System.debug('Save URL (Custom Controller)= ' + saveMCPlanURL);
        
        return newMCPlanURL;
    }
}