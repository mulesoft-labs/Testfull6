/**
Last modified by Andreas Slovacek
Last modified date 11 July 2016

Changelog:

11 July 2016 - Andreas: On insert process with trigger.new constructor.  On Update
                        check that the Role field changed, otherwise do not process.
*/
trigger UserTrigger on User (before update,before insert) {
    if( Trigger.isInsert){
        RoleBasedFieldHandler.process(trigger.new); 
    }// end if( Trigger.isInsert)
    else{
        RoleBasedFieldHandler.process(trigger.new, trigger.old);
    }// end else
    
}// end trigger UserTrigger on User (before update,before insert)