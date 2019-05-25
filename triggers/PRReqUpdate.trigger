trigger PRReqUpdate on Presales_Request__c (before update) {   
    if(Trigger.new.size()==1) {
        System.debug('Owner Trigger.old##:' + Trigger.old[0].OwnerId);
        System.debug('Owner Trigger.new##:' + Trigger.new[0].OwnerId);
        //Status Changed
        if (Trigger.old[0].Status__c != Trigger.new[0].Status__c) {   
              System.debug('Status Changed');
            if(Trigger.old[0].Status__c=='New'){
                System.debug('Previous Status New');
                Trigger.new[0].OwnerId = UserInfo.getUserId();
                Trigger.new[0].Presales_Request_Previous_Owner_Name__c = Trigger.old[0].Presales_Request_Owner_Name__c;
                User pu = [SELECT Name, Email from User WHERE id=:Trigger.new[0].OwnerId];
                Trigger.new[0].Presales_Request_Owner_Name__c = pu.Name;
            }
        }
        //Status not changed
        if (Trigger.old[0].Status__c == Trigger.new[0].Status__c){
            
              System.debug('Status not changed');
              if(Trigger.old[0].OwnerId != Trigger.new[0].OwnerId){
                 System.debug('Owner changed');
                 Trigger.new[0].Presales_Request_Previous_Owner_Name__c = Trigger.old[0].Presales_Request_Owner_Name__c;
                 List<User> cu = [SELECT Name, Email from User WHERE id=:Trigger.new[0].OwnerId];
                 if(cu.size()>0){
                       System.debug('User not empy');
                       Trigger.new[0].Presales_Request_Owner_Name__c = cu[0].Name;  
                 }
                System.debug('Owner Update Previous Owner(after)##:' + Trigger.new[0].Presales_Request_Previous_Owner_Name__c);
                System.debug('Owner Update New Owner(after)##:' + Trigger.new[0].Presales_Request_Owner_Name__c);   
            }
        }
}
}