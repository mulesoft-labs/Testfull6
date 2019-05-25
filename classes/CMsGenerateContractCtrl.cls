/**
 * Controller for the page CMsGenerateContractCtrl
 */
public with sharing class CMsGenerateContractCtrl {
    public Boolean hasContract = false;
    public String contractCreationPromptMsg {get; set;}
    public CMsGenerateContractCtrl(ApexPages.StandardController opptyController) {
        List<Contract> childContracts;
        if(opptyController.getRecord().Id != null){
            childContracts = [SELECT Id, SBQQ__Opportunity__c  FROM Contract
                        	  WHERE SBQQ__Opportunity__c  = :opptyController.getRecord().Id];
        }
        if(childContracts.size() > 0) {
            hasContract = true;
        }
		if(hasContract){
        	contractCreationPromptMsg = 'There is already a Contract linked to this Opportunity. Do you still want to create a new Contract?';
   	 	} else {
        	contractCreationPromptMsg = 'Are you sure you want to create a new Contract?';
    	}    
    }

    @RemoteAction
    public static boolean generateContract(Id oppId) {
        Opportunity opp = [select SBQQ__Contracted__c from Opportunity where id = :oppId];

       if(opp.SBQQ__Contracted__c == true){ //Even the Contract is created when user clicks on the button we need to create another Contract
       	  opp.SBQQ__Contracted__c = false;
          update opp;
       }
        opp.SBQQ__Contracted__c = true;
		update opp;
        return true;
    }
}