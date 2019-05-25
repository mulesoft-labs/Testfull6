public with sharing class TechEnvironmentCustomCreate {
   
    ApexPages.StandardController c;
    public Opportunity o { get; set; }

    public TechEnvironmentCustomCreate(ApexPages.StandardController controller) {
        this.c=controller;
        this.o=(Opportunity)c.getRecord();
    }
    
    public pageReference NewTechEnvironment() {
        
        PageReference newTechEnvironmentURL;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        
        Opportunity currentOpp = [SELECT Id, Tech_Assessment__c, Name from Opportunity where Id=:o.Id];
        
        //List <Mutual_Close_Plan__c> mcPlanList = [SELECT mcp.Id, mcp.Opportunity__c from Mutual_Close_Plan__c mcp where mcp.Opportunity__c=:o.Id];
        //List <Mutual_Close_Plan__c> upMCPlanList = new List <Mutual_Close_Plan__c> ();
        
        if(currentOpp.Tech_Assessment__c !=null)
        {
           newTechEnvironmentURL = new PageReference(sfdcURL + currentOpp.Tech_Assessment__c + '/e?retURL=%2F' + currentOpp.Tech_Assessment__c);
        }
        else{
          
             Profile_Qualification__c techEnvironment = new Profile_Qualification__c();
             techEnvironment.Name = currentOpp.Name + '-' + 'TechEnvironment';
             techEnvironment.Opportunity__c = currentOpp.Id;
             
             insert techEnvironment;
             
             /*for(Mutual_Close_Plan__c mc:mcPlanList){
                upMCPlanList .add(mc);
             }
             update upMCPlanList ;*/
             
             newTechEnvironmentURL = new PageReference(sfdcURL + techEnvironment.Id + '/e?retURL=%2F' + techEnvironment.Id);
         
        }
        
        return newTechEnvironmentURL;
    }

}