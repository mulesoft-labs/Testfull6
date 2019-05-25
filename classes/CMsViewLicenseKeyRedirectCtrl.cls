/**
 * Controller for the page PMsViewLicenseKeyRedirect
 */
global with sharing class CMsViewLicenseKeyRedirectCtrl {
    public Id tempEntitlementHistoryId;
    public CMsViewLicenseKeyRedirectCtrl(ApexPages.StandardController stdController) {
		tempEntitlementHistoryId =  ApexPages.currentPage().getParameters().get('tempEntitlementHistoryId');        
    }

    public PageReference url() {
		Id licKeyReqId;
		List<Licence_Key_Request__c> licKeyRequests = [ SELECT Id, Name, Request_Status__c, Generation_Date__c, Temporary_Entitlement_Request_History__c 
                                                       	FROM Licence_Key_Request__c 
                                                        WHERE Temporary_Entitlement_Request_History__c =:tempEntitlementHistoryId AND Request_Status__c = 'Completed' ORDER BY Generation_Date__c DESC LIMIT 1 ];
		System.debug(LoggingLevel.ERROR, 'licKeyRequests --> '+licKeyRequests);            
		
        if(licKeyRequests.size() > 0) {
			licKeyReqId = licKeyRequests[0].Id;
		}
        
		System.debug(LoggingLevel.ERROR, 'licKeyReqId --> '+licKeyReqId);       
        PageReference p;
        if(licKeyReqId !=null && tempEntitlementHistoryId != null){
			p = new PageReference('/apex/PMsViewLicensekey?tempEntitlementHistoryId=' + tempEntitlementHistoryId+'&LicenseKeyId='+ licKeyReqId);   
        } else if(licKeyReqId == null && tempEntitlementHistoryId != null){
			p = new PageReference('/apex/PMsViewLicensekey?tempEntitlementHistoryId=' + tempEntitlementHistoryId);   
        } else if(licKeyReqId != null){
			p = new PageReference('/apex/PMsViewLicensekey?LicenseKeyId=' + licKeyReqId);   
        }
        p.setRedirect(true);        
        return p;
    }
    
	webservice static Boolean checkLicenseKeyPermission(Id objTempEntitlementHistoryId){        
        Boolean canSeeLicenseKey = false;
        Id loggedInUserId =UserInfo.getUserId();
        Set<Id> oppIds = new Set<Id>();        
        List<Temporary_Entitlement_History__c> tempEntitlementHistory = [ SELECT Temporary_Entitlements__r.Opportunity__c
                                                                          FROM 
                                                                          	Temporary_Entitlement_History__c
                                                                          WHERE id = :objTempEntitlementHistoryId];
        
        System.debug(LoggingLevel.ERROR, 'tempEntitlementHistory --> '+ tempEntitlementHistory);
        for(Temporary_Entitlement_History__c teh: tempEntitlementHistory){
            oppIds.add(teh.Temporary_Entitlements__r.Opportunity__c);
        }
        System.debug(LoggingLevel.ERROR, 'oppIds --> '+ oppIds);
		
        List<OpportunityTeamMember > oppTeamMembers = [ SELECT UserId 
                                                        FROM OpportunityTeamMember 
                                                        WHERE OpportunityId IN :oppIds];        
        Set<Id> idsToCheck = new Set<Id>();
        for(OpportunityTeamMember otm:oppTeamMembers){
			idsToCheck.add(otm.UserId); 
    	}
		
        //Give access to Financial Ops, Support and System Admins
        for(User u :[SELECT Id FROM User WHERE Profile.Name IN ('System Administrator','2_18 Financial Operations','2_18 Support','2_18 Support - Limited')]){
			idsToCheck.add(u.Id); 
        }        

        if(idsToCheck.contains(loggedInUserId)){
            canSeeLicenseKey = true;            
        }
        
        return canSeeLicenseKey;
    }    
    
}