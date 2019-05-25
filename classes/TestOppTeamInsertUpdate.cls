@isTest(seeAllData=true)
private class TestOppTeamInsertUpdate{
static testMethod void verify_OppTeamTriggers() {
    Pricebook2 priceBookId = [SELECT Id FROM Pricebook2 WHERE Name=:'Standard Price Book'];
    PricebookEntry pbID = [select Id,CurrencyIsoCode from PricebookEntry where isActive = true limit 1];

    Account a = new Account(Name='TestAccount',BillingCountry='US');
    insert a;
    System.debug ('Account = ' + a.id);

    Opportunity o = new Opportunity();
    o.Name = 'TestOpportunity';
    o.AccountId = a.id ;
    o.CloseDate = Date.today();
    o.StageName = ConstantDeclarations.OPP_STAGE_SALES_QUALIFIED;
    o.CurrencyIsoCode = pbID.CurrencyIsoCode;
    ID opprtId = [SELECT Id FROM RecordType WHERE Name = 'Standard / New Business'].Id;
    o.RecordTypeId=opprtId;
    o.Type = 'New Business';
    o.Amount=1000;
    o.NextStep='Discovery Call';
    o.Opportunity_Source__c ='Direct';     
    o.Pricebook2Id=priceBookId.Id;
    o.Primary_Solution_Interest__c = 'SOA';
    
    List<User> salesRep = [SELECT Id, Region__c, FirstName, LastName from User where Email LIKE 'justin.gardiner%'];  
    o.OwnerId = salesRep[0].Id; //Paul 
    insert o;
    
    OpportunityLineItem oli = new OpportunityLineItem(opportunityId = o.Id);
    oli.PriceBookEntryID = pbID.Id;
    oli.Quantity = 1;
    oli.UnitPrice = 2.00;    
    insert oli;  
   
    List<User> scLeadList = [SELECT Id, Region__c, FirstName, Team_Role__c, LastName from User where Region__c='EMEA' AND Division='Solution Consulting'];
    User sclead = null;
    User sc = null;
    for (User usr:scLeadList){
        if(usr.Team_Role__c == 'Lead'){
            sclead = usr;
        }else{
            sc = usr;
        }
    }
 
    List<User> admins = [SELECT Id, FirstName, Team_Role__c, LastName from User where ProfileId IN (SELECT Id FROM Profile where Name='System Administrator')
                         and IsActive = true];
 
    if(sclead != null && sc != null)
    {
       System.debug('Running as Lead');
      OpportunityTeamMember member = new OpportunityTeamMember();
      OpportunityTeamMember member2 = new OpportunityTeamMember();
       
       System.runAs(sclead){
        member.OpportunityId = o.Id;
        member.UserId = sclead.Id;
        member.TeamMemberRole = 'Solution Consultant';
        member.SC_Role_Details__c = 'Primary';
        
        
        member2.OpportunityId = o.Id;
        member2.UserId = sc.Id;
        member2.TeamMemberRole = 'Solution Consultant';
        member2.SC_Role_Details__c = 'Supporting'; 
        
        insert member; 
        insert member2;  
       }
       
       if(member2 != null){
        System.runAs(admins[0]){ 
          //List<UserProfileFeed> feedItemList  = [Select Id, Body, LinkUrl from UserProfileFeed with UserId =:sc.Id];
          String linkUrlPost = URL.getSalesforceBaseUrl().toExternalForm() + '/' + o.Id; 
          List<FeedItem> feedItemList = [Select Id, Body, LinkUrl from FeedItem where ParentId = :sc.Id];
         
          /*for(UserProfileFeed upf:feedItemList){
              if(upf.LinkUrl==linkUrlPost){
                System.assertEquals(upf.LinkUrl,linkUrlPost);               
              }
          }*/
          System.debug('Size of FeedITem = ' + feedItemList.size());
          for(FeedItem fT:feedItemList){  
              if(fT.LinkUrl==linkUrlPost){
                System.assertEquals(fT.LinkUrl,linkUrlPost); 
                            
              }
          }
        }
       }
       
       if(member != null){
        System.runAs(sclead){           
          delete member;
        }
       }

        System.runAs(sclead){   
          OpportunityTeamMember otm = [SELECT Id, SC_Role_Details__c, OpportunityId, UserId from OpportunityTeamMember where OpportunityId=:o.Id AND UserId=:sc.Id];
          otm.SC_Role_Details__c  = 'Primary';          
          update otm;
        }

          
         //}
         //catch(Exception e){}
       }
          
    }
  }