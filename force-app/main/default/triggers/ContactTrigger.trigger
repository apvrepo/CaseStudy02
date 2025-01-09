trigger ContactTrigger on Contact (before insert, after insert, before update, after update, after delete) {
   new ContactTriggerHandler().run();
}