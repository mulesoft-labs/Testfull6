/*
 *@Auhor  :  Narasimha (perficient)
 *@Created:  01/21/2015
 *@Desc   : Helper class for PartnerInfluenceTriggerHandler class
            1. add Account Owner as Opportunity Team member with role Account executive.
 *
 *@Revision Hist:
 *
 */
public class PartnerInfluenceHelper {


     public void addAccountOwnerAsOpptyTeamMember(map<Id,Partner_Influence__c> mapPartnerInfluenceRecords){
        set<id> setAccId = new set<Id>();
        set<id> setOpptyId = new set<Id>();
        list<OpportunityTeamMember> lstOpptyTeamMem = new list<OpportunityTeamMember>();
        for(Id recid:mapPartnerInfluenceRecords.keySet()){
            Partner_Influence__c prInfluenceRec =mapPartnerInfluenceRecords.get(recid);
            if(prInfluenceRec.Opportunity__c !=null && prInfluenceRec.Account__c!=null){
                setAccId.add(prInfluenceRec.Account__c);
                setOpptyId.add(prInfluenceRec.Opportunity__c);
            }
        }
            map<Id,Account> mapAccOwner = getAccountOwnerMap(setAccId);
            map<Id,Opportunity> mapOpptyDetails = mapPartnreOpptyDetails(setOpptyId);
            for(Id recid:mapPartnerInfluenceRecords.keySet()){
                Partner_Influence__c prInfluenceRec =mapPartnerInfluenceRecords.get(recid);
                Opportunity opptyObj = mapOpptyDetails.get(prInfluenceRec.Opportunity__c);
                if((prInfluenceRec.Influence__c || prInfluenceRec.Sourced__c) && prInfluenceRec.Opportunity__c != null
                     && prInfluenceRec.Account__c!=null  && mapAccOwner.containsKey(prInfluenceRec.Account__c)){
                    OpportunityTeamMember opptymemObj = new OpportunityTeamMember(
                                                                                OpportunityId = prInfluenceRec.Opportunity__c,
                                                                                UserId = mapAccOwner.get(prInfluenceRec.Account__c).ownerId,
                                                                                TeamMemberRole = OpportunitySettings.sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR 
                                                                            );
                    lstOpptyTeamMem.add(opptymemObj);
                }
            }
            if(!lstOpptyTeamMem.isEmpty()){
                Database.insert(lstOpptyTeamMem,false);
            }
        }//end addAccountOwnerAsOpptyTeamMember
    
        public map<Id,Account> getAccountOwnerMap(set<id> accidset){
            return new Map<Id,Account>([select Id,OwnerId from Account where Id IN :accidset and Owner.isActive=true]);
            
        }
        
        public map<Id,Opportunity> mapPartnreOpptyDetails(set<Id> opptyId){
            return new map<Id,Opportunity>([select Id,Opportunity_Source__c from Opportunity where Id IN :opptyId]);
        }
}