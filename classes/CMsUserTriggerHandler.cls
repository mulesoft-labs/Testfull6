public class CMsUserTriggerHandler extends CMsBaseTriggerHandler {
	Map<Id,User> oldMap = (Map<Id,User>)Trigger.oldMap;
	Map<Id,User> newMap = (Map<Id,User>)Trigger.newMap;

	List<User> newList = (List<User>)Trigger.new;
	public static Map<Id,String> mapOfRoleIdAndRoleName = new Map<Id,String>();
	public static Map<Id, User_Role_Mapping__c> roleIdToRoleMapping = new Map<Id, User_Role_Mapping__c  >();

	public static final String REFERENCEVIEW_USER_PS_NAME = 'ReferenceView_User';
	public static final String REFERENCEVIEW_USER_SUPPLEMENTAL_PS_NAME = 'ReferenceView_User_Supplemental';
	public static final String OVERRIDE_FORECAST_PS_NAME = 'Forecasting_Access_to_Override_Forecast';
	public static final String VIEW_ALL_FORECAST_PS_NAME = 'Forecasting_Access_to_view_all_Forecasts';
	public static final String SC_LEAD_PS_NAME = 'SC_Leads_Update_Opp_Teams';

	public static map<String, Id> permissionsetNameToId = new map<String, Id>();
	//2_18 Sales Hybrid, 2_18 Field & Channel Sales, 2_18 Managers, 2_18 CSM
	//Hard-coding the profile Ids to avoid an SOQL as these won't change
	public static final Set<string> PROFILE_IDS_APPROVAL_RECORD_CREATION = new Set<string>{'00e80000001CMQC','00e80000001CKqK','00e80000001CKzI','00e80000001CMP9'};

	/*
      If this user has the below profiles then we check the "Allow Forecasting" flag
      - 2_18 Sales Hybrid
      - 2_18 Field & Channel Sales
      - 2_18 Managers
      - 2_18 CSM
      */
	public override void beforeInsert() {
		System.debug(LoggingLevel.ERROR, ' --> Inside BEFORE INSERT --> ');
        
		populateUserRoleMapping(newList);
		for(User u : newList){
			if(u.isActive && PROFILE_IDS_APPROVAL_RECORD_CREATION.contains(String.valueOf(u.ProfileId).substring(0, 15))){
				u.ForecastEnabled = true;
			}
			System.debug(LoggingLevel.ERROR, 'INSERT --> u.UserType --> '+u.UserType);
			if(u.UserRoleId != null && roleIdToRoleMapping.get(u.UserRoleId) != null){
				u.Territory__c = roleIdToRoleMapping.get(u.UserRoleId).Theater__c;
				u.Sales_Region__c = roleIdToRoleMapping.get(u.UserRoleId).User_Sales_Region__c ;
				u.Sales_Region_Team__c = roleIdToRoleMapping.get(u.UserRoleId).User_Sales_Region_Team__c ;
				u.Function_type__c = roleIdToRoleMapping.get(u.UserRoleId).User_Segment__c  ;
				u.Function__c = roleIdToRoleMapping.get(u.UserRoleId).User_Function__c  ;
				u.User_Function_Detail__c = roleIdToRoleMapping.get(u.UserRoleId).User_Function_Detail__c ;
				u.Division  = roleIdToRoleMapping.get(u.UserRoleId).Division__c ;
				u.Sales_Manager__c = roleIdToRoleMapping.get(u.UserRoleId).Sales_Manager_Indicator__c;
			}
			System.debug('u -->'+ u);
		}
	}
	public override void afterInsert() {
		System.debug(LoggingLevel.ERROR, ' --> Inside AFTER INSERT --> ');
        
		//Populate the permissionset Map
		permissionsetNameToId = populatePsNameToId();

		/*
            If this user has the below profiles then only we need to create an Approval record
                 - 2_18 Sales Hybrid
                - 2_18 Field & Channel Sales
                - 2_18 Managers
                - 2_18 CSM
            */
		Set<Id> approvalRecordToCreateUserIds = new Set<Id>();
		List<Profile> all_2_18_Profiles = [SELECT Id, name FROM Profile WHERE Name LIKE '2_18%'];
		Set<String> all_2_18_Profiles_Set = new Set<String>();
		for(Profile p : all_2_18_Profiles){
			all_2_18_Profiles_Set.add(p.Id);
		}

		Set<Id> permissionSetsUserIds = new Set<Id>();
		for(User u : newMap.values()){
			System.debug(LoggingLevel.ERROR, ' --> u --> '+u);
			System.debug(LoggingLevel.ERROR, ' --> PROFILE_IDS_APPROVAL_RECORD_CREATION --> '+PROFILE_IDS_APPROVAL_RECORD_CREATION);
			System.debug(LoggingLevel.ERROR, ' --> u.ProfileId --> '+u.ProfileId);
            
			if(PROFILE_IDS_APPROVAL_RECORD_CREATION.contains(String.valueOf(u.ProfileId).substring(0, 15))){
				approvalRecordToCreateUserIds.add(u.Id);
			}

			if(all_2_18_Profiles_Set.contains(String.valueOf(u.ProfileId))){
				permissionSetsUserIds.add(u.Id);
			}
		}

		if(approvalRecordToCreateUserIds.size() > 0){
			createOrUpdateApprovalRecord(approvalRecordToCreateUserIds, true);
		}

		if(permissionSetsUserIds.size() > 0){
			createReferenceViewPermissionSets(permissionSetsUserIds);
		}

		//Automate adding the below Permission sets for VP and RVP
		//For RVP —> assign —> Forecasting - Access to Override Forecast
		//For VP —> assign —> Forecasting - Access to View All Forecast

		Set<User> VpOrRvpUsers = new Set<User>();
		Set<User> sCLeadUsers = new Set<User>();
		Map<Id,String> mapOfRoleIdAndRoleName = getUserRoleName(newList);
		for(User u : newMap.values()){
			if(mapOfRoleIdAndRoleName.get(u.UserRoleId) !=null &&
					(((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_VP'))
							|| ((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_RVP')))){
				VpOrRvpUsers.add(u);
			}
			if(mapOfRoleIdAndRoleName.get(u.UserRoleId) !=null &&
					((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_SC_Lead'))){
				sCLeadUsers.add(u);
			}
		}
		if(VpOrRvpUsers.size() > 0){
			createPermissionSetsForVPandRVP(VpOrRvpUsers);
		}

		if(sCLeadUsers.size() > 0){
			createPermissionSetsForScLead(sCLeadUsers);
		}
	}

	public override void beforeUpdate() {
		populateUserRoleMapping(newList);
		for(User u : newList){
			if(u.isActive && PROFILE_IDS_APPROVAL_RECORD_CREATION.contains(String.valueOf(u.ProfileId).substring(0, 15))){
				u.ForecastEnabled = true;
			}
			System.debug(LoggingLevel.ERROR, 'UPDATE --> u.UserType --> '+u.UserType);
			if(u.UserType == 'Standard' 
                && (u.Trigger_Mapping_Update__c == true || u.UserRoleId != oldMap.get(u.id).UserRoleId)
                && (u.UserRoleId != null && roleIdToRoleMapping.get(u.UserRoleId) != null)){
				System.debug(LoggingLevel.ERROR, 'beforeUpdate ---> u --> '+u);
				u.Territory__c = roleIdToRoleMapping.get(u.UserRoleId).Theater__c;
				u.Sales_Region__c = roleIdToRoleMapping.get(u.UserRoleId).User_Sales_Region__c ;
				u.Sales_Region_Team__c = roleIdToRoleMapping.get(u.UserRoleId).User_Sales_Region_Team__c ;
				u.Function_type__c = roleIdToRoleMapping.get(u.UserRoleId).User_Segment__c  ;
				u.Function__c = roleIdToRoleMapping.get(u.UserRoleId).User_Function__c;
				if(u.Function__c != 'Sales') {
					u.User_Function_Detail__c = roleIdToRoleMapping.get(u.UserRoleId).User_Function_Detail__c ;
				}
				u.Division  = roleIdToRoleMapping.get(u.UserRoleId).Division__c ;
				u.Sales_Manager__c = roleIdToRoleMapping.get(u.UserRoleId).Sales_Manager_Indicator__c;
			}
			//Uncheck the trigger mapping update flag
            u.Trigger_Mapping_Update__c = false;        
		}
	}

	public override void afterUpdate() {
		List<User> inactiveUsers = new List<User>();
		Set<User> changedToVPorRVPRole = new Set<User>();
		Set<User> changedToSCLeadRole = new Set<User>();
		Set<Id> userIdsToUpdate = new Set<Id>();
		permissionsetNameToId = populatePsNameToId();
		Map<Id,String> mapOfRoleIdAndRoleName = getUserRoleName(newList);
		for(User u : newMap.values()) {
			if(u.UserType == 'Standard'){
				//if user moved from Active to Inactive then remove Managed Package Licenses
				if(u.isActive != oldMap.get(u.id).isActive && u.isActive == false){
					inactiveUsers.add(u);
				}
				//if user FirstName/LastName or ManagerId changed then update the Approval Record
				if(u.FirstName != oldMap.get(u.id).FirstName
						|| u.LastName != oldMap.get(u.id).LastName
						|| u.ManagerId != oldMap.get(u.id).ManagerId){
					userIdsToUpdate.add(u.Id);
				}

				//If user role is changed then add permission sets.
				//If user role is changed from null to something, then only add permissionset and not vice versa.
				//Currently, removal of permissionset based on the Role Change is not supported
				if(u.UserRoleId != oldMap.get(u.id).UserRoleId && u.UserRoleId != null){
					if(mapOfRoleIdAndRoleName.get(u.UserRoleId) !=null &&
							(((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_VP'))
									|| ((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_RVP')))){
						changedToVPorRVPRole.add(u);
					}
					if(mapOfRoleIdAndRoleName.get(u.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_SC_Lead'))){
						changedToSCLeadRole.add(u);
					}
				}


				if(inactiveUsers != null && inactiveUsers.size() > 0 ){
					removeManagedPackageLicense(inactiveUsers);
				}

				if(userIdsToUpdate.size() > 0 ){
					createOrUpdateApprovalRecord(userIdsToUpdate, false);
				}

				if(changedToVPorRVPRole.size() > 0 ){
					createPermissionSetsForVPandRVP(changedToVPorRVPRole);
				}

				if(changedToSCLeadRole.size() > 0 ){
					createPermissionSetsForScLead(changedToSCLeadRole);
				}
			}

		}
	}

	public static void createPermissionSetsForVPandRVP(Set<User> newUsers) {
		List<PermissionSetAssignment> permissionsets = new List<PermissionSetAssignment>();
		for(User u : newUsers){
			PermissionSetAssignment psaForBothVpAndRvp = new PermissionSetAssignment(PermissionSetId = permissionsetNameToId.get(OVERRIDE_FORECAST_PS_NAME), AssigneeId = u.Id);
			permissionsets.add(psaForBothVpAndRvp);

			if(mapOfRoleIdAndRoleName.get(u.UserRoleId) !=null && ((mapOfRoleIdAndRoleName.get(u.UserRoleId)).contains('_VP'))){
				PermissionSetAssignment psaForVp = new PermissionSetAssignment(PermissionSetId = permissionsetNameToId.get(VIEW_ALL_FORECAST_PS_NAME), AssigneeId = u.Id);
				permissionsets.add(psaForVp);
			}
		}
		Database.insert(permissionsets, false);
	}

	public static void createPermissionSetsForScLead(Set<User> newUsers) {
		List<PermissionSetAssignment> permissionsets = new List<PermissionSetAssignment>();
		for(User u : newUsers){
			PermissionSetAssignment psaForScLead = new PermissionSetAssignment(PermissionSetId = permissionsetNameToId.get(SC_LEAD_PS_NAME), AssigneeId = u.Id);
			permissionsets.add(psaForScLead);
		}
		Database.insert(permissionsets, false);
	}

	public static void createReferenceViewPermissionSets(Set<Id> newUserIds) {
		List<PermissionSetAssignment> permissionsets = new List<PermissionSetAssignment>();
		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, name, ManagerId FROM User WHERE id IN :newUserIds]);
		for(Id userId : newUserIds){
			PermissionSetAssignment psaForReferenceView = new PermissionSetAssignment(PermissionSetId = permissionsetNameToId.get(REFERENCEVIEW_USER_PS_NAME), AssigneeId = userId);
			permissionsets.add(psaForReferenceView);
			PermissionSetAssignment psaForReferenceViewSupplemental = new PermissionSetAssignment(PermissionSetId = permissionsetNameToId.get(REFERENCEVIEW_USER_SUPPLEMENTAL_PS_NAME), AssigneeId = userId);
			permissionsets.add(psaForReferenceViewSupplemental);
		}
		Database.insert(permissionsets, false);
	}

	@future
	public static void createOrUpdateApprovalRecord(Set<Id> newUserIds, Boolean isInsert) {
        System.debug(LoggingLevel.ERROR, 'Inside createOrUpdateApprovalRecord --> newUserIds --> '+newUserIds);
        System.debug(LoggingLevel.ERROR, 'Inside createOrUpdateApprovalRecord --> isInsert --> '+isInsert);
        
		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, name, ManagerId FROM User WHERE id IN :newUserIds]);
		Map<Id, sbaa__Approver__c> approvalIdMap = new Map<Id, sbaa__Approver__c>();
		List<sbaa__Approver__c> approvers = [SELECT Id, sbaa__User__c FROM sbaa__Approver__c];
        System.debug(LoggingLevel.ERROR, 'Inside createOrUpdateApprovalRecord --> approvers --> '+approvers);

		//Populate the approvalIdMap
		for(sbaa__Approver__c app : approvers ){
			if(app.sbaa__User__c != null){
				approvalIdMap.put(app.sbaa__User__c, app);
			}
		}

		List<sbaa__Approver__c> approverRecs = new List<sbaa__Approver__c>();
		for(Id userId : newUserIds){
			sbaa__Approver__c approverRec = new sbaa__Approver__c();
			if(userMap.get(userId) != null){
				approverRec.Name = userMap.get(userId).name;
				approverRec.sbaa__User__c = userMap.get(userId).Id;
				if(approvalIdMap.get(userMap.get(userId).ManagerId) == null){
					approverRec.sbaa__NextApprover__c = null;
				} else {
					approverRec.sbaa__NextApprover__c  = (approvalIdMap.get(userMap.get(userId).ManagerId)).Id;
				}
			}

			if(!isInsert){
				if(approvalIdMap.get(userMap.get(userId).Id) != null){
					approverRec.Id = approvalIdMap.get(userMap.get(userId).Id).Id;
				}
			}
			approverRecs.add(approverRec);
		}
        System.debug(LoggingLevel.ERROR, 'Inside createOrUpdateApprovalRecord --> approverRecs --> '+approverRecs);
        
		upsert approverRecs;
	}

	public void removeManagedPackageLicense(List<User> inactiveUsers) {
		//SOQL to get all the package licenses for a User
		List<UserPackageLicense> userPackageLicenses = new List<UserPackageLicense>([SELECT id,PackageLicenseid,Userid
		FROM UserPackageLicense
		WHERE userId IN :inactiveUsers]);

		System.debug(LoggingLevel.ERROR, 'userPackageLicenses --> '+userPackageLicenses);
		if(userPackageLicenses.size() > 0) {
			try{
				delete userPackageLicenses;
			}catch(Exception e){
				system.debug(' Delete exception: '+ e.getStackTraceString() + ' \n exception message :'+e.getMessage());
			}
		}
	}

	private static Map<String,Id> populatePsNameToId(){
		map<String, Id> psNameToId = new map<String, Id>();
		List<PermissionSet> allPermissionSets = [SELECT Id, Name, label FROM PermissionSet];
		for(PermissionSet ps : allPermissionSets){
			psNameToId.put(ps.Name, ps.Id);
		}
		return psNameToId;
	}

	private static Map<Id,String> getUserRoleName(List<User> users){
		Set<Id> userRoleIds = new Set<Id>();
		for(User usr : users){
			if(usr.UserRoleId !=null){
				userRoleIds.add(usr.UserRoleId);
			}
		}
		for(UserRole role :[SELECT Id,DeveloperName FROM userRole WHERE id in:userRoleIds]){
			mapOfRoleIdAndRoleName.put(role.Id,role.DeveloperName);
		}
		return mapOfRoleIdAndRoleName;
	}

	private static void populateUserRoleMapping(List<User> newUsers){
		Map<Id,String> mapOfRoleIdAndRoleName = getUserRoleName(newUsers);
		Map<String,User_Role_Mapping__c  > roleNameToUserRoleMapping = new Map<String,User_Role_Mapping__c>();
		System.debug(LoggingLevel.ERROR, '---> mapOfRoleIdAndRoleName --> '+mapOfRoleIdAndRoleName);
		for(User_Role_Mapping__c urm : [SELECT Name,Division__c,Role_Developer_Name__c,Theater__c, User_Function__c,
				User_Function_Detail__c, User_Sales_Region__c , User_Sales_Region_Team__c,
				User_Segment__c,Sales_Manager_Indicator__c
		FROM User_Role_Mapping__c
		WHERE Role_Developer_Name__c IN :mapOfRoleIdAndRoleName.values()]){
			roleNameToUserRoleMapping.put(urm.Role_Developer_Name__c, urm);
		}

		for(Id roleId : mapOfRoleIdAndRoleName.keyset()){
			roleIdToRoleMapping.put(roleId,roleNameToUserRoleMapping.get(mapOfRoleIdAndRoleName.get(roleId)));
		}
		System.debug(LoggingLevel.ERROR, '---> roleIdToRoleMapping --> '+roleIdToRoleMapping);

	}
}