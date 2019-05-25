public with sharing class MilestoneConstants {
	
	public static final String REQUIREMENTS_DEFINITION = 'Requirements Definition';
	
	public static final String INFORMATION_ARCHITECTURE = 'Information Architecture';
	public static final String VISUAL_DESIGN = 'Visual Design';
	public static final String FRONT_END_DEVELOPMENT = 'Front End Development';
	public static final String PROGRAMMING = 'Programming';
	public static final String QA_TESTING_LAUNCH = 'QA/Testing & Launch';
	public static final String POST_LAUNCH = 'Post-Launch';
	public static final String ACCOUNT_MANAGEMENT = 'Account Management';
	public static final String RELATIONSHIP_MANAGEMENT = 'Relationship Management';


	public static List<String> milestoneNames = new List<String>();
	public static List<String> getMilestoneNames() {
		
		Milestone_Template__c[] templates = [select id,name from Milestone_Template__c];
		
		if (templates.size()>0) {
			
			for (Milestone_Template__c template:templates) {
			
			
				milestoneNames.add(template.name);
			
			}
			
			
			
		} else {
	
		milestoneNames.add(REQUIREMENTS_DEFINITION);	
		milestoneNames.add(INFORMATION_ARCHITECTURE);
		milestoneNames.add(VISUAL_DESIGN);
		milestoneNames.add(FRONT_END_DEVELOPMENT);
		milestoneNames.add(PROGRAMMING);
		milestoneNames.add(QA_TESTING_LAUNCH);
		milestoneNames.add(POST_LAUNCH);
		milestoneNames.add(ACCOUNT_MANAGEMENT);
		milestoneNames.add(RELATIONSHIP_MANAGEMENT);
		
		
		}
		
		return milestoneNames;
		
	}
	
	


}