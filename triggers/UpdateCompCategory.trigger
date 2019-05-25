/*
 * When the annual revenue changed on account update compensation category 
 */ 
trigger UpdateCompCategory on Account  (before update, before insert) {
    /*
    for( Account acct: trigger.new )
    {
        
        if( acct.AnnualRevenue <= 149999999.999 )
        {
            //acct.Compensation_Category__c = 'Commercial';
        }// end if( acct.AnnualRevenue <= 149999999.999)
        else if( acct.AnnualRevenue <= 249999999.999 )
        {
            //acct.Compensation_Category__c = 'Enterprise';
        }// end else if( acct.AnnualRevenue <= 249999999.999 )
        else 
        {
            //acct.Compensation_Category__c = 'Strategic';
        }// end else
        
    }// end for( Account acct: trigger.new )
    */
}// end trigger