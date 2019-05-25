public class CMsTriggerRunCounter {
    // Added this boolean to bypass the OpportunityTeamMember creation in Opportunity trigger execution
    // Default is not to skip the logic
    public static boolean skipOppTeamMemberCopy = false;

    //Skip Opportunity Trigger
    public static boolean skipOppTrigger = false;

    //skip validation to prevent opportunity line items for opportunity in closing
    public static boolean bypassOpportunityInClosingEditValidation = false;

    //Skip Account Trigger
    public static boolean skipAccountTrigger = false;

    //Skip Contact Trigger
    public static boolean skipContactTrigger = false;

    //Skip Subscription Trigger
    public static boolean skipSubscriptionTrigger = false;

    //Skip Anypoint Organization Trigger
    public static boolean skipAnypointOrgTrigger = false;

    //Skip Partner Trigger
    public static boolean skipPartnerInfleunceTrigger = false;
    
    //Skip Quote Trigger
    public static boolean skipQuoteTrigger = false;    
}