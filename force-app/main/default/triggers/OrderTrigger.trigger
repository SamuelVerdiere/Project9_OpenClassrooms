trigger OrderTrigger on Order (before update, after update) {
    if(Trigger.isBefore) {
        OrderTriggerRender.OrderTriggerBefore(Trigger.new);
    }
    if(Trigger.isAfter) {
        OrderTriggerRender.OrderTriggerAfter(Trigger.new);
    }
}