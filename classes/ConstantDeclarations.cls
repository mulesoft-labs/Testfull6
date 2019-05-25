/**
 * Description : ConstantDeclarations is used for all constant declaration.  
 *
 *
 * Date        : 01/09/2015
 * Version     : 1.0
 * Author      :Nikhil (Perficient)
 */
public with sharing class ConstantDeclarations {
    public static final String OPP_STAGE_SALES_QUALIFIED = '0. Sales Qualified Lead';
    public static final String OPP_STAGE_ID_BUSINESS_INITIATIVE = '1. ID Business Initiative'; 
    public static final String OPP_STAGE_EDUCATE_ON_MULESOFT_VISION= '2. Educate on MuleSoft Vision';
    public static final String OPP_STAGE_CONFIRM_NEED_AND_IMPACT = '3. Confirm Need & Impact';
    public static final String OPP_STAGE_VALIDATE_SOLUTION = '4. Validate Solution';
    public static final String OPP_STAGE_NEGOTIATE_CLOSE = '5. Negotiate & Close';
    public static final String OPP_STAGE_SUBMIT_CLOSING = '6. Submitted for Closing';
    public static final String OPP_STAGE_BOOKING = '7. Booking';
    public static final String OPP_STAGE_VERBAL_WIN = '5. Verbal Win';


    public static final String OPP_STAGE_REJECTED_LEAD = 'Rejected Lead';
    public static final String OPP_STAGE_CLOSED_WON = 'Closed Won';

    public static final String OPP_STAGE_10_PERCENT = '1. ID Business Initiative';
    //public static final String OPP_STAGE_5_PERCENT = '0.5. Pre-SAL';
    public static final String OPP_STAGE_CLOSED_LOST = 'Closed Lost';
    public static final String OPP_TYPE_NEW_BUSINESS = 'New Business';
    public static final String OPP_TYPE_ADD_ON_BUSINESS = 'Add-On Business';
    public static final String OPP_TYPE_ADD_ON_BUSINESS_RENEWAL_PRICE_UPLIFT = 'Add-On Business - Renewal Price Uplift';
    public static final String OPP_TYPE_ADD_ON_BUSINESS_MULTI_YEAR_ANNUAL_PAY = 'Add-On Business - Multi-Year Annual Pay';
    public static final String OPP_TYPE_ADD_ON_BUSINESS_MULTI_YEAR = 'Add-On Business - Multi-Year';
    public static final String OPP_TYPE_RENEWAL = 'Renewal';
    public static final String OPP_TYPE_RENEWAL_MULTI_YEAR = 'Renewal - Multi-Year';
    public static final String OPP_TYPE_RENEWAL_MULTI_YEAR_ANNUAL_PAY = 'Renewal - Multi-Year Annual Pay';
    public static final String OPP_TYPE_RENEWAL_CONTRA_BOOKING = 'Contra-Booking - Renewal';
    public static final String OPPORTUNITY_SPLIT_TYPE_OVERLAY = 'OVERLAY';
    public static final string OPPORTUNITY_SPLIT_TYPE_REVENUE = 'REVENUE';
    public static final string OPPORTUNITY_SPLIT_TYPE_RENEWAL_FORECAST = 'RENEWAL FORECAST';
    public static Boolean isStageTrackingpartExecuted=false;

    //profile names
    public static final string SYSTEM_ADMINISTRATOR_PROFILE = 'System Administrator';
    public static final string SALES_OPERAION_PROFILE = '2_18 Sales Operations';


    //opportunity record types
    public static final string  OPPORTUNITY_IN_CLOSING_RECORD_TYPE_DEVELOPER_NAME = 'Opportunity_in_Closing';
    public static final string  OPPORTUNITY_IN_CLOSING_RECORD_TYPE_LABEL = 'Opportunity in Closing';
    public static final string  OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_DEVELOPER_NAME = 'Opportunity_in_Closing_Renewal';
    public static final string  OPPORTUNITY_IN_CLOSING_RENEWAL_RECORD_TYPE_LABEL = 'Opportunity in Closing (Renewal)';

}