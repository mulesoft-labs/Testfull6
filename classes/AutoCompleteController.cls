//Controller used for the AutoComplete Enhancement

public with sharing class AutoCompleteController{

  //Constructors
  
    public AutoCompleteController() {}
    
    public AutoCompleteController(ApexPages.StandardController controller) {}

  //Attributes
  
  private List<String> resultsname = new List<String>();
  private Boolean hasparams = false;
  private Boolean hasnoresults = false;
  
        
    //Getters and Setters
    
   public Boolean getHasparams(){

     return hasparams;
     
   }
   
   public void clearValues(){
     
     hasparams = false;
     
   }
   
   public Boolean getHasnoresults(){
   
     return hasnoresults;  
   }

  public void avoidRefresh(){
    
  }
   
     public PageReference searchSuggestions() {

    //Initalize variables, hasparams just indicates that a search has started
        resultsname.clear();   
        hasparams = true;
        hasnoresults = false;

    //Obtain current parameters
        String sobjectname = System.currentPageReference().getParameters().get('objectname');
        String stext = '%'+System.currentPageReference().getParameters().get('aname')+'%';
        
        //Limit Suggestions to 10 Results
        Integer iLimit = 10;
        
     //Validate if there's an input and get results
     
     
     System.debug('sobjectname: '+sobjectname + ' : '+stext);
     if(stext.length() > 3){
       Vendor__c[] vendor;
    String sql = null;

// Namespace
    if (sobjectname == 'Vendor') {
      System.debug('Starting autocomplete');
//    if (sobjectname == 'Contact') {

      try{
                
            vendor = [select name from Vendor__c where name like :stext];
          //ql = 'select name from ' + sobjectname + ' where contact.name like \''+stext+'\' limit '+ iLimit;
                 
                 for (Vendor__c v : vendor) {
                   
                   String s = v.name;
                   
                   
                 
                   resultsname.add(s);
                 
                 }
                 
        
      }catch(Exception e){
        System.debug('Problem: '+e);
        
        resultsname.add('Unexpected Error, please contact support');  
      }
    }
    else {  
    
      System.debug('It was not that..');
    try{
              
        sql = 'select name from ' + sobjectname + ' where name like \''+stext+'\' limit '+ iLimit;
               
               for(sobject x : Database.query(sql)){
                
                String s  = (String)(x.get('name'));
                resultsname.add(s);  
              }
    
      
    }catch(Exception e){
              System.debug('Problem2: '+e);

      
      resultsname.add('Unexpected Error, please contact support');  
    }
    }

     }
     else {
       
         resultsname.add('Please type additional letters');  
       
     }
       return null;
  }
  
  public Boolean checkUniqueInRegistered(String nameAccount) {
    
       
       return null;
    
  }
  
    
    
   public List<String> getResultsname(){
        //Make sure to clear past values
        clearValues();
        if(resultsname.isEmpty()){
      hasnoresults = true;
      resultsname.add('No Results');
        }
        return resultsname;
    }
 


}