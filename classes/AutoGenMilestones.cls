public with sharing class AutoGenMilestones {
	
	public static Milestone__c[] generateMilestones(String projectId) {
		
		
		Project__c[] projects = [select id,name from Project__c where id=:projectId];
		
		
		Project__c proj = projects[0];
		 
		Milestone__c milestone;
		
		
		Milestone__c[] toInsert = new Milestone__c[0];
		
		for (String milestoneName:MilestoneConstants.getMilestoneNames()) {
			
			milestone = new Milestone__c();
			
			milestone.project__c = proj.id;
		
			milestone.name = milestoneName;
		
			toInsert.add(milestone);
		
		}
		
		insert toInsert;
		
		return toInsert;
		
		
		
	}
	
	public static void generateWorkTasks(List<Milestone__c> milestones) {
		
		
		 
		Work_Task__c task;
		
		
		Work_Task__c[] toInsert = new Work_Task__c[0];
		
		for (Milestone__c milestone:milestones) {
			
			task = new Work_Task__c();
			
			task.project__c = milestone.project__c;
			
			task.Milestone__c = milestone.id;
		
			task.name = 'Complete '+milestone.Name;
		
			toInsert.add(task);
			
		
		}
		
		insert toInsert;
		
		
		
		
	}
	

}