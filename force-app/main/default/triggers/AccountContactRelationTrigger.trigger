trigger AccountContactRelationTrigger on AccountContactRelation (before insert, after insert, before update, after update) {
new AccountContactRelationTriggerHandler().run();
}