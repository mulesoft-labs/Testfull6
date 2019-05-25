/*********************************************************************
*
*   File Name: SCTeamMemberRestrictions.cls
*
*   File Description: Business logic class restricting inserting,
*   updating, and deleting Opportunity and Account team members
*
**********************************************************************
*
*   Date        Author              Change
*   10/07/14    Rob                 Commenting out Account Team code
*                                   as custom object no longer being
*                                   used.
*   08/22/14    Rob                 Initial Creation                  
*
*********************************************************************/

public class SCTeamMemberRestrictions
{
    public static UserRole objUserRole{set; get;}
    private static String userProfileName;
    public static Map<String, List<String>> mpCustSetting {set; get;}
    public static List<String> lstStr {set; get;}
    public static Map<String, String> mpUserRole {set; get;}
    public static Map<String, String> mpUserRoleId {set; get;}
    
    /**
     * Starting method initiated by OpportunityTeamMember_BeforeInsert, OpportunityTeamMember_BeforeUpdate,
     * and OpportunityTeamMember_BeforeDelete triggers
     */
    public static void checkRoleToAddOpportunityTeamMember(List<OpportunityTeamMember> lstTrigger)
    {   
        intialize();

        // Only apply check to non-System Administrators
        if(userProfileName != 'System Administrator' && userProfileName != '2_18 Sales Operations' && userProfileName != '2_18 Financial Operations')
        {
            // creating list of user Id which are adding as OpportunityTeamMember
            for(OpportunityTeamMember otm : lstTrigger )
            {       
                lstStr.add(otm.UserId);
            }
            
            // cheching that the user is having the permission to add or not
            Set<String> stError = checkPermission();
           
            // showing error if its not allowed to add into OpportunityTeamMember
            if(stError.size() > 0)
            {
                for(OpportunityTeamMember o : lstTrigger)
                {            
                    if(stError.contains(o.UserId))
                    {                
                        o.addError('Only SC Leads can add, change, and remove SCs');
                    }
                }
            }
        }
    }

    /**
     * Initialization method to obtain restriction rules from custom setting to place in map
     * for use later on
     */
    private static void intialize()
    {
        //fetching the user role name 
        if(UserInfo.getUserRoleId() != null)
        {
            objUserRole = [select Id, Name from UserRole where Id =: UserInfo.getUserRoleId() ];
        }
        else
        {
            objUserRole = null;
        }

        // fetch the user's profile
        try
        {
            userProfileName = [select Profile.Name from User where Id =: UserInfo.getUserId()].Profile.Name;
        }
        catch(Exception e)
        {
            userProfileName = '';
        }
       
        // data from custom setting
        mpCustSetting = new Map<String,List<String>>();
       
        for(Team_Member_Settings__c obj:[SELECT Id,Name,Child_Role_Name__c,Parent_Role_Name__c FROM Team_Member_Settings__c])
        {
            List<String> lstparentrole = new List<String>();
            if(!mpCustSetting.containskey(obj.Child_Role_Name__c))
            {
                lstparentrole.add(obj.Parent_Role_Name__c); 
                mpCustSetting.put(obj.Child_Role_Name__c,lstparentrole);
            }
            else
            {
                List<String> templst= mpCustSetting.get(obj.Child_Role_Name__c);
                templst.add(obj.Parent_Role_Name__c);
                mpCustSetting.put(obj.Child_Role_Name__c,templst);
            }
        }
        
        system.debug(mpCustSetting);

        // map declaration
        mpUserRoleId = new Map<String, String>();
        mpUserRole = new Map<String, String>();
        
        // list declaration
        lstStr = new List<String>();
    }

    /**
     * Method to check permissions against restrictions in custom settings map
     */
    private static Set<String> checkPermission()
    {
        Set<String> stError = new Set<String>();
        
        try
        {    
            // collecting all of those user Id & role Id to a map which are going to add as a team member 
            for (User ur : [select Id, UserRoleId from User where Id IN : lstStr ])
            {
                if(ur.UserRoleId != null)
                {
                    mpUserRoleId.put(ur.Id, ur.UserRoleId);
                }
            }
            
            // collecting all of those user Role Name & role Id to a map which are going to add as a team member
            for(UserRole uro : [select Id, Name from UserRole where Id IN : mpUserRoleId.Values() ])
            {
                mpUserRole.put(uro.Id, uro.Name);
            }
            
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
          
        for(String srtUrole : mpUserRoleId.keySet())
        {     
            // First check if it's a restricted role
            if(mpCustSetting.containsKey(mpUserRole.get(mpUserRoleId.get(srtUrole))))
            {            
                //  Check if current user has required parent role
                String roleIdOfTeamMember = mpUserRoleId.get(srtUrole);
                String roleNameOfTeamMember = mpUserRole.get(roleIdOfTeamMember);
                List<String> setting = mpCustSetting.get(roleNameOfTeamMember);
               
                if(objUserRole == null)
                { // Current user has no role so can't possibly have parent role needed to add the SC                       
                    stError.add(srtUrole);
                } 
                else 
                {
                    boolean found=false;
                    for(String s:setting)
                    { 
                        if(s.equalsIgnoreCase(objUserRole.Name))
                        {   
                            found =true;
                        } 
                    }
                    if(!found)
                    {    
                        // Current user doesn't have the parent role to add the SC
                        stError.add(srtUrole);
                    }
                }
            } 
        }

        return stError;
    }
}