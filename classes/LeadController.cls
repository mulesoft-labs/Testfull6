/**
*   Author:-        Andrew (Mondaycall)
*   Created:-       2/20/2014
*   Description:-   Valdiate lead fields while converting
*   Revision:-  
**/

public class LeadController{
    String ERROR_MESSAGE = 'Lead Status should be Qualified or Convert - Merge';
    public Lead leadObj {get;set;}
    ApexPages.StandardController stdCon;
    
    public LeadController(ApexPages.StandardController stdCon){
        leadObj = [SELECT 
                    Id, Status
                  FROM 
                    Lead 
                  Where 
                    id =:stdCon.getid()];
       this.stdCon = stdCon;            
    }
    
    //Action:- validate leads fields and return to Lead convert stndard page
    public PageReference validateForLeadConversion(){
        PageReference pg;
        if(leadObj.Status == 'Qualified' || leadObj.Status == 'Convert - Merge'){
            pg = new PageReference('/lead/leadconvert.jsp?nooverride=1&id=' + leadObj.id + '&returl=' + EncodingUtil.URLENCODE('/'+leadObj.id,'UTF-8'));
        }else{
            stdCon.getRecord().addError(ERROR_MESSAGE);
        }
        
        return pg;        
    }
    
}