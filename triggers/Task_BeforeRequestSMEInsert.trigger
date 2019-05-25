trigger Task_BeforeRequestSMEInsert on Task (before insert) {
/*
    Map <string,Id> recordTypeMap = new Map<string,Id>();
    Set<String> userIds = new Set<String>();
     
    List<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = 'Task' and isActive = true ]; 
     
    for(RecordType rt : recTypes){
        System.debug('Task - Creating SME object');
        recordTypeMap.put(rt.Name, rt.Id);        
    }
    for (Task t : Trigger.new)
    {
           if(t.recordTypeId == recordTypeMap.get('Request SME')) {
              System.debug('Task - adding to userIds');
              userIds.add(t.OwnerId);
           }
                   
     }
     
     List <User> userList = [SELECT 
            UserRole.Name, Id, FirstName, LastName, Region__c, Team_Role__c, ManagerId
            FROM User WHERE Id IN :userIds];
   
    if(userList.size() > 0)
    {
        for (Task t : Trigger.new)
        {
               for(User user:userList){
    
                   if(t.OwnerId == user.Id) {
                         System.debug('Task - Setting ManagerId');
                        t.OwnerId = user.ManagerId;
                   }
                 
               }      
         }
     }
       

*/
}