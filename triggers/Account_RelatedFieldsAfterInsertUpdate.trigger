/*********************************************************************
*
*   File Name: Account_RelatedFieldsAfterInsertUpdate
*
*   File Description: This triggers executes on insert and update of Account
*
**********************************************************************
*
*   Date            Author          Change
*   08/29/14        Rob             Added a validation for BillingCountry
*                                                         
*
*********************************************************************/
trigger Account_RelatedFieldsAfterInsertUpdate on Account (after insert, after update) 
{
    List<Opportunity> opps = new List<Opportunity>();
    Set<String> accountIds = new Set<String>();
    Set<String> oppIds    = new Set<String>();
    List<Opportunity> oppList = new List<Opportunity>();

    for (Account a : Trigger.new)
    { 
    	if(String.isNotEmpty(a.BillingCountry))
		{		          	               
            if(trigger.isupdate)
            {
            	Account oldAccount = Trigger.oldMap.get(a.ID);
                if (a.Company_Description__c != oldAccount.Company_Description__c)
                {
                	accountIds.add(a.Id); 
                }
            }
            if(trigger.isInsert)
            {
             	accountIds.add(a.Id);  
            } 
		}
		else	
		{   
        	a.addError('Billing Country is Required on the Account');
        }            
    }

    if(!accountIds.isEmpty())
	{
    	oppList = [SELECT StageName, AccountId, Company_Description__c, Id from Opportunity where AccountId IN:accountIds AND StageName != 'Closed Won'];
	}

    if(oppList.size() > 0)
    {
        for(Opportunity o: oppList)
        {
            if (o.StageName != 'Closed Lost' && o.StageName != 'Rejected Lead')
            {
                for(Account a : trigger.new)
                {
                    if(o.AccountId == a.Id)
                    {
                       o.Company_Description__c = a.Company_Description__c;
                       opps.add(o);
                       //changedOppsMap.put(o.Id, o);
                    }
                }
            }
        }
    }

    if(!opps.isEmpty())
    { 
        update opps;
    }
}