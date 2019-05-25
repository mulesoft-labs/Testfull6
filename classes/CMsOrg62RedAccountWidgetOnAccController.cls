public with sharing virtual class CMsOrg62RedAccountWidgetOnAccController { 
		    private Account currentAccount = null;
		    private String covMessage{get;set;}
   		    private List<Org62red> org62RedAccounts = new list<Org62red>();
    
    // This class will display all the corresponding Org62 Red Accounts in a section on Account Detail Page.     
    public CMsOrg62RedAccountWidgetOnAccController(ApexPages.StandardController stdController){
        this.currentAccount = (Account)stdController.getRecord();
        queryOrg62RedAccounts(true);
    		}
    protected void queryOrg62RedAccounts(boolean flag){
        
        try{
                set<id> org62AccIdSet = new set<id>();          
            for(Account cAR:[SELECT Id, ORG62_Account_ID__c FROM Account WHERE ORG62_Account_ID__c != null AND (Id =:currentAccount.Id)]){
                org62AccIdSet.add(cAR.ORG62_Account_ID__c);                
            } 
                
            List<Org62_Red_Account__x> Org62RedAccountList;
            set<Id> ownerIdSet = new set<Id>();  
            
            if(flag){
                if(org62AccIdSet.size() > 0){
 				Org62RedAccountList	=[SELECT Account_Name__r.Name__c,Account_Name__r.CSG_Coverage__c, Action_Plan__c,ACV_at_Risk__c,At_Level_3_escalated_to__r.Name__c,CFL_Region_SVP__c,CFL_Region__c,Currency__c, Days_Red__c,DisplayUrl,ECOMM_Headline__c,EOP_Sponsor__c,Escalation_Category__c,Executive_Action_Requested__c,ExternalId,Id,Issue_Owner__r.Name__c,Issue__c,Original_Issue__c,Red_Account__c,Red_Trending__c,Region__c,Stage__c FROM Org62_Red_Account__x WHERE Red_Account__c IN: org62AccIdSet];
                System.debug(Org62RedAccountList.size() + ' Red Accounts(s) returned.');
                System.debug(Org62RedAccountList);                    
                }
            }            
             else{
                Org62_Red_Account__x org62RedAccount = new Org62_Red_Account__x(ExternalId='001300000076v5SAAQ');
                Org62RedAccountList = new list<Org62_Red_Account__x>();
                Org62RedAccountList.add(org62RedAccount);
                Org62red testOrgRedx = new Org62red();
            }


            for(Org62_Red_Account__x org62RedAcc: Org62RedAccountList){
                Org62red red = new Org62red();
                red.Region = org62RedAcc.Region__c;
                red.ActionPlan = org62RedAcc.Action_Plan__c;
                red.AccName = org62RedAcc.Account_Name__r.Name__c;
                red.StageName = org62RedAcc.Stage__c;
                red.AccId = org62RedAcc.ExternalId;
                red.ACV_at_Risk = org62RedAcc.ACV_at_Risk__c;
                red.Days_Red = org62RedAcc.Days_Red__c;
                //red.Region = org62RedAcc.Region__c;
                red.CFL_Region = org62RedAcc.CFL_Region__c;
                red.CSG_Coverage = org62RedAcc.Account_Name__r.CSG_Coverage__c;
                red.CFL_Region_SVP = org62RedAcc.CFL_Region_SVP__c;
                red.CurrencyISO = org62RedAcc.Currency__c;
                red.Escalation_Category = org62RedAcc.Escalation_Category__c;
                red.Executive_Action_Requested = org62RedAcc.Executive_Action_Requested__c;
                red.Red_Trending = org62RedAcc.Red_Trending__c;
                red.Issue_Owner = org62RedAcc.Issue_Owner__r.Name__c;
                red.At_Level = org62RedAcc.At_Level_3_escalated_to__r.Name__c;
                red.EOP_Sponsor = org62RedAcc.EOP_Sponsor__c;
                red.ECOMM_Headline = org62RedAcc.ECOMM_Headline__c;
                red.Issue = org62RedAcc.Issue__c;
                red.Original_Issue = org62RedAcc.Original_Issue__c;
                org62RedAccounts.add(red);
            }  
            
            if (org62RedAccounts.size()==0){
                this.covMessage = 'Org62 Account Id not mapped';
            }
            else
            {
                this.covMessage = 'Org62 Opportunities record(s) found '+org62RedAccounts.size();
            } 
            
        }
        catch(Exception e){
            System.debug('Exception in queryOrg62RedAccounts :'+e.getCause());
            covMessage = e.getStackTraceString();
        	}   
    }
    
      public void testCoverage(String id){
      Account acc = [SELECT Id From Account WHERE Id=:id].get(0);
      this.currentAccount = acc;
      queryOrg62RedAccounts(false);
    }
            
    public List<Org62red> getorg62RedAccounts(){
        return this.org62RedAccounts;
    }
    
        private class Org62red{              
        public String AccName{get;set;}
        public String ActionPlan{get;set;}
        public String StageName{get;set;}
        public String AccId{get;set;}
        public Decimal ACV_at_Risk{get;set;}
        public String CSG_Coverage{get;set;}
        public Decimal Days_Red{get;set;}
        public String Region{get;set;}             
        public String CFL_Region{get;set;}
        public String CFL_Region_SVP{get;set;}
        public String CurrencyISO{get;set;}
        public String Escalation_Category{get;set;}
        public String Executive_Action_Requested{get;set;}
        public String Red_Trending{get;set;}
        public String Issue_Owner{get;set;}
        public String At_Level{get;set;}
        public String EOP_Sponsor{get;set;}
        public String ECOMM_Headline{get;set;}
        public String Issue{get;set;}
        public String Original_Issue{get;set;}
    } 
}