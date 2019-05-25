public class CMsNPSAlertsToSend{
    public List<NPS_Response__c> unpNPS = new List<NPS_Response__c>();
    public static Map<String, Email_Config_Role__mdt> emailMapping = new Map<String, Email_Config_Role__mdt>();
    public static Map<String, NPS_Region__mdt> accountRegionMapping = new Map<String, NPS_Region__mdt>();
    public static Map<String, NPS_Email_Inclusion_Exclusion__mdt> emailInclusionExclusionMapping = new Map<String, NPS_Email_Inclusion_Exclusion__mdt>();

    public List<Messaging.SingleEmailMessage> getNPSEmails(List<NPS_Response__c> unpNPS){
        List<Email_Config_Role__mdt> npsEmailConfig = [SELECT Label, Active__c, Detractor__c, Passive__c, Promoter__c FROM Email_Config_Role__mdt];
        List<NPS_Region__mdt> npsRegionConfig = [SELECT Label, Email__c FROM NPS_Region__mdt];
        List<NPS_Email_Inclusion_Exclusion__mdt> npsEmailInclusionExclusion = [SELECT Email__c , Included_Email__c FROM NPS_Email_Inclusion_Exclusion__mdt ];
        
        List<String> users = new List<String>{'Owner', 'CSM', 'Engagement Manager', 'Partner Enablement Manager'};
        Map<String, Set<Id>> mapRoleTrack = new Map<String, Set<Id>>();
        Map<String, List<Email_Config_Role__mdt>> mapCategorytoECR = new Map<String, List<Email_Config_Role__mdt>>();
        Map<Id, Set<String>> mapNPStoRecipients = new Map<Id, Set<String>>();
        Map<Id, Set<String>> mapNPStoCcRecipients = new Map<Id, Set<String>>();
        Map<Id,User> mapRoleId = new Map<Id,User>();
        Map<String,Map<Id,User>> mapTrackRoleId = new Map<String,Map<Id,User>>();
        Map<Id, Map<String,Map<Id,User>>> mapNpsUserTrack = new Map<Id, Map<String,Map<Id,User>>>();
               
        for(NPS_Response__c nps :unpNPS){
            //prepare mapping for config role
            for(Email_Config_Role__mdt ecr :npsEmailConfig){
                emailMapping.put(ecr.Label,ecr);
            }
            
            //prepare mapping for account region
            for(NPS_Region__mdt nrm :npsRegionConfig){
                accountRegionMapping.put(nrm.Label,nrm);
            }
            
            for(NPS_Email_Inclusion_Exclusion__mdt emailIncExc : npsEmailInclusionExclusion){
				emailInclusionExclusionMapping.put(emailIncExc.Email__c, emailIncExc);
            }
            
            //prepare mapping for related users to the NPS record
            for(String usr :users){
                if(usr == 'Owner') {
                    if(nps.Account__r.OwnerId != Null){
                        if(!mapRoleTrack.containsKey(usr)){
                            Set<Id> npsList = new Set<Id>();
                            npsList.add(nps.Account__r.OwnerId);
                            mapRoleTrack.put(usr, npsList);
                        }
                        mapRoleTrack.get(usr).add(nps.Account__r.OwnerId);
                    }
                }
                
                if(usr == 'CSM'){
                    if(nps.Account__r.Customer_Success_Manager_new__c != Null){
                        if(!mapRoleTrack.containsKey(usr)){
                            Set<Id> npsList = new Set<Id>();
                            npsList.add(nps.Account__r.Customer_Success_Manager_new__c);
                            mapRoleTrack.put(usr, npsList);
                        }
                        mapRoleTrack.get(usr).add(nps.Account__r.Customer_Success_Manager_new__c);
                    }
                }
                
                if(usr == 'Engagement Manager'){
                    if(nps.Account__r.Engagement_Manager__r.ManagerId != Null){ //The manager of Engagement_Manager__c will be the "Services Regional Lead"
                        if(!mapRoleTrack.containsKey(usr)){
                            Set<Id> npsList = new Set<Id>();
                            npsList.add(nps.Account__r.Engagement_Manager__r.ManagerId);
                            mapRoleTrack.put(usr, npsList);
                        }
                        mapRoleTrack.get(usr).add(nps.Account__r.Engagement_Manager__r.ManagerId);
                    }
                }
                
                if(usr == 'Partner Enablement Manager'){
                    if(nps.Account__r.Partner_Enablement_Manager__r.ManagerId != Null){ //The manager of Partner_Enablement_Manager__c will be the "Channel Theater Lead"
                        if(!mapRoleTrack.containsKey(usr)){
                            Set<Id> npsList = new Set<Id>();
                            npsList.add(nps.Account__r.Partner_Enablement_Manager__r.ManagerId);
                            mapRoleTrack.put(usr, npsList);
                        }
                        mapRoleTrack.get(usr).add(nps.Account__r.Partner_Enablement_Manager__r.ManagerId);
                    }
                }
            }
            
            for(String s: mapRoleTrack.keySet()){
                mapRoleId = getRoleNonSubordinateUsers(mapRoleTrack.get(s));
                mapTrackRoleId.put(s, mapRoleId);
            } 
            mapNpsUserTrack.put(nps.Id,mapTrackRoleId); 
            
        }
        
        
        
        System.debug(LoggingLevel.ERROR, '----->>Identified Track' + mapTrackRoleId);
        //check setting from Metadata if emails will be sent
        for(NPS_Response__c nps : unpNPS){
            String rolesAndUsers = '';
            List<Email_Config_Role__mdt> ecrListperCategory = mapCategorytoECR.get(nps.Category__c);
            Set<String> emailRecipient = new Set<String>();
            mapTrackRoleId  =  mapNpsUserTrack.get(nps.Id);
            
            for(Map<Id,User> internalMap : mapTrackRoleId.values() ){
                Integer i = 0;
                for(User u:  internalMap.values()){
                    //--> call NPS_Response__c
                    if(u != null){
                        i++;
                        emailConfigWrapper ecWrapper =  getEmailConfig(u,nps);
                        if(nps.Account__r.Customer_Success_Manager_new__c == u.Id || nps.Account__r.OwnerId == u.Id){
                            if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                                if(nps.Account__r.Customer_Success_Manager_new__c == u.Id){
                                    mapNPStoRecipients.put(nps.Id, new Set<String> {u.Email});
                                } else{
                                    emailRecipient.add(u.Email);
                                }
                                rolesAndUsers += u.Name +' : '+ u.UserRole.Name + '- Direct Manager '+ u.Manager.Name +'\n';
                            }
                            if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                                emailRecipient.add(u.Manager.Email);
                            }
                            
                        } else {                     
                            if(!mapNPStoCcRecipients.containsKey(nps.Id)){
                                if(u.Email != Null && nps.Account__r.Customer_Success_Manager_new__c != u.Id){
                                    if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                                      emailRecipient.add(u.Email); // add the 'CC' of the NPS Survey
                                      rolesAndUsers += u.Name +'-'+ u.UserRole.Name + '\n';
                                    }
                                    
                                    if(u.UserRole.Name.contains('-VP') && ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){
                                        if(u.Manager.Email != Null){
                                            if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c)))
                                            	emailRecipient.add(u.Manager.Email);
                                            	rolesAndUsers += u.Manager.Name +'-'+ u.Manager.UserRole.Name + '\n';
                                        }
                                    }
                                }
                                
                                mapNPStoCcRecipients.put(nps.Id, emailRecipient);
                            } else {
                                if(u.Email != Null && nps.Account__r.Customer_Success_Manager_new__c != u.Id){
                                    if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                                        mapNPStoCcRecipients.get(nps.Id).add(u.Email);
                                        rolesAndUsers += u.Name +'-'+ u.UserRole.Name + '\n';
                                    
                                    }
                                    
                                    if(u.UserRole.Name.contains('-VP') && ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){
                                        if(u.Manager.Email != Null){
                                            if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){
                                            	mapNPStoCcRecipients.get(nps.Id).add(u.Manager.Email);
                                            	rolesAndUsers += u.Manager.Name +'-'+ u.Manager.UserRole.Name + '\n';
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }                 
                }
                System.Debug(LoggingLevel.ERROR,'>> User Count:'  + i);
            }
            // add the 'To' of the NPS Survey
            System.Debug(LoggingLevel.ERROR, '---->> Email To:'  + mapNPStoRecipients);
            System.Debug(LoggingLevel.ERROR, '---->> Email CC:'  + mapNPStoCcRecipients);
            nps.Roles_and_Users__c = rolesAndUsers;
            nps.Processed__c = TRUE;
            System.Debug(LoggingLevel.ERROR,'>> Save to Record'+ nps.Roles_and_Users__c );
        }
        
        List<Messaging.SingleEmailMessage> npsEmails = new List<Messaging.SingleEmailMessage>();
        
        String templateAPIName = 'NPS_Response_Notification'; // To convert to label
        Boolean saveAsActivity  = false;
        OrgWideEmailAddress orgWideId = [SELECT Id FROM OrgWideEmailAddress Where DisplayName = 'NPS Response' Limit 1];// To convert to Label
        Set<String> ccSet = new Set<String>();
        
        for(NPS_Response__c nps :unpNPS){
            List<String> defaultCCList = getEmailConfigCC(nps);
            List<String> ccList = new List<String>();
            ccList.addAll( mapNPStoCcRecipients.get(nps.Id));
            if(defaultCCList != null)
                ccList.addAll(defaultCCList);
            if (nps.Category__c == 'Detractor' && nps.Account_Region__c != null){
                if(accountRegionMapping.get(nps.Account_Region__c) != null){
                    ccList.add(accountRegionMapping.get(nps.Account_Region__c).Email__c);
                }
            }
            
            List<String> toList = new List<String>();
            if(mapNPStoRecipients.get(nps.Id) !=null){
            	toList.addAll( mapNPStoRecipients.get(nps.Id));
            }
            System.debug(logginglevel.ERROR, ' BEFORE Size ---->>> CC Size ---->>> '+ ccList.size());
            System.debug(logginglevel.ERROR, ' BBEFORE CC List ---->>> CC List ---->>> '+ ccList);
            System.debug(logginglevel.ERROR, '---->>> toList ---->>> '+ toList);
            System.debug(logginglevel.ERROR, '---->>> templateAPIName ---->>> '+ templateAPIName);

            ccSet.addAll(ccList);
            
            for(String cc : ccSet) {
            	if(emailInclusionExclusionMapping.get(cc) != null) {
                	if(emailInclusionExclusionMapping.get(cc).Included_Email__c == false){ 
                		ccSet.remove(cc);
                    }
                }                
            }
           
            for(String email : emailInclusionExclusionMapping.keySet()){
                if(emailInclusionExclusionMapping.get(email).Included_Email__c == true){
                    ccSet.add(email);
                }
            }
            
            ccList.clear();
            ccList.addAll(ccSet);
            System.debug(logginglevel.ERROR, ' 22222222 ---> --->>> ccSet ---->>> '+ ccSet);
            System.debug(logginglevel.ERROR, ' AFTER Size ---->>> CC Size ---->>> '+ ccList.size());
            System.debug(logginglevel.ERROR, ' AFTER CC List ---->>> CC List ---->>> '+ ccList);
            
            npsEmails.add(prepNPSAlerts(toList,ccList , templateAPIName, null, nps.Id, orgWideId.Id, saveAsActivity));                  
        }
        
        return npsEmails;
    }
    
    public static Messaging.SingleEmailMessage prepNPSAlerts(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity){
        Id templateId;  
        
        try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
            }
        catch (Exception e) {
            system.assert(false, 'Unable to locate EmailTemplate using name: ' + templateApiName); 
        }
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, null, whatId);
        email.setOrgWideEmailAddressId(orgWideEmailId);
        email.setSubject(email.getSubject());
        email.sethtmlBody(email.gethtmlBody());
        email.setToAddresses(toRecipients);
        email.setCcAddresses(ccRecipients);
        email.saveAsActivity = saveAsActivity;
        return email;
    }
    
    
    public static Map<Id,User> getRoleNonSubordinateUsers(Set<Id> userId) {
        Set<Id> roleIds = new Set<Id>();
        Map<String,Id> mapRoleId = new Map<String,Id>();
        // get requested user's role
        for(User u : [select UserRoleId from User where Id IN :userId]){
            roleIds.add( u.UserRoleId);
        }
        // get all of the roles above the user
        Set<Id> allSubRoleIds = getAllUpperRoleIds(roleIds);
        //allSubRoleIds.addAll(roleIds);
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name, ManagerId, UserRole.Name, Email, Manager.Email, Manager.Name, Manager.UserRole.Name From User where 
                                                (UserRoleId IN :allSubRoleIds OR Id IN:userId ) AND UserRoleId != NULL AND isActive = TRUE]);
        
        System.Debug(LoggingLevel.ERROR,'---->>>Users --->>>  '+ users);        
        return users;   
    }
    
    public static emailConfigWrapper getEmailConfig(User u, NPS_Response__c nps){
        emailConfigWrapper ecWrapper = new emailConfigWrapper();
        if(u != null){
            if(u.Id == nps.Account__r.Customer_Success_Manager_new__c){                
                ecWrapper.ecr = emailMapping.get('CSM');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                    nps.CSM__c = true;
                }
                ecWrapper.ecrManager = emailMapping.get('CSM Direct Manager');
                if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                    nps.CSM_Direct_Manager__c = true;
                }
            }
            else if(u.UserRole.Name.contains('CS') && u.UserRole.Name.contains('RD') ){                
                ecWrapper.ecr = emailMapping.get('CS Regional Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.CS_Regional_Lead__c = true; 
                }
            }
            else if(u.UserRole.Name.contains('CS') && u.UserRole.Name.contains('TD') ){
                ecWrapper.ecr = emailMapping.get('CS Theater Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.CS_Theater_Lead__c = true; 
                }
            }
            else if(u.UserRole.Name.contains('CS') && u.UserRole.Name.contains('VP') ){
                ecWrapper.ecr = emailMapping.get('CS Global Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.CS_Global_Lead__c = true; 
                }
            }
            else if(u.Id == nps.Account__r.OwnerId ){
                ecWrapper.ecr = emailMapping.get('AE');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                 	nps.AE__c = true; 
                }
                ecWrapper.ecrManager = emailMapping.get('AE Direct Manager (RSD)');
                if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                	nps.AE_Direct_Manager_RSD__c = true; 
                }
            }
            else if(u.UserRole.Name.contains('Sales') && u.UserRole.Name.contains('RVP') ){
                ecWrapper.ecr = emailMapping.get('AE Regional Lead (RVP)');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.AE_Regional_Lead_RVP__c = true; 
                }
            }
            else if(u.UserRole.Name.contains('Sales') && u.UserRole.Name.contains('VP') ){
                ecWrapper.ecr = emailMapping.get('AE Theater Lead');
                ecWrapper.ecrManager = emailMapping.get('AE Global Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.AE_Theater_Lead__c = true; 
                }
                if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                	nps.AE_Global_Lead__c = true;
                }
            }
            else if(u.Id == nps.Account__r.Engagement_Manager__r.ManagerId){
                ecWrapper.ecr = emailMapping.get('Services Regional Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.Services_Regional_Lead__c = true; 
                }             
            }
            else if(u.UserRole.Name.contains('Services') && u.UserRole.Name.contains('VP') ){
                ecWrapper.ecr = emailMapping.get('Services Theater Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                	nps.Services_Theater_Lead__c = true; 
                }
                ecWrapper.ecrManager = emailMapping.get('Services Global Lead');
                if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                	nps.Services_Global_Lead__c = true; 
                }
            }
            else if(u.Id == nps.Account__r.Partner_Enablement_Manager__r.ManagerId ){
		        System.Debug(LoggingLevel.ERROR,'@@@@@@@@@@ ----> INSIDE Channels');                                
                ecWrapper.ecr = emailMapping.get('Channels Theater Lead');
                ecWrapper.ecrManager = emailMapping.get('Channels Global Lead');
                if(ecWrapper.ecr.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecr.Promoter__c))) {
                 	nps.Channels_Theater_Lead__c = true; 
                }
                if(ecWrapper.ecrManager != null && ecWrapper.ecrManager.Active__c && ((nps.Category__c == 'Detractor' && ecWrapper.ecrManager.Detractor__c) || (nps.Category__c == 'Passive' && ecWrapper.ecrManager.Passive__c) || (nps.Category__c == 'Promoter' && ecWrapper.ecrManager.Promoter__c))){ 
                	nps.Channels_Global_Lead__c = true; 
                }
            }
         }
         return ecWrapper;
    }   
    
    public static List<String> getEmailConfigCC(NPS_Response__c nps){
        List<String> emailAddressList = new List<String>();
        Email_Config_Role__mdt ecr;
        
        //Uncomment this code in Production
        ecr = emailMapping.get('CPO Staff');
        if(ecr.Active__c && ((nps.Category__c == 'Detractor' && ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecr.Promoter__c))) {
            nps.Product__c = true; 
            emailAddressList.add(System.Label.NPS_Product);
        }
        
        
        ecr = emailMapping.get('CS Ops');
        System.debug(LoggingLevel.ERROR, 'Inside CS Ops --> ecr ---> '+ecr);
        if(ecr.Active__c && ((nps.Category__c == 'Detractor' && ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecr.Promoter__c))) {
            nps.CS_Ops__c = true; 
            emailAddressList.add(System.Label.NPS_CS_Ops);
        }
        
        ecr = emailMapping.get('Support-Leadership');
        if(ecr.Active__c && ((nps.Category__c == 'Detractor' && ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecr.Promoter__c))) {
            nps.Support__c = true; 
            emailAddressList.add(System.Label.NPS_Support);
        }
        
        ecr = emailMapping.get('Detractor Alias');
        if(ecr.Active__c && ((nps.Category__c == 'Detractor' && ecr.Detractor__c) || (nps.Category__c == 'Passive' && ecr.Passive__c) || (nps.Category__c == 'Promoter' && ecr.Promoter__c))) {
            nps.Marketing__c = true; 
            emailAddressList.add(System.Label.NPS_Marketing);
        }
                    
        if(!emailAddressList.isEmpty()){
            return emailAddressList;
        } else { 
            return null;
        }
    }
    
    public class emailConfigWrapper{
        Email_Config_Role__mdt ecr;
        Email_Config_Role__mdt ecrManager;
    }
    
    private static Set<ID> getAllUpperRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
        // get all of the roles above the passed roles
        for(UserRole userRole :[SELECT Id, ParentRoleId, Name FROM UserRole WHERE ID IN :roleIds]){
        	System.Debug(LoggingLevel.ERROR, 'Role -->'+ userRole.Name);
            //currentRoleIds.add(userRole.Id);
            if(!userRole.Name.contains('-VP')){
            	currentRoleIds.add(userRole.ParentRoleId);
            }
        }
        // go fetch some more roles
        if(currentRoleIds.size() > 0) {
        	currentRoleIds.addAll(getAllUpperRoleIds(currentRoleIds));
        }        
        return currentRoleIds;
    }
}