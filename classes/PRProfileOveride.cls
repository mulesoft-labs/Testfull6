public with sharing class PRProfileOveride {
    
    ApexPages.StandardController c;
    public Opportunity o { get; set; }

    public PRProfileOveride(ApexPages.StandardController controller) {
        this.c=controller;
        this.o=(Opportunity)c.getRecord();
    }
    
    public pageReference NewProfile() {
        
        PageReference newProfileURL;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        Opportunity currentOpp = [SELECT Id, Profile_and_Qualifications__c, Name from Opportunity where Id=:o.Id];
        
        List<Presales_Request__c> presalesList = [SELECT p.Id, p.Opportunity__c, p.Profile_and_Qualifications__c  from Presales_Request__c p where p.Opportunity__c=:o.Id];
        List <Presales_Request__c> upPresalesList = new List <Presales_Request__c> ();
        
        if(currentOpp.Profile_and_Qualifications__c !=null)
        {
           newProfileURL = new PageReference(sfdcURL + currentOpp.Profile_and_Qualifications__c + '/e?retURL=%2F' + currentOpp.Profile_and_Qualifications__c);
        }
        else{
          
             Profile_Qualification__c profileQual = new Profile_Qualification__c();
             profileQual.Name = currentOpp.Name;
             profileQual.Opportunity__c = currentOpp.Id;
             
             insert profileQual;
             
             for(Presales_Request__c pr:presalesList){
                 pr.Profile_and_Qualifications__c=profileQual.Id;
                 upPresalesList.add(pr);
             }
             update upPresalesList;
             Profile_Qualification__c pqq = [SELECT Id from Profile_Qualification__c where Opportunity__c=:currentOpp.Id];
             
             newProfileURL = new PageReference(sfdcURL + pqq.Id + '/e?retURL=%2F' + pqq.Id);
         
        }
        
        return newProfileURL;
    }

}