public with sharing class ProjectSearchController {
	
	private String searchNameFilter;
    private List<IdentityComposite> userList = new List<IdentityComposite>();
    
	public class IdentityComposite {			
		Contact con;
		Project__c proj;			
		String recordId;
		String identityType;
		String name;			
	}
    
    public String getJsonList(){
        populateUserList();
        return createJsonString(this.userList);
    }
    
    public ProjectSearchController(){
        this.searchNameFilter = ApexPages.currentPage().getParameters().get('name');
    }
    
    public static User createC4CUser(){
		Profile pr = [select id from profile limit 1]; 
        
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com', 
                          emailencodingkey='UTF-8', 
                          lastname='Testing', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US', 
                          profileid = pr.Id, 
                          timezonesidkey='America/Los_Angeles', 
                          username='standard' + String.valueOf(System.now().getTime()) + '@testorg.com');
            
        return u;
	}
    
    public static String parseName(String name) {
    	
    	if (name.lastIndexOf(',')!=-1) {    		
    		System.debug('The last index of comma is not negative one!!');
    		String[] toSplit = name.split(',');
    		String last = toSplit[0];    		
    		String firstMiddle = toSplit[1];    		
    		System.debug('First middle: '+firstMiddle);
    		
    		if (firstMiddle.startsWith(' ')) {    			
    			firstMiddle = firstMiddle.substring(1, firstMiddle.length());    			
    		}
    		    		
    		if (firstMiddle!=null) {
    			String[] secondPass = firstMiddle.split(' ');    		
	    		if (secondPass.size()>1) {
	    			firstMiddle = secondPass[0];	    			
	    			System.debug('Second pass.....: '+firstMiddle);
	    		}
    		}    		
    		System.debug('Returning this: '+firstmiddle + ' '+last);    		
    		return firstMiddle + ' '+last;
    	}
    	else {    		
    		System.debug('Negative one does not exist in string: '+name);
    		return name;
    	}
    }
    
    private void populateUserList(){
        String searchFilter = this.searchNameFilter;
        
        if(this.searchNameFilter != null){

        	searchFilter = ProjectSearchController.parseName(searchFilter);
        	String searchquery='FIND\' '+searchFilter+'*\'IN NAME FIELDS RETURNING Project__c (Id, Project_Status__c, Name,Projected_Completion_Date__c) limit 100';
                
	        List<List<SObject>> searchList=search.query(searchquery);
	        List<Project__c> aList = searchList[0];
		        
	        for (Project__c a:aList) {
	        	if(a.Project_Status__c=='Active'){
	        		IdentityComposite comp = new IdentityComposite();		        		
	        		String projCompletionDate = ''+ a.Projected_Completion_Date__c;
	        	                		
	        		comp.identityType =''+ projCompletionDate.substring(0,10);       		
	        		comp.proj = a;
	        		comp.name = a.Name;                		
	        		comp.recordid = a.Id;
	        		
	        		userList.add(comp);
	        	}
	        }
			System.debug('Results size: '+userList.size());
			
		}else{
		    this.userList = new List<IdentityComposite>();
		}
    }
    
    private String createJsonString(List<IdentityComposite> pUsers){
        String jsonString = '[';
            
            if(pUsers != null && pUsers.size() > 0){
                for(IdentityComposite p: pUsers){
                                  
					jsonString += '{id:\"' + p.recordId + '\",' +
                                  'text:\"' + p.Name + '\",' +
                                  'href:\"/' + p.recordId + '\",' +
                                  'extra:\"' +  p.identityType +'\"'+                                   
                                  '},';                                  
                }
                jsonString = jsonString.substring(0,jsonString.length() - 1);
            }
        
        jsonString += ']';
        return jsonString;
    }
    
    static testMethod void test() {
    	User user1 = createC4CUser();
		user1.Email = 'testingUser1@salesforce.com';
		insert user1;
		System.assertNotEquals(null, user1.Id);
		
    	ApexPages.currentPage().getParameters().put('name','Testing');
    	ProjectSearchController psc = new ProjectSearchController();
    	String jSonString = psc.getJsonList();
    	System.assertNotEquals(null,jSonString);
    	System.assertEquals(']',jSonString.substring(jSonString.length() -1 ));	//ensure Json is in good form
    }
    
}