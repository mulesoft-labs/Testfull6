trigger GenerateVendorFromAccount on Account (after insert, after update) {
	
	/*
	try {
		RecordType rt = [select Name,id from RecordType where RecordType.SobjectType = 'Account' and Name='Vendor'];
	
	   Account newacc = Trigger.new[0];
	   
	   
	   if (newacc.RecordTypeId==rt.id) {
	   	
	   	Vendor__c[] existing = [select name,id from Vendor__c where name=:newacc.name limit 1];
	   	
	   	if (existing.size()==0) {
	   	
	   			Vendor__c v = new Vendor__c();
	   			v.name = newacc.name;
	   			v.account__c = newacc.id;
	   			
	   			insert v;
	   	}
	   	
	   }
	} catch (Exception e) {
		
	}
	*/
}