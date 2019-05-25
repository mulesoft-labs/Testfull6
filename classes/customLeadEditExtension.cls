public class customLeadEditExtension {

    private final Lead ld;
    private Id recId;

    public customLeadEditExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest())  {
            stdController.addFields(new String[]{
            'recordtypeId'
        });
        
        }
        this.ld= (Lead)stdController.getRecord();
        this.recId=ld.recordtypeId;
    }
    
    //New LeadDeflcection method
    public PageReference getRedir() { 
      PageReference newPage;
       if(UserInfo.getProfileId().equalsIgnoreCase(label.LeadEditRedirectProfile)){         
          newPage=Page.CustomLeadEdit;
          return newPage.setRedirect(true);
       }else{
           if(recId != null){
           return new PageReference ('/00Q/e?retURL=%2F00Q%2Fo&RecordType='+recId+'&ent=Lead&nooverride=1');
           }else{
           return new PageReference ('/00Q/e?retURL=%2F00Q%2Fo&ent=Lead&nooverride=1');
           }
       }  
    }
    
    public PageReference saveLead() {
        try{
            insert ld;
        }catch(DmlException e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
        } 
        PageReference ldPage = new ApexPages.StandardController(ld).view();
        ldPage.setRedirect(true);
        return ldPage;
    }
    
     public PageReference saveLeadandAprroval() {
        try {
            insert ld;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval');
            req1.setObjectId(ld.id);
            Approval.ProcessResult result = Approval.process(req1);
        }catch(DmlException e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
        }
        PageReference ldPage = new ApexPages.StandardController(ld).view();
        ldPage.setRedirect(true);
        return ldPage;
    }

}