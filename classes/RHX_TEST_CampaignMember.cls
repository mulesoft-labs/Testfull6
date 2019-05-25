@isTest(SeeAllData=true)
public class RHX_TEST_CampaignMember {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM CampaignMember LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new CampaignMember()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}