public with sharing class CopyDocumentsAsAttachments {
	
	
	    public blob Attach {get;set;}
	    
	    
	    public static void deepCloneProject(String projectId, String templateId) {
	    	
	    	System.debug('In deepclone: '+projectId + ' : '+templateId);
	    	
	    	Project__c newProject = [select id,name from Project__c where id=:projectId limit 1];
	    	Project__c masterTemplate = [select id,name from Project__c where id=:templateId];
	    	
	    	Milestone__c[] milestones = [select id,name from Milestone__c where project__c=:masterTemplate.id];
	    	
	    	Work_Task__c[] worktasks = [select id,name,ownerid from Work_Task__c where project__c=:masterTemplate.id];
	    	
	    	
	    	
	    	Map<Id,Id> oldNewMilestoneIds = new Map<Id,Id>();
	    	
	    	Map<Id,Id> oldNewWorkTaskIds = new Map<Id,Id>();
	    	
	    	
	    	for (Milestone__c milestone:milestones) {
	    		
	    		String id = milestone.id;
	    		
	    		String soql = Utils.getCreatableFieldsSOQL('Milestone__c','id=\''+id+'\'');
				Milestone__c m = (Milestone__c)Database.query(soql);
				Milestone__c m2 = m.clone(false, true);
				m2.Project__c = newProject.id;
				insert m2;
				
				oldNewMilestoneIds.put(id,m2.id);
				
	    		
	    	}
	    	
	    	
	    	for (Work_Task__c worktask:worktasks) {
	    		
	    		
	    		String id = worktask.id;
	    		
	    		String soql = Utils.getCreatableFieldsSOQL('Work_Task__c','id=\''+id+'\'');
				Work_Task__c wt = (Work_Task__c)Database.query(soql);
				
				
				Work_Task__c wt2 =  wt.clone(false, true);
				
				wt2.Project__c = newProject.id;
				
				wt2.from_template__c = true;
				
				Id newId = OldNewMilestoneIds.get(wt2.milestone__c);
				wt2.Milestone__c = newId;
				
				insert wt2;
				
				oldNewWorkTaskIds.put(id,wt2.id);
				
	    		
	    	}
	    	
	    	
	    		List<Id> ids = new List<Id>();
	    		
	    		Id ownerid = null;
	    		
	    		for (Work_Task__c worktask:worktasks) {
	    			
	    			ids.add(worktask.id);
	    			
	    			ownerid = worktask.ownerid;
	    			
	    	
	    		}
	    	
	    		
	    		List<UserProfileFeed> items = [select id,type,body,contentdata,contentdescription,contentfilename,parentid from UserProfileFeed where parentId in :ids with userid=:ownerid limit 1000]; 
	    		
	    			
	    		
	    		
	    		System.debug('Items size: '+items.size());
	    		
	    		for (UserProfileFeed item:items) {
	    			
	    			if (item.type=='ContentPost') {
	    			
		    			FeedItem newItem = new FeedItem();
		    			
		    			Id newId = OldNewWorkTaskIds.get(item.parentId);
		    			
		    			newItem.ParentId = newId;
		    			newItem.Type = 'ContentPost';
		    			newItem.ContentData = item.contentdata;
		    			newItem.contentdescription = item.contentdescription;
		    			newItem.contentfilename = item.contentfilename;
		    			
		    			insert newitem;
		    			
		    			System.debug('Inserted : '+newitem + ' : parent '+newitem.parentid);
	    			
	    			}	
	    			
	    		}	
	    	
	    	
	    	
	    	
	    	
	    }
	
		public void runCopy() {
			
			Folder[] folders = [select id, name from Folder where Name='Project Templates' and Type='Document'];
			
			
			System.debug('Folders: '+folders.size());
			
			id fid = (folders.isEmpty()) ? null : folders[0].id;
			
			Document[] docs = [select id,name,body from Document where folderid=:fid];
			
			System.debug('Documents! : '+docs.size());
			
			
			
			
			for (Document doc:docs) {
				
				Attachment attach = new Attachment(Name=doc.Name, body=doc.body,parentId='a1XV00000001I7N');
				
				FeedItem item = new FeedItem();
				item.ContentData = doc.body;
				item.ContentFileName = doc.name;
				
				item.ParentId = 'a1XV00000001I7N';
				
				insert item;
				
				
			}
			
	        try {
	      
	       // Blob b = Attach;
	        //Attachment At = new Attachment(Name ='NewFile'+'.jpg',body = b,parentId='123123123');
	        //insert At;
	       
	        }Catch(Exception ee){}
	        
   
		}
		

}