public class timelineworkitemcont {
   
   public List <Work_Task__c> lsttask {get;set;}
  // public List <Work_Task__c> lsttaskdummy {get;set;}
   public List <Work_Task__c> cleanedtask {get;set;}
   public List<Work_Task__c> getlsttask() {    return this.lsttask; } 
   public List<Work_Task__c> getcleanedtask() {    return this.cleanedtask ; } 
   
    public String HOST_NAME {get;set;}
    String param1= ApexPages.currentPage().getParameters().get('Test1');
    String param2= ApexPages.currentPage().getParameters().get('Test2');
    public void clean1stask()
    {
       HOST_NAME  = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
      lsttask  = new List <Work_Task__c> ();
      cleanedtask = new List <Work_Task__c> ();
    if(param1== 'workitem' && param2== 'completed date')
    {
     
 //    ShowData  = false;
       lsttask   =[Select Id,name,Due_Date__c,description__c from Work_Task__c where Status__c= 'Closed' Order By Due_Date__c Desc limit 200];
      }
       if(param1== 'workitem' && param2== 'start date')
    {
     
 //    ShowData  = false;
       lsttask   =[Select Id,name,Due_Date__c,description__c from Work_Task__c Order By Due_Date__c Desc limit 200];
      }
       if(param1== 'workitem' && param2== 'due date')
    {
     
 //    ShowData  = false;
       lsttask   =[Select Id,name,Due_Date__c,description__c from Work_Task__c where Status__c!= 'Closed' Order By Due_Date__c Desc limit 200];
      }
      cleanedtask = new List <Work_Task__c> ();
      for (Integer i = 0 ;i<lsttask.size();i++)
      { 
       if(lsttask[i].name != null)
        lsttask[i].name=lsttask[i].name.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('\'','&apos;').replace('"','&quot;');
       if(lsttask[i].description__c!= null)
        lsttask[i].description__c=lsttask[i].description__c.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('\'','&apos;').replace('"','quot;');
        cleanedtask.add(lsttask[i]);
       system.debug('+++++'+cleanedtask[i].description__c);
      }
      //update lsttask;
  
    }
   public timelineworkitemcont ()
   {
 clean1stask();
      System.Debug('inside constructor');
      

    
 
   }








}