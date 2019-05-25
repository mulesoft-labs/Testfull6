global with sharing class CMsViewLicenseKeyCtrl {

    public String  attId {get;set;}
    public Integer attCount {get;set;}    
	public String  licenseKeyId;
	public String  tempEntitlementHistoryId;
    public String  navFromLicKey;
    public sObject licKeyReqOrTempEntitlementHistoryObj{get;set;}
    public String attParentRecordId;
       
    public CMsViewLicenseKeyCtrl() {
		licenseKeyId =  ApexPages.currentPage().getParameters().get('LicenseKeyId');   
		tempEntitlementHistoryId =  ApexPages.currentPage().getParameters().get('tempEntitlementHistoryId');   
        navFromLicKey =  ApexPages.currentPage().getParameters().get('navFromLicKey');
        if(navFromLicKey == 'true' ||(licenseKeyId !=null && tempEntitlementHistoryId != null)){
	        attParentRecordId = licenseKeyId;
        } else{
            attParentRecordId = tempEntitlementHistoryId;
        }

        List<sObject> sobjects;
        if(licenseKeyId !=null){        
        	sobjects = [SELECT Id FROM Licence_Key_Request__c WHERE Id = :licenseKeyId];
        } else if(tempEntitlementHistoryId !=null){
            sobjects = [SELECT Id FROM Temporary_Entitlement_History__c WHERE Id = :tempEntitlementHistoryId];            
        }        
        if(sobjects.size() > 0) {
	        licKeyReqOrTempEntitlementHistoryObj = sobjects[0];
        }
        String soql = Utils.getCreatableFieldsSOQL('Attachment', 'ParentId = :attParentRecordId AND Name Like \'%.lic\' ORDER BY createddate desc LIMIT 1');
        List<Attachment> atts = (List<Attachment>) Database.query(soql);
        if(atts.size() > 0){
        	attId = atts[0].id; 
        }
        attCount= database.countQuery('SELECT Count() FROM Attachment WHERE ParentId = :attParentRecordId');
        System.debug(LoggingLevel.ERROR, 'attCount --> '+ attCount);        
    }
    
    public PageReference url() {
		System.debug(LoggingLevel.ERROR, 'Inside URL --> attParentRecordId --> '+attParentRecordId);
        string returnUrl;
        if(navFromLicKey == 'true'){
            returnUrl = licenseKeyId;
        } else {
            returnUrl = tempEntitlementHistoryId;
        }
        PageReference pageRef = new PageReference('/ui/content/ViewAllNotesPage?id=' + attParentRecordId+'&retURL='+returnUrl);
		System.debug(LoggingLevel.ERROR, 'Inside URL --> attCount --> '+attCount);
        
        if(attCount > 1) {
        	return pageRef;
        }        
        return null;
    }
    
    
    webservice static Boolean checkLicenseKeyPermission(Id objLicenseKeyId){        
        Boolean canSeeLicenseKey = false;
        Id loggedInUserId =UserInfo.getUserId();
        
        List<Licence_Key_Request__c> LicKeyRequests = [ SELECT  
                                                           account__r.ownerId,
                                                           account__r.owner.ManagerId,
                                                           account__r.Customer_Success_Manager_new__c,
                                                           account__r.Customer_Success_Manager_new__r.ManagerId,
                                                           Temporary_Entitlement_Request_History__r.Temporary_Entitlements__r.OwnerId
                                                       FROM 
                                                       	   Licence_Key_Request__c
                                                       WHERE id = :objLicenseKeyId];
        
        System.debug(LoggingLevel.ERROR, 'LicKeyRequests --> '+ LicKeyRequests);
        Set<Id> idsToCheck = new Set<Id>();
        Set<Id> idsToRetrieve = new Set<Id>();
        if(LicKeyRequests[0].account__r.ownerId != LicKeyRequests[0].account__r.Customer_Success_Manager_new__c){
            idsToRetrieve.add(LicKeyRequests[0].account__r.Customer_Success_Manager_new__c);
        }
        idsToRetrieve.add(LicKeyRequests[0].account__r.ownerId);
        //
        Set<Id> idsToCheck2 = getRoleNonSubordinateUsers(idsToRetrieve);
        idsToCheck.addAll(idsToCheck2);//
        
        if(LicKeyRequests.size() > 0 ){
            if(LicKeyRequests[0].account__r.ownerId != null){
                idsToCheck.add(LicKeyRequests[0].account__r.ownerId);
            } 
            if(LicKeyRequests[0].account__r.owner.ManagerId != null){
                idsToCheck.add(LicKeyRequests[0].account__r.owner.ManagerId);
            } 
            if(LicKeyRequests[0].account__r.Customer_Success_Manager_new__c != null){
                idsToCheck.add(LicKeyRequests[0].account__r.Customer_Success_Manager_new__c);
            } 
            if(LicKeyRequests[0].account__r.Customer_Success_Manager_new__r.ManagerId != null){
                idsToCheck.add(LicKeyRequests[0].account__r.Customer_Success_Manager_new__r.ManagerId);
            }   
			
            if(LicKeyRequests[0].Temporary_Entitlement_Request_History__r.Temporary_Entitlements__r.OwnerId != null){
                idsToCheck.add(LicKeyRequests[0].Temporary_Entitlement_Request_History__r.Temporary_Entitlements__r.OwnerId);
            }               
        }

        //Give access to Financial Ops, Support and System Admins
        for(User u :[SELECT Id FROM User WHERE Profile.Name IN ('System Administrator','2_18 Financial Operations','2_18 Support','2_18 Support - Limited')]){
			idsToCheck.add(u.Id); 
        }        

        System.debug(LoggingLevel.ERROR, 'idsToCheck --> '+ idsToCheck);
        System.debug(LoggingLevel.ERROR, 'loggedInUserId --> '+ loggedInUserId);
        
        if(idsToCheck.contains(loggedInUserId)){
            canSeeLicenseKey = true;            
        }
        
        return canSeeLicenseKey;
    }
    
    public static Set<ID> getRoleNonSubordinateUsers(Set<Id> userId) {
        Set<Id> roleIds = new Set<Id>();
        // get requested user's role
        for(User u : [select UserRoleId from User where Id IN :userId]){
           roleIds.add( u.UserRoleId);
        }
        
        // get all of the roles above the user
        Set<Id> allSubRoleIds = getAllUpperRoleIds(roleIds);
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where 
                                                UserRoleId IN :allSubRoleIds AND UserRoleId != NULL AND isActive = TRUE]);
        // return the ids as a set so you can do what you want with them
        return users.keySet();   
    }
    
    private static Set<ID> getAllUpperRoleIds(Set<ID> roleIds) {
        
        System.Debug('UserRoles>>' + roleIds);
        Set<ID> currentRoleIds = new Set<ID>();
        
        // get all of the roles above the passed roles
        for(UserRole userRole :[select Id, ParentRoleId from UserRole where ID
                                IN :roleIds]){
                currentRoleIds.add(userRole.ParentRoleId);
        }
        
        // go fetch some more roles
        if(currentRoleIds.size() > 0)
            currentRoleIds.addAll(getAllUpperRoleIds(currentRoleIds));
        
        return currentRoleIds;
    }
        
  	public PageReference returnToPrevPage() {
        PageReference p;
        if(navFromLicKey == 'true'){
        	p = new PageReference('/' + LicenseKeyId);
        } else {
        	p = new PageReference('/' + tempEntitlementHistoryId);
        } 
        p.setRedirect(true);
        return p;
    }

    public boolean getIsLicKeyReq() { 
    	if(navFromLicKey == 'true'){
            return true;
        }
        return false;
    }
    
    
}