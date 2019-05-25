/*
 *@Auhor  :  Narasimha (perficient)
 *@Created:  01/21/2015
 *@Desc   : handler class for all the trigger events on Partner_Influence__c Object
 *@Revision Hist:
 *
 */

public class PartnerInfluenceTriggerHandler {
	
	public void handlerAfterInsert(List<Partner_Influence__c> newList, map<Id,Partner_Influence__c> newMapPartnerInfluence, Map<Id,Partner_Influence__c> oldMap){
		// add Account owner and opportunity Team Member
		PartnerInfluenceHelper partnerInfluenceHelperObj = new PartnerInfluenceHelper();
		partnerInfluenceHelperObj.addAccountOwnerAsOpptyTeamMember(newMapPartnerInfluence);
		populatePartnerDataOnOppForOrg62Mirroring(newList,oldMap);
        
	}
	
	public void handlerAfterUpdate( List<Partner_Influence__c> newList, Map<Id,Partner_Influence__c> oldMap ){
		map<Id,Partner_Influence__c> newMapPartnerInfluence = new map<Id,Partner_Influence__c>();
		for(Partner_Influence__c l :newList)
        {
        	if(( l.Influence__c != oldMap.get(l.id).Influence__c ) || ( l.Sourced__c  != oldMap.get(l.id).Sourced__c  )){
        		newMapPartnerInfluence.put(l.id,l);
        	}
        }
         if(!newMapPartnerInfluence.isEmpty())
        {    
            PartnerInfluenceHelper partnerInfluenceHelperObj = new PartnerInfluenceHelper();
			partnerInfluenceHelperObj.addAccountOwnerAsOpptyTeamMember(newMapPartnerInfluence);
        }
        populatePartnerDataOnOppForOrg62Mirroring(newList, oldMap);
	} 
    
    public void handlerAfterDelete(Map<Id,Partner_Influence__c> oldMap){
        populatePartnerDataOnOppForOrg62Mirroring(oldMap.values(), oldMap);
	}
    
	public void handleBeforeInsert(List<Partner_Influence__c> newPartnerInfluenceList){   
		validateUserIsAllowedToUpdateOpportunityInClosing(newPartnerInfluenceList);
        populateEndCustomerAccount(newPartnerInfluenceList);        
	}
    
	public void handleBeforeUpdate(List<Partner_Influence__c> newPartnerInfluenceList, map<Id,Partner_Influence__c> oldMapPartnerInfluence){  
		validateUserIsAllowedToUpdateOpportunityInClosing(newPartnerInfluenceList);
	}
    
	public void handleBeforeDelete(List<Partner_Influence__c> oldPartnerInfluenceList){  
		validateUserIsAllowedToUpdateOpportunityInClosing(oldPartnerInfluenceList); 
	}

    public void populateEndCustomerAccount(List<Partner_Influence__c> partnerDetails){
        Set<Id> OppIds = new Set<Id>();
        for(Partner_Influence__c p : partnerDetails){
            oppIds.add(p.Opportunity__c);
        }        
        Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>([SELECT AccountId FROM Opportunity WHERE Id =:oppIds]);

        for(Partner_Influence__c p : partnerDetails){
            p.End_Customer_Account__c = (oppIdMap.get(p.Opportunity__c)).AccountId;
        }    
    }
	
	public void populatePartnerDataOnOppForOrg62Mirroring(List<Partner_Influence__c> partnerDetails,  map<Id,Partner_Influence__c> oldMap){
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@----> INSIDE populatePartnerDataOnOppForOrg62Mirroring --> ');
        Set<Id> OppIds = new Set<Id>();
		for(Partner_Influence__c p : partnerDetails){
			oppIds.add(p.Opportunity__c);
		}
		Map<Id, Opportunity> OppMap  = new Map<Id, Opportunity>([SELECT id, Name,(SELECT Id, createddate, delivery__c, sourced__c, reseller__c, influence__c,
                                                                                  Account__r.ParentId
									   											  FROM Opp_Partner_Influence__r order by createddate asc) 
									   							 FROM Opportunity WHERE Id = :oppIds]); 
		
		List<String> characteristics = new List<String>{'Sourced', 'Influence', 'Delivery', 'Reseller'};
		Map<String, List<Partner_Influence__c>> mapCharacteristicsTrack = new Map<String, List<Partner_Influence__c>>();
        
		for (Opportunity opp : OppMap.values()){
            System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@----> opp --> '+ opp);
            for(Partner_Influence__c p : opp.Opp_Partner_Influence__r){
            	System.debug(LoggingLevel.ERROR, '-------> '+ p);
            	for(String str : characteristics){
                	if(str == 'Sourced' && p.sourced__c == true) {
						if(!mapCharacteristicsTrack.containsKey(str)){
							List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
							pList.add(p);
							mapCharacteristicsTrack.put(str, pList);
						} else if(mapCharacteristicsTrack.get(str) != null)
							mapCharacteristicsTrack.get(str).add(p);
                    }
                    
                	if(str == 'Influence' && p.influence__c == true) {
						if(!mapCharacteristicsTrack.containsKey(str)){
							List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
							pList.add(p);
							mapCharacteristicsTrack.put(str, pList);
						} else if(mapCharacteristicsTrack.get(str) != null)
							mapCharacteristicsTrack.get(str).add(p);
                    }

                	if(str == 'Delivery' && p.delivery__c == true) {
						if(!mapCharacteristicsTrack.containsKey(str)){
							List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
							pList.add(p);
							mapCharacteristicsTrack.put(str, pList);
						} else if(mapCharacteristicsTrack.get(str) != null)
							mapCharacteristicsTrack.get(str).add(p);
                    }
                	
                    if(str == 'Reseller' && p.Reseller__c == true) {
						if(!mapCharacteristicsTrack.containsKey(str)){
							List<Partner_Influence__c> pList = new List<Partner_Influence__c>();
							pList.add(p);
							mapCharacteristicsTrack.put(str, pList);
						} else if(mapCharacteristicsTrack.get(str) != null)
							mapCharacteristicsTrack.get(str).add(p);
                    }
                }
            }     		
  		}
        
        System.debug(LoggingLevel.ERROR, '@@@@@@@@@@@@@@@@@@@@@@----> mapCharacteristicsTrack --> '+ mapCharacteristicsTrack);
        for(Partner_Influence__c p : partnerDetails){
            System.debug(LoggingLevel.ERROR, '2 ---> @@@@@@@@@@@@@@@@@@@@@@----> p --> '+ p);
            Opportunity opp = OppMap.get(p.Opportunity__c);
            System.debug(LoggingLevel.ERROR, '2 ---> @@@@@@@@@@@@@@@@@@@@@@----> opp --->'+ opp);
            
            /***************************************************************************
             * START: Use Case: Sourced(Sourced__c) and influence Partners(Influence__c)
             ***************************************************************************/
            if(p.Sourced__c == true && mapCharacteristicsTrack.get('Sourced') != null) {
                //Lead/Sales Partner is "source" partner
            	if((mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId != null){
                	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId;
                } else {
                	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__c;
               	}
    	        //Lead/Sales Partner Type is "sourced lead"
    	        opp.Org62_Lead_Sales_Partner_Role__c = 'Sourced Lead';
            } 
            else if(Trigger.isDelete || (oldMap != null && p.Sourced__c == false && p.Sourced__c != oldMap.get(p.id).Sourced__c)){
                //This is only for UPDATE case: oldMap != null for UPDATE
                if(mapCharacteristicsTrack.get('Sourced') != null){
                	if((mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId != null){
                    	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__r.ParentId;
                    } else {
                        opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Sourced')[0]).Account__c;
                    }
    	        opp.Org62_Lead_Sales_Partner_Role__c = 'Sourced Lead';
                } else {
            		opp.SI_Partner_Account_1__c = null;
					opp.Org62_Lead_Sales_Partner_Role__c = null;        
                }
            } 
            
            if(p.Sourced__c == false && p.Influence__c == true && mapCharacteristicsTrack.get('Influence') != null 
               && mapCharacteristicsTrack.get('Sourced') == null) {
                // Lead / Sales Partner is *first* "influence" partner                
            	if((mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId != null){
                	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId;
                } else {
                	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__c;
               	}
    	        //Lead / Sales Partner Type is "joint sales"
    	        opp.Org62_Lead_Sales_Partner_Role__c = 'Joint Sales';
            } else if(Trigger.isDelete || (oldMap != null && p.Sourced__c == false && p.Influence__c == false)){
                //This is only for UPDATE case: oldMap != null for UPDATE
                if(mapCharacteristicsTrack.get('Influence') != null){
                	if((mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId != null){
                    	opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__r.ParentId;
                    } else {
                        opp.SI_Partner_Account_1__c = (mapCharacteristicsTrack.get('Influence')[0]).Account__c;
                    }
    	        opp.Org62_Lead_Sales_Partner_Role__c = 'Joint Sales';
                } else {
            		opp.SI_Partner_Account_1__c = null;
					opp.Org62_Lead_Sales_Partner_Role__c = null;        
                }
            }
            
            /***************************************************************************
             * END: Use Case: Implementation Partner(Delivery__C)
             ***************************************************************************/             
            
            /***************************************************************************
             * START: Use Case: Implementation Partner(Delivery__C)
             ***************************************************************************/
            if(p.Delivery__c == true && mapCharacteristicsTrack.get('Delivery') != null) {
                //Implementation Partner is the Parent Account of the *first* "delivery" partner
                //If No parent account --> then the partner account
            	if((mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId != null){
                	opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId;
                } else {
                	opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__c;
               	}
            } else if(Trigger.isDelete || (oldMap != null && p.Delivery__c == false && p.Delivery__c != oldMap.get(p.id).Delivery__c)){
                //This is only for UPDATE case: oldMap != null for UPDATE
                if(mapCharacteristicsTrack.get('Delivery') != null){
                	if((mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId != null){
                    	opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__r.ParentId;
                    } else {
                        opp.SI_Partner_Account_2__c = (mapCharacteristicsTrack.get('Delivery')[0]).Account__c;
                    }
                } else {
            		opp.SI_Partner_Account_2__c = null;
                }
            }
            /***************************************************************************
             * END: Use Case: Implementation Partner(Delivery__C)
             ***************************************************************************/
            
			/***************************************************************************
             * START: Use Case: Reseller Partner(Reseller__c)
             ***************************************************************************/
            if(p.Reseller__c == true && mapCharacteristicsTrack.get('Reseller') != null) {
                //Reseller Partner is the Parent Account of the *first* "reseller" partner
                //If no parent account --> then the partner account
            	if((mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId != null){
                	opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId;
                } else {
                	opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__c;
               	}
            } else if(Trigger.isDelete || (oldMap != null && p.Reseller__c == false && p.Reseller__c != oldMap.get(p.id).Reseller__c)){
                //This is only for UPDATE case: oldMap != null for UPDATE
                if(mapCharacteristicsTrack.get('Reseller') != null){
                	if((mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId != null){
                    	opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__r.ParentId;
                    } else {
                        opp.App_Partner_Account_1__c = (mapCharacteristicsTrack.get('Reseller')[0]).Account__c;
                    }
                } else {
            		opp.App_Partner_Account_1__c = null;
                }
            }
            /***************************************************************************
             * END: Use Case: Implementation Partner(Delivery__C)
             ***************************************************************************/            
        }
        System.debug(LoggingLevel.ERROR, '3 ---> @@@@@@@@@@@@@@@@@@@@@@----> OppMap.values() --->'+ OppMap.values());
		if(!OppMap.isEmpty()){
            CMsTriggerRunCounter.skipOppTrigger = true;            
            update OppMap.values();
        }            
    }

    public void validateUserIsAllowedToUpdateOpportunityInClosing(List<Partner_Influence__c> partnerDetails){
		if(!Utilities.canUpdateOpportuniytyInClosing()){
			for(Partner_Influence__c partnerDetail: partnerDetails){
				if(ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(partnerDetail.Opportunity_Record_Type_Developer_Name__c)
						||ConstantDeclarations.OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME.equalsIgnoreCase(partnerDetail.Opportunity_Record_Type_Developer_Name__c)){
					partnerDetail.addError(Label.Opportunity_In_Closing_UnAuthorized_Edit);
				}
			}
		}
	}
}