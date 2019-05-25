/*
*  Revison History:
*
**********************************************************************
*
*   Date            Author                 Change
*   06/12/15        Elmar Chen             Add !Test.isRunningTest() to wrap the satement calling 
*                                          standardController.addFieldsthe in the construtor so as
*                                          to make it testable.      
*
*********************************************************************/

public with sharing class ConnectorRelatedList 
{

    //used to save the status of popup and change it
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }

    //holds current opportunity
    private Opportunity opp {get; set;} 

    //holds required connedctors for the current opportunity
    public  List<Extension_Opportunity__c> oppConnectors { get; set; }
  
    //holds the connector selected for deletion
    public string selectedConnectorId { get; set; }
    
    //holds the list of connectors chosen to be added to the current opportunity   
    public string[] selectedConnectors { get;set; }

    //holds if the connector is critical or not critical   
    public boolean critical { get;set; }
   
    //holds the list of available connectors for popup
    public List<SelectOption> optionsList { get;set; }
  

    private ApexPages.StandardController standardController;

    public ConnectorRelatedList(ApexPages.StandardController standardController)
    {   
        this.standardController = standardController;
        
        //intializing opportunity and realted connectors
        if (!Test.isRunningTest()) {
          this.standardController.addFields(new List<String> { 'ExpectedRevenue', 'Amount', 'isWon', 'isClosed', 'Opportunity_Extensions__r',  'Opportunity_Extensions__r.id', 'Opportunity_Extensions__r.Date_Created__c', 'Opportunity_Extensions__r.Extension__r.Name', 'Opportunity_Extensions__r.Extension__r.Category__c', 'Opportunity_Extensions__r.Extension__r.Supported__c', 'Opportunity_Extensions__r.Extension__r.Status__c', 'Opportunity_Extensions__r.Extension__r.Planned_Release_Year__c', 'Opportunity_Extensions__r.Extension__r.Planned_Release_Month__c'});
        }
        opp = (Opportunity) standardController.getRecord();
        loadOppConnectors();

        //populating popup list of available connectors
        List<Extension__c> connectorsList;
        optionsList = new list<SelectOption>();
        connectorsList = [Select id, Name from Extension__c order by Name];
        if (connectorsList != null)
            for(Extension__c c : connectorsList)
            {
                optionsList.add(new SelectOption(c.Id, c.Name.Replace(' Connector', '')));
            }

    }
    
    // loads related connectors to the current opportunity
    public void loadOppConnectors()
    {
        oppConnectors = [select id, Date_Created__c, Critical__c, Extension__r.id, Extension__r.Name, Extension__r.Category__c, Extension__r.Supported__c, Extension__r.Status__c, Extension__r.Planned_Release_Year__c, Extension__r.Planned_Release_Month__c from Extension_Opportunity__c where Opportunity__r.id = :opp.id order by Critical__c desc];
    }
        

    // return the number of related connectors for the current opportunity
    public Integer getChildCount()
    {
        if (oppConnectors != null)
            return oppConnectors.size();
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
      List<Extension_Opportunity__c> connectors;
      connectors = [Select id from Extension_Opportunity__c where id=:selectedConnectorId];
      Extension_Opportunity__c tobeDeleted = null;
      for(Extension_Opportunity__c c : connectors)
       if (c.Id == selectedConnectorId) {
          tobeDeleted = c;
          break;
       }
      
      //if account record found delete it
      if (tobeDeleted != null) {
      try
      {
       Delete tobeDeleted;
       }
       
       catch(System.DmlException d){
            if(d.getDmlType(0) == StatusCode.ENTITY_IS_LOCKED){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'The Opportunity has been locked for editing.  Please contact your System Administrator to request it be unlocked.'));
            }
         }
       
      }
      
//      standardController.reset();
//      opp = (Opportunity) standardController.getRecord();
        loadOppConnectors();
   }

   // Makes a connector critical/not critical
   public void Criticalize()
   {
      // if for any reason we are missing the reference 
      if (selectedConnectorId == null) {
      
         return;
      }
     
     // find the account record within the collection
      List<Extension_Opportunity__c> connectors;
      connectors = [Select id from Extension_Opportunity__c where id=:selectedConnectorId];
      Extension_Opportunity__c tobeCritical = null;
      for(Extension_Opportunity__c c : connectors)
       if (c.Id == selectedConnectorId) {
          tobeCritical = c;
          break;
       }
      
      //if account record found delete it
      if (tobeCritical != null) {
       tobeCritical.Critical__C = critical;
       try
       {
        Update tobeCritical;
       }
       catch(System.DmlException d){
            if(d.getDmlType(0) == StatusCode.ENTITY_IS_LOCKED){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'The Opportunity has been locked for editing.  Please contact your System Administrator to request it be unlocked.'));
            }
         }
       
      }

//      standardController.reset();
//      opp = (Opportunity) standardController.getRecord();
        loadOppConnectors();
     
   }
   

   // Add a list of connectors user has chosen in popup
   public void AddConnectors()
   {

      if (selectedConnectors == null) {
      
         return;
      }
      
      for (string id: selectedConnectors)
      {
         Extension_Opportunity__c requiredConnector = new Extension_Opportunity__c();
         requiredConnector.Extension__c = id;
         requiredConnector.Opportunity__c = opp.id;

         requiredConnector.ExpectedRevenue__c = 0;
         requiredConnector.BookedRevenue__c = 0;
         requiredConnector.LostRevenue__c = 0;

         if (opp.isClosed == true && opp.isWon == true){
             requiredConnector.Status__c = 'Won';
             requiredConnector.BookedRevenue__c = opp.Amount;
         }    
         else if (opp.isClosed == true && opp.isWon == false) {
             requiredConnector.Status__c = 'Lost';
             requiredConnector.LostRevenue__c = opp.Amount;
         }
         else if (opp.isClosed == false) {
             requiredConnector.Status__c = 'In Progress'; 
             requiredConnector.ExpectedRevenue__c = opp.ExpectedRevenue;
         }    
         try{
            insert requiredConnector;     
         }
         catch(System.DmlException d){
            if(d.getDmlType(0) == StatusCode.ENTITY_IS_LOCKED){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'The Opportunity has been locked for editing.  Please contact your System Administrator to request it be unlocked.'));
            }
         }
      }
      
      displayPopup = false;    
//      standardController.reset();
//      opp = (Opportunity) standardController.getRecord();
      loadOppConnectors();
    
  }
}