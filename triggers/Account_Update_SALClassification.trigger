/*
 * When the annual revenue changed on account update compensation category 
 */

trigger Account_Update_SALClassification on Account  (before update, before insert) {
/*
     for( Account acct: trigger.new ) {
     if( acct.AnnualRevenue >= 4000000000.00 ) {
            acct.SAL_Classification__c = 'Strategic';
         }
         else if( acct.AnnualRevenue <= 3999999999.99 && acct.AnnualRevenue >= 1000000000.00) {
            acct.SAL_Classification__c = 'Enterprise';
         } else if(acct.AnnualRevenue <= 999999999.99 && acct.AnnualRevenue >= 400000000.00) {
             acct.SAL_Classification__c = 'Mid-Market';
         } else {
           acct.SAL_Classification__c = 'Commercial';
         }
     }
*/
}