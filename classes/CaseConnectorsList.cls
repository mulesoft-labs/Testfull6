public with sharing class CaseConnectorsList
{

    //used to save the status of popup and change it
    public boolean displayPopup {get; set;}    
   
    public void closePopup() {       
        displayPopup = false;   
    }    
    public void showPopup() {       
        displayPopup = true;   
    }

    //holds current case
    private Case thisCase {get; set;}

    //holds required connedctors for the current case
    public  List<Case_Connector__c> caseConnectors { get; set; }
 
    //holds the connector selected for deletion
    public string selectedConnectorId { get; set; }
   
    //holds the list of connectors chosen to be added to the current opportunity  
    public string[] selectedConnectors { get;set; }
  
    //holds the list of available connectors for popup
    public List<SelectOption> optionsList { get;set; }
 

    private ApexPages.StandardController standardController;

    public CaseConnectorsList(ApexPages.StandardController standardController)
    {  
        this.standardController = standardController;
       
        //intializing case and realted connectors
        if(!test.isRunningTest())
            this.standardController.addFields(new List<String> { 'Case_Connectors__r',  'Case_Connectors__r.id', 'Case_Connectors__r.Date_Created__c', 'Case_Connectors__r.Extension_Version__r.Name', 'Case_Connectors__r.Extension_Version__r.Extension__r.Name'});
        thisCase = (Case) standardController.getRecord();
        loadCaseConnectors();

        //populating popup list of available connectors
        List<Extension_Version__c> connectorsList;
        optionsList = new list<SelectOption>();
        connectorsList = [Select id, Name, Extension__r.Name from Extension_Version__c order by Extension__r.Name, Name];
        for(Extension_Version__c c : connectorsList)
        {
            optionsList.add(new SelectOption(c.Id, c.Extension__r.Name + ': ' + c.Name));
        }

    }
   
    // loads related connectors to the current opportunity
    public void loadCaseConnectors()
    {
        caseConnectors = [select id, Date_Created__c, Extension_Version__r.id, Extension_Version__r.Name, Extension_Version__r.Extension__r.Name from Case_Connector__c where Case__r.id = :thisCase.id order by Extension_Version__r.Extension__r.Name, Name];
    }
       

    // return the number of related connectors for the current opportunity
    public Integer getChildCount()
    {
        if (caseConnectors != null)
            return caseConnectors.size();
        else
            return 0;
    }
  
   // Deletes a connector
   public void DeleteConnector()
   {
      // if for any reason we are missing the reference
      if (selectedConnectorId == null) {
     
         return;
      }
    
     // find the account record within the collection
      List<Case_Connector__c> connectors;
      connectors = [Select id from Case_Connector__c where id=:selectedConnectorId];
      Case_Connector__c tobeDeleted = null;
      for(Case_Connector__c c : connectors)
       if (c.Id == selectedConnectorId) {
          tobeDeleted = c;
          break;
       }
     
      //if account record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }

//      standardController.reset();
//      opp = (Opportunity) standardController.getRecord();
        loadCaseConnectors();
    
   }
  

   // Add a list of connectors user has chosen in popup
   public void AddConnectors()
   {

      if (selectedConnectors == null) {
     
         return;
      }
     
      for (string id: selectedConnectors)
      {
         Case_Connector__c requiredConnector = new Case_Connector__c();
         requiredConnector.Extension_Version__c = id;
         requiredConnector.Case__c = thisCase.id;
         insert requiredConnector;    
      }
     
      displayPopup = false;   
//      standardController.reset();
//      opp = (Opportunity) standardController.getRecord();
      loadCaseConnectors();
   
  }
  
}