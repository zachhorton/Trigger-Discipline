trigger ContactTrigger on Contact (after insert) {
    // if (Trigger.isInsert && Trigger.isAfter) {
    //     ContactTriggerHandler.MakeFollowUpTask(Trigger.New);
    // }
    TriggerX.handleTrigger( ContactTriggerHandler.class );
}