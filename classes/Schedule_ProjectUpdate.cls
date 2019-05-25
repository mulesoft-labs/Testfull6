/**
*   Global Schedule_ProjectUpdate Class
*   @version: 1.0
*   @author Victor Vargas Reyes
*   @date 09/26/2011
*   @description Class that implements schedulable content to schedule the execution of the ProjectDateUpdateBatch class.   
*/
global class Schedule_ProjectUpdate implements Schedulable{ 
    
    global void execute(SchedulableContext sc) {
		String userId = UserInfo.getUserId();
		User u = [select Id, Email from User where Id=:userId limit 1];
		Execute_ProjectDateUpdate EXECUTE_PDU = new Execute_ProjectDateUpdate();
		AsyncApexJob aaj = EXECUTE_PDU.executeProjUpdate();
		if(aaj!=null){	   		
	   		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {u.Email});
			mail.setReplyTo(u.Email);
			mail.setSenderDisplayName('Project Update');
			mail.setSubject('Project Update Process');
			mail.setPlainTextBody('The Project update process is completed\n\nRESULTS OF THE SYNC PROCESS\n\nJob Id: '+
			aaj.Id+
			'\n\nJob Method Name: '+aaj.MethodName+
			'\n\nJob Created by: '+aaj.CreatedBy.Email+
			'\nJob Type: '+aaj.JobType+			
			'\nJob Status: '+aaj.Status+
			'\nJob Extended Status: '+aaj.ExtendedStatus+
			'\nJob Completed Date: '+aaj.CompletedDate+
			'\nJob Total Items: '+aaj.TotalJobItems+
			'\nJob Items Processed: '+aaj.JobItemsProcessed+
			'\nNumber of Errors: '+aaj.NumberOfErrors+
			'\nJob Last Processed: '+aaj.LastProcessed+
			'\nJob Last Processed Offset: '+aaj.LastProcessedOffset);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  			
		}
				
	}
}