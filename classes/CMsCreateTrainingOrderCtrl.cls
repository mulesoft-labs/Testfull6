/**
 * Controller for the page CMsCreateTrainingOrderCtrl
 */
public with sharing class CMsCreateTrainingOrderCtrl {
    public Boolean hasTrainingOpps = false;
    public String trainingOppsCreationPromptMsg {get; set;}
    public CMsCreateTrainingOrderCtrl(ApexPages.StandardController accController) {
        List<Opportunity> trainingOpps;
        if(accController.getRecord().Id != null){
            trainingOpps = [SELECT Id, accountId  FROM Opportunity
                        	WHERE accountId  = :accController.getRecord().Id AND name like '%Online Training%'];
        }
        if(trainingOpps.size() > 0) {
            hasTrainingOpps = true;
        }
		if(hasTrainingOpps){
        	trainingOppsCreationPromptMsg = 'There is already online training Order linked to this Account. Do you still want to create a new online training Order?';
   	 	} else {
        	trainingOppsCreationPromptMsg = 'Are you sure you want to create a new online training Order?';
    	}    
    }

    @RemoteAction
    public static boolean generateOnlineTrainingOrders(Id accId) {
        Opportunity opp = createOpportunity(accId);
        createQuote(opp);
        updateOppStageName(opp);

        return true;
    }

    public static Opportunity createOpportunity(Id accId) { 
        Account acct = [SELECT Name, OwnerId, ARR__c, X1st_Transaction_Date__c  FROM Account WHERE Id =:accId];
        Opportunity opp = new Opportunity();
        opp.name = acct.Name + ' - Online Training - [Add Contact Name]';
        opp.OwnerId = acct.OwnerId;
        opp.accountId = acct.Id;
        /* If online training order is created within 30 days of the 1st transaction date then its "New Business" 
		   else its "Add-On Business".
		*/
        if(acct.X1st_Transaction_Date__c !=null && acct.X1st_Transaction_Date__c.daysBetween(date.today()) > 30) { //TODO: Need acct.ARR__c > 0 ?
            opp.Type = 'Add-On Business';
            opp.Add_On_Type__c = 'Expansion';
        } else {
            opp.Type = 'New Business';
        }
        opp.CloseDate = Date.today();
        opp.Forecast__c = 'Likely';
        opp.Sales_Channel__c = 'Self-Service';
        opp.Opportunity_Source__c = 'Direct';
        opp.SFDC_New_and_Add_On_ACV__c = 0.0;
        opp.Multi_Year_Deal__c = 'no';
        opp.stageName = '1. ID Business Initiative';//ConstantDeclarations.OPP_STAGE_NEGOTIATE_CLOSE;
        //opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_LABEL).getRecordTypeId();
        insert opp;
        return opp;
    }

    public static void updateOppStageName(opportunity opp) { 
		opp.stageName = ConstantDeclarations.OPP_STAGE_NEGOTIATE_CLOSE;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_LABEL).getRecordTypeId();
        update opp;
    }
    
    public static void createQuote(opportunity oppty) {
 	    List<Pricebook2> priceBookId = [SELECT Id FROM Pricebook2 WHERE Name ='Standard Price Book'];        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = oppty.AccountId;
        quote.SBQQ__Opportunity2__c = oppty.Id;
        quote.SBQQ__StartDate__c = oppty.CloseDate;
        quote.SBQQ__Primary__c = true;
        quote.SBQQ__EndDate__c  = Date.today().addYears(1).addDays(-1);
        insert quote;
        
        if(priceBookId.size() > 0){
	        quote.SBQQ__PricebookId__c = priceBookId[0].Id;
        }
        CMsTriggerRunCounter.skipQuoteTrigger = true;
		update quote;
        CMsTriggerRunCounter.skipQuoteTrigger = false;
        
    }


}