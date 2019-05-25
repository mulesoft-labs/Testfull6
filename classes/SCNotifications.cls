/*********************************************************************
*
*   File Name: SCNotifications.cls
*
*   File Description: Handles SC notifications by creating Chatter
*   posts.  Identifying users by hard-coding them was requested.   
*
**********************************************************************
*
*   Date        Author              Change
*   10/02/14    Rob                 Initial Creation                             
*
*********************************************************************/

public without sharing class SCNotifications
{	
    /**
     * Starting method invoked by the OpportunityTrigger trigger after update event
     */
    public static void notifyAt10Percent(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap)
    {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Id oppId : newMap.keySet())
        {                       
            if(oldMap.get(oppId).Probability != 10 && newMap.get(oppId).Probability == 10)
            {
                opportunities.add(newMap.get(oppId));
            }
        }

        create10PercentChatterPost(opportunities);
    }

    /**
     * Method to create chatter posts.  This identifies region by looking up role of opportunity
     * owner and referencing map to determine who to notify based on role name
     */
    private static void create10PercentChatterPost(List<Opportunity> opps)
    {  
        // Get Owner Roles
        Set<String> ownerIds = new Set<String>();
        for(Opportunity opp : opps) 
        {
            ownerIds.add(opp.ownerid);
        }        
        List<Opportunity> opportunitiesWithOwners = [select Id, Name, Date_Probability_10__c, Amount, CloseDate,
                                                     Owner.UserRole.Name from Opportunity where OwnerId in : ownerIds
                                                     and Id in: opps];

        // Get user notification map
        Map<String, List<Id>> userMap = getUserMap();

        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        List<FeedItem> feedList = new List<FeedItem>();
        for(Opportunity opp : opportunitiesWithOwners)
        {
            List<Id> usersToNotify = new List<Id>();            
            for(String region : userMap.keySet())
            {
                if(opp.Owner.UserRole.Name.startsWith(region))
                {
                    usersToNotify.addAll(userMap.get(region));
                }
            }
            
            for(Id userIds : usersToNotify)
            {                   
                FeedItem post = new FeedItem();
                post.Body = 'Opportunity 10 %: ' + opp.Name + ' changed on: ' + opp.Date_Probability_10__c
                          + '\nAmount: ' + opp.Amount
                          + '\nClose Date: ' + opp.CloseDate;
                post.LinkURL = sfdcURL + opp.Id;
                post.Title = opp.Name;
                post.ParentId = userIds;
                feedList.add(post); 
            }
        }

        try
        {
            insert feedList;
        }
        catch(Exception e)
        {
            System.debug('=> Error Inserting Chatter Post When Opportunity Probability is 10%: ' + e.getMessage());
        }
    }

    /**
     * Map that returns role name and users to notify when opp moves to 10 percent
     */
    private static Map<String, List<Id>> getUserMap()
    {
        Map<String, List<Id>> userMap = new Map<String, List<Id>>();
        userMap.put('EMEA', new List<Id>{'00580000003q1Bz'}); // Pablo Luna
        userMap.put('APAC', new List<Id>{'00580000004SQC3'}); // David Irecki
        userMap.put('NA-Sales-N', new List<Id>{'00580000003rr3O', '00580000006gweP'}); // Shuba Swaminathan, John DaDamio
        userMap.put('NA-Sales-W', new List<Id>{'00580000003rr3O', '00580000006gweP'}); // Shuba Swaminathan, John DaDamio
        userMap.put('NA-Sales-E', new List<Id>{'00580000004TCUo', '00580000006gweP'}); // Tyrone Borromeo, John DaDamio
        userMap.put('NA-Sales-S', new List<Id>{'00580000004TCUo', '00580000006gweP'}); // Tyrone Borromeo, John DaDamio

        return userMap;
    }
}