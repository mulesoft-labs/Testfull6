/*
 *@Auhor  :  Narasimha (perficient)
 *@Created:  01/21/2015
 *@Desc   : Opportunity settings/config 
            list all Hadecoded values/settings/Constants related to the Opportunity object.
 *
 *@Revision Hist:
 *
 */

public with sharing class OpportunitySettings { 
    
    //Opportunity Team Member Roles
    public static final String sOPPTY_TEAM_MEMBER_ROLE_SENIOR_MGR ='Senior Manager';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_SALES_MGR ='Sales Manager';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR ='SI Channel Manager';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_ACCOUNT_EXE ='Account Executive';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CSM ='Customer Success Manager (CSM)';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CSR ='Customer Success Representative (CSR)';
    // Added by Tia Xuan 12/02/2016
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CSD ='Customer Success Director (CSD)';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_ADR ='Account Development (ADR)';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_PRIMARY= 'Solutions Consultant - Primary';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_SECONDARY= 'Solutions Consultant - Secondary';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CLIENT_ARCHITECT= 'Client Architect';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARC_PRIMARY= 'Customer Success Architect - Primary';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARC_SECONDARY = 'Customer Success Architect - Secondary';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ENGINEER= 'Customer Success Engineer';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARCHITECT = 'Customer Success Architect';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_PARTNER_CLIENT_ARCHITECT= 'Partner Client Architect';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER= 'Engagement Manager';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_BUSINESS_OUTCOMES_CONSULTANT= 'Business Outcomes Consultant';
    public static final String sOPPTY_TEAM_MEMBER_ROLE_PARTNER = 'Partner';
    

    public static final Set<string> OPPORTUNITY_TEAM_MEMBER_ROLES_REQUIRING_OVERLAY_SPLIT = new Set<string>{
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_PRIMARY,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_SECONDARY,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CLIENT_ARCHITECT,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_ADR,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARC_PRIMARY,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARC_SECONDARY,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CSM,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CSR,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CSD,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ENGINEER,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_CUSTOMER_SUCCESS_ARCHITECT,    
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_ENGAGEMENT_MANAGER,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_PARTNER_CLIENT_ARCHITECT,
                                                                                            sOPPTY_TEAM_MEMBER_ROLE_PARTNER_MGR,
																							sOPPTY_TEAM_MEMBER_ROLE_BUSINESS_OUTCOMES_CONSULTANT                                                                                                
                                                                                            };
     
    //constants to prevent Solution Managers from modifying splits not associated to solution Roles                                                                                       };
    public static final String SOLUTION_MANAGER_PROFILE_NAME = '2_18 Solution Consultant';
    public static final Set<string> OPPORTUNITY_TEAM_MEMBER_ROLES_WHOSE_SPLITS_CAN_BE_CHANGED_BY_SOLUTION_MANAGER = new Set<string>{
                                                                                                                    sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_PRIMARY,
                                                                                                                    sOPPTY_TEAM_MEMBER_ROLE_SOLUTIONS_CONSULTANT_SECONDARY,
                                                                                                                    sOPPTY_TEAM_MEMBER_ROLE_CLIENT_ARCHITECT
                                                                                                                    };

    
    //User Roles
    public static final String sUSER_ROLE_SALES ='Sales';
    public static final String sUSER_ROLE_CHANNEL ='Partner Manager'; //previous it was Channel
    public static final String sUSER_ROLE_ADR='ADR';
    
    //Opportunity Stage Names
    public static final String sStage_SubmittedClosing ='Submitted for Closing';
    
    //Opportunity Types
    
    public static final String sType_AddOnBusiness ='Add-On Business';
    public static final String sType_Renewal ='Renewal';
    public static final String sType_AddonBusinessRenewalpriceUplift = 'Add-On Business - Renewal Price Uplift';
    
    //Opportunity Add on Types
    public static final String sType_AddOnType ='New Project';
    
    //Opportunity lead Source
    public static final String sOpptyLeadSource_PartnerReferral ='Partner - Field Referral';
    
    //Opportunity Source
    public static final String sOpptySource_Indirect_Channel_SI_VAR ='Indirect - Channel/SI/VAR';
    public static final String sOpptySource_Indirect_ISV_ALLIANCES ='Indirect - ISV/Alliances';
    //Account Types
    public static final String sAccountTypeEnterprisePartner ='Enterprise Partner (OEM)';

    //Custom forecast to standard forecast map
    public static final Map<String,String> forecastCategoryMap = new Map<String,String>{
        //common mapping for New/Add On and Renewal
        Label.Opp_Custom_Forecast_Commit.toUpperCase() => Label.Opp_Standard_Forecast_Commit,
        Label.Opp_Custom_Forecast_Closed.toUpperCase() => Label.Opp_Standard_Forecast_Closed,

        //mappings for new/Add on 
        Label.Opp_Custom_Forecast_Likely.toUpperCase() => Label.Opp_Standard_Forecast_Commit,
        Label.Opp_Custom_Forecast_Upside.toUpperCase() => Label.Opp_Standard_Forecast_Upside,
        Label.Opp_Custom_Forecast_Pipeline.toUpperCase() =>Label.Opp_Standard_Forecast_Pipeline,        
        Label.Opp_Custom_Forecast_Lost.toUpperCase() => Label.Opp_Standard_Forecast_Omitted,

        //mappings for renewal
        Label.Opp_Custom_Forecast_Renewal_Risk.toUpperCase() => Label.Opp_Standard_Forecast_Upside,
        Label.Opp_Custom_Forecast_Untouched.toUpperCase() => Label.Opp_Standard_Forecast_Commit,
        Label.Opp_Custom_Forecast_Significant_Renewal_Risk.toUpperCase() => Label.Opp_Standard_Forecast_Pipeline,
        Label.Opp_Custom_Forecast_Processing_Closed_lost.toUpperCase() => Label.Opp_Standard_Forecast_Omitted
    };


    
}