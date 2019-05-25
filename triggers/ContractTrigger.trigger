trigger ContractTrigger on Contract (before insert,before update,after insert,after update, before delete, after delete) {
   new ContractTriggerHandler().handle();
}