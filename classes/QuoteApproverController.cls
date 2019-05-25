/**
 *    Description: Controller class to get list of Quote related Approvals.
 *    Version        Author            Date            Description
 *  
 *    1.0            Team Simplus      07/13/2017      Created Controller class.
 *    2.0            Team Simplus      07/26/2017      updated Controller class.
 **/

public  class QuoteApproverController
{
    public Id quoteId;
    public List<sbaa__Approval__c> approverList {get; set;}
    public map<sbaa__Approval__c, list<String>> approverMap {get; set;}
    public map<Id,sbaa__Approval__c> approvalsMap {get; set;}
    
    public void setQuoteId(String qId){
        //quoteId = qId; 
        quoteApprovals(qId); 
    } 
    
    public String getQuoteId(){
        return quoteId; 
    }
       
    // Get list of Quote related Approvals.
    // [2.0]
    public map<sbaa__Approval__c, list<String>> quoteApprovals(Id quoteRecId){
        approverList = new List<sbaa__Approval__c>();
        approvalsMap = new map<Id,sbaa__Approval__c>();
        approverMap = new map<sbaa__Approval__c, list<String>>();
        List<sbaa__Approval__c> topApprovaList  = new List<sbaa__Approval__c>();
        List<sbaa__Approval__c> recentUpdatedApprovalList = new List<sbaa__Approval__c>();
        list<String> approvalComments;
        
        for(sbaa__Approval__c approverObj : [Select Id,Quote__c,sbaa__Approver__r.Name,Approval_Requested_For__c,Approval_Order__c,sbaa__AssignedTo__c, sbaa__AssignedTo__r.Name, 
                                                        sbaa__CommentsLong__c,sbaa__Status__c,Comment_History__c,Date_Processed__c,Date_Requested__c,sbaa__ApprovalStep__c, Rule2__c                 
                                                 FROM sbaa__Approval__c 
                                                 WHERE Quote__c=: quoteRecId
                                                 ORDER BY Approval_Order__c DESC, sbaa__AssignedTo__r.Name ASC
                                                 //ORDER BY sbaa__ApprovalStep__c,  ASC
                                                ]){            
                topApprovaList.add(approverObj);
        }
        
        // Get list of most recently updated Approvals of Qyote
        if(!topApprovaList.isEmpty()) {
            if(topApprovaList.size() == 1){
                recentUpdatedApprovalList.add(topApprovaList[0]);
            }
            else{
                for(Integer j=0; j<topApprovaList.size(); j++) {                
                    if((String.valueOf(topApprovaList[0].Approval_Order__c)).substringBefore('Z') == 
                       (String.valueOf(topApprovaList[j].Approval_Order__c)).substringBefore('Z')) {
                        if(!approvalsMap.containsKey(topApprovaList[j].Id)){
                            approvalsMap.put(topApprovaList[j].Id, topApprovaList[j]);
                            recentUpdatedApprovalList.add(topApprovaList[j]);
                        }
                    }
                    else{
                        break;
                    }
                }  
            } 
        } 
        
        // Get map of most recently updated Approvals having multiple Cooments
        if(quoteRecId!= null){
            for(sbaa__Approval__c approverObj : recentUpdatedApprovalList) {
            System.Debug('***Here: approverObj '+ approverObj );
               approvalComments = new list<String>();               
               if(!approverMap.containsKey(approverObj)){                   
                    if(String.isNotEmpty(approverObj.Comment_History__c)){
                        approvalComments.addAll(approverObj.Comment_History__c.split('[^\\S\\n]*\n+[^\\S\\n]*'));
                        approverMap.put(approverObj , approvalComments);
                    } 
                    else{
                        approvalComments.add('');
                        approverMap.put(approverObj, approvalComments);
                    }                                       
                }  
                approverList.add(approverObj); 
            }              
        }                      
        return approverMap;
    }
}