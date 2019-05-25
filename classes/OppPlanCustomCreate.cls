public with sharing class OppPlanCustomCreate {
    
    ApexPages.StandardController c;
    public Opportunity o { get; set; }

    public OppPlanCustomCreate(ApexPages.StandardController controller) {
        this.c=controller;
        this.o=(Opportunity)c.getRecord();
    }
    
    public pageReference NewOpportunityPlan() {
        
        PageReference newOppPlanURL;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        
        Opportunity currentOpp = [SELECT Id, Name from Opportunity where Id=:o.Id];
        //String returnURL = sfdcURL + currentOpp.Id;
           
        //List <Mutual_Close_Plan__c> mcPlanList = [SELECT mcp.Id, mcp.Opportunity__c from Mutual_Close_Plan__c mcp where mcp.Opportunity__c=:o.Id];
        //List <Mutual_Close_Plan__c> upMCPlanList = new List <Mutual_Close_Plan__c> ();
        
        if(currentOpp.Name !=null)
        {
           newOppPlanURL = new PageReference(sfdcURL);
        }
        else{
          
                       
             newOppPlanURL = new PageReference(sfdcURL);             
        }
        
        //newOppPlanURL.getParameters().put('saveURL', returnURL); 
        //newOppPlanURL.getParameters().put('cancelURL', returnURL);
        
        return newOppPlanURL;
    }

}