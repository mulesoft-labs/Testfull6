public  class taskxmlcontroller{

   public Boolean ShowData {get;set;}
   public List <Task> cleanedtask {get;set;}
   public List <Task> lsttask {get;set;}
   public List<Task> getcleanedtask() {    return this.cleanedtask ; } 
   public String getHOST_NAME()
   {return this.HOST_NAME;}
 
   public List<Task> getlsttask() {return this.lsttask; } 
   public final String HOST_NAME = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    String param1= ApexPages.currentPage().getParameters().get('Test1');
    String param2= ApexPages.currentPage().getParameters().get('Test2');
   

   public taskxmlcontroller()
   {
 
      if(param1== 'Task' && param2== 'completed date')
    {
     lsttask  = new List <Task> ();
 //    ShowData  = false;
       lsttask   =[Select id,description,OwnerId,WhoId,Status,Subject,ActivityDate from Task where Status = 'Completed' Order By ActivityDate Desc Limit 1000];
      }
       if(param1== 'Task' && param2== 'start date')
    {
     lsttask  = new List <Task> ();
 //    ShowData  = false;
       lsttask   =[Select id,description,OwnerId,WhoId,Status,Subject,ActivityDate from Task Order By ActivityDate Desc Limit 1000];
      }
     if(param1== 'Task' && param2== 'due date')
    {
     lsttask  = new List <Task> ();
 //    ShowData  = false;
       lsttask   =[Select id,description,OwnerId,WhoId,Status,Subject,ActivityDate from Task where Status != 'Completed' Order By ActivityDate Desc Limit 1000];
      }
        cleanedtask = new List <Task> ();
      for (Integer i = 0 ;i<lsttask.size();i++)
      { 
       if(lsttask[i].Subject!= null)
        lsttask[i].Subject=lsttask[i].Subject.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('\'','&apos;').replace('"','&quot;');
       if(lsttask[i].description!= null)
        lsttask[i].description=lsttask[i].description.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('\'','&apos;').replace('"','quot;');
        cleanedtask.add(lsttask[i]);
      
      }
  

          //getters and setters
//   public String getTod_ay() {return Task.toDateTime( System.Today() ).formatGMT('MMM d yyyy HH:mm:ss') + ' GMT'; } 
//   public String getTomorr_ow() {return Task.toDateTime( System.Today().addDays(1) ).formatGMT('MMM d yyyy HH:mm:ss') + ' GMT'; }
 
    
 
   }





}