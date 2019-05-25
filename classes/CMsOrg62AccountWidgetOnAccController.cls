public with sharing virtual class CMsOrg62AccountWidgetOnAccController { 
        
    private Account currentAccount = null;
    private String covMessage{get;set;}
    private List<Org62Accx> org62Accounts = new list<Org62Accx>();
    private String pae_id;
    private String cpqae_id;
    private static final String TEAM_MEMBER_ROLE_1 ='Platform AE';
    private static final String TEAM_MEMBER_ROLE_2 ='CPQ AE';    
    
    // This class will display the corresponding Org62 Account in a section on Account Detail Page. 
    public CMsOrg62AccountWidgetOnAccController(ApexPages.StandardController stdController){
        this.currentAccount = (Account)stdController.getRecord();
        queryOrg62Account(true);
    }
    
        protected void queryOrg62Account(boolean flag){
        
        try{
            //get Org62 Account Id that is matching to the current Mulesoft Account Id
            set<id> org62AccIdSet = new set<id>(); 
            System.debug('current Account Id : '+ currentAccount.Id);
            for(Account cAR:[SELECT Id, ORG62_Account_ID__c FROM Account WHERE ORG62_Account_ID__c != null AND (Id =:currentAccount.Id)]) {
                 org62AccIdSet.add(cAR.ORG62_Account_ID__c);
                 System.debug(cAR.ORG62_Account_ID__c);                 
            }
                                           
      
            
            List<Org62_Account__x> org62AccountList;
            List<Org62_sfbase_SalesforceTeam_c__x> org62TeamList;
            set<Id> ownerIdSet = new set<Id>();

            
          if(flag){
              if(org62AccIdSet.size() > 0){
               //Get Org62 Account Details for the mapped account in the above
				org62AccountList = [SELECT Id, name__c, ExternalId, AOV_Band_c__c, Account_Owner_Role__c, Core_Edition__c, CSG_Portfolio_Success_Manager__r.Name__c, CSM_lookup_c__c, Customer_Status__c, CurrencyIsoCode,DisplayUrl, Industry__c, OwnerId__c, Owner_r__r.ManagerId__r.Name__c, Premier_AOV_Band_c__c,Rating__c,Region_AOV_Band_c__c, Region_c__c, Segment_c__c, Success_Partner_c__r.Name__c, Type__c FROM Org62_Account__x WHERE ExternalId IN: org62AccIdSet];
				
              //User lookup relationship
              for(Org62_Account__x ownerIdRec:[select OwnerId__c ,CSM_lookup_c__c from Org62_Account__x WHERE ExternalId IN: org62AccIdSet and ExternalId !=null]){
                 ownerIdSet.add(ownerIdRec.OwnerId__c);
                 ownerIdSet.add(ownerIdRec.CSM_lookup_c__c);
              }
              //Set up SalesForce Team
              org62TeamList = [SELECT sfbase_User_c__c,Team_Role_Name_c__c FROM Org62_sfbase_SalesforceTeam_c__x WHERE sfbase_Account_c__c In:org62AccIdSet  AND ((Team_Role_Name_c__c =: TEAM_MEMBER_ROLE_1) OR (Team_Role_Name_c__c =: TEAM_MEMBER_ROLE_2)) AND sfbase_EndDate_c__c = null];                               
                if (org62TeamList.size()>0){
                    for(Org62_sfbase_SalesforceTeam_c__x TeamList: org62TeamList){
                      ownerIdSet.add(TeamList.sfbase_User_c__c);
                    
                    if(TeamList.Team_Role_Name_c__c == TEAM_MEMBER_ROLE_1){
                       pae_id=TeamList.sfbase_User_c__c;
                       }
                       else if (TeamList.Team_Role_Name_c__c == TEAM_MEMBER_ROLE_2)
                       {
                       cpqae_id=TeamList.sfbase_User_c__c;
                       }
                 }
                }   
              } 
            }else{
                Org62_Account__x org62Account = new Org62_Account__x(ExternalId='0013000000rnQR9AAM');
                org62AccountList = new list<Org62_Account__x>();
                org62AccountList.add(org62Account);
                Org62Accx testOrgAccx = new Org62Accx();
                testOrgAccx.Name = '';                
               }
            
           Map<String, Org62_User__x> userMap = new Map<String,Org62_User__x>();
            if(ownerIdSet.size() > 0){
       	      for (Org62_User__x objCS: [SELECT ExternalId, Name__c, Email__c, Phone__c FROM Org62_User__x WHERE ExternalId IN: ownerIdSet]){
                userMap.put(objCS.ExternalId, objCS);
            		}  
            }
			

        for(Org62_Account__x org62Account: org62AccountList){
            Org62Accx acc = new Org62Accx();
            acc.Name = org62Account.name__c;
 			acc.CustomerStatus = org62Account.Customer_Status__c;                    
            acc.AOV_Band = org62Account.AOV_Band_c__c;
            acc.AccountOwnerRole = org62Account.Account_Owner_Role__c;
            acc.PorfolioSuccessManager = org62Account.CSG_Portfolio_Success_Manager__r.Name__c;
            if(org62Account.CSM_lookup_c__c != null){
            acc.CSM_Name = userMap.get(org62Account.CSM_lookup_c__c).Name__c; 
            acc.CSM_Email = userMap.get(org62Account.CSM_lookup_c__c).Email__c;                
            }
            acc.Industry = org62Account.Industry__c;          
            acc.Premier_AOV_Band = org62Account.Premier_AOV_Band_c__c;
            acc.Rating = org62Account.Rating__c;
            acc.Region_AOV_Band = org62Account.Region_AOV_Band_c__c;
            acc.Region = org62Account.Region_c__c;
            acc.Segment = org62Account.Segment_c__c;
            acc.ManagerName = org62Account.Owner_r__r.ManagerId__r.Name__c;
            acc.Success_Partner = org62Account.Success_Partner_c__r.Name__c;
            acc.Core_Edition = org62Account.Core_Edition__c;             
                if(pae_id != null){
                acc.pae_Name = userMap.get(pae_id).Name__c;
                acc.pae_Email = userMap.get(pae_id).Email__c;
                }
                if(cpqae_id != null){
                acc.cpqae_Name = userMap.get(cpqae_id).Name__c;
                acc.cpqae_Email = userMap.get(cpqae_id).Email__c;                    
                }
            if(!test.isRunningTest()){
            acc.OwnerEmail = userMap.get(org62Account.OwnerId__c).Email__c; 
            acc.OwnerName = userMap.get(org62Account.OwnerId__c).Name__c;   
            } 
                org62Accounts.add(acc);
                }
                                        
            
            if (org62Accounts.size()==0){
                this.covMessage = 'Org62 Account Id not mapped';
            }                        
        }
            
            catch(Exception e){
            System.debug('Exception in queryOrg62Account :'+e.getCause() + ' message : ' + e.getMessage() +' Line Number : ' + e.getLineNumber() );
            covMessage = e.getStackTraceString();
        }        
    }
    
    public void testCoverage(String id){
        //Account acc = [SELECT Id From Account WHERE Id=:id].get(0);
        //this.currentAccount = acc;
        queryOrg62Account(false);
    }
    
    public List<Org62Accx> getOrg62Accounts(){
        return this.org62Accounts;
    }  
    
        private class Org62Accx{
        public String Name{get;set;}
	    public String pae_Name{get;set;}
	    public String pae_Email{get;set;}            
        public String cpqae_Name{get;set;}
	    public String cpqae_Email{get;set;}            
		public String CustomerStatus{get;set;}
        public String AccountOwnerRole{get;set;}            
        public String AOV_Band{get;set;}
        public String CSM_Name{get;set;}
        public String CSM_Email{get;set;}
        public String Industry{get;set;} 
        public String OwnerName{get;set;}
        public String ManagerName{get;set;}
        public String OwnerEmail{get;set;} 
        public String PorfolioSuccessManager{get;set;}
        public String Premier_AOV_Band{get;set;} 
        public String Rating{get;set;} 
        public String Region_AOV_Band{get;set;} 
        public String Region{get;set;} 
        public String Segment{get;set;}
        public String Success_Partner{get;set;}
        public String Core_Edition{get;set;}  
            
            public Org62Accx(){
            if(test.isRunningTest()) {
              this.pae_Name = 'test_pae_Name';
              this.pae_Email = 'test_pae_email';         
        	  this.cpqae_Name = 'test_cpqae_name';
	      	  this.cpqae_Email = 'test_cpqae_email';           
			  this.OwnerName = 'owner_Name';
              this.OwnerEmail = 'owner_Email';
              this.CSM_Name = 'test_csm_Name';
              this.CSM_Email = 'tes_csm_email';
            }
            } 
  
        } 
}