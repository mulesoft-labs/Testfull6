public class timelogxmlcontroller
{
   public Boolean ShowData {get;set;}
      public List <Time_log__c> cleanedtask {get;set;}
      public List<Time_log__c> getcleanedtask() {    return this.cleanedtask ; } 
  
   public List <Time_log__c> lsttask {get;set;}
   

 
   public List<Time_log__c> getlsttask() {return this.lsttask; } 
   public final String HOST_NAME = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    String param1= ApexPages.currentPage().getParameters().get('Test1');
   // String param2= ApexPages.currentPage().getParameters().get('Test2');

   public timelogxmlcontroller ()
   
   {
 
      if(param1== 'Timelog')
    {
     lsttask  = new List <Time_log__c> ();
 //    ShowData  = false;
       lsttask   =[Select id,Date__c,Name,Activity_Description__c from Time_log__c  Order By Date__c Desc limit 200];
       
   

    
      }
       cleanedtask = new List <Time_log__c> ();
      for (Integer i = 0 ;i<lsttask.size();i++)
      { 
        if(lsttask[i].Activity_Description__c!= null)
        lsttask[i].Activity_Description__c=lsttask[i].Activity_Description__c.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('\'','&apos;').replace('"','quot;');
        cleanedtask.add(lsttask[i]);
      
      }

      }
      }