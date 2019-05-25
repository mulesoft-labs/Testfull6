/* This is handler class for Content Document Link Object*/
public without sharing class ContentDocumentLinkTriggerHandler {
	public static final string ENABLEMENT_ACTIVITY_FILE_NAME = 'Enablement Activity';
	public static final string ENABLEMENT_ACTIVITY_FILE_EXTENSION = 'CSV';

	public static final string FIRST_NAME_COLUMN_NAME = 'First Name';
	public static final string LAST_NAME_COLUMN_NAME = 'Last Name';
	public static final string EMAIL_COLUMN_NAME = 'Email';	
	public static final string  LEAD_SOURCE_PARTNER_EVENT= 'Partner - Event';
	public static final string CONVERTED_LEAD_STATUS = 'Convert - Merge';

	/*Method Processes documents uploaded to the Account Object's Files section to load contacts and enablement Activity Participants*/
	public static void processcEnablementActivityFile(ContentDocumentLink conDocLink){
		Id enablementActivityId = conDocLink.LinkedEntityId;

		Enablement_Activity__c activityInContext = [Select Id, Partner__c, Partner__r.OwnerId from Enablement_Activity__c where Id=: enablementActivityId];

		ContentDocument conDoc = [Select Id,Title, FileType, FileExtension, LatestPublishedVersionId, LatestPublishedVersion.VersionData
						from ContentDocument where Id =: conDocLink.ContentDocumentId];

		if(ENABLEMENT_ACTIVITY_FILE_EXTENSION.equalsIgnoreCase(conDoc.FileType) && conDoc.Title != null && 
			conDoc.Title.toUpperCase().contains(ENABLEMENT_ACTIVITY_FILE_NAME.toUpperCase())){
            //check there is a partner on enablement activity
            if(activityInContext.Partner__c == null){
            	conDocLink.AddError('No Partner associated to the enablement Activity');
            	return;
            }

            String fileContent = conDoc.LatestPublishedVersion.VersionData.toString();
            List<List<String>> fileRows = CSVReader.parse(fileContent);
            System.debug('fileRows: ' + fileRows);
            
            Map<String,Integer> columnIndexMap = new Map<String,Integer>();
            Integer rowCount = 0;

            if(!fileRows.isEmpty()){
            	for(Integer i=0; i < fileRows[0].size();i++){
            		columnIndexMap.put((fileRows[0][i]).toUpperCase(), i);
            	}
            	
            	Integer firstNameColumnIndex = columnIndexMap.get(FIRST_NAME_COLUMN_NAME.toUpperCase()) != null ? columnIndexMap.get(FIRST_NAME_COLUMN_NAME.toUpperCase()) : -1;
            	Integer lastNameColumnIndex = columnIndexMap.get(LAST_NAME_COLUMN_NAME.toUpperCase()) != null ? columnIndexMap.get(LAST_NAME_COLUMN_NAME.toUpperCase()) : -1;
            	Integer emailColumnIndex = columnIndexMap.get(EMAIL_COLUMN_NAME.toUpperCase()) != null ? columnIndexMap.get(EMAIL_COLUMN_NAME.toUpperCase()) : -1;
            
            	if(firstNameColumnIndex == -1 || lastNameColumnIndex == -1 || emailColumnIndex == -1){
            		conDocLink.AddError('The file should contain the columns ' + FIRST_NAME_COLUMN_NAME + ', ' + LAST_NAME_COLUMN_NAME + ' and '+ EMAIL_COLUMN_NAME);
            		return;
            	}

            	//remove last row if it is a blank line (files generated from xl will have a blank line at the end)
            	List<String> lastRow = fileRows[fileRows.size() - 1];
            	if(lastRow.size() < columnIndexMap.size()){
            		fileRows.remove(fileRows.size() - 1);
            	}

            	Set<Integer> requiredColumnIndexSet = new Set<Integer>{lastNameColumnIndex, emailColumnIndex, firstNameColumnIndex};            	
            	
            	Set<String> emailIds = new Set<String>(); 

            	for(Integer i=1; i < fileRows.size(); i++){
            		List<String> currentRow = fileRows[i];
            		if(isAttendeeRowValid(currentRow, requiredColumnIndexSet)){
	            		emailIds.add(currentRow[emailColumnIndex]);
	            		rowCount++;
	            	}
            	}

            	if(rowCount > 0){
            		Map<String,String> errorsByEmailMap = new Map<String,String>();
            		Map<string, Contact> existingContactsMap = getContactEmailToContactMap(emailIds);
            		Map<String,Id> convertedContactsMap = new Map<String,Id>();
            		System.debug('*********** existingContactsMap: ' + existingContactsMap);

            		//check if any of the missing contacts exist as leads
            		Set<String> emailsNotFoundIncontact = new Set<String>();
            		for(String email: emailIds){
	            		if(existingContactsMap.get(email.toUpperCase()) == null){
	            			emailsNotFoundIncontact.add(email);
	            		}
	            	}
	            	if(!emailsNotFoundIncontact.isEmpty()){
	            		System.debug('*********** emailsNotFoundIncontact: ' + emailsNotFoundIncontact);
	            		Map<Id, Lead> leadsToConvertMap = new Map<Id, Lead>([Select Id, Email 
	            															from Lead 
	            															where isConverted = false and Email in: emailsNotFoundIncontact]);
	            		System.debug('*********** leadsToConvertMap: ' + leadsToConvertMap);
	            		if(!leadsToConvertMap.isEmpty()){

	            			//prepare lead convert records
	            			List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            				for(Lead l : leadsToConvertMap.values()){
            					Database.LeadConvert lc = new database.LeadConvert();
            					lc.setLeadId(l.Id);
            					lc.convertedStatus = CONVERTED_LEAD_STATUS;
            					lc.setAccountId(activityInContext.Partner__c);
            					lc.setDoNotCreateOpportunity(true);
            					lc.setOwnerId(activityInContext.Partner__r.OwnerId);
            					leadConverts.add(lc);
            				}

            				//convert leads
            				Database.LeadConvertResult[] lcrList = Database.convertLead(leadConverts, false);
            				System.debug('*********** lcrList: ' + lcrList);
            				for(integer i=0; i< lcrList.size() ; i++){
            					Id leadId = leadConverts[i].getLeadId();
            					String leadEmail = leadsToConvertMap.get(leadId).Email;

            					if(lcrList[i].isSuccess()){
            						convertedContactsMap.put(leadEmail.toUpperCase(),lcrList[i].getContactId());
            					}
            					else{
            						errorsByEmailMap.put(leadEmail.toUpperCase(), lcrList[i].getErrors()[0].message);
            					}
            				}
	            		}
	            	}

            		//create missing contacts
            		List<Contact> contactsToCreate = new List<Contact>();
            		Set<string> newContactEmails = new Set<string>();
	            	for(Integer i=1; i < fileRows.size(); i++){
	            		List<String> currentRow = fileRows[i];
	            		if(isAttendeeRowValid(currentRow, requiredColumnIndexSet)){
	            			String emailInCaps = currentRow[emailColumnIndex].toUpperCase();
	            			if(existingContactsMap.get(emailInCaps) == null && convertedContactsMap.get(emailInCaps) == null && 
	            				errorsByEmailMap.get(emailInCaps) == null && !newContactEmails.contains(emailInCaps)){
	            				newContactEmails.add(currentRow[emailColumnIndex].toUpperCase());
	            				Contact newContact = new Contact();
	            				newContact.FirstName = currentRow[firstNameColumnIndex];
	            				newContact.LastName = currentRow[lastNameColumnIndex];
	            				newContact.Email = currentRow[emailColumnIndex];
	            				newContact.LeadSource = LEAD_SOURCE_PARTNER_EVENT;
	            				newContact.AccountId = activityInContext.Partner__c;	            				
	            				//set contact owner to account owner	            				
	            				newContact.OwnerId = activityInContext.Partner__r.OwnerId;	            				
	            				contactsToCreate.add(newContact);
	            			}
		            		
		            	}
	            	}

	            	if(!contactsToCreate.isEmpty()){
	            		Database.SaveResult[] newContactResult = Database.insert(contactsToCreate, false);
	            		for(Integer i=0; i <  newContactResult.size() ; i++){
	            			if(newContactResult[i].isSuccess()){
		            			existingContactsMap.put(contactsToCreate[i].email.toUpperCase(), contactsToCreate[i]);
		            		}
		            		else{
		            			errorsByEmailMap.put(contactsToCreate[i].email.toUpperCase(), newContactResult[i].getErrors()[0].message);
		            		}
	            		}
	            	}

	            	//create enablment activity participant records
	            	Set<Id> enablementActivityParticipantContacts = getEnablementActivityParticipantContacts(enablementActivityId);
	            	Set<string> processedParticipants = new Set<String>();

	            	List<Enablement_Activity_Participant__c> enablmentActivityParticipantToCreate = new List<Enablement_Activity_Participant__c>();
	            	for(Integer i=1; i < fileRows.size(); i++){
	            		List<String> currentRow = fileRows[i];
	            		if(isAttendeeRowValid(currentRow, requiredColumnIndexSet)){		            		
		            		string email = currentRow[emailColumnIndex];
		            		if(existingContactsMap.get(email.toUpperCase()) != null || convertedContactsMap.get(email.toUpperCase()) != null){
		            			Id contactId = existingContactsMap.get(email.toUpperCase()) != null ? existingContactsMap.get(email.toUpperCase()).Id : convertedContactsMap.get(email.toUpperCase());
		            			string key = enablementActivityId + '-' + email.toUpperCase();
		            			if(!processedParticipants.contains(key)){
		            				processedParticipants.add(key);

		            				//do noting if enablement participant exists
		            				if(enablementActivityParticipantContacts.contains(contactId)){
		            					continue;
		            				}
		            				Enablement_Activity_Participant__c participant = new Enablement_Activity_Participant__c();
		            				participant.Contact__c = contactId;
		            				participant.Account__c = activityInContext.Partner__c;
		            				participant.Enablement_Activity__c = enablementActivityId;
		            				enablmentActivityParticipantToCreate.add(participant);
		            			}
		            		}		            		
		            	}
	            	}
	            	//create activity participant if any
	            	if(!enablmentActivityParticipantToCreate.isEmpty()){
	            		Database.SaveResult[] participantResult = Database.insert(enablmentActivityParticipantToCreate, false);
	            	}

	            	//create logs if there are any errors
	            	if(!errorsByEmailMap.isEmpty()){
	            		List<Enablement_Participant_Load_Error_Log__c> logsToCreate = new List<Enablement_Participant_Load_Error_Log__c>();
	            		for(Integer i=1; i < fileRows.size(); i++){
	            			List<String> currentRow = fileRows[i];
	            			if(isAttendeeRowValid(currentRow, requiredColumnIndexSet)){
	            				String emailInCaps = currentRow[emailColumnIndex].toUpperCase();
	            				if(errorsByEmailMap.containsKey(emailInCaps)){
	            					Enablement_Participant_Load_Error_Log__c log = new Enablement_Participant_Load_Error_Log__c();
	            					log.Enablement_Activity__c = enablementActivityId;

	            					log.Email__c = currentRow[emailColumnIndex];
	            					log.First_Name__c = currentRow[firstNameColumnIndex];
	            					log.Last_Name__c = currentRow[lastNameColumnIndex];
	            					log.Error_Message__c = errorsByEmailMap.get(emailInCaps);
	            					logsToCreate.add(log);
	            				}
	            			}
	            		}
	            		insert logsToCreate;
	            	}
            	}
            }
		}
	}

	private static Set<Id> getEnablementActivityParticipantContacts(ID enablmentActivityId){
		Set<Id> enablementActivityParticipants = new Set<Id>();
		for(Enablement_Activity_Participant__c eap: [Select Enablement_Activity__c, Contact__c 
													from Enablement_Activity_Participant__c
													where Enablement_Activity__c =: enablmentActivityId]){
			if(eap.Contact__c != null){
				
				enablementActivityParticipants.add(eap.Contact__c);
			}
		}
		return enablementActivityParticipants;
	}
	

	private static boolean isAttendeeRowValid(List<String> row, Set<Integer> requiredColumns){
		boolean isRowValid = true;
		for(Integer rquiredColumnIndex: requiredColumns){
			if(String.isBlank(row[rquiredColumnIndex])){
				isRowValid = false;
			}
		}
		return isRowValid;
	}

	private static Map<string, Contact> getContactEmailToContactMap(Set<string> emailIds){
		Map<string, Contact> contactEmailToContactMap = new Map<string, Contact>(); 
		for(Contact con: [Select Id, email, lastmodifieddate,AccountId from Contact where email in:emailIds]){
			if(contactEmailToContactMap.get(con.email.toUpperCase()) == null){
				contactEmailToContactMap.put(con.email.toUpperCase(), con);
			}
			else{
				Contact currentContactInMap = contactEmailToContactMap.get(con.email.toUpperCase());
				if(con.lastmodifieddate > currentContactInMap.lastmodifieddate){
					contactEmailToContactMap.put(con.email.toUpperCase(), con);
				}
			}
		}
		return contactEmailToContactMap;
	}
}