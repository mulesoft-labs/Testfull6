/*********************************************************************
*
*   File Name: LeadTriggerHandler.cls
*
*   File Description: Handler class to handle logic for all trigger
*   events on the Lead Object
*
**********************************************************************
*
*   Date        Author              Change                 
*   07/03/14    Robert              Added onBeforeInsert method to handle
*                                   validation before insert when status
*                                   is equal to Qualified.  Also changed
*                                   validation to accept Phone OR Email
*   02/20/14    Andrew              Initial Creation                             
*
*********************************************************************/   

public class LeadTriggerHandler
{
    static boolean m_IsExecuting = false;
    static final string LEAD_STATUS_QUALIFIED = 'Qualified';
    static final string USER_TYPE_PARTNER = 'Partner';
    static final string USER_TYPE_POWERPARTNER = 'PowerPartner';
    static final string LEAD_RECORD_TYPE_PRM_DEAL_REGISTRATION = 'PRM Deal Registration';

    // implementation of on before insert event
    public void onBeforeInsert(List<Lead> leads)
    {
        //List of Lead records that needs to be validated
        List<Lead> leadsToValidate = new List<Lead>();
        for(Lead l :leads)
        {
            if(l.Status == LEAD_STATUS_QUALIFIED)
            {
                leadsToValidate.add(l);
            }
        }

        //Validate Lead records
        if(leadsToValidate.size() > 0)
        {    
            validateLeads(leadsToValidate);
        }
        
        
        Set<Id> leadOwnerIds = new Set<Id>();
        for (Lead l:leads) {
		    leadOwnerIds.add(l.ownerId);
	    }
	    Map<Id,User> userMap = getUserMap(leadOwnerIds);
	    Id prmDealRegistartionRecordTypeId = [SELECT Id FROM RecordType WHERE Name =: LEAD_RECORD_TYPE_PRM_DEAL_REGISTRATION].Id;
	    
	    //update lead owner role based on the role name of the lead owner
	    for (Lead l:leads) {
    		if (l.ownerId!=null && l.IsConverted==false) {
    		    if(userMap.get(l.ownerId) != null && userMap.get(l.ownerId).userroleid != null){
    		        l.Lead_Owner_Role__c = userMap.get(l.ownerId).userRole.Name;
    		    }
    		}
    	}
    	
    	//populate channel manager and partner contact
    	for (Lead l:leads) {
    		if(isPartnerUser (l.OwnerId, userMap)  && l.RecordTypeId == prmDealRegistartionRecordTypeId ){
    		    l.Partner_Contact__c = userMap.get(l.OwnerId).ContactId; 
                l.Channel_Account_Manager__c = userMap.get(l.OwnerId).Contact.Account.OwnerId;
            }
    	}
    }
    
    public void onAfterInsert(List<Lead> leads){
        //populate the lead lookup on Anypoint User records matching leads in context by email
        Set<String> leadEmails = new Set<String>();
        for (Lead l : leads) {
            if(l.Email != null)
                leadEmails.add(l.Email);
        }
        if(!leadEmails.isEmpty()){
            updateAnyPointUsersLeadField(leadEmails, leads);
        }
    }
    
    public void onBeforeUpdate(List<Lead> newList, Map<Id,Lead> oldMap)
    {
        //List of Lead records that needs to be validated
        List<Lead> leadsToValidate = new List<Lead>();
        for(Lead l :newList)
        {
            //When lead is converting, validate lead fields
            if( l.Status  == LEAD_STATUS_QUALIFIED 
                && ( l.Status != oldMap.get(l.id).Status  ||  l.Convert_to_Contact_Only__c != oldMap.get(l.id).Convert_to_Contact_Only__c)
            )
            {
                    leadsToValidate.add(l);
            }
        }
        
        //Validate Lead records
        if(leadsToValidate.size() > 0)
        {    
            validateLeads(leadsToValidate);
        }
        
        //validate Rejection reason Exists for Rejected Leads
        For(lead l: newList)
        {
            if(l.Rejected__c && (l.Rejection_Reason__c == null || l.Rejection_Reason__c == ''))
            {
                l.addError('Please Enter Rejection Reason.');
            } 
        }
        
        Set<Id> leadOwnerIds = new Set<Id>();
        for (Lead l:newList) {
		    leadOwnerIds.add(l.ownerId);
		    leadOwnerIds.add(oldMap.get(l.Id).ownerId);
	    }
	    
	    Map<Id,User> userMap = getUserMap(leadOwnerIds);
	    Id prmDealRegistartionRecordTypeId = [SELECT Id FROM RecordType WHERE Name =: LEAD_RECORD_TYPE_PRM_DEAL_REGISTRATION].Id;
	    
	    //update lead owner role based on the role name of the lead owner
	    for (Lead l:newList) {
    		if (l.ownerId!=null && l.IsConverted==false) {
    		    if(userMap.get(l.ownerId) != null && userMap.get(l.ownerId).userroleid != null){
    		        l.Lead_Owner_Role__c = userMap.get(l.ownerId).userRole.Name;
    		    }
    		}
    	}
    	
    	//populate/clear channel manager and partner contact
    	for( Lead l : newList ){
            Lead oldLead = oldMap.get( l.Id ); 
            if( isPartnerUser(l.OwnerId, userMap) && l.RecordTypeId == prmDealRegistartionRecordTypeId && 
                ( l.OwnerId != oldLead.OwnerId || l.RecordTypeId != oldLead.RecordTypeId ) ){
                l.Partner_Contact__c = userMap.get(l.OwnerId).ContactId; 
                l.Channel_Account_Manager__c = userMap.get(l.OwnerId).Contact.Account.OwnerId;
            }
            
            if( isPartnerUser(oldLead.OwnerId, userMap) && oldLead.RecordTypeId == prmDealRegistartionRecordTypeId &&
                ( l.OwnerId != oldLead.OwnerId || l.RecordTypeId != oldLead.RecordTypeId ) ){
                l.Partner_Contact__c = null; 
                l.Channel_Account_Manager__c = null;
            }
        }
    }
    
    //implementiaon of onAfter update event
    public void onAfterUpdate(List<Lead> newList, Map<Id,Lead> oldMap)
    {
        Set<Id> accountsForConvertedLeads = new Set<Id>();
        Set<Id> convertedLeadIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Lead> StageTrackingLeads = new Set<Lead>();
        Set<String> leadEmails = new Set<String>();
        Map<Id,Integer> accountContactCountMap = new Map<Id,Integer>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Opportunity> opps = new List<Opportunity>();
        
        
        for(Lead l: newList){
            if(l.isConverted == true && oldMap.get(l.Id).isConverted == false){
                if(l.ConvertedContactId != null && l.ConvertedAccountId != null){
                    accountsForConvertedLeads.add(l.ConvertedAccountId);
                }
            }
            userIds.add(l.OwnerId);
            
            //get emails for unconverted leads to update associated any point users
            if(l.Email != null && !l.isConverted){
                leadEmails.add(l.Email);
            }
        }
        
        //add current user to User Ids (to add current user to Opp team)
        userIds.add(UserInfo.getUserId());
        
        Map<Id,User> userMap = getUserMap(userIds);
        
        if(!accountsForConvertedLeads.isEmpty()){
            for(Contact c: [SELECT Id, AccountId FROM Contact WHERE AccountId in: accountsForConvertedLeads]){
                if(accountContactCountMap.get(c.AccountId) == null){
                    accountContactCountMap.put(c.AccountId, 1);
                }
                else{
                     accountContactCountMap.put(c.AccountId, accountContactCountMap.get(c.AccountId) + 1);
                }
            }
        }
        for(Lead l: newList){
            if(l.isConverted == true && oldMap.get(l.Id).isConverted == false){
                //update contacts associated to converted leads
                if(l.ConvertedContactId != null){
                    Contact contactToUpdate = new Contact(Id = l.ConvertedContactId);
                    contactToUpdate.lead_source_asset__c = l.Lead_Source_Asset__c;
                    contactToUpdate.lead_source_detail__c = l.Lead_Source_Detail__c;
                    //update primary flag on contact
                    if(l.ConvertedAccountId != null){
                        if(accountContactCountMap.get(l.ConvertedAccountId) == 1){
                            contactToUpdate.Primary_Contact__c = true;   
                        }
                    }
                    contactsToUpdate.add(contactToUpdate);
                }
                //updates opportunities associated to converted leads
                if(l.ConvertedOpportunityId != null){
                    Opportunity opportunityToUpdate = new Opportunity(Id = l.ConvertedOpportunityId);
                    mapConvertedLeadToOpportunity(l,  opportunityToUpdate, userMap);
                    opps.add(opportunityToUpdate);  
                    StageTrackingLeads.add(l);
                }
            }
        }
        
        //update contacts associated to converted leads
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
        
        //update opportunities associated to converted leads
        if(opps.size() > 0)
        {
            update opps;
        }
        //create staage tracking for opportunities created as a result of lead conversion
        if(StageTrackingLeads.size() > 0)
        {    
            createStageTrackingLeads(StageTrackingLeads);
        }
        //populate the lead lookup on Anypoint User records matching leads in context by email
        if(!leadEmails.isEmpty()){
            updateAnyPointUsersLeadField(leadEmails, newList);
        }
        //-------------------------------------------------------------------------------------------------------------------------//
        //code from Lead.trigger
        Map<Id, Id> oppId_Partner_Map = new Map<Id, Id>(); 
        Map<Id,Id> OppId_Userid_Map = new map<id,id>();
        map<id,String> TeamMemberRoleMap = new map<id,String>();
        ATST_Settings__c defaultApplicationSettings = AddToSalesTeam.getDefaultApplicationSettings();
        if(defaultApplicationSettings.Lead_Record_Types__c != null) {
            Set<Id> leadRecordTypes = new Set<Id>();
            for (String rt : defaultApplicationSettings.Lead_Record_Types__c.split(';')) {
                leadRecordTypes.add(rt);
            }
            
            for (Lead l: newList){
                if (l.ConvertedOpportunityId != null && !oldMap.get(l.Id).IsConverted && l.IsConverted &&  leadRecordTypes.contains(l.RecordTypeId)) {
                    oppId_Partner_Map.put(l.ConvertedOpportunityId, OldMap.get(l.Id).OwnerId);     
                }
            }
            //although call says partner, it adds standard users as well
            if (!oppId_Partner_Map.isEmpty()){
                AddToSalesTeam.addPartnerToSalesTeamFuture(oppId_Partner_Map);
            }
            
        }
        //-------------------------------------------------------------------------------------------------------------------------
    }
    
    public static void createStageTrackingLeads( Set<Lead> StageTrackingLeads){
        set<id> oppId = new set<id>();
        map<String,Decimal> probabilityStageNameMap  = new map<String,Decimal>();
        list<Stage_Tracking__c> upsertStageTrackingList = new list<Stage_Tracking__c>();
        for(Lead l : StageTrackingLeads){
            if(l.ConvertedOpportunityId != null){
                oppId.add(l.ConvertedOpportunityId);
            }
        }
        
        for (OpportunityStage oppStageProb : [Select MasterLabel, DefaultProbability From OpportunityStage]){
            probabilityStageNameMap.put(oppStageProb.MasterLabel, oppStageProb.DefaultProbability);
         }
        
        for(Opportunity o : [SELECT Id,Lead_Passed_By__c,Lead_Passed_By_Group__c,StageName,Probability,amount,Subscription_Amount__c,ACV__c,CloseDate 
                            FROM Opportunity WHERE Id IN :oppId]){
            Stage_Tracking__c st= new Stage_Tracking__c();
            system.debug('**********'+o.Lead_Passed_By_Group__c);
            system.debug('**********'+o.Lead_Passed_By__c);
            upsertStageTrackingList.add(OpportunityTriggerHandler.formStageTrackingRec(st,o,true,false,null,probabilityStageNameMap, null));
        }
        
        if(!upsertStageTrackingList.isEmpty()) {
             try {
                 upsert upsertStageTrackingList;
             }catch(DmlException e) {
                 System.debug('The following exception has occurred: ' + e.getMessage());
             }
        }
        
    }
    
    //Validate Lead Fields
    public void validateLeads(List<Lead> leadList) {
       //Fields to Validate for conversion without Opportunity
        for(Lead l : leadList){
            if(l.LeadSource == null){
                l.LeadSource.addError(Label.Lead_Source_Error);
            }
            if(l.Phone == null && l.Email == null)
            {
                l.Phone.addError(Label.Lead_Phone);
            }
        }
    }
    
    private Map<Id,User> getUserMap(Set<ID> userIds){
        return  new Map<Id,User>([select id,name,userroleid,userRole.Name,ContactId,UserType,Contact.Account.OwnerId, Division
	                                            from User where id in:userIds]);
    }
    
    private boolean isPartnerUser (Id userId, Map<Id,User> userMap){
        boolean isPartnerUser = false;
        if(userMap.get(userId) != null){
            User partnerUser = userMap.get(userId);
            if(partnerUser.contactId != null 
            && (USER_TYPE_PARTNER.equalsIgnoreCase(partnerUser.UserType) || USER_TYPE_POWERPARTNER.equalsIgnoreCase(partnerUser.UserType))){
	            isPartnerUser = true;
	        }
        }
        return isPartnerUser;
    }
    
    //maps fields from converted lead to the associated opportunity
    private void mapConvertedLeadToOpportunity(Lead convertedLead, Opportunity o, Map<Id, User> userMap){
        o.Who_cares_about_it__c=convertedLead.Who_cares_about_it__c ; 
        //o.What_is_the_use_case_s__c = convertedLead.PQ_Makeup_of_Current_Environment__c;
        o.What_company_integration_strategy__c = convertedLead.PQ_Current_or_Past_Integration_Strategy__c;
        o.Compelling_Event__c= convertedLead.PQ_Project_Description__c; 
        o.What_business_problem_are_they_solving__c = convertedLead.PQ_Business_or_Technical_Challenges__c;
        o.Opp_Business_Impact_ROI__c = convertedLead.PQ_Business_Impact__c;      
        o.Evaluation_Go_live_Timelines__c=convertedLead.PQ_Key_Milestones__c;
        o.What_are_the_consequence_of_waiting__c = convertedLead.PQ_Goals_and_Objectives__c;
        o.What_products_are_they_evaluating__c=convertedLead.What_products_are_they_evaluating__c;
        o.Who_is_the_competition__c= convertedLead.Who_is_the_competition__c;
        o.Existing_ESB_other_technology__c = convertedLead.Existing_ESB_other_technology__c;               
        o.Describe_Evaluation_Process__c = convertedLead.PQ_Evaluation_Process_and_Criteria__c;
        o.Additional_Information_Comments__c = convertedLead.PQ_Additional_Information_or_Questions__c;
        o.Primary_Solution_Interest__c = convertedLead.Lead_Main_Interest__c;
        o.Lead_Source_Detail__c = convertedLead.Lead_Source_Detail__c;
        o.Lead_Source_Asset__c = convertedLead.Lead_Source_Asset__c;
  
        //Check if LeadSource is unknown
        if(String.isNotBlank(convertedLead.LeadSource))
        {
            o.LeadSource = convertedLead.LeadSource;
        }
        else
        {
            o.LeadSource = 'Unknown';
        }
        
        //Check if Lead Type is unknown    
        if(String.isNotBlank(convertedLead.Lead_Type__c))
        {
            o.Lead_Type__c = convertedLead.Lead_Type__c;
        }
        else
        {
            o.Lead_Type__c = 'Unknown';
        }

        o.Lead_Passed_By__c= convertedLead.OwnerId;
        o.Amount=1.00;
        
        // When lead is first converted, there's a delay in setting the
        // converted date so it doesn't get passed to the opportunity
        // So setting used today's date if it's null.
        if(convertedLead.ConvertedDate == null)
        {                
            o.Lead_Passed_On__c = Date.today(); // convertedLead.ConvertedDate;
        }
        else
        {             
            o.Lead_Passed_On__c = convertedLead.ConvertedDate;
        }

        if(userMap.get(convertedLead.OwnerId) != null)
        {
            o.Lead_Passed_By_Group__c = userMap.get(convertedLead.OwnerId).Division;
        }
    }
    
    private static void updateAnyPointUsersLeadField(Set<String> leadEmails, List<Lead> leads){
        List<AnypointUser__c> anyPointUsers = [SELECT Id, Email__c from AnypointUser__c where Email__c in :leadEmails];
        List<AnypointUser__c> anyPointUserstoUpdate = new List<AnypointUser__c>();
        
        for (AnypointUser__c anyPointUser : anyPointUsers) {
            for (Lead l : leads) {
                if (anyPointUser.Email__c == l.Email && !l.IsConverted) {
                    anyPointUser.Lead__c = l.Id;
                    
                    boolean addToUpdate = true;
                    for (AnypointUser__c updatedUser : anyPointUserstoUpdate) {
                        if (anyPointUser.Id == updatedUser.Id) {
                            addToUpdate = false;
                        }
                    }
                    
                    if (addToUpdate) anyPointUserstoUpdate.add(anyPointUser);
                }
            }
        }
        if(!anyPointUserstoUpdate.isEmpty()){
            Database.update(anyPointUserstoUpdate);
        }
    }
}