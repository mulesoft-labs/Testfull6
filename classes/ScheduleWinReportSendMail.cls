/*********************************************************************
*
*   File Name: ScheduleWinReportSendMail
*
*   File Description: This class sends out a combined email on a 
*  schedule.
*
**********************************************************************
*
*   Date    Author              Change
*  1/27/15    Rob               Initial Creation  
*  7/31/15    Chetan            Remove limit 200 from Win report query
*
*********************************************************************/

global class ScheduleWinReportSendMail implements Schedulable
{
     global void execute(SchedulableContext sc) 
     {        
       List<Win_Report__c> reports = [Select id, Win_Report_Complete_2__c, Win_Report_Emailed__c, Name, Win_Report__c.Account__r.Name,
                        Opportunity__r.Name, Amount__c, Opportunity_Source__c, Lead_Source__c, Lead_Source_Asset__c, 
                        Lead_Source_Detail__c, Opportunity_Team__c, Account__c, Company_Description__c, 
                        Location_HQ_or_buying_entity__c, Annual_Revenue__c, Industry__c, Number_of_Employees__c, 
                        Products_and_Subscription_Level__c, Sales_Cycle_Start__c, Sales_Cycle_End__c, 
                        Compelling_Event__c, Buyer_Name_Role__c, Primary_Solution_Interest__c, Win_Report__c.Opportunity_Owner__c, 
                        What_business_problem_are_they_solving__c, What_business_impact_and_ROI__c, Existing_Technology__c,
                        Competition__c, Key_Takeaway_on_Competition__c, What_is_the_use_case_s__c, End_point__c, 
                        Partner_Influence__c, Why_did_the_customer_choose_MuleSoft__c, Describe_our_solution_differentiation__c, 
                        Customer_Reference_Calls_Used_to_Win__c, Customer_Reference_Details__c, CreatedBy.Name, 
                        LastModifiedBy.Name from Win_Report__c where Amount__c > 0 and Schedule_For_Combined_Email__c = true ];

       if(!reports.isEmpty())
       {
         try
         {
           String emailBody = buildEmailBody(reports);
           
           Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
           message.setHtmlBody(emailBody);
           message.setSubject('Latest Win Reports');
           //message.setToAddresses(new List<String>{'caroline.paty@mulesoft.com'});     
           message.setTargetObjectId(KeyValueSetting__c.getInstance('Win Report Email Recipient').value__c);
           message.setSenderDisplayName('MuleSoft');           
           Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});
           
           for(Win_Report__c w : reports)
           {
             w.Schedule_For_Combined_Email__c = false;
           }

           update reports;
         }
         catch(Exception e)
         {
           System.debug('=> Error sending combined Win Report email: ' + e.getMessage());
         }
       }
     }

     private String buildEmailBody(List<Win_Report__c> reportsPassed)
     {
       String body = 'Congrats to the Sales Team on their recent successes.  Learn about the following opportunities below:<br />'
               + '<ul>';
       
       for(Win_Report__c w : reportsPassed)
       {
         body += '<li>'
             + w.Account__r.Name + ' - ' + w.Opportunity__r.Name + ' - ' + w.Opportunity_Owner__c
             + '</li>';
       }

       body += '</ul><br /><br />';

       for(Win_Report__c w : reportsPassed)
       {
         body += '<h2>Win Report Detail</h2>'
             + '<b>Win Report:</b> ' + w.Name + '<br />'
          + '<b>Opportunity:</b> ' + w.Opportunity__r.Name + '<br />'
          + '<b>Amount:</b> ' + w.Amount__c + '<br />'
          + '<b>Opportunity Source:</b> ' + w.Opportunity_Source__c + '<br />'
          + '<b>Lead Source:</b> ' + w.Lead_Source__c + '<br />'
          + '<b>Lead Source Asset:</b> ' + w.Lead_Source_Asset__c + '<br />'
          + '<b>Lead Source Detail:</b> ' + w.Lead_Source_Detail__c + '<br />'
          + '<b>Opportunity Team:</b> ' + w.Opportunity_Team__c + '<br /><br />'

          + '<b>Account:</b> ' + w.Account__r.Name + '<br />'
          + '<b>Company Description:</b> ' + w.Company_Description__c + '<br />'
          + '<b>Location (HQ, or buying entity):</b> ' + w.Location_HQ_or_buying_entity__c + '<br />'
          + '<b>Annual Revenue:</b> ' + w.Annual_Revenue__c + '<br />'
          + '<b>Industry:</b> ' + w.Industry__c + '<br />'
          + '<b>Number of Employees:</b> ' + w.Number_of_Employees__c + '<br /><br />'

          + '<b>Products & Subscription Level:</b> ' + w.Products_and_Subscription_Level__c + '<br />'
          + '<b>Sales Cycle Start:</b> ' +(w.Sales_Cycle_Start__c == null ? '' : w.Sales_Cycle_Start__c.format())+ '<br />'
          + '<b>Sales Cycle End:</b> ' +(w.Sales_Cycle_End__c == null ? '' : w.Sales_Cycle_End__c.format())+ '<br />'
          + '<b>Compelling Event:</b> ' + w.Compelling_Event__c + '<br />'
           + '<b>Financial Decision Maker & Role:</b> ' + w.Buyer_Name_Role__c + '<br /><br />'

          + '<b>Primary Solution Interest:</b> ' + w.Primary_Solution_Interest__c + '<br />'
          + '<b>What business problem are they solving?:</b> ' + w.What_business_problem_are_they_solving__c + '<br />'
          + '<b>What is the business impact and ROI:</b> ' + w.What_business_impact_and_ROI__c + '<br />'
          + '<b>Existing Technology:</b> ' + w.Existing_Technology__c + '<br />'
          + '<b>Competition:</b> ' + w.Competition__c + '<br />'
          + '<b>Key Takeaway on Competition:</b> ' + w.Key_Takeaway_on_Competition__c + '<br /><br />'

          + '<b>What is the use case(s)?:</b> ' + w.What_is_the_use_case_s__c + '<br />'
          + '<b>Connectivity:</b> ' + w.End_point__c + '<br />'
          + '<b>Partner Influence:</b> ' + w.Partner_Influence__c + '<br />'
          + '<b>Why did the customer choose MuleSoft?:</b> ' + w.Why_did_the_customer_choose_MuleSoft__c + '<br />'
          + '<b>Describe our solution differentiation:</b> ' + w.Describe_our_solution_differentiation__c + '<br /><br />'
       
          + '<h3>Customer References</h3>'

          + '<b>Customer Reference Calls Used to Win?:</b> ' + w.Customer_Reference_Calls_Used_to_Win__c + '<br />'
          + '<b>Customer Reference Details:</b> ' + w.Customer_Reference_Details__c + '<br />'
          + '<b>Created By:</b> ' + w.CreatedBy.Name + '<br />'
          + '<b>Last Modified By:</b> ' + w.LastModifiedBy.Name + '<br /><br /><br /><br />';
       }

       return body;
     }
}