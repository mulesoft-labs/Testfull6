trigger TMsUser on User (before insert,before update,after insert,after update, before delete, after delete) {
	new CMsUserTriggerHandler().handle();
}