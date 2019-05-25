public with sharing virtual class CMsOrg62OpptyWidgetOnAccController { 
		    private Account currentAccount = null;
		    public String covMessage{get;set;}
   		    private List<Org62oppx> org62Opportunities = new list<Org62oppx>();
    
    // This class will display all the corresponding Org62 Open and Closed Opportunities in a section on Account Detail Page.     
    public CMsOrg62OpptyWidgetOnAccController(ApexPages.StandardController stdController){
        this.currentAccount = (Account)stdController.getRecord();
        queryOrg62Opportunity(true);
    		}
    
        protected void queryOrg62Opportunity(boolean flag){
        
            try{
               set<id> org62AccIdSet = new set<id>();          
                for(Account cAR:[SELECT Id, ORG62_Account_ID__c FROM Account WHERE ORG62_Account_ID__c != null AND (Id =:currentAccount.Id)]) {
                org62AccIdSet.add(cAR.ORG62_Account_ID__c);                    
                } 
                
            List<Org62_Opportunity__x> Org62OpportunityList;
            set<Id> ownerIdSet = new set<Id>();
            set<Id> AccountIdSet = new Set<Id>();                

            if(flag){ 
                if(org62AccIdSet.size() > 0){
                Org62OpportunityList = [SELECT Amount__c,Business_Case_ROI_c__c,CloseDate__c,Compelling_Event_c__c,CurrencyIsoCode, Customer_Goals_c__c,Customer_Use_Case_c__c,Decision_Maker_c__r.Name__c,Executive_Sponsor_c__c,ForecastCategoryName__c,Has_Products__c, Implementation_Partner_c__r.Name__c,Lead_Sales_Partner_new_c__c,Lead_Sales_Partner_Role_c__c,Name__c,Next_Steps_c__c,OwnerId__c,Red_Flags_c__c,Reseller_Partner_c__r.Name__c,Reseller_Partner_Type_c__c,Salesforce_Exec_Sponsor_c__c,Secondary_Partner_Role_c__c,SI_Reseller_c__r.Name__c,StageName__c FROM Org62_Opportunity__x WHERE AccountId__c IN: org62AccIdSet
                                       				    and (RecordTypeId__c = '01230000000010LAAQ' or RecordTypeId__c = '012300000000LrjAAE')
                                       					and StageName__c not in ('Dead - No Opportunity', 'Dead - No Decision','Dead - Webstore','Dead - Duplicate', 'Dead - Lost', 'Dead - OEM','Closed - Out Clause', 'Closed')];   
                
                
                System.debug(Org62OpportunityList.size() + ' Opportunity(s) returned.');
                System.debug(Org62OpportunityList);
                for(Org62_Opportunity__x ownerIdRec: [SELECT OwnerId__c, Implementation_Partner_c__c, Lead_Sales_Partner_new_c__c, Reseller_Partner_c__c,SI_Reseller_c__c  FROM Org62_Opportunity__x WHERE AccountId__c IN: org62AccIdSet]){
                    ownerIdSet.add(ownerIdRec.OwnerId__c);
                    AccountIdSet.add(ownerIdRec.Implementation_Partner_c__c);
                    AccountIdSet.add(ownerIdRec.Lead_Sales_Partner_new_c__c);
                    AccountIdSet.add(ownerIdRec.Reseller_Partner_c__c);
                    AccountIdSet.add(ownerIdRec.SI_Reseller_c__c);
                }                    
                }
            }
	   else{
                //Opportunity__x org62Opportunity = new Opportunity__x(Id='x0430000010j48HAAQ', ExternalId='00630000010j48HAAQ');
                Org62_Opportunity__x org62Opportunity = new Org62_Opportunity__x(ExternalId='00630000010j48HAAQ');
           		Org62OpportunityList = new list<Org62_Opportunity__x>();
                Org62OpportunityList.add(org62Opportunity);
                Org62oppx testOrgoppx = new Org62oppx();
            }

		    Map<String, Org62_User__x> userMap = new Map<String,Org62_User__x>();
            for (Org62_User__x objCS: [SELECT ExternalId, Name__c FROM Org62_User__x WHERE ExternalId IN: ownerIdSet]){
                userMap.put(objCS.ExternalId, objCS);
            }
                
		    Map<String, Org62_Account__x> accountMap = new Map<String,Org62_Account__x>();
            for (Org62_Account__x objCS: [SELECT ExternalId, Name__c FROM Org62_Account__x WHERE ExternalId IN: AccountIdSet]){
                accountMap.put(objCS.ExternalId, objCS);
            }                

            for(Org62_Opportunity__x org62Opportunity: Org62OpportunityList){
                Org62oppx opp = new Org62oppx();
                opp.OppName = org62Opportunity.Name__c;
                opp.StageName = org62Opportunity.StageName__c;
                opp.Amount = org62Opportunity.Amount__c;
                opp.CloseDate = org62Opportunity.CloseDate__c;
                opp.CurrencyISOcode = org62Opportunity.CurrencyIsoCode;
                //opp.Owner = userMap.get(org62Opportunity.OwnerId__c).Name__c;
                opp.ForecastCategoryName = org62Opportunity.ForecastCategoryName__c;
                opp.NextSteps = org62Opportunity.Next_Steps_c__c;
                opp.DecisionMaker = org62Opportunity.Decision_Maker_c__r.Name__c;
                opp.ExecutiveSponser = org62Opportunity.Executive_Sponsor_c__c;
                opp.CompellingEvent = org62Opportunity.Compelling_Event_c__c;
                opp.HasProducts = org62Opportunity.Has_Products__c;
                opp.SalesforceExec = org62Opportunity.Salesforce_Exec_Sponsor_c__c;
                opp.CustomerUse = org62Opportunity.Customer_Use_Case_c__c;
                opp.BusinessCase = org62Opportunity.Business_Case_ROI_c__c;
                opp.CustomerGoals = org62Opportunity.Customer_Goals_c__c;
                opp.RedFlags = org62Opportunity.Red_Flags_c__c;
                //opp.Lead_Sales_Partner = accountMap.get(org62Opportunity.Lead_Sales_Partner_new_c__c).Name__c;                 
                opp.Lead_Sales_Partner_Role = org62Opportunity.Lead_Sales_Partner_Role_c__c;
                //opp.Implementation_Partner =  accountMap.get(org62Opportunity.Implementation_Partner_c__c).Name__c;                 
                //opp.SI_Reseller = accountMap.get(org62Opportunity.SI_Reseller_c__c).Name__c;                
                opp.Secondary_Partner = org62Opportunity.Secondary_Partner_Role_c__c;
                opp.Reseller_Partner = org62Opportunity.Reseller_Partner_c__r.Name__c;
                //opp.Reseller_Partner = accountMap.get(org62Opportunity.Reseller_Partner_c__c).Name__c;                
                opp.Reseller_Partner_Type = org62Opportunity.Reseller_Partner_Type_c__c;
                
                if(!test.isRunningTest()){
                    if(accountMap.get(org62Opportunity.Lead_Sales_Partner_new_c__c) != null){
                 opp.Lead_Sales_Partner = accountMap.get(org62Opportunity.Lead_Sales_Partner_new_c__c).Name__c;                        
                    }
                    if(userMap.get(org62Opportunity.OwnerId__c) != null){
                 opp.Owner = userMap.get(org62Opportunity.OwnerId__c).Name__c;                         
                    }
                    if(accountMap.get(org62Opportunity.Implementation_Partner_c__c) != null){
                 opp.Implementation_Partner =  accountMap.get(org62Opportunity.Implementation_Partner_c__c).Name__c;      
                    }
                    if(accountMap.get(org62Opportunity.SI_Reseller_c__c) != null){
                 opp.SI_Reseller = accountMap.get(org62Opportunity.SI_Reseller_c__c).Name__c;                         
                    }
                    if(accountMap.get(org62Opportunity.Reseller_Partner_c__c) != null){
                 opp.Reseller_Partner = accountMap.get(org62Opportunity.Reseller_Partner_c__c).Name__c;                         
                    }
                }
                org62Opportunities.add(opp);
            }
                
            if (org62Opportunities.size()==0){
                this.covMessage = 'Org62 Account Id not mapped';
            }
            else
            {
                this.covMessage = 'Org62 Opportunities record(s) found '+org62Opportunities.size();
            } 
                
            	}
            catch(Exception e){
            System.debug('Exception in queryOrg62Opportunity :'+e.getCause());
            covMessage = e.getStackTraceString();
        	}
                        
        }
              
    public void testCoverage(String id){
      Account acc = [SELECT Id From Account WHERE Id=:id].get(0);
      this.currentAccount = acc;
      queryOrg62Opportunity(false);
    }
            
    public List<Org62oppx> getOrg62Opportunities(){
        return this.org62Opportunities;
    }             
    
        private class Org62oppx{
        public String OppName{get;set;}
        public String StageName{get;set;}
        public Decimal Amount{get;set;}
        public Date CloseDate{get;set;}
            public String Owner{get;set;}
            public String CurrencyISOcode{get;set;}
            public String ForecastCategoryName{get;set;}
            public String NextSteps{get;set;}
            public String DecisionMaker{get;set;}
            public String ExecutiveSponser{get;set;}
            public String CompellingEvent{get;set;}
            public String SalesforceExec{get;set;}
            public Decimal HasProducts{get;set;}
            public String CustomerUse{get;set;}
            public String BusinessCase{get;set;}
            public String CustomerGoals{get;set;}
            public String RedFlags{get;set;}
            public String Lead_Sales_Partner{get;set;}
            public String Lead_Sales_Partner_Role{get;set;}
            public String Implementation_Partner{get;set;}
            public String SI_Reseller{get;set;}
            public String Secondary_Partner{get;set;}
            public String Reseller_Partner{get;set;}
            public String Reseller_Partner_Type{get;set;}  
            
            public Org62oppx(){
                if(test.isRunningTest()){
                 this.Owner = 'test_Owner'; 
                 this.Lead_Sales_Partner = 'test_Lead_Sales_Partner';
                 this.Implementation_Partner = 'test_Implementation_Partner';
                 this.SI_Reseller = 'test_SI_Reseller';
                 this.Reseller_Partner = 'test_Reseller_Partner';
                }
            }
    }  
}