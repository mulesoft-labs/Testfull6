public with sharing class CMsApprovalComponent {
    private List<sbaa__Approval__c> allApprovals = new list<sbaa__Approval__c>();

    public CMsApprovalComponent() {
    }
    
	public List<sbaa__Approval__c> getAllApprovals() {
        allApprovals = [SELECT Id, Name, Quote__c,Quote__r.SBQQ__Status__c, Quote__r.SBQQ__opportunity2__c,Quote__r.SBQQ__opportunity2__r.Owner.Name,
		                       Quote__r.SBQQ__Account__c,
                        	   Quote__r.SBQQ__StartDate__c, Quote__r.SBQQ__EndDate__c, Quote__r.Subscription_Amount__c, Quote__r.Services_Net_Total__c , 
                        	   sbaa__AssignedTo__c, sbaa__AssignedTo__r.Name, sbaa__Status__c, Date_Requested__c, Rule2__c 
                        FROM  sbaa__Approval__c 
                		WHERE sbaa__Status__c = 'Requested' AND Quote__r.SBQQ__Status__c IN ('In Review')
                        	  AND sbaa__AssignedTo__c=:UserInfo.getUserId()
                        ORDER BY Quote__c, Date_Requested__c ASC];
        return allApprovals;
	}  
}