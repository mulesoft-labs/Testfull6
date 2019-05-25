/***
* Class: CMsBookingController
* Description: This is Controller class for Booking Automation
* 4 pages uses this controller are
* b) PMsBookingStep1.page
* b) PMsBookingStep2.page
* d) PMsBookingStep3.page
* e) PMsBookingStep4.page

*	All the navigation logic is build in this class
*	Logic to create child opportunities based on what user enter in PMsBookingStep1
*	It also clones Partner details, Quotes and All Opportunity products for each child opportunity
*	Logic to update the Opportunity/Quote fields based on what user modify in PMsBookingStep2
*	Logic to show the opportunity team members and clone only the opportunity team members that user selects in the PMsBookingStep3
*	Logic to show the fields on the “Review Screen” : PMsBookingStep4
*
*
* Author: Sid Sah
* Created on: 01/11/2018
*/

/**********************************************************************
*
*   Date            Author                 Change
*   01/10/2018      Sid Sah                Initial Creation
*
*********************************************************************/
public class CMsBookingController {

    public Id parentOppId;
    public Opportunity opportunity {get; set;}
    public List<wrapperOppTeamMember> OpportunityTeamMemberList {get; set;}
    public List<Opportunity> ChildOppsAll {get; set;}
    public List<Opportunity> childOppsFiltered {get; set;}
    public Id opportunityInClosingRenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_LABEL).getRecordTypeId();
    public Id opportunityInClosingNAORecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_LABEL).getRecordTypeId();    
    public List<Opportunity> oppToInsert = new List<Opportunity>();

    public CMsBookingController(ApexPages.StandardController stdController) {
        if(parentOppId == null){
            parentOppId =  ApexPages.currentPage().getParameters().get('parentOppId');
        }
        opportunity = [SELECT Name, Parent_Opportunity__c, Num_of_Child_Opps__c, Mulesoft_ACV__c, Booking_Wizard__c   FROM Opportunity WHERE id = :parentOppId];
        childOppsAll = [SELECT name, CloseDate, stagename,Type, Booking_Wizard__c, Add_On_Type__c , Total_Subscription_List__c,
                Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Parent_Opportunity__c,Num_of_Child_Opps__c,
                SBQQ__PrimaryQuote__r.SBQQ__StartDate__c, SBQQ__PrimaryQuote__r.SBQQ__EndDate__c,Mulesoft_ACV__c, Future_Dated_Order__c 
        FROM Opportunity
        WHERE Parent_Opportunity__c=:parentOppId];

        childOppsFiltered = [SELECT name, CloseDate, stagename,Type, Booking_Wizard__c, Add_On_Type__c , Total_Subscription_List__c,
                Multi_Year_Deal__c,If_yes_Year_X_of_Total_Years__c,Parent_Opportunity__c,Num_of_Child_Opps__c,
                SBQQ__PrimaryQuote__r.SBQQ__StartDate__c, SBQQ__PrimaryQuote__r.SBQQ__EndDate__c,Mulesoft_ACV__c, Future_Dated_Order__c 
        FROM Opportunity
        WHERE Parent_Opportunity__c=:parentOppId AND Booking_Wizard__c = true];
    }

    //This method uses a simple SOQL query to return a List of OpportunityTeamMembers
    public List<wrapperOppTeamMember> getOpportunityTeamMembers() {
        if(OpportunityTeamMemberList == null) {
            OpportunityTeamMemberList = new List<wrapperOppTeamMember>();
            for(OpportunityTeamMember o: [SELECT OpportunityId, UserId, Name, Title, TeamMemberRole, OpportunityAccessLevel
            FROM OpportunityTeamMember
            WHERE OpportunityId =:parentOppId]) {
                // As each OpportunityTeamMember is processed we create a new wrapperOppTeamMember object and add it to the OpportunityTeamMemberList
                OpportunityTeamMemberList.add(new wrapperOppTeamMember(o));
            }
        }
        return OpportunityTeamMemberList;
    }

    //Inner class for Opportunity Team Member selection page
    public class wrapperOppTeamMember {
        public OpportunityTeamMember otm {get; set;}
        public Boolean selected {get; set;}

        // This is the contructor method. When we create a new wrapperOppTeamMember object we pass a OpportunityTeamMember that is set to the otm property.
        // We also set the selected value to false
        public wrapperOppTeamMember(OpportunityTeamMember o) {
            otm = o;
            selected = false;
        }
    }

    /**********************************************************************
    ************ Start : Navigation Control Methods               *********
    ***********************************************************************/
    public PageReference step1() {
        return Page.PMsBookingStep1;
    }

    public PageReference step2() {
        if(opportunity.Num_of_Child_Opps__c <= 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a valid number of Opportunity'));
            return null;
        }

        if(opportunity.Num_of_Child_Opps__c > 5){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You cannot create more than 5 child opportunities'));
            return null;
        }

        if(opportunity.Num_of_Child_Opps__c > 0){
            ///Create Child Opportunities
            createChildOpportunities(opportunity, opportunity.Num_of_Child_Opps__c);
        }
        PageReference step2 = new PageReference('/apex/PMsBookingStep2?parentOppId=' + parentOppId);
        step2.setRedirect(true);
        return step2;
    }

    public PageReference step3() {
        //Update Child opportunities
        try{
            updateChildOpportunities();
        }catch(DMLException  ex){
            System.debug(LoggingLevel.ERROR,'ex ---------------------------> '+ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
            return null;
        }
        return null;
    }

    public PageReference goToStep3() {
        //Update Child opportunities when user click on "Next" button on Page 2
        try{
            updateChildOpportunities();
        }catch(DMLException  ex){
            System.debug(LoggingLevel.ERROR,'ex ---------------------------> '+ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
            return null;
        }
        PageReference step3 = new PageReference('/apex/PMsBookingStep3?parentOppId=' + parentOppId);
        step3.setRedirect(true);
        return step3;
    }

    public PageReference backToStep2() {
        PageReference step2 = new PageReference('/apex/PMsBookingStep2?parentOppId=' + parentOppId);
        step2.setRedirect(true);
        return step2;
    }

    public PageReference backToStep3() {
        PageReference step3 = new PageReference('/apex/PMsBookingStep3?parentOppId=' + parentOppId);
        step3.setRedirect(true);
        return step3;
    }

    public PageReference step4() {
        //We create a new list of OpportunityTeamMembers that we be populated only with OpportunityTeamMembers if they are selected
        List<Id> selectedOpportunityTeamMembersIds = new List<Id>();

        //We will cycle through our list of wrapperOppTeamMembers and will check to see if the selected property is set to true,
        //if it is we add the OpportunityTeamMember Id to the selectedOpportunityTeamMembersIds list
        for(wrapperOppTeamMember wOtm: getOpportunityTeamMembers()) {
            if(wOtm.selected == true) {
                selectedOpportunityTeamMembersIds.add(wOtm.otm.Id);
            }
        }
        //Clone the Opp Team Member and set the OppId field to be the Children Opp Id.
        copyOppTeamMember(selectedOpportunityTeamMembersIds);
        updateChildOppFlag();
        //return null;//Stay on the same page
        PageReference step4 = new PageReference('/apex/PMsBookingStep4?parentOppId=' + parentOppId);
        step4.setRedirect(true);
        return step4;
    }
    /*
    public PageReference nextPage() {
        PageReference next = new PageReference('/apex/PMsBookingStep4?parentOppId=' + parentOppId);
        next.setRedirect(true);
        return next;
    }
    */
    // This method cancels the wizard, and returns the user to the
    // Parent Opportunity
    public PageReference cancel() {
        PageReference parentOppPage = new PageReference('/' + parentOppId );
        parentOppPage.setRedirect(true);
        return parentOppPage;
    }
    /**********************************************************************
    ************ End : Navigation Control Methods               ***********
    ***********************************************************************/


    /**********************************************************************
    This method:
    1) Clone Child Opportunity
    2  Clone Opportunity Products
    3) Clone opportunity Contact Role(Only Primary)
    4) Clone Partner Details
    5) Clone Primary Quote
    6) Clone Quote Lines
    ***********************************************************************/
    public void createChildOpportunities(Opportunity parentOpp, Decimal numOfOpp){
        List<Id> oppIdsToPassToFutureMethod = new List<Id>();
        //Clone Opportunities except the Type field
        CMsTriggerRunCounter.skipOppTeamMemberCopy = true;
        List<Opportunity> newChildOpps = createChildOpp(parentOpp, numOfOpp);
        CMsTriggerRunCounter.skipOppTeamMemberCopy = false;
        for(Opportunity opp : newChildOpps){
            oppIdsToPassToFutureMethod.add(opp.Id);
        }
        //Clone Opportunity Primary Contact Role
        CloneOpportunityPrimaryContactRole(numOfOpp, oppIdsToPassToFutureMethod, parentOpp.Id);

        System.debug('1 ------->> Total Number of SOQL queries that have been issued.: ' +  Limits.getQueries());
        System.debug('1 ------->> Total Number of SOQL Queries that can be issued: ' +  Limits.getLimitQueries());

        //Clone All Partner details related list
        cloneAllPartners(numOfOpp, oppIdsToPassToFutureMethod, parentOpp.Id);
        System.debug('2 ------->> Total Number of SOQL queries that have been issued.: ' +  Limits.getQueries());
        System.debug('2 ------->> Total Number of SOQL Queries that can be issued: ' +  Limits.getLimitQueries());

        //Clone Quote that is marked as Primary
        ClonePrimaryQuote(numOfOpp);

        System.debug('3 ------->> Total Number of SOQL queries that have been issued.: ' +  Limits.getQueries());
        System.debug('3 ------->> Total Number of SOQL Queries that can be issued: ' +  Limits.getLimitQueries());
    }


    public List<Opportunity> createChildOpp(Opportunity parentOpp, Decimal numOfOpp){
        String soql = Utils.getCreatableFieldsSOQL('Opportunity','id=\''+parentOpp.Id+'\'');
        Opportunity opportunity = (Opportunity)Database.query(soql);
        for(Integer i=1; i <= numOfOpp; i++ ){
            Opportunity opp = opportunity.clone(false, false);
            opp.Name = parentOpp.Name +' '+i;
            opp.Parent_Opportunity__c = parentOpp.Id;
            opp.Booking_Wizard__c = true;
            List<Schema.FieldSetMember> fieldsNotCopiedInChildOpps = Schema.SObjectType.Opportunity.fieldSets.getMap().get('Fields_Not_Copied_Booking_Wizard').getFields();
            for (Schema.FieldSetMember f : fieldsNotCopiedInChildOpps) {
                System.debug(LoggingLevel.ERROR, 'f ----->>>> '+ f);
                if(f.getType() == Schema.DisplayType.Boolean) {
                    opp.put(f.fieldPath, false);
                } else {
                    opp.put(f.fieldPath, null);
                }
            }
            oppToInsert.add(opp);
        }
        if(oppToInsert.size() > 0) {
            //Put Try-Catch
            insert oppToInsert;
        }
        //Child Opps got created. Lets update the Role to "Account Executive"
        List<OpportunityTeamMember> OppTeamMembersToUpdate = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> ChildOppTeamMembers = [SELECT TeamMemberRole, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN :oppToInsert];
        system.debug(LoggingLevel.ERROR, 'ChildOppTeamMembers --> '+ChildOppTeamMembers);

        for(OpportunityTeamMember childOtm : ChildOppTeamMembers){
            childOtm.TeamMemberRole = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_ACCOUNT_EXE;
            OppTeamMembersToUpdate.add(childOtm);
        }
        upsert OppTeamMembersToUpdate;
        return oppToInsert;
    }

    @future
    public static void CloneOpportunityPrimaryContactRole(Decimal numOfOpp, List<Id> oppIds, Id parentOppId){
        //------ Cloning the Primary Contact Roles----------
        String crSOQL = Utils.getCreatableFieldsSOQL('OpportunityContactRole', 'OpportunityId = :parentOppId AND isPrimary = true');

        List<OpportunityContactRole> ocrList = (List<OpportunityContactRole>)Database.query(crSOQL);
        List<OpportunityContactRole> relatedContactRoles = new List<OpportunityContactRole>();
        if(ocrList.size() > 0){
            for(integer i = 0; i < numOfOpp; i++){
                OpportunityContactRole newCR = ocrList[0].clone(false);
                newCR.OpportunityId = oppIds[i];
                relatedContactRoles.add(newCR);
            }
        }
        if(relatedContactRoles.size() > 0) {
            insert relatedContactRoles;
        }
    }

    @future
    public static void cloneAllPartners(Decimal numOfOpp,List<Id> oppIds, Id parentOppId){
        String piSOQL = Utils.getCreatableFieldsSOQL('Partner_Influence__c', 'Opportunity__c = :parentOppId');
        List<Partner_Influence__c> pis = (List<Partner_Influence__c>)Database.query(piSOQL);
        List<Partner_Influence__c> relatedPi = new List<Partner_Influence__c>();
        for(Partner_Influence__c p : pis){
            for(integer i = 0; i < numOfOpp; i++){
                Partner_Influence__c newpi = p.clone(false);
                newpi.Opportunity__c = oppIds[i];
                relatedPi.add(newpi);
            }
        }
        system.debug(LoggingLevel.ERROR, 'Inside cloneAllPartners --> relatedPi --> '+relatedPi);
        if(relatedPi.size() > 0) {
	        CMsTriggerRunCounter.skipPartnerInfleunceTrigger = true;
            insert relatedPi;
			CMsTriggerRunCounter.skipPartnerInfleunceTrigger = false;            
        }
    }

    public void ClonePrimaryQuote(Decimal numOfOpp){
        List<String> excludedFieldsList = new List<String>();
        excludedFieldsList.add('SBQQ__ChangeVersion__c');
        excludedFieldsList.add('SBQQ__PreviousChangeQuote__c');

        //------Cloning the Primary Quote ----------
        String quoteSOQL = Utils.getCreatableFieldsSOQL('sbqq__quote__c', 'sbqq__opportunity2__c = :parentOppId AND sbqq__Primary__c  = true',excludedFieldsList);
        List<sbqq__quote__c> quoteList = (List<sbqq__quote__c>)Database.query(quoteSOQL);
        List<sbqq__quote__c> relatedPrimaryQuote = new List<sbqq__quote__c>();
        if(quoteList.size() > 0){
            for(integer i = 0; i < numOfOpp; i++){
                sbqq__quote__c newCR = quoteList[0].clone(false);
                newCR.SBQQ__Opportunity2__c = oppToInsert[i].Id;
                relatedPrimaryQuote.add(newCR);
            }
            if(relatedPrimaryQuote.size() > 0) {
                insert relatedPrimaryQuote;
            }
            CloneQuoteLineItems(quoteList[0].Id, numOfOpp, relatedPrimaryQuote);
        }
    }

    public void CloneQuoteLineItems(Id quoteId, Decimal numOfOpp, List<sbqq__quote__c> relatedPrimaryQuote){
        List<String> excludedFieldsList = new List<String>{'SBQQ__RequiredBy__c','SBQQ__CompletelyContracted__c'};
        String quoteItemSOQL = Utils.getCreatableFieldsSOQL('SBQQ__QuoteLine__c', 'SBQQ__Quote__c = :quoteId',excludedFieldsList);

        List<SBQQ__QuoteLine__c> quoteItemList = (List<SBQQ__QuoteLine__c>)Database.query(quoteItemSOQL);
        List<SBQQ__QuoteLine__c> relatedQi = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c q : quoteItemList){
            for(integer i = 0; i < numOfOpp; i++){
                SBQQ__QuoteLine__c newqi = q.clone(false);
                newqi.SBQQ__Quote__c = relatedPrimaryQuote[i].Id;
                newqi.SBQQ__Product__c = q.SBQQ__Product__c;
                relatedQi.add(newqi);
            }
        }
        if(relatedQi.size() > 0) {
            insert relatedQi;
        }
    }

    public void updateChildOppFlag(){
        List<Opportunity> oppToUpdateFlag = new List<Opportunity>();
        for(Opportunity childOpty : childOppsFiltered) {
            childOpty.Booking_Wizard__c = false;
            oppToUpdateFlag.add(childOpty);
        }
        if(oppToUpdateFlag.size() > 0){
            CMsTriggerRunCounter.skipOppTrigger = true;
            update oppToUpdateFlag;
            CMsTriggerRunCounter.skipOppTrigger = false;
        }
    }

    public void updateChildOpportunities(){
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();
        for(Opportunity childOpty : childOppsAll) {
            System.debug(LoggingLevel.ERROR, 'Child Oppty name: '+ childOpty.Name + '  childOpty.Type --> '+ childOpty.Type);
			if(ConstantDeclarations.OPP_TYPE_RENEWAL.equalsIgnoreCase(childOpty.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR.equalsIgnoreCase(childOpty.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_MULTI_YEAR_ANNUAL_PAY.equalsIgnoreCase(childOpty.Type)
                        || ConstantDeclarations.OPP_TYPE_RENEWAL_CONTRA_BOOKING.equalsIgnoreCase(childOpty.Type)){
            	childOpty.RecordTypeID = opportunityInClosingRenewalRecordTypeId;
             }else {
                childOpty.RecordTypeID = opportunityInClosingNAORecordTypeId;
             }
             oppToUpdate.add(childOpty);
            if(childOpty.SBQQ__PrimaryQuote__c != null){
                quotesToUpdate.add(childOpty.SBQQ__PrimaryQuote__r);
            }
        }
        if(oppToUpdate.size() > 0){
            update oppToUpdate;
        }
        if(quotesToUpdate.size() > 0){
            update quotesToUpdate;
        }
    }

    public void copyOppTeamMember(List<Id> otmIds){
        String otmSOQL = Utils.getCreatableFieldsSOQL('OpportunityTeamMember', 'Id = :otmIds');

        List<OpportunityTeamMember> otms = (List<OpportunityTeamMember>)Database.query(otmSOQL);
        List<OpportunityTeamMember> relatedOtms = new List<OpportunityTeamMember>();
        for(OpportunityTeamMember o : otms){
            for(integer i = 0; i < childOppsFiltered.size(); i++){
                OpportunityTeamMember newotm = o.clone(false);
                newotm.OpportunityId = childOppsFiltered[i].Id;
                relatedOtms.add(newotm);
            }
        }
        if(relatedOtms.size() > 0) {
            insert relatedOtms;
        }
    }

}