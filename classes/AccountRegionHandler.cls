/*********************************************************************
*
*   File Name: AccountRegionHandler
*
*   File Description: This class handles setting Account Region and
*   Sub-Region values on Account insert and update.  It is invoked
*   from the Account_BeforeInsert and Account_BeforeUpdate triggers.
*
**********************************************************************
*
*   Date        Author                      Change
*   12/10/14    Rob                         Initial Creation                        
*
*********************************************************************/
public class AccountRegionHandler
{       
    private final static String STATE = 'State - ';
    private final static String COUNTRY = 'Country - ';
	private final static Map<string,Account_Region_Rules__c> mapCustomSettingKey = new Map<string,Account_Region_Rules__c>();
    
    /**
     * Method to set Region and Sub Region on before insert.  This method is
     * invoked from the Account_BeforeInsert trigger.
     */
    public static void AccountBeforeInsert(List<Account> accList)
    {    	        
        setSettings();

        for(Account a : accList)
        {
        	String key = '';        	
        	if(String.isNotEmpty(a.BillingState))
        	{
        		key = STATE + a.BillingState;        		
        	}

            if(mapCustomSettingKey.get(key) == null)
            {
                if(String.isNotEmpty(a.BillingCountry))
                {
                    key = COUNTRY + a.BillingCountry;
                }
            }

            setRegionAndSubRegion(a, key);
        }
    }
    
    /**
     * Method to set Region and Sub Region on before update.  This method is invoked
     * from the Account_BeforeUpdate trigger.
     */
    public static void AccountBeforeUpdate(List<Account> accList, Map<Id, Account> oldIdAccountMap)
    {
        setSettings();

        String newBillingState = '';
        String oldBillingState = '';
        String newBillingCountry = '';
        String oldBillingCountry = '';
        for(Account a : accList)
        {
            String key = '';

            // Have to do case sensitive compare to need to make sure values compared are not null to prevent null pointer error
            newBillingState     = (a.BillingState == null ? '' : a.BillingState);
            oldBillingState     = (oldIdAccountMap.get(a.Id).BillingState == null ? '' : oldIdAccountMap.get(a.Id).BillingState);
            newBillingCountry   = (a.BillingCountry == null ? '' : a.BillingCountry);
            oldBillingCountry   = (oldIdAccountMap.get(a.Id).BillingCountry == null ? '' : oldIdAccountMap.get(a.Id).BillingCountry);

            if(!newBillingState.equals(oldBillingState) || 
               !newBillingCountry.equals(oldBillingCountry))
            {
            	if(String.isNotEmpty(a.BillingState))
        		{
        			key = STATE + a.BillingState;        		 	
        		}

                if(mapCustomSettingKey.get(key) == null)
                {
                    if(String.isNotEmpty(a.BillingCountry))
                    {
                        key = COUNTRY + a.BillingCountry;
                    }
                }

                setRegionAndSubRegion(a, key);
            }            
        }
    }

    /**
     * Method to set Region and SubRegion fields based on the key passed
     */
    private static void setRegionAndSubRegion(Account passedAccount, String passedKey)
    {
        // Clear field values before setting
        passedAccount.Region__c = '';
        passedAccount.Sub_Region__c = '';

        if(passedKey != '')
        {            
            if(mapCustomSettingKey.get(passedKey) != null)
            {
                // Set Region
                if(mapCustomSettingKey.get(passedKey).Region__c != null)
                {
                    passedAccount.Region__c = mapCustomSettingKey.get(passedKey).Region__c;
                }
                 
                // Set Sub-Region        
                if(mapCustomSettingKey.get(passedKey).Sub_Region__c != null)
                {
                    passedAccount.Sub_Region__c = mapCustomSettingKey.get(passedKey).Sub_Region__c;
                }
            }
        }
    }

    /**
     * Method to set the custom settings to memory for looking up region and sub-region values
     */
    private static void setSettings()
    {
        Map<String, Account_Region_Rules__c> mapStringCustomSetting = Account_Region_Rules__c.getAll();
        for(Account_Region_Rules__c accountRegionRule : mapStringCustomSetting.values())
        {
            mapCustomSettingKey.put(accountRegionRule.Key__c, accountRegionRule);
        }
    }
}