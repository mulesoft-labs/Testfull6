public without sharing class TaskTriggerUtility extends CMsBaseTriggerHandler{
    List<Task> newTasks = Trigger.New;
    List<Task> oldTasks = Trigger.Old;
    Map<Id, Task> oldTasksMap = (Map<Id, Task>)trigger.oldMap;

    public override void beforeInsert(){
        system.debug(LoggingLevel.ERROR, 'Inside BEFORE INSERT --> ');        
        validateCLevelConnect(newTasks);
        checkIfCLevelCompletedOnePerOpp(newTasks);
    }

    public override void afterInsert(){
        system.debug(LoggingLevel.ERROR, 'Inside AFTER INSERT --> ');                
        updateCallTypeValues(null, newTasks);
        //updates the Activity fields for contact and lead records
        ActivityCountHandler.updateActivityCount(newTasks);
    }

    public override void beforeUpdate(){
        system.debug(LoggingLevel.ERROR, 'Inside BEFORE UPDATE --> ');                
        validateCLevelConnect(newTasks);
        checkIfCLevelCompletedOnePerOpp(newTasks);
    }

    public override void afterUpdate(){
        system.debug(LoggingLevel.ERROR, 'Inside AFTER UPDATE --> ');                        
        updateCallTypeValues(oldTasksMap, newTasks);
        //updates the Activity fields for contact and lead records
        ActivityCountHandler.updateActivityCount(newTasks);
    }

    public override void afterDelete(){
        system.debug(LoggingLevel.ERROR, 'Inside AFTER DELETE --> ');                                
        updateCallTypeValuesOnDelete(oldTasks);
        //updates the Activity fields for contact and lead records
        ActivityCountHandler.updateActivityCount(oldTasks);
    }

    public override void afterUndelete(){
        system.debug(LoggingLevel.ERROR, 'Inside AFTER UNDELETE --> ');                                        
        //updates the Activity fields for contact and lead records
        ActivityCountHandler.updateActivityCount(newTasks);
    }

    private static void updateCallTypeValuesOnDelete( List<Task> oldTasks ){
        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oldTasks --> '+oldTasks);
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, List<Task>> oppIdToTasksMap = new Map<Id, List<Task>>();
        for( Task t : oldTasks ){
            String whatId = t.whatId;
            if( whatId != null && whatId.startsWith('006') ){
                opportunityIds.add(t.whatId );
                if(oppIdToTasksMap.containsKey( whatId ) ){
                    oppIdToTasksMap.get( whatId ).add( t );
                } else{
                    oppIdToTasksMap.put( whatId , new List<Task>{ t } );
                }
            }
        }
        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oppIdToTasksMap --> '+oppIdToTasksMap);
        if( !opportunityIds.isEmpty() ){
            Set<String> oppFields = new Set<String>();
            Map<String, CallTypetoOpportunityMapping__c> callTypesMap = new Map<String, CallTypetoOpportunityMapping__c>();
            for( CallTypetoOpportunityMapping__c cto : [ SELECT Call_Type__c, Field_Name__c, Value__c
            FROM CallTypetoOpportunityMapping__c] ){
                callTypesMap.put( cto.Call_Type__c, cto );
                oppFields.add( cto.Field_Name__c );
            }
            system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oppFields --> '+oppFields);
            system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oppIdToTasksMap --> '+oppIdToTasksMap);

            if( !oppFields.isEmpty() && !oppIdToTasksMap.isEmpty()){
                Map<Id, List<Task>> oppIdToAllTasks = TaskTriggerUtility.getOppIdToAllTasksMap(oppIdToTasksMap.keySet());
                List<Opportunity> oppToUpdateForDelete = new List<Opportunity>();
                if(Trigger.isDelete && oppIdToAllTasks.isEmpty()){
                    for( Opportunity opp : Database.query( constructOpportunityQuery( opportunityIds, oppFields ) ) ){
                        for( string field : oppFields ){
                            opp.put(field, false);
                        }
                        oppToUpdateForDelete.add(opp);
                    }
                    if( !oppToUpdateForDelete.isEmpty() ){
                        update oppToUpdateForDelete;
                    }
                } else {
                    system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oppIdToAllTasks --> '+oppIdToAllTasks);
                    for( Opportunity opp : Database.query( constructOpportunityQuery( opportunityIds, oppFields ) ) ){
                        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> opp --> '+opp);
                        List<Task> allTasks = oppIdToAllTasks.get(opp.Id);
                        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> allTasks --> '+allTasks);
                        for( string field : oppFields ){
                            opp.put( field, false );
                        }
                        oppsToUpdate.add(updateOpportunityBasedOnRelatedTasks( opp, allTasks, callTypesMap ) );
                    }
                }
            }
        }

        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValuesOnDelete --> oppsToUpdate --> '+oppsToUpdate);
        if( !oppsToUpdate.isEmpty() ){
            update oppsToUpdate;
        }
    }
    private static void updateCallTypeValues(Map<Id, Task> oldTasksMap, List<Task> newTasks){
        List<Task> tasks = new List<Task>();
        Map<String, CallTypetoOpportunityMapping__c> callTypesMap = new Map<String, CallTypetoOpportunityMapping__c>();
        for( CallTypetoOpportunityMapping__c cto : [ SELECT Call_Type__c, Field_Name__c, Value__c
        FROM CallTypetoOpportunityMapping__c] ){
            callTypesMap.put( cto.Call_Type__c, cto );
        }
        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValues --> callTypesMap --> '+callTypesMap);
        for( Task theTask : newTasks ){
            String whatId = theTask.whatId;
        	system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValues --> theTask --> '+theTask);            
        	system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValues --> whatId --> '+whatId);
            Task oldTask = oldTasksMap != null ? oldTasksMap.get( theTask.Id ) : null;
        	system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValues --> oldTask --> '+oldTask);            
            if( oldTask == null  || (( theTask.WhatId != oldTask.WhatId || theTask.Call_Type__c != oldTask.Call_Type__c ) &&
                    callTypesMap.containsKey( theTask.Call_Type__c )) ){
                if( whatId != null && whatId.startsWith('006') ){
                    tasks.add( theTask );
                }
            }
        }
        system.debug(LoggingLEvel.ERROR, 'Inside updateCallTypeValues --> tasks --> '+tasks);            
        if( !tasks.isEmpty() ){
            updateRelatedOpportunitiesOnUpsert( tasks, callTypesMap );
        }
    }

    private static void updateRelatedOpportunitiesOnUpsert( List<Task> newTasks, Map<String, CallTypetoOpportunityMapping__c> callTypesMap ){
        system.debug(LoggingLEvel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> newTasks --> '+newTasks);
        system.debug(LoggingLEvel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> callTypesMap --> '+callTypesMap);
        Map<Id, Opportunity> oppsToUpdateMap = new Map<Id, Opportunity>();
        Set<String> oppFields = new Set<String>();
        Map<Id, List<Task>> oppIdToTasksMap = new Map<Id, List<Task>>();

        for( CallTypetoOpportunityMapping__c cto : callTypesMap.values() ){
            oppFields.add( cto.Field_Name__c );
        }
        system.debug(LoggingLevel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> oppFields --> '+oppFields);        
        for( Task theTask : newTasks ){
            String whatId = theTask.whatId;
	        system.debug(LoggingLevel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> whatId --> '+whatId);        
            if( whatId != null && whatId.startsWith('006') ){
                if( oppIdToTasksMap.containsKey( whatId ) ){
                    oppIdToTasksMap.get( whatId ).add( theTask );
                }else{
                    oppIdToTasksMap.put( whatId , new List<Task>{ theTask } );
                }
            }
        }
        system.debug(LoggingLevel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> oppIdToTasksMap --> '+oppIdToTasksMap);
        if( !oppIdToTasksMap.isEmpty() && !oppFields.isEmpty() ){
            Map<Id, List<Task>> oppIdToAllTasks = TaskTriggerUtility.getOppIdToAllTasksMap(oppIdToTasksMap.keySet());


            for( Opportunity opp : Database.query(constructOpportunityQuery(oppIdToTasksMap.keySet(), oppFields)) ){
		        system.debug(LoggingLevel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> opp --> '+opp);                        
                List<Task> allTasks = oppIdToAllTasks.get(opp.Id);
                system.debug(LoggingLevel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> allTasks --> '+allTasks);
                if(allTasks != null && allTasks.size() > 0){ 
                	for( string field : oppFields ){
                        opp.put( field, false );
                    }
                    opp = updateOpportunityBasedOnRelatedTasks( opp, allTasks , callTypesMap );
                    if( opp != null ){
                        oppsToUpdateMap.put( opp.Id, opp );
                    }
                }
            }
            if( !oppsToUpdateMap.isEmpty() ){
                system.debug(LoggingLEvel.ERROR, 'Inside updateRelatedOpportunitiesOnUpsert --> oppsToUpdateMap --> '+oppsToUpdateMap);
                update oppsToUpdateMap.values();
            }
        }
    }

    public static Map<Id, List<Task>> getOppIdToAllTasksMap( Set<Id> oppIds){
        System.debug(LoggingLevel.ERROR, 'Inside getOppIdToAllTasksMap --> oppIds --> '+oppIds);        
        Map<Id, List<Task>> oppIdToAllTasksMap = new Map<Id, List<Task>>();
        //Get all the Tasks based on the OppIds
        List<Task> allTasksGivenOpp = [SELECT WhatId,Call_Type__c FROM Task WHERE WhatId in:oppIds];
        system.debug(LoggingLevel.ERROR, 'Inside getOppIdToAllTasksMap --> allTasksGivenOpp --> '+allTasksGivenOpp);

        //Lets build a Map
        for(Task t : allTasksGivenOpp){
            if(oppIdToAllTasksMap.containsKey(t.WhatId)){
                oppIdToAllTasksMap.get(t.whatId ).add(t);
            }else {
                List<Task> taskList=new List<Task>();
                taskList.add(t);
                oppIdToAllTasksMap.put(t.whatId,taskList);            }
        }
        system.debug(LoggingLevel.ERROR, 'Inside getOppIdToAllTasksMap --> oppIdToAllTasksMap --> '+oppIdToAllTasksMap);
        return oppIdToAllTasksMap;
    }

    private static Opportunity updateOpportunityBasedOnRelatedTasks( Opportunity opp, List<Task> tasks,
            Map<String, CallTypetoOpportunityMapping__c> callTypesMap ){
        system.debug(LoggingLEvel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> opp --> '+opp);
        system.debug(LoggingLEvel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> tasks --> '+tasks);
        system.debug(LoggingLEvel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> callTypesMap --> '+callTypesMap);
        for( Task task : tasks ){
            if( callTypesMap.containsKey( task.Call_Type__c ) ){
                CallTypetoOpportunityMapping__c cto = callTypesMap.get( task.Call_Type__c );
                if( opp.get( cto.Field_Name__c ) != cto.Value__c ){
        			system.debug(LoggingLEvel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> HERE --> ');
                    opp.put( cto.Field_Name__c, cto.Value__c );
                }
            }
        }
        system.debug(LoggingLEvel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> opp --> '+opp);
        return opp;
    }

    private static String constructOpportunityQuery( Set<Id> oppIds, Set<String> oppFields ){
        string idList = '(';
        for( Id oppId : oppIds ){
            idList += '\'' + oppId + '\',';
        }
        if( idList.endsWith(',') ){
            idList = idList.substring(0, idList.length() - 1 );
            idList += ')';
        }
        String query = 'SELECT Id , ';
        for( String field : oppFields ){
            query += field + ' , ';
        }
        if( query.endsWith(' , ') ){
            query = query.substring( 0, query.length() - 3 );
        }
        query += ' FROM Opportunity WHERE Id IN ' + idList ;
        system.debug(LoggingLevel.ERROR, 'Inside updateOpportunityBasedOnRelatedTasks --> query --> '+query);
        return query;
    }

    public static void checkIfCLevelCompletedOnePerOpp(List<Task> newTasks){
        Map<Id,Decimal> OppIdToCLevelConnect = new Map<Id,Decimal>();
        AggregateResult[] groupedResult = [SELECT WhatId, what.type, count(Id) countOfRecords
        FROM Task
        WHERE Call_Type__c = 'C-level connect completed' AND
        what.type = 'Opportunity'
        GROUP BY WhatId,what.type];
        for(AggregateResult ar : groupedResult) {
            if(!OppIdToCLevelConnect.containsKey((String)ar.get('WhatId'))) {
                OppIdToCLevelConnect.put((String)ar.get('WhatId'), (Decimal)ar.get('countOfRecords'));
            }
        }

        for(Task t : newTasks){
            if(t.Call_Type__c == 'C-level connect completed' && OppIdToCLevelConnect.containsKey(t.WhatId)) {
                if(OppIdToCLevelConnect.get(t.WhatId) > 1) {
                    t.addError('There is already a C-level connect completed associated with this Opportunity. Please select another Call Type');
                }
            }
        }
    }

    public static void validateCLevelConnect(List<Task> newTasks){
        for(Task t : newTasks){
            if(t.Call_Type__c == 'C-level connect completed'
                    || t.Call_Type__c == 'C-level connect scheduled - Email/LinkedIn'
                    || t.Call_Type__c == 'C_level_connect_scheduled_Call'
                    || t.Call_Type__c == 'Stakeholder connect scheduled - Call'
                    || t.Call_Type__c == 'Stakeholder connect scheduled - Email'
                    || t.Call_Type__c == 'Stakeholder connect completed'){
                if(t.whoId == null){
                    t.whoId.addError('A Contact or Lead is required for a '+ t.Call_Type__c);
                }
            }
        }
    }
}