trigger FridgeLogTrigger on Fridge_Log__e (after insert) {
    FridgeLogTriggerHandler.handleEvent((List<Fridge_Log__e>)Trigger.new);
}