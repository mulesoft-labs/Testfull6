/*********************************************************************
*
*   File Name: OpportunityTriggerHandler.cls
*
*   File Description:  Generic class to handle all Trigger event on 
*   Opportunity object
*
**********************************************************************
*
*   Date        Author              Change
*   07/07/14    Robert              Added functionality to lock records
*                                   using approval workflow when stage
*                                   is Closed Lost or Submitted for Closing
*   03/01/14    Andrew              Create Win report When opportunity
*                                   stage changed to Awaiting Paperwork
*                                   (On After Update)
*   03/01/14    Andrew              Create loss report when opportunity
*                                   get lost  (on After Update)
*   02/20/14    Andrew              Initial Creation                             
*
*********************************************************************/

public class OpportunityTriggerHandler
{
    private static Set<Id> parentIds = new Set<Id>();
    static boolean m_IsExecuting = false;
    //After Update trigger is retriggering from Opp_RelatedFieldsAfterUpdate
    static boolean m_stop_AfterUpdate = false;
    //TODO:- put this into custom label
    static string ERROR_MESSAGE = 'Please enter a value before going to 10%';

    private Set<Id> oppIdsWithMuleSoft;
    //Map to hold all error messages
    private Map<String,List<String>> mapOppToErrorMessage = new Map<String,List<String>>();

    static boolean hasExecuted = false;

    static String MOVE_TO_5_PERCENT = Label.MOVE_TO_5_PERCENT;
    static String APPROVAL_STATUS_APPROVED = 'Approved';
    static Set<Id> oppWithSTageTrackingProcessPerformed = new Set<Id>();

    //used to validate Opprotuities have primary contact role after creation
    public static Map<Id, List<OpportunityContactRole>> opportunityContactRoleMap = new Map<Id, List<OpportunityContactRole>>();
    public static Integer minutesToWaitBeforeValidatingOpportunityPrimaryCotactRole = 3;
    public static Map<Id,Id> oppIdsToContactIdMap = new Map<Id,Id>();
    public static Map<Id,Id> opportunityIdsToContactIdMapExpansion = new Map<Id,Id>();
    public static Map<Id,Id> opportunityIdsToContactIdMapNewProject = new Map<Id,Id>();

	public void onBeforeInsert(List<Opportunity> newList){
        List<Opportunity> renewalOpps = new List<Opportunity>();
        List<Id> relevantContractIds = new List<Id>();
        String currentUserProfile = Utilities.currentUser.Profile.Name;
        System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> currentUserProfile --> '+ currentUserProfile);
 
        for(Opportunity opp : newList){
            if (opp.SBQQ__Renewal__c == TRUE && opp.SBQQ__RenewedContract__c != NULL){
                relevantContractIds.add(opp.SBQQ__RenewedContract__c);
                renewalOpps.add(opp);
            }
            /* When Cloning an Opportunity using the Cloning button, Oppty Mirroring related fields should be 
             * Blanked out
            */            
            if(currentUserProfile != 'SFDC - Org62 Mirroring'){
                if(opp.Org62_Opportunity_ID__c !=null){
                    opp.Org62_Opportunity_ID__c = null;
                }
                if(opp.Org62_Ready_to_Mirror_Date__c !=null){
                    opp.Org62_Ready_to_Mirror_Date__c = null;
                }
                if(opp.Org62_Final_Sync_Completed__c == true){
                    opp.Org62_Final_Sync_Completed__c = false;
                }
                if(opp.Org62_Order__c == true){
                    opp.Org62_Order__c = false;
                }                
                if(opp.SI_Partner_Account_2__c !=null){
                    opp.SI_Partner_Account_2__c = null;
                }                
                if(opp.SI_Partner_Account_1__c !=null){
                    opp.SI_Partner_Account_1__c = null;
                }
                if(opp.Org62_Lead_Sales_Partner_Role__c !=null){
                    opp.Org62_Lead_Sales_Partner_Role__c = null;
                }
                if(opp.App_Partner_Account_1__c !=null){
                    opp.App_Partner_Account_1__c = null;
                }
                if(opp.Org62_Opportunity_Product_Id__c !=null){
                    opp.Org62_Opportunity_Product_Id__c = null;
                }
            }
        }
 
        if(!relevantContractIds.isEmpty()){
            CopyFieldsFromOrigToRenewalOpp(renewalOpps, relevantContractIds);
        }
 
        //Sync custom forecast to standard forecast for new/add on opportunity
        setForecastCategoryBasedOnCustomForecast(newList);
        
    }

    /**
    * After update event implementation
    */
    public void onAfterInsert(Map<Id,Opportunity> newMap)
    {
        //Added by Nikhil to track stage @2/1/2017
        setStageTracking(newMap, null,true);

        //copy over partner details for renewal opportunities
        copyPartnerDetialsForNewRenewalOpportunities(newMap.values());

        //Update "Num of Child Opps" count
        for (Opportunity newOpp : (List<Opportunity>)Trigger.new){
            if(newOpp.Parent_Opportunity__c  != null){
                parentIds.add(newOpp.Parent_Opportunity__c );
            }
            //ORG 62 Lead Pass: Whenever a new Opp is created and Salesforce_lead_pass_contact__c loopkup is populated,
            //and type is New OR Add on business, create OCR
            if(!String.isblank(newOpp.Salesforce_lead_pass_contact__c)){
                if(ConstantDeclarations.OPP_TYPE_NEW_BUSINESS.equalsIgnoreCase(newOpp.Type) || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(newOpp.Type)){
                    oppIdsToContactIdMap.put(newOpp.Id, newOpp.Salesforce_lead_pass_contact__c);
                }
            }
        }

        if(parentIds.size() > 0){
            updateChildrenCount(parentIds);
        }

        //ORG 62 Lead Pass: Create Opportunity Contact Role
        if (oppIdsToContactIdMap != null && !oppIdsToContactIdMap.isEmpty()) {
            createOpportunityContactRole(oppIdsToContactIdMap);
        }


    }

    private void updateChildrenCount(set<Id> parentIdSet){
        System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> updateChildrenCount --> parentIdSet --> '+ parentIdSet);
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        //Get a map of the Opportunities with the number of children
        Map<Id, Opportunity> oppMap = new Map<Id,Opportunity>([SELECT Id, Parent_Opportunity__c FROM Opportunity WHERE Id IN :parentIdSet]);

        //Query the Opportunity and the related children and add the size of the children to the Parent Contract
        for (Opportunity oppty : [SELECT Id, Name, Parent_Opportunity__c, Num_of_Child_Opps__c,(SELECT Id FROM Opportunities1__r)
        FROM Opportunity WHERE Id IN :parentIdSet]) {
            oppMap.get(oppty.Id).Num_of_Child_Opps__c = oppty.Opportunities1__r.size();
            //add the child Contract in the map to a list so we can update it
            oppsToUpdate.add(oppMap.get(oppty.Id));
        }
        System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> oppsToUpdate  --> '+ oppsToUpdate);
        if(Trigger.isUpdate || (Trigger.isAfter && Trigger.isDelete)){
            CMsTriggerRunCounter.skipOppTrigger = true;
            update oppsToUpdate;
            CMsTriggerRunCounter.skipOppTrigger = false;

        }
    }

    /**
     * After update event implementation
     */
    public void onAfterUpdate(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap)
    {
        for (Opportunity oldOpp : (List<Opportunity>)Trigger.old){
            if(oldOpp.Parent_Opportunity__c != null){
                parentIds.add(oldOpp.Parent_Opportunity__c);
            }
        }

        //When we link an existing Opportunity to be a child, Trigger.new will have value for Parent_Opportunity__c
        for (Opportunity newOpp : (List<Opportunity>)Trigger.new){
            if(newOpp.Parent_Opportunity__c != null){
                parentIds.add(newOpp.Parent_Opportunity__c);
            }
        }
        if(parentIds.size() > 0) {
            updateChildrenCount(parentIds);
        }
        List<Opportunity> opportunitiesWithCloseDateChange = new List<opportunity>();

        //Added by Nikhil to track stage @2/1/2017
        setStageTracking(newMap, oldMap,false);

        System.debug('@@@@@ after setStageTracking');

        //if(m_IsExecuting == false && m_stop_AfterUpdate == false)
        //{
        //m_IsExecuting = true;
        //m_stop_AfterUpdate = true;
        List<Opportunity> listLostOpps = new List<Opportunity>();
        List<Opportunity> lisWonOpps = new List<Opportunity>();
        Map<Id, Opportunity> opportuntiesForConnectorUpdateMap = new Map<Id,Opportunity>();
        Map<Id, Id> oldOppToDuplicateOpp = new Map<Id, Id>();

        //If Opportunity get lost then create lost report
        for(Opportunity opp : newMap.values())
        {
            Opportunity oldOpp = oldMap.get(opp.id);
            if(opp.StageName != oldMap.get(opp.id).StageName && opp.StageName == 'Closed Lost')
            {
                listLostOpps.add(opp);
            }
            else if(opp.StageName != oldMap.get(opp.id).StageName && opp.StageName == 'Closed Won')
            {
                //create won report when opportunity is ready for paperwork
                lisWonOpps.add(opp);
            }
            if ((opp.Amount !=  oldOpp.Amount) || (opp.ExpectedRevenue != oldOpp.ExpectedRevenue) || (opp.isWon != oldOpp.isWon) || (opp.isClosed != oldOpp.isClosed)) {
                opportuntiesForConnectorUpdateMap.put(opp.Id, opp);
            }

            //identify opportunities with close date change
            if(opp.CloseDate != oldOpp.closeDate){
                opportunitiesWithCloseDateChange.add(opp);
            }
            /* Check if that Opportunity Stage is Closed Lost OR Rejected Lead and
            * If Closed Lost, Primary Reason: (NAO) = Duplicate OR Consolidated Into Existing Opp
            * Copy the SC Action to the duplicate Opp.
            * */
            if((opp.StageName == ConstantDeclarations.OPP_STAGE_REJECTED_LEAD ||opp.StageName == ConstantDeclarations.OPP_STAGE_CLOSED_LOST) &&
                    (opp.If_Closed_Lost_Primary_Reason__c == 'Duplicate' || opp.If_Closed_Lost_Primary_Reason__c == 'Consolidated Into Existing Opp') &&
                    opp.Duplicate_Opportunity_if_exists__c != oldMap.get(opp.id).Duplicate_Opportunity_if_exists__c &&
                    opp.Duplicate_Opportunity_if_exists__c != null
                    ){
                oldOppToDuplicateOpp.put(opp.Id, opp.Duplicate_Opportunity_if_exists__c);
            }

        }

        System.debug(LoggingLevel.ERROR, 'oldOppToDuplicateOpp --> '+oldOppToDuplicateOpp);
        if (oldOppToDuplicateOpp != null && !oldOppToDuplicateOpp.isEmpty()) {
            migrateScActions(oldOppToDuplicateOpp);
        }

        if(listLostOpps.size() > 0)
        {
            //Create lost Report
            createLossReport(listLostOpps);
        }
        else if(lisWonOpps.size() > 0)
        {
            //create wonReport
            createWonReport(lisWonOpps);

            //propagate business initiative and objectives to parent accounts
            updateAccountBusinessInitiatives(lisWonOpps);
        }
        System.debug('@@@@@ after createLostWonReport');
        //Added By Nikhil @ Perficient 11/27/2015
        Set<Id> closedOpps = new Set<Id>();
        for(Opportunity opp : newMap.values()){
            if((opp.StageName != oldMap.get(opp.id).StageName && opp.StageName == 'Closed Won') && (opp.Amount > 0) && (String.isNotBlank(opp.Intacct_Message__c)) &&  (String.isNotBlank(opp.Sales_Channel__c) && opp.Sales_Channel__c.containsIgnoreCase('Self-Service')) && (opp.Name.containsIgnoreCase('- Dataloader -'))){
                closedOpps.add(opp.id);
            }
        }

        if(!closedOpps.isEmpty())processOppCreateOrder(closedOpps);
        System.debug('@@@@@ after processOppCreateOrder');

        //update the Status/Expected Revenue/Booked Revenue/Lost Revenew on connectors associated to the opportunity (API Name: Extension_Opportunity__c)
        if(!opportuntiesForConnectorUpdateMap.isEmpty()){
            updateOpportunityConnectors(opportuntiesForConnectorUpdateMap);
        }
        System.debug('@@@@@ after updateOpportunityConnectors');
        //m_IsExecuting = false;
        //}

        if(!opportunitiesWithCloseDateChange.isEmpty()){
            updateOpportunityLineItemServiceDate(opportunitiesWithCloseDateChange);
        }

    }

	/*
    public static void updateOpportunityStage( Map<Id, Opportunity> newMap, Set<Id> oppIds ){
        Map<Id, String> oppIdToStatusMap = new Map<Id, String>();
        for( ProcessInstance pi : [SELECT targetObjectId, LastModifiedDate, Id,
        (SELECT Id, StepStatus, Comments
        FROM StepsAndWorkitems
        WHERE StepStatus = 'Approved')
        FROM ProcessInstance
        WHERE targetObjectId IN: oppIds
        AND Status = 'Approved' ORDER BY LastModifiedDate DESC] ){
            if( !oppIdToStatusMap.containsKey(pi.TargetObjectId ) ){
                if( pi.StepsAndWorkitems != null){
                    for( ProcessInstanceHistory pih : pi.StepsAndWorkitems ){
                        if( pih.Comments != null && pih.Comments.contains( MOVE_TO_5_PERCENT ) ){
                            oppIdToStatusMap.put( pi.TargetObjectId, ConstantDeclarations.OPP_STAGE_5_PERCENT );
                        }else{
                            oppIdToStatusMap.put( pi.TargetObjectId, '' );
                        }
                    }
                }
            }
        }
        system.debug(oppIdToStatusMap);
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for( Id oppId : oppIdToStatusMap.keySet() ){
            Opportunity opp = newMap.get( oppId );
            if( oppIdToStatusMap.get(oppId) != '' ){
                opp.StageName = oppIdToStatusMap.get(oppId);
                opp.SAL_Approval_status__c = 'Approved -  5%';
            }
        }
    }
	*/

    /**
     * Before update event implementation
     */
    public void onBeforeUpdate(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap)
    {
        Id opportunityInClosingNAORecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_LABEL).getRecordTypeId();
        Id opportunityInClosingRenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_LABEL).getRecordTypeId();

        //Sync custom forecast to standard forecast for new/add on opportunity
        setForecastCategoryBasedOnCustomForecast(newMap.values());

        Set<Id> ruleDiscoveryIds = new Set<Id>();
        Set<Id> rulePreValueIds = new Set<Id>();
        Set<Id> ruleTechEvalIds = new Set<Id>();
        for(Opportunity opp : newMap.values())
        {
            /*set "Sales Accepted Lead Date" on opportunity to Today when the Opportunity stage changes from 0. Sales Qualified Lead to  any other  stage
            except Rejected Lead/Closed Lost */
            if (opp.StageName != ConstantDeclarations.OPP_STAGE_REJECTED_LEAD && opp.StageName != ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED
                    && opp.StageName != ConstantDeclarations.OPP_STAGE_CLOSED_LOST 
                	&& oldMap.get(opp.Id).StageName == ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED) {
                opp.Sales_Accepted_Lead_Date__c = System.today();
            }

            //Set "Date when Probability 10%" to today if Probability was set to 10% and stage is not Closed/Won or Rejected lead
            if(opp.StageName != ConstantDeclarations.OPP_STAGE_CLOSED_WON && opp.StageName != ConstantDeclarations.OPP_STAGE_REJECTED_LEAD
                    && opp.Probability != oldMap.get(opp.Id).Probability && opp.Probability==10)
            {
                opp.Date_Probability_10__c = System.TODAY();
            }
            
            //set record type to Opportunity in closing if stage is submitted for closing
            if(opp.RecordTypeId != opportunityInClosingNAORecordTypeId && opp.RecordTypeId != opportunityInClosingRenewalRecordTypeId && ConstantDeclarations.OPP_STAGE_SUBMIT_CLOSING.equalsIgnoreCase(opp.StageName)){
                if(ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR.equalsIgnoreCase(opp.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR_ANNUAL_PAY.equalsIgnoreCase(opp.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_CONTRA_BOOKING.equalsIgnoreCase(opp.Type)){
                    opp.RecordTypeID = opportunityInClosingRenewalRecordTypeId;
                } else {
                    opp.RecordTypeID = opportunityInClosingNAORecordTypeId;
                }
            }
            
            //Automating CloseDate for Booked opportunities 
            System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@  ---> opp.Type --> '+ opp.Type);
            System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@  ---> opp.SubscriptionStartDate__c --> '+ opp.SubscriptionStartDate__c);            
 			if(opp.StageName == ConstantDeclarations.OPP_STAGE_CLOSED_WON && 
               (opp.StageName != oldMap.get(opp.id).StageName || opp.SubscriptionStartDate__c  != oldMap.get(opp.id).SubscriptionStartDate__c  
                || opp.Type  != oldMap.get(opp.id).Type)){
                    //Handle opportunity type: "Renewal - Multi-Year" and "Renewal - Multi-Year Annual Pay"
                    if(ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR.equalsIgnoreCase(opp.Type) || ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR_ANNUAL_PAY.equalsIgnoreCase(opp.Type)){
                        opp.CloseDate = opp.SubscriptionStartDate__c;
            			System.debug(LoggingLevel.ERROR, '1 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                        
                    }//Handle opportunity type: Renewal
                    else if(ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type)) {
	                   if(opp.Original_Renewal_Close_Date__c > Date.Today()){
					   	  opp.CloseDate = opp.Original_Renewal_Close_Date__c;
               			  System.debug(LoggingLevel.ERROR, '2.1 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                        
                   		} else {
                       		opp.CloseDate = Date.Today();
            			    System.debug(LoggingLevel.ERROR, '2.2 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                    
                   		}
                    }//Handle opportunity types: "Add-On Business - Multi-Year Annual Pay", "Add-On Business - Multi-Year" and Future Dated Orders 
                    else if(ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS_MULTI_YEAR_ANNUAL_PAY.equalsIgnoreCase(opp.Type) || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS_MULTI_YEAR.equalsIgnoreCase(opp.Type) || opp.Future_Dated_Order__c == true){
                        if(opp.SubscriptionStartDate__c.day() > 15){
                            opp.CloseDate = opp.SubscriptionStartDate__c - (opp.SubscriptionStartDate__c.day() - 1);
            				System.debug(LoggingLevel.ERROR, '3.1 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                
                        } else {
                            opp.CloseDate = opp.SubscriptionStartDate__c.addMonths(-1) - (opp.SubscriptionStartDate__c.day() - 1); 
            				System.debug(LoggingLevel.ERROR, '3.2 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                
                        }
                    }//Handle opportunity type: New Business,Add-On Business and Add-On Business - Renewal Price Uplift 
                    else if(ConstantDeclarations.OPP_TYPE_NEW_BUSINESS.equalsIgnoreCase(opp.Type) || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type) || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS_RENEWAL_PRICE_UPLIFT.equalsIgnoreCase(opp.Type)){
						if(Date.Today() >= opp.SubscriptionStartDate__c || opp.SubscriptionStartDate__c.month() == Date.Today().month()){
							opp.CloseDate = Date.Today();
            				System.debug(LoggingLevel.ERROR, '4.1 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                                            
                        } else if(opp.SubscriptionStartDate__c.month() - Date.Today().month() == 1 
                                  && opp.SubscriptionStartDate__c.year() == Date.Today().year()){
                                if(opp.SubscriptionStartDate__c.day() <=15){
                                    opp.CloseDate = Date.Today();
		            				System.debug(LoggingLevel.ERROR, '4.2 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                                            
                                } 
                                if(opp.SubscriptionStartDate__c.day() > 15){
                                    opp.CloseDate =  date.newInstance(opp.SubscriptionStartDate__c.year(),opp.SubscriptionStartDate__c.month(),1);
		            				System.debug(LoggingLevel.ERROR, '4.3 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                                            
                                }                        
                        } else if(opp.SubscriptionStartDate__c.day() > 15){
                        	opp.CloseDate = opp.SubscriptionStartDate__c - (opp.SubscriptionStartDate__c.day() - 1);
            				System.debug(LoggingLevel.ERROR, '4.4 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                                                                        
                        }  else{
                            opp.CloseDate = opp.SubscriptionStartDate__c.addMonths(-1) - (opp.SubscriptionStartDate__c.day() - 1); 
            				System.debug(LoggingLevel.ERROR, '4.5 --> @@@@@@@@@@@@@@@@@@  ---> opp.CloseDate --> '+ opp.CloseDate);                                                                                                    
                        }
                    }
            }			
            System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> opp.CloseDate --> '+ opp.CloseDate);
            

            //ORG 62 Lead Pass: Whenever Salesforce_lead_pass_contact__c loopkup is changed then populate the Map
            if(opp.Salesforce_lead_pass_contact__c  != oldMap.get(opp.id).Salesforce_lead_pass_contact__c
                    && opp.Salesforce_lead_pass_contact__c !=null
                    && (ConstantDeclarations.OPP_TYPE_NEW_BUSINESS.equalsIgnoreCase(opp.Type)
                    || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type)
            )){
                oppIdsToContactIdMap.put(opp.Id, opp.Salesforce_lead_pass_contact__c);
            }

            //set Fill "Reviewed By"
            if(opp.Deal_Checked__c && opp.Deal_Checked__c != oldMap.get(opp.id).Deal_Checked__c && String.ISBLANK(opp.Reviewed_By__c) ){
                opp.Reviewed_By__c = UserInfo.getFirstName()+ ' ' + UserInfo.getLastName();
            }

            //Update Sales Ops Processed By
            if(opp.StageName == 'Closed Won' && String.ISBLANK(opp.Processed_By__c) && opp.CloseDate >= Date.newInstance(2016, 5, 1) ){
                opp.Processed_By__c = UserInfo.getFirstName()+ ' ' + UserInfo.getLastName();
            }

            /******************************************************************************************************************************************
             * ORG 62 Lead Pass:
             * IF Org62 Lead Pass Add-On Review is TRUE AND Type = Add-On Business AND Add On Type = Expansion AND SFDC LeadPass contact is not Null
             * then:
             * 1. Set contact status to Unqualified (follow details on deck)
             * 2. Remove the Salesforce Lead Pass contact from opportunity
            ******************************************************************************************************************************************/
            if(opp.Org62_Lead_Pass_Add_On_Review__c == true && ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type) && opp.Add_On_Type__c == 'Expansion'
                    && !String.isblank(opp.Salesforce_lead_pass_contact__c)
                    && (opp.Org62_Lead_Pass_Add_On_Review__c  != oldMap.get(opp.id).Org62_Lead_Pass_Add_On_Review__c
                    || opp.Type  != oldMap.get(opp.id).Type
                    || opp.Add_On_Type__c  != oldMap.get(opp.id).Add_On_Type__c
            )
                    ){
                System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside CONDITION 1 --> ');
                opportunityIdsToContactIdMapExpansion.put(opp.Id, opp.Salesforce_lead_pass_contact__c);
            }

            /******************************************************************************************************************************************
             * ORG 62 Lead Pass:
             * IF Org62 Lead Pass Add-On Review is TRUE AND Type = Add-On Business AND Add On Type = New Project AND SFDC LeadPass contact is not Null
             * then:
             * 1. Set contact status to Qualified (follow details on deck)
            ******************************************************************************************************************************************/
            if(opp.Org62_Lead_Pass_Add_On_Review__c == true && ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type) && opp.Add_On_Type__c == 'New Project'
                    && !String.isblank(opp.Salesforce_lead_pass_contact__c)
                    && (opp.Org62_Lead_Pass_Add_On_Review__c  != oldMap.get(opp.id).Org62_Lead_Pass_Add_On_Review__c
                    || opp.Type  != oldMap.get(opp.id).Type
                    || opp.Add_On_Type__c  != oldMap.get(opp.id).Add_On_Type__c
            )
                    ){
                System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside CONDITION 2 --> ');
                opportunityIdsToContactIdMapNewProject.put(opp.Id, opp.Salesforce_lead_pass_contact__c);
            }

        }

        //validate new business and add on opportunities have primary contact role
        validateOpportunityHasPrimaryContactRoleANdSync(newMap, oldMap);
        //ORG 62 Lead Pass: Create Opportunity Contact Role
        if (oppIdsToContactIdMap != null && !oppIdsToContactIdMap.isEmpty()) {
            createOpportunityContactRole(oppIdsToContactIdMap);
        }
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> opportunityIdsToContactIdMapExpansion . --> '+opportunityIdsToContactIdMapExpansion);
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> opportunityIdsToContactIdMapNewProject . --> '+opportunityIdsToContactIdMapNewProject);

        if(opportunityIdsToContactIdMapExpansion != null && !opportunityIdsToContactIdMapExpansion.isEmpty()) {
            //Set Contact Status(Status__c) = 'Unqualified';
            updateContactStatus(opportunityIdsToContactIdMapExpansion, 'Expansion');
            //Remove the Salesforce Lead Pass contact from opportunity
            removeSalesforceLeadPassContact(opportunityIdsToContactIdMapExpansion, newMap);
        }

        if(opportunityIdsToContactIdMapNewProject != null && !opportunityIdsToContactIdMapNewProject.isEmpty()) {
            //Set Contact Status(Status__c) = 'Qualified';
            updateContactStatus(opportunityIdsToContactIdMapNewProject,'New Project');
        }

        //Add Error message on opportunity record
        if(mapOppToErrorMessage.size() > 0)
        {
            for(String oppId : mapOppToErrorMessage.keyset())
            {
                Opportunity opp = newMap.get(oppId);
                String errorMessage = '';
                Integer i = 1;
                for(String err : mapOppToErrorMessage.get(oppId))
                {
                    errorMessage += (errorMessage == '' ?  '' : '<br/>') + '  ' + i + ':-' + err;
                    i++;
                }
                opp.addError(errorMessage,false);
            }
        }

		/*
        // Added by Rashmi @Perficient 1/23/2017
        Set<Id> oppIds = new Set<Id>();
        for( Opportunity opp : newMap.values() ){
            Opportunity oldOpp = oldMap.get( opp.Id );
            system.debug(opp.StageName );
            if( opp.StageName != oldOpp.StageName && opp.StageName == ConstantDeclarations.OPP_STAGE_10_PERCENT ){
                oppIds.add( opp.Id );
            }
        }
        if( !oppIds.isEmpty() && !System.isFuture() ){
            updateOpportunityStage( newMap, oppIds );
        }
		*/
    }

    //Set Contact Status(Status__c) = 'Unqualified';
    private void updateContactStatus(Map<Id, Id> opptyIdToContactId, String addOnType){
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside updateContactStatus --> opptyIdToContactId . --> '+opptyIdToContactId);
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside updateContactStatus --> addOnType . --> '+addOnType);

        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact c : [SELECT Id, status__c FROM Contact WHERE Id IN :opptyIdToContactId.values()]){
            if(addOnType == 'Expansion') {
                c.Status__c = 'Unqualified';
                c.Unqualified_Reason__c = 'Determined during review to be add-on expand deal (SF lead pass only)';
                c.Unqualified_Explanation_SF_Lead_Pass__c = 'Identified as add-on expand opportunity during review.';
            } else if(addOnType == 'New Project'){
                c.Status__c = 'Qualified';
                c.Unqualified_Reason__c = null;
                c.Unqualified_Explanation_SF_Lead_Pass__c = null;
            }
            contactsToUpdate.add(c);
        }

        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> contactsToUpdate --> '+contactsToUpdate);
        if(contactsToUpdate.size() > 0){
            CMsTriggerRunCounter.skipOppTrigger = true;
            CMsTriggerRunCounter.skipContactTrigger = true;
            update contactsToUpdate;
        }
    }

    //Remove the Salesforce Lead Pass contact from opportunity
    private void removeSalesforceLeadPassContact(Map<Id, Id> opptyIdToContactId, Map<Id,Opportunity> newMap){
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside removeSalesforceLeadPassContact --> opptyIdToContactId . --> '+opptyIdToContactId);
        for (Opportunity opp : newMap.values()) {
            if(opptyIdToContactId.containsKey(opp.Id)){
                System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> Inside removeSalesforceLeadPassContact --> LOOP . --> ');
                opp.Salesforce_lead_pass_contact__c = null;
            }
        }
    }

    /**
     * Create Order
     */
    public void processOppCreateOrder(Set<Id> closedOpps)
    {
        list <CHANNEL_ORDERS__Service_Order__c> orders = new list<CHANNEL_ORDERS__Service_Order__c>();
        list <CHANNEL_ORDERS__Service_Order_Detail__c> orderDetailList= new list<CHANNEL_ORDERS__Service_Order_Detail__c>();

        Map<string, List<OpportunityLineItem>> orderToOppLineitems = new Map<string, List<OpportunityLineItem>>();
        list<Opportunity> oppToProcess=[SELECT Id, Name,Intacct_Message__c,Account.Name,Account.BillingStreet,Account.BillingCity,
                Account.BillingCountry,Account.BillingState,Account.BillingPostalCode,Account.Won_Opportunity_Count__c,
        (SELECT Quantity, UnitPrice, TotalPrice,PricebookEntry.Product2.ProductCode,
                PricebookEntry.Name, PricebookEntry.Product2.Family,PricebookEntry.Product2.Name
        FROM OpportunityLineItems)
        FROM Opportunity WHERE Id = :closedOpps];
        system.debug('***oppToProcess'+oppToProcess);
        for(Opportunity opp : oppToProcess)
        {
            CHANNEL_ORDERS__Service_Order__c so=new CHANNEL_ORDERS__Service_Order__c();
            so.CHANNEL_ORDERS__Customer_Org_ID__c=opp.Intacct_Message__c == null ? '' : opp.Intacct_Message__c;
            so.CHANNEL_ORDERS__Customer_Name__c=opp.Account.Name == null ? '' : opp.Account.Name;
            so.CHANNEL_ORDERS__Customer_Billing_Street__c=opp.Account.BillingStreet == null ? '' : opp.Account.BillingStreet;
            so.CHANNEL_ORDERS__Customer_Billing_City__c=opp.Account.BillingCity == null ? '' : opp.Account.BillingCity;
            so.CHANNEL_ORDERS__Customer_Billing_Country__c=opp.Account.BillingCountry == null ? '' : opp.Account.BillingCountry;
            so.CHANNEL_ORDERS__Customer_Billing_State__c=opp.Account.BillingState == null ? '' : opp.Account.BillingState;
            so.CHANNEL_ORDERS__Customer_Billing_Zip_Postal_Code__c=opp.Account.BillingPostalCode == null ? '' : opp.Account.BillingPostalCode;
            so.CHANNEL_ORDERS__Order_Type__c=opp.Account.Won_Opportunity_Count__c > 0 ? 'Add-On':'Initial';
            so.CHANNEL_ORDERS__Related_Opportunity__c=opp.id;
            so.CHANNEL_ORDERS__Date_Partner_Received_Customer_Order__c=date.today();
            so.CHANNEL_ORDERS__Service_Start_Date__c=date.today();
            so.CHANNEL_ORDERS__Partner_Contract_Rules__c=label.Partner_Contract_Rules;
            if(!opp.OpportunityLineItems.isEmpty()){
                string key=opp.id+opp.Intacct_Message__c;
                system.debug('***Key'+key);
                orderToOppLineitems.put(key,opp.OpportunityLineItems);
            }
            orders.add(so);
        }

        if(!orders.isEmpty()){
            try {
                system.debug('***orders'+orders);
                insert orders;
            } catch (system.Dmlexception e) {
                system.debug (e);
            }
        }

        for(CHANNEL_ORDERS__Service_Order__c so: orders){
            string key=so.CHANNEL_ORDERS__Related_Opportunity__c+so.CHANNEL_ORDERS__Customer_Org_ID__c;
            system.debug('SOLINEITEMS***Key'+key);
            system.debug('SOLINEITEMS***'+(orderToOppLineitems.containskey(key) && orderToOppLineitems.get(key) != null));

            if(orderToOppLineitems.containskey(key) && orderToOppLineitems.get(key) != null){
                for(OpportunityLineItem oli : orderToOppLineitems.get(key)){
                    CHANNEL_ORDERS__Service_Order_Detail__c sod= new CHANNEL_ORDERS__Service_Order_Detail__c();
                    sod.CHANNEL_ORDERS__Product_Line_Description__c=oli.PricebookEntry.Product2.ProductCode;
                    sod.CHANNEL_ORDERS__Quantity__c=1;
                    sod.CHANNEL_ORDERS__Customer_Price_Per_Month__c=oli.PricebookEntry.Product2.ProductCode.containsIgnoreCase('DLIOPro')?
                            99: 299;
                    sod.CHANNEL_ORDERS__Partner_Order__c=so.id;
                    sod.CHANNEL_ORDERS__Product_Line_Description__c='ISVForce for '+oli.PricebookEntry.Product2.Name;
                    sod.CHANNEL_ORDERS__Product_Name__c=label.ISVForceForDataloader;
                    orderDetailList.add(sod);
                }

            }
        }

        if(!orderDetailList.isEmpty()){
            try {
                system.debug('***orderDetailList'+orderDetailList);
                insert orderDetailList;
            } catch (system.Dmlexception e) {
                system.debug (e);
            }
        }
    }

    /**
     * Method to add error messages to map
     */
    private void addErrorMessage(String oppId, String message)
    {
        if(mapOppToErrorMessage.containsKey(oppId))
        {
            mapOppToErrorMessage.get(oppId).add(message);
        }
        else
        {
            mapOppToErrorMessage.put(oppId,new List<String>{message});
        }
    }

    /**
     * Validate if Opp have Mule ESB product or Cloudhub product
     */
    /*
    private Set<Id> getMuleESBOppIds(Set<Id> updatedOppIds)
    {
        oppIdsWithMuleSoft = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem lineItem: [Select opportunityId, PricebookEntry.Product2.Name From OpportunityLineItem
        where (PricebookEntry.Product2.Name like '%Mule ESB%' or
        PricebookEntry.Product2.Name like '%cloudhub%') AND opportunityId IN :updatedOppIds])
        {
            oppIds.add(lineItem.OpportunityId);
            if(lineItem.PricebookEntry.Product2.Name.toLowerCase().contains('mule esb'))
            {
                oppIdsWithMuleSoft.add(lineItem.opportunityId);
            }
        }

        return oppIds;
    }
    */
    /**
     * Create Win reports for Approved opportunities
     */
    public void createWonReport(List<Opportunity> lisWonOpps)
    {
        Map<Id,Opportunity> mapOpportunities = getWonLostOpportunities(lisWonOpps);
        List<Win_Report__c> wonReports = new List<Win_Report__c>();

        for(Opportunity opp : lisWonOpps)
        {
            Win_Report__c wr= new Win_Report__c();
            //To get fields of child record and parent object
            Opportunity oppObj = mapOpportunities.get(opp.id);
            //Opp fields
            wr.Opportunity__c = opp.Id;
            wr.Account__c = opp.AccountId;
            wr.Sales_Cycle_Start__c = opp.Sales_Accepted_Lead_Date__c;
            wr.Sales_Cycle_End__c = date.newinstance(opp.CloseDate.year(), opp.CloseDate.month(), opp.CloseDate.day());
            wr.Products_Deployed__c = opp.What_products_are_they_evaluating__c;
            //wr.What_is_the_use_case_s__c = opp.What_is_the_use_case_s__c;
            wr.Compelling_Event__c= opp.Compelling_Event__c;
            wr.Competition__c = opp.Who_is_the_competition__c;
            wr.Existing_technology__c= opp.Existing_ESB_other_technology__c;
            wr.Primary_Solution_Interest__c = opp.Primary_Solution_Interest__c;
            wr.What_business_problem_are_they_solving__c = opp.What_business_problem_are_they_solving__c;
            wr.What_business_impact_and_ROI__c=opp.Opp_Business_Impact_ROI__c;
            wr.Win_Report_Complete_2__c= 'No';
            wr.Unique_Key__c = opp.id;
            //Account field
            wr.Name = oppObj.Account.Name;
            wr.Company_Description__c = oppObj.Account.Company_Description__c;
            //wr.Number_Of_Employees__c = oppObj.Account.NumberOfEmployees;
            //OpportunityLineItem products
            for(OpportunityLineItem lineItem : oppObj.OpportunityLineItems)
            {
                wr.Products_and_Subscription_Level__c= (wr.Products_and_Subscription_Level__c == null ?
                        ''  : wr.Products_and_Subscription_Level__c +  '\n')
                        + lineItem.PricebookEntry.Product2.Name;
            }
            //Connectors fields
            for(Extension_Opportunity__c conn : oppObj.Opportunity_Extensions__r)
            {
                if(conn.Extension_Name__c != null)
                {
                    wr.End_point__c = (wr.End_point__c == null     ?   ''  :  wr.End_point__c + '\n')
                            + conn.Extension_Name__c;
                }
            }
            //Partners fields
            String pInfluence;
            for(Partner_Influence__c partner : oppObj.Opp_Partner_Influence__r)
            {
                pInfluence = getValue(partner.Partner_Name__c) + ';' + getValue(partner.Partner_Type__c) + ';' +
                        getValue(partner.Partner_Involvement__c) ;
                wr.Partner_Influence__c += (wr.Partner_Influence__c == null     ?   ''  :  wr.Partner_Influence__c +  '\n' ) +  pInfluence;
            }
            //Contact Roles
            for(OpportunityContactRole oppcontact : oppObj.OpportunityContactRoles)
            {
                String buyer = getValue(oppcontact.contact.FirstName) + ' ' + getValue(oppcontact.contact.LastName) + ' : '
                        + getValue(oppcontact.contact.title) ;
                wr.Buyer_Name_Role__c = (wr.Buyer_Name_Role__c == null     ?   ''  :  wr.Buyer_Name_Role__c +  '\n' ) +  buyer;
            }
            //Team Members
            for(OpportunityTeamMember oppTeam : oppObj.OpportunityTeamMembers)
            {
                String member = getValue(oppTeam.User.FirstName) + ' ' + getValue(oppTeam.User.LastName) + ' : ' + getValue(oppTeam.TeamMemberRole);
                wr.Opportunity_Team__c = (wr.Opportunity_Team__c == null   ?   ''  :  wr.Opportunity_Team__c +  '\n' ) +  member;
            }
            wr.Opportunity_Team__c = oppObj.Owner.Name + ': Account Executive' +'\n' +wr.Opportunity_Team__c;

            //Added by Shuba
            //wr.Opportunity_Team__c =   + ' : ' + 'Account Executive\n' +  wr.Opportunity_Team__c;


            wonReports.add(wr);
        }
        if(wonReports.size() > 0)
        {
            upsert wonReports Unique_Key__c;
        }
    }

    String getValue(String val)
    {
        return val == null ? '' : val;
    }

    /**
     * Create lost reports for Lost opportunities
     */
    public void createLossReport(List<Opportunity> listLostOpps)
    {
        Map<Id,Opportunity> mapOpportunities = getWonLostOpportunities(listLostOpps);
        List<Loss_Report__c> lostReports = new List<Loss_Report__c>();

        for(Opportunity opp : listLostOpps)
        {
            Loss_Report__c lr= new Loss_Report__c();
            //To get fields of child record and parent object
            Opportunity oppObj = mapOpportunities.get(opp.id);
            //Opp fields
            lr.Opportunity__c = opp.Id;
            lr.Account__c = opp.AccountId;
            lr.Sales_Cycle_Start__c = opp.Sales_Accepted_Lead_Date__c;
            lr.Sales_Cycle_End__c = date.newinstance(opp.CloseDate.year(), opp.CloseDate.month(), opp.CloseDate.day());
            lr.Products_Deployed__c = opp.What_products_are_they_evaluating__c;
            //lr.What_is_the_use_case_s__c = opp.What_is_the_use_case_s__c;
            lr.Compelling_Event__c= opp.Compelling_Event__c;
            lr.Competition__c = opp.Who_is_the_competition__c;
            lr.Existing_technology__c= opp.Existing_ESB_other_technology__c;
            lr.Primary_Solution_Interest__c = opp.Primary_Solution_Interest__c;
            lr.What_business_problem_are_they_solving__c = opp.What_business_problem_are_they_solving__c;
            lr.What_business_impact_and_ROI__c=opp.Opp_Business_Impact_ROI__c;
            lr.Unique_Key__c = opp.id;
            //Account Fields
            lr.Name = oppObj.Account.Name;
            lr.Company_Description__c = oppObj.Account.Company_Description__c;
            //lr.Number_Of_Employees__c = oppObj.Account.NumberOfEmployees;


            //OpportunityLineItem products
            for(OpportunityLineItem lineItem : oppObj.OpportunityLineItems)
            {
                lr.Products_and_Subscription_Level__c = (lr.Products_and_Subscription_Level__c == null ?
                        ''  : lr.Products_and_Subscription_Level__c +  '\n')
                        + lineItem.PricebookEntry.Product2.Name;
            }

            //Connectors fields
            for(Extension_Opportunity__c conn : oppObj.Opportunity_Extensions__r)
            {
                if(conn.Extension_Name__c != null)
                {
                    lr.End_point__c = (lr.End_point__c == null     ?   ''  : lr.End_point__c +  '\n')
                            + conn.Extension_Name__c;
                }
            }
            //Partners fields
            String pInfluence;
            for(Partner_Influence__c partner : oppObj.Opp_Partner_Influence__r)
            {
                pInfluence = getValue(partner.Partner_Name__c) + ';' + getValue(partner.Partner_Type__c) + ';' +
                        getValue(partner.Partner_Involvement__c) ;
                lr.Partner_Influence__c += (lr.Partner_Influence__c == null     ?   ''  :  lr.Partner_Influence__c + '\n' ) +  pInfluence;
            }
            //Contact Roles
            for(OpportunityContactRole oppcontact : oppObj.OpportunityContactRoles)
            {
                String buyer = getValue(oppcontact.contact.FirstName) + ' ' + getValue(oppcontact.contact.LastName) + ' : ' +
                        getValue(oppcontact.contact.title) ;
                lr.Buyer_Name_Role__c = (lr.Buyer_Name_Role__c == null     ?   ''  :  lr.Buyer_Name_Role__c + '\n' ) +  buyer;
            }
            //Team Members
            for(OpportunityTeamMember oppTeam : oppObj.OpportunityTeamMembers)
            {
                String member = getValue(oppTeam.User.FirstName) + ' ' + getValue(oppTeam.User.LastName) + ' : ' +
                        getValue(oppTeam.TeamMemberRole);
                lr.Opportunity_Team__c = (lr.Opportunity_Team__c == null   ?   ''  :  lr.Opportunity_Team__c + '\n' ) +  member;
            }
            lr.Opportunity_Team__c = oppObj.Owner.Name  + ' : Account Executive' +'\n' +lr.Opportunity_Team__c;
            //Added by Shuba
            //lr.Opportunity_Team__c =   + ' : ' + 'Account Executive\n' +  lr.Opportunity_Team__c;




            lostReports.add(lr);
        }
        if(lostReports.size() > 0)
        {
            upsert lostReports Unique_Key__c;
        }

    }

    /**
     * Fetch Opportunity records with child records for Won/Lost report
     */
    private Map<Id,Opportunity> getWonLostOpportunities(List<Opportunity> opps)
    {
        return new Map<Id,Opportunity>(
        [Select
                Id, AccountId, Account.Name, Account.Company_Description__c, Account.NumberOfEmployees, Account.Industry,Owner.Name
                ,( Select
                Name, Id, Extension_Name__c, Opportunity__c
        From
                Opportunity_Extensions__r
        Where   Extension_Name__c <> null
        ),(
                SELECT
                        Id, PricebookEntry.Product2.Name
                FROM
                        OpportunityLineItems
        ),(
                SELECT
                        Name, Id, Partner_Name__c, Partner_Type__c, Partner_Involvement__c, Opportunity__c
                FROM
                        Opp_Partner_Influence__r
        ), (
                SELECT
                        Contact.FirstName, Contact.LastName, Contact.Title, opportunityId
                FROM
                        OpportunityContactRoles
                WHERE
                        role='Financial Decision Maker'
        ), (
                SELECT
                        User.FirstName, User.LastName, TeamMemberRole, OpportunityId
                FROM
                        OpportunityTeamMembers
        ), (
                SELECT
                        Why_should_they_do_it_with_Mulesoft__c, Opportunity__c
                FROM
                        Opportunity_Plan__r
        )
        From
                Opportunity
        Where
                Id in :opps]
        );
    }

    /**
     * Get record type information based on record Type name
     * Static method is created to avoid Round-trip calls
     */
    static Map<String,RecordType> recordTypeMap;
    public static RecordType getRecordTypeId(String recordTypeName)
    {
        if(recordTypeMap == null)
        {
            recordTypeMap = new Map<String,RecordType>();
            for(RecordType rt :  [SELECT id, DeveloperName,Name,SobjectType FROM RecordType WHERE SobjectType = 'Opportunity'])
            {
                recordTypeMap.put(rt.Name, rt);
            }
        }
        return recordTypeMap.get(recordTypeName);
    }

    /**
     * Method to return a set containing opportunity Ids for opportunities that have an active approval process
     */
    /*
    private static Set<Id> getOpportunitiesWithActiveApprovals(Map<Id, Opportunity> opportunityMap)
    {
        Set<Id> activeApprovalSet = new Set<Id>();
        List<ProcessInstance> existingApprovals = new List<ProcessInstance>();
        existingApprovals = [select TargetObjectId from ProcessInstance where TargetObjectId in: opportunityMap.keySet() and
        (Status != 'Rejected' and Status != 'Approved' and Status != 'Removed')];

        for(ProcessInstance p : existingApprovals)
        {
            activeApprovalSet.add(p.TargetObjectId);
        }

        return activeApprovalSet;
    }
    */
    /*
        Method to validate Mutal close paln activity for update the opportunity
        adde by - Narasimha(Perficient) 01/09/2015
    */

    public void OpptyMutalClosePlanActivityValidation(map<Id,Opportunity> opptyOldMap,map<Id,Opportunity> opptyNewMap){
        /*
        List<User> uObjList = [select Id,Validation_Override__c from User where Id =:UserInfo.getUserId()];
        if(uObjList.size()>0 && uObjList[0].Validation_Override__c == false){
            //only validate Mutal close plan validation based on User record Validation_Override checkbox
            set<Id> opptyIdValidateMutualClsPlan = new set<Id>();
            map<Id,Integer> opptyActivityCount = new map<Id,Integer>();
            for(Opportunity oppty:opptyNewMap.values()){
                if(String.isNotBlank(oppty.Type) && oppty.Probability >= 50 && (oppty.Type.containsIgnoreCase('New Business') ||
oppty.Type.containsIgnoreCase('Add-On Business')) && oppty.ACV__c>=100000 )
                {
                    opptyIdValidateMutualClsPlan.add(oppty.id);
                }
            }
            if(!opptyIdValidateMutualClsPlan.isEmpty()){
                list<AggregateResult> aggreagateTaskCount = [select whatId, Count(id) cnt from Task
where WhatId IN:opptyIdValidateMutualClsPlan and RecordType.DeveloperName='Mutual_Close_Plan' group by WhatId];
                for(AggregateResult agr:aggreagateTaskCount){
                    Id opptyId=(id)agr.get('whatId');
                    Integer iCount  = (Integer)agr.get('cnt');
                    opptyActivityCount.put(opptyId,iCount);
                }
                for(Id opptyvalidateId:opptyIdValidateMutualClsPlan){
                    if(!opptyActivityCount.containsKey(opptyvalidateId)){
                        opptyNewMap.get(opptyvalidateId).addError(System.Label.Mutual_Close_Plan_validation_Error);
                    }
                }
            }
        } */
    }

    public static void setStageTracking(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap, Boolean isInsert){
        System.debug('****** setStageTracking called: ');
        System.debug('****** newMap: ' + newMap);
        System.debug('****** oldMap: ' + oldMap);
        System.debug('******  isInsert: ' + isInsert);
        map<Id,Opportunity> opptymap = new map<Id,Opportunity>();
        for(Id oId : newMap.keySet())
        {
            if(String.isNotBlank(newMap.get(oId).type)){
                if(newMap.get(oId).type.equalsIgnoreCase(ConstantDeclarations.OPP_TYPE_NEW_BUSINESS) ||
                        newMap.get(oId).type.equalsIgnoreCase(ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS)){
                    if(isInsert){
                        if(String.isNotBlank(newMap.get(oId).StageName)){
                            opptymap.put(oId,newMap.get(oId));
                        }
                    }else{
                        //if(!ConstantDeclarations.isStageTrackingpartExecuted && String.isNotBlank(newMap.get(oId).StageName) && (newMap.get(oId).StageName != oldMap.get(oId).StageName)){
                        if(oppWithSTageTrackingProcessPerformed.contains(oId) == false && String.isNotBlank(newMap.get(oId).StageName) && (newMap.get(oId).StageName != oldMap.get(oId).StageName)){
                            opptymap.put(oId,newMap.get(oId));
                            oppWithSTageTrackingProcessPerformed.add(oId);
                        }
                    }
                }
            }

        }
        if(!opptymap.isEmpty()){
            upsertStageTracking(opptymap,oldMap);
        }
        //ConstantDeclarations.isStageTrackingpartExecuted=true;
    }

    private static void upsertStageTracking(Map<Id, Opportunity> opportunityMap,Map<Id,Opportunity> oldMap)
    {
        System.debug('******  upsertStageTracking callaed');
        System.debug('******  opportunityMap: ' + opportunityMap);
        System.debug('******  oldMap: ' + oldMap);

        map<Id,list<Stage_Tracking__c>> stageTrackingMap = new map<Id,list<Stage_Tracking__c>>();
        map<String,Decimal> probabilityStageNameMap  = new map<String,Decimal>();

        map<Decimal,String> osOrderMap = new map<Decimal,String>();
        map<String,Decimal> osStringMap = new map<String,Decimal>();

        set<String> oppStage =new set<String>();
        list<Stage_Tracking__c> upsertStageTrackingList = new list<Stage_Tracking__c>();
        for(Stage_Tracking__c st: [SELECT Id,Opportunity__c,Stage__c,From_Stage__C
        FROM Stage_Tracking__c
        WHERE Opportunity__c IN:opportunityMap.values() AND Ending_date__c = NULL ]){
            if(stageTrackingMap.containsKey(st.Opportunity__c)){
                stageTrackingMap.get(st.Opportunity__c).add(st);
            }else{
                stageTrackingMap.put(st.Opportunity__c,new List<Stage_Tracking__c>{st});
            }
        }

        for (OpportunityStage oppStageProb : [Select MasterLabel, DefaultProbability From OpportunityStage]){
            probabilityStageNameMap.put(oppStageProb.MasterLabel, oppStageProb.DefaultProbability);
        }

        for(OpportunityStageOrder__c os : OpportunityStageOrder__c.getAll().values()){
            osOrderMap.put(os.order__c,os.name);
            osStringMap.put(os.name,os.order__c);
        }

        for(Opportunity opp : opportunityMap.values())
        {
            String previousStageName = oldMap != null ? oldMap.get(opp.id).StageName : null;
            System.debug('******  previousStageName: ' + previousStageName);

            if(oldMap != null && (opp.StageName !=  ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED) && osStringMap.containskey(oldMap.get(opp.id).StageName) && osStringMap.containskey(opp.StageName)){
                decimal oldStage=osStringMap.get(oldMap.get(opp.id).StageName);
                decimal newStage=osStringMap.get(opp.StageName);
                if(newStage- oldStage > 1){
                    for (decimal i = oldStage +1; i < newStage; i++) {
                        if(osOrderMap.containsKey(i)){
                            if(osOrderMap.get(i) != null){
                                system.debug(i + ' : '+osOrderMap.get(i));
                                Stage_Tracking__c sst= new Stage_Tracking__c();
                                upsertStageTrackingList.add(formStageTrackingRec(sst,opp,false,true,osOrderMap.get(i),probabilityStageNameMap, previousStageName));
                            }
                        }

                    }
                }
            }

            Stage_Tracking__c st= new Stage_Tracking__c();
            oppStage.clear();
            oppStage =new set<String>();
            if(stageTrackingMap.containsKey(opp.Id)){
                if(!stageTrackingMap.get(opp.Id).isEmpty()){
                    for(Stage_Tracking__c stc : stageTrackingMap.get(opp.Id)){
                        if(oldMap != null && oldMap.get(opp.id).StageName.equalsIgnoreCase(stc.Stage__c)){
                            Stage_Tracking__c ost= new Stage_Tracking__c(id=stc.id);
                            upsertStageTrackingList.add(formStageTrackingRec(ost,opp,false,false,null,probabilityStageNameMap, stc.From_Stage__c));
                        }
                        oppStage.add(stc.Stage__c);
                    }
                    if(!oppStage.contains(opp.StageName)){
                        st= new Stage_Tracking__c();
                        upsertStageTrackingList.add(formStageTrackingRec(st,opp,true,false,null,probabilityStageNameMap, previousStageName));
                    }
                }
            }else{
                st= new Stage_Tracking__c();
                upsertStageTrackingList.add(formStageTrackingRec(st,opp,true,false,null,probabilityStageNameMap, previousStageName));
            }
        }

        if(!upsertStageTrackingList.isEmpty()) {
            try {
                upsert upsertStageTrackingList;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }

    }

    public static Stage_Tracking__c formStageTrackingRec(Stage_Tracking__c ost,Opportunity opp,boolean IsInsert,boolean IsSkipped,
            string skippedStage,map<String,Decimal> probabilityStageNameMap, String fromStage){
        System.debug('******  previousStageName: ' + fromStage);
        ost.From_Stage__c = fromStage;
        if(IsInsert && !IsSkipped){
            ost.Opportunity__c=opp.Id;
            ost.Stage__c=opp.StageName;
            ost.Probability__c=opp.Probability;
            ost.Starting_Amount__c=opp.amount;
            ost.Starting_date__c=system.now();
            ost.Starting_Subscription_Amount__c=opp.Subscription_Amount__c;
            ost.Starting_New_and_Add_On_ACV__c=opp.ACV__c;
            ost.Starting_Close_Date__c=opp.CloseDate;
            if(opp.StageName.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_ID_BUSINESS_INITIATIVE) ||
                    opp.StageName.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_EDUCATE_ON_MULESOFT_VISION) ||
                    opp.StageName.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_CONFIRM_NEED_AND_IMPACT) ||
                    opp.StageName.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED)){
                if(String.isNotBlank(opp.Lead_Passed_By__c)){
                    if(String.isNotBlank(opp.Lead_Passed_By_Group__c)){
                        if(opp.Lead_Passed_By_Group__c.containsIgnoreCase('ADR')){
                            ost.SAL_Audited__c=true;
                            ost.Lead_Passed_By__c=opp.Lead_Passed_By__c;
                        }
                    }
                }
            }
        }else if((!IsInsert) || (IsSkipped)){
            ost.Ending_Amount__c=opp.amount;
            ost.Ending_date__c=system.now();
            ost.Ending_Subscription_Amount__c=opp.Subscription_Amount__c;
            ost.Ending_New_and_Add_On_ACV__c=opp.ACV__c;
            ost.Ending_Close_Date__c=opp.CloseDate;
            if(IsSkipped){
                ost.Opportunity__c=opp.Id;
                ost.Stage__c=skippedStage;
                if(probabilityStageNameMap.containsKey(skippedStage)){
                    ost.Probability__c = probabilityStageNameMap.get(skippedStage);
                }
                ost.Starting_Amount__c=opp.amount;
                ost.Starting_date__c=system.now();
                ost.Starting_Subscription_Amount__c=opp.Subscription_Amount__c;
                ost.Starting_New_and_Add_On_ACV__c=opp.ACV__c;
                ost.Starting_Close_Date__c=opp.CloseDate;
                if(skippedStage.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_ID_BUSINESS_INITIATIVE) ||
                        skippedStage.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_EDUCATE_ON_MULESOFT_VISION) ||
                        skippedStage.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_CONFIRM_NEED_AND_IMPACT) ||
                        skippedStage.equalsIgnoreCase(ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED)){
                    if(String.isNotBlank(opp.Lead_Passed_By__c)){
                        if(String.isNotBlank(opp.Lead_Passed_By_Group__c)){
                            if(opp.Lead_Passed_By_Group__c.containsIgnoreCase('ADR')){
                                ost.SAL_Audited__c=true;
                                ost.Lead_Passed_By__c=opp.Lead_Passed_By__c;
                            }
                        }
                    }
                }
            }
        }

        return ost;
    }

    private static void updateOpportunityConnectors(Map<Id,Opportunity> opportunityMap){
        List<Extension_Opportunity__c> connectors = [Select id, ExpectedRevenue__c, BookedRevenue__c, LostRevenue__c, Status__c, Opportunity__c
        from Extension_Opportunity__c where Opportunity__c in: opportunityMap.keySet()];
        for(Extension_Opportunity__c connector : connectors)
        {

            Opportunity opp =  opportunityMap.get(connector.Opportunity__c);
            connector.ExpectedRevenue__c = 0;
            connector.BookedRevenue__c = 0;
            connector.LostRevenue__c = 0;

            if (opp.isClosed == true && opp.isWon == true){
                connector.Status__c = 'Won';
                connector.BookedRevenue__c = opp.Amount;
            }
            else if (opp.isClosed == true && opp.isWon == false) {
                connector.Status__c = 'Lost';
                connector.LostRevenue__c = opp.Amount;
            }
            else if (opp.isClosed == false) {
                connector.Status__c = 'In Progress';
                connector.ExpectedRevenue__c = opp.ExpectedRevenue;
            }
        }
        if(!connectors.isEmpty()){
            update connectors;
        }
    }

    private static void CopyFieldsFromOrigToRenewalOpp(List<Opportunity> renewalOpps, List<Id> relevantContractIds){
        if (!relevantContractIds.isEmpty() && !renewalOpps.isEmpty()){

            List<Contract> origContracts = [SELECT Id, EndDate, SBQQ__Opportunity__c FROM Contract WHERE Id IN: relevantContractIds];
            Map<Id,Contract> contractMap = new Map<Id,Contract>();
            Map<Id,Id> contractToOrigOppMap = new Map<Id,Id>();
            for(Contract c : origContracts){
                contractMap.put(c.Id,c);
                contractToOrigOppMap.put(c.Id,c.SBQQ__Opportunity__c);
            }

            List<Opportunity> origOpps = [SELECT Id,Sales_Channel__c,Opportunity_Source__c,Billing_Contact_Email__c,Primary_Solution_Interest__c,
                    Payment_Terms__c,Reference_PO__c,Intacct_Message__c,Parent_Opportunity__c,
                    Foreign_Currency__c,Foreign_Currency_Exchange_Rate__c,Shipping_Address_Override__c,Billing_Address_Override__c,
                    ContractEndDate__c,Renewal_Contact__c,Auto_Renew__c,Renewal_Pricing_Restrictions__c,
                    Renewal_Special_Terms__c,Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Push_to_Intacct__c
            FROM Opportunity WHERE Id IN: contractToOrigOppMap.values()];
            System.debug(origOpps.size());
            Map<Id,Opportunity> origOppMap = new Map<Id,Opportunity>();
            for(Opportunity o: origOpps){
                origOppMap.put(o.Id,o);
            }

            for(Opportunity renewalOpp: renewalOpps){
                Opportunity origOpp = origOppMap.get(contractToOrigOppMap.get(renewalOpp.SBQQ__RenewedContract__c));
                Contract origContract = contractMap.get(renewalOpp.SBQQ__RenewedContract__c);
                if (origContract != NULL && origOpp != NULL){
                    if (origContract.EndDate != NULL){
                        renewalOpp.CloseDate = origContract.EndDate;
                    }
                    renewalOpp.forecast__c = 'Likely';
                    renewalOpp.Sales_Channel__c = origOpp.Sales_Channel__c;
                    renewalOpp.Opportunity_Source__c = origOpp.Opportunity_Source__c;
                    renewalOpp.Foreign_Currency__c = origOpp.Foreign_Currency__c;
                    renewalOpp.Renewal_Contact__c = origOpp.Renewal_Contact__c;
                }
            }
        }
    }

    private static void copyPartnerDetialsForNewRenewalOpportunities(List<Opportunity> opps){
        Set<Id> contractIds = new Set<Id>();

        for(Opportunity opp: opps){
            if(opp.SBQQ__RenewedContract__c != null && ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type)){
                contractIds.add(opp.SBQQ__RenewedContract__c);
            }
        }

        if(!contractIds.isEmpty()){
            Map<Id,Id> contractToOpportunityMap = new Map<Id,Id>();
            for(Contract c: [Select Id, SBQQ__Quote__c, SBQQ__Quote__r.SBQQ__Opportunity2__c
            from Contract
            where Id in:contractIds and SBQQ__Quote__c != null ]){
                if(c.SBQQ__Quote__r.SBQQ__Opportunity2__c != null){
                    contractToOpportunityMap.put(c.Id, c.SBQQ__Quote__r.SBQQ__Opportunity2__c);
                }
            }

            if(!contractToOpportunityMap.isEmpty()){
                Map<Id,List<Partner_Influence__c>> opportunityPartnerInfluenceMap = new Map<Id,List<Partner_Influence__c>> ();

                Set<String> fieldsToClone = new Set<String>();
                //fieldsToClone.add('Id');
                for(Schema.FieldSetMember fld :SObjectType.Partner_Influence__c.FieldSets.Fields_for_Clone_in_Renewal_Opportunity.getFields()) {
                    fieldsToClone.add(fld.getFieldPath());
                }
                if(!fieldsToClone.isEmpty()){
                    List<Id> originalOpportunityIds = contractToOpportunityMap.values();
                    List<String> fieldsToCloneList = new List<String>();
                    fieldsToCloneList.addAll(fieldsToClone);
                    String partnerDetailQuery = 'Select ' + String.join(fieldsToCloneList, ',') + ' from Partner_Influence__c where Opportunity__c in: originalOpportunityIds';
                    for(Partner_Influence__c pi: Database.Query(partnerDetailQuery)){
                        if(opportunityPartnerInfluenceMap.get(pi.Opportunity__c) == null){
                            opportunityPartnerInfluenceMap.put(pi.Opportunity__c, new List<Partner_Influence__c>());
                        }
                        opportunityPartnerInfluenceMap.get(pi.Opportunity__c).add(pi);
                    }
                }

                List<Partner_Influence__c> partnerInfluenceToCreate = new List<Partner_Influence__c>();
                for(Opportunity opp: opps){
                    if(opp.SBQQ__RenewedContract__c != null && ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type)){
                        if(contractToOpportunityMap.get(opp.SBQQ__RenewedContract__c) != null){
                            Id parrentOpportunityId = contractToOpportunityMap.get(opp.SBQQ__RenewedContract__c);
                            if(opportunityPartnerInfluenceMap.get(parrentOpportunityId) != null){
                                for(Partner_Influence__c pi: opportunityPartnerInfluenceMap.get(parrentOpportunityId)){
                                    Partner_Influence__c clonedPi = pi.clone(false,true);
                                    clonedPi.Opportunity__c = opp.Id;
                                    partnerInfluenceToCreate.add(clonedPi);
                                }
                            }
                        }
                    }
                }

                if(!partnerInfluenceToCreate.isEmpty()){
                    insert partnerInfluenceToCreate;
                }
            }
        }

    }

    private void migrateScActions(Map<Id, Id> oldOppToNewOpp) {
        System.debug(LoggingLevel.ERROR, 'Inside migrateScActions --> oldOppToNewOpp --> '+oldOppToNewOpp);
        //Check if SC Action exists on the old opp?
        Set<Id> oldOppIds = oldOppToNewOpp.keySet();
        String ScActionSOQL = Utils.getCreatableFieldsSOQL('SC_Action__c', 'Opportunity__c IN :oldOppIds');
        System.debug(LoggingLevel.ERROR, 'ScActionSOQL --> '+ScActionSOQL);
        List<SC_Action__c> scActions = (List<SC_Action__c>)Database.query(ScActionSOQL);
        System.debug(LoggingLevel.ERROR, 'scActions --> '+scActions);
        if(scActions.size() > 0 ) {
            Map<id,List<SC_Action__c>> oldOppIdScActionMap=new Map<id,List<SC_Action__c>>();
            for(SC_Action__c sca: scActions){
                if(oldOppIdScActionMap.containskey(sca.Opportunity__c)){
                    oldOppIdScActionMap.get(sca.Opportunity__c).add(sca);
                } else{
                    List<SC_Action__c> scaList=new List<SC_Action__c>();
                    scaList.add(sca);
                    oldOppIdScActionMap.put(sca.Opportunity__c,scaList);
                }
            }
            System.debug(LoggingLevel.ERROR, 'oldOppIdScActionMap --> '+oldOppIdScActionMap);
            List<SC_Action__c> copiedScAction = new List<SC_Action__c>();
            for(Id oldOppId : oldOppIdScActionMap.keySet()) {
                //Migrate the SC Actions to the surviving Opportunity
                for (SC_Action__c sca : oldOppIdScActionMap.get(oldOppId)) {
                    sca.Opportunity__c = oldOppToNewOpp.get(oldOppId);
                    copiedScAction.add(sca);
                }
            }
            System.debug(LoggingLevel.ERROR, 'copiedScAction --> '+copiedScAction);
            if (copiedScAction.size() > 0) {
                update copiedScAction;

            }
        }

    }
    //ORG 62 Lead Pass: Create Opportunity Contact Role
    //Whenever Salesforce_lead_pass_contact__c lookup is changed --> Create OCR
    //The Default value for role is "Mobilizer"
    //Please note: If user is trying to add the same contact, code will ignore it
    private void createOpportunityContactRole(Map<Id, Id> oppIdToContactId){
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> oppIdToContactId --> '+oppIdToContactId);
        Map<Id, Id> oppIdToContactIdMap = new Map<Id, Id>();
        List<OpportunityContactRole> ocrToInsert = new List<OpportunityContactRole>();
        System.debug(LoggingLevel.ERROR, '######### --> Trigger.oldMap --> '+Trigger.oldMap);
        List<OpportunityContactRole> existingOCRs = [SELECT Id, ContactId, OpportunityId
        FROM OpportunityContactRole
        WHERE ContactId IN :oppIdToContactId.values()];
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> existingOCRs --> ' + existingOCRs);
        for (OpportunityContactRole oc : existingOCRs) {
            oppIdToContactIdMap.put(oc.OpportunityId, oc.ContactId);
        }
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> oppIdToContactIdMap --> ' + oppIdToContactIdMap);
        for (Id oppId : oppIdToContactId.keySet()) {
            if (oppIdToContactId.get(oppId) != oppIdToContactIdMap.get(oppId)) {
                OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = oppId, ContactId = oppIdToContactId.get(oppId), Role = 'Mobilizer');
                ocrToInsert.add(ocr);
            }
        }
        System.debug(LoggingLevel.ERROR, '$$$$$$$$$$$$$ .  ---> ocrToInsert --> '+ocrToInsert);
        if(ocrToInsert.size() > 0){
            CMsTriggerRunCounter.skipOppTrigger = true;
            insert ocrToInsert;
        }
    }

    private void validateOpportunityHasPrimaryContactRoleANdSync(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap){
        DateTime validationCutOfTime = DateTime.now().addMinutes(minutesToWaitBeforeValidatingOpportunityPrimaryCotactRole * -1);
        Set<Id> newBusinessANdAddOnOpportunities = new Set<Id>();

        for(Opportunity opp: newMap.values()){
            if(ConstantDeclarations.OPP_TYPE_NEW_BUSINESS.equalsIgnoreCase(opp.Type) || ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type)){
                newBusinessANdAddOnOpportunities.add(opp.Id);
            }
        }

        if(newBusinessANdAddOnOpportunities.isEmpty()){
            return;
        }

        //get primary contact roles
        Set<Id> oppIdsForContactRoleQuery = new Set<Id>();
        for(Id oppId: newBusinessANdAddOnOpportunities){
            if(opportunityContactRoleMap.get(oppId) == null){
                oppIdsForContactRoleQuery.add(oppId);
                opportunityContactRoleMap.put(oppId, new List<OpportunityContactRole>());
            }
        }

        if(!oppIdsForContactRoleQuery.isEmpty()){

            for(OpportunityContactRole oppConRole: [Select OpportunityId, Contact.LeadSource, Contact.Lead_Source_Detail__c,
                    Contact.Lead_Source_Asset__c, Contact.Username__c, IsPrimary
            from OpportunityContactRole
            where OpportunityId in:oppIdsForContactRoleQuery]){
                opportunityContactRoleMap.get(oppConRole.OpportunityId).add(oppConRole);

                if(oppConRole.IsPrimary){
                    //update opportunity fields based on primary contact fields
                    Opportunity oppInContext = newMap.get(oppConRole.OpportunityId);
                    if(oppInContext.LeadSource == null){
                        oppInContext.LeadSource = oppConRole.Contact.LeadSource;
                    }
                    if(oppInContext.Lead_Source_Detail__c == null){
                        oppInContext.Lead_Source_Detail__c = oppConRole.Contact.Lead_Source_Detail__c;
                    }
                    if(oppInContext.Lead_Source_Asset__c == null){
                        oppInContext.Lead_Source_Asset__c = oppConRole.Contact.Lead_Source_Asset__c;
                    }
                }
            }
        }

        //update opportunity contact role counts
        for(Opportunity opp: newMap.values()){
            if(newBusinessANdAddOnOpportunities.contains(opp.Id)){
                opp.Opportunity_Contact_Roles__c = opportunityContactRoleMap.get(opp.Id).size();
            }
        }

        //flag opportunities which do not have contact roles and were created before the validation cutoff time if user does not have validation override
        if(!Utilities.currentUser.Validation_Override__c){
            for(Opportunity opp: newMap.values()){
                if(newBusinessANdAddOnOpportunities.contains(opp.Id) && opp.CreatedDate < validationCutOfTime ){
                    boolean hasPrimaryContact = false;
                    if(opportunityContactRoleMap.get(opp.Id) != null){
                        for(OpportunityContactRole oppConRole: opportunityContactRoleMap.get(opp.Id)){
                            if(oppConRole.isPrimary){
                                hasPrimaryContact = true;
                                break;
                            }
                        }
                    }
                    if(!hasPrimaryContact){
                        addErrorMessage(opp.Id, Label.Opportunity_Missing_Primary_Contact_Role_Error_Msg);
                    }
                }
            }
        }
    }

    private static void setForecastCategoryBasedOnCustomForecast(List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            if(opp.forecast__c != null && OpportunitySettings.forecastCategoryMap.get(opp.forecast__c.toUpperCase()) != null &&
                    (ConstantDeclarations.OPP_TYPE_NEW_BUSINESS.equalsIgnoreCase(opp.Type) ||
                            ConstantDeclarations.OPP_TYPE_ADD_ON_BUSINESS.equalsIgnoreCase(opp.Type) ||
                            ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(opp.Type))){
                opp.ForecastCategoryName = OpportunitySettings.forecastCategoryMap.get(opp.forecast__c.toUpperCase()) ;
            }
        }
    }

    private void updateOpportunityLineItemServiceDate(List<Opportunity> oppLIst){

        CMsTriggerRunCounter.bypassOpportunityInClosingEditValidation = true;
        //get opportunity line items
        List<OpportunityLineItem> lineItems = [Select Id , OpportunityId from OpportunityLineItem where OpportunityId in: oppList];

        if(!lineItems.isEmpty()){
            //prepare opportunity close date map
            Map<Id,Date> opportunityCloseDateMap = new Map<Id,Date>();
            for(Opportunity opp: oppLIst){
                opportunityCloseDateMap.put(opp.Id, opp.CloseDate);
            }

            for(OpportunityLineItem oli: lineItems){
                oli.ServiceDate = opportunityCloseDateMap.get(oli.OpportunityId);
            }

            update lineItems;
        }
    }

    public void afterDelete(List<Opportunity> oldOpp){
        for (Opportunity opp : oldOpp) {
            if(opp.Parent_Opportunity__c  != null){
                parentIds.add(opp.Parent_Opportunity__c );
            }
        }

        if(parentIds.size() > 0){
            updateChildrenCount(parentIds);
        }

    }

    private static void updateAccountBusinessInitiatives(List<Opportunity> closedWonOpportunities){
        Map<Id,Set<String>> accountBizObjectivesMap = new Map<Id,Set<String>>();
        Map<Id,Set<String>> accountSupportedInitiativesMap = new Map<Id,Set<String>>();
        string picklistValuesSeparator = ';';
        for(Opportunity closedOpp: closedWonOpportunities){
            if(closedOpp.AccountId != null){
                if(closedOpp.What_are_biz_objectives_of_initiative__c != null){
                    List<String> bizObjectives = closedOpp.What_are_biz_objectives_of_initiative__c.split(picklistValuesSeparator);
                    if(!accountBizObjectivesMap.containsKey(closedOpp.AccountId)){
                        accountBizObjectivesMap.put(closedOpp.AccountId, new Set<String>());
                    }
                    accountBizObjectivesMap.get(closedOpp.AccountId).addAll(bizObjectives);
                }
                if(closedOpp.What_initiatives_will_we_support__c != null){
                    List<string> supportedInitiatives = closedOpp.What_initiatives_will_we_support__c.split(picklistValuesSeparator);
                    if(!accountSupportedInitiativesMap.containsKey(closedOpp.AccountId)){
                        accountSupportedInitiativesMap.put(closedOpp.AccountId, new Set<String>());
                    }
                    accountSupportedInitiativesMap.get(closedOpp.AccountId).addAll(supportedInitiatives);
                }
            }
        }

        if(!accountBizObjectivesMap.isEmpty() || !accountSupportedInitiativesMap.isEmpty()){
            Set<Id> allAccountIds = new Set<Id>();
            allAccountIds.addall(accountBizObjectivesMap.keySet());
            allAccountIds.addall(accountSupportedInitiativesMap.keySet());

            List<Account> accountList = [Select Id, Customer_Initiative__c,What_are_biz_objectives_of_initiative__c
            from Account where Id in:allAccountIds];

            for(Account a: accountList){
                if(accountBizObjectivesMap.containskey(a.Id)){
                    if(a.What_are_biz_objectives_of_initiative__c != null){
                        accountBizObjectivesMap.get(a.Id).addAll(a.What_are_biz_objectives_of_initiative__c.split(picklistValuesSeparator));
                    }
                    List<string> allObjectiveValues = new List<string>(accountBizObjectivesMap.get(a.Id));
                    a.What_are_biz_objectives_of_initiative__c = String.join(allObjectiveValues, picklistValuesSeparator);
                }
                if(accountSupportedInitiativesMap.containskey(a.Id)){
                    if(a.Customer_Initiative__c != null){
                        accountSupportedInitiativesMap.get(a.Id).addAll(a.Customer_Initiative__c.split(picklistValuesSeparator));
                    }
                    List<string> allInitiatives = new List<string>(accountSupportedInitiativesMap.get(a.Id));
                    a.Customer_Initiative__c = String.join(allInitiatives, picklistValuesSeparator);
                }
            }
            update accountList;
        }

    }

}