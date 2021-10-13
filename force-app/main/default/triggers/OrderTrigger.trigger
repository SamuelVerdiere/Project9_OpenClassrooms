trigger OrderTrigger on Order (before update, after update) {
   OrderTriggerRender MyOrder = new OrderTriggerRender();
    if(Trigger.isBefore) {
        MyOrder.CalculateNetAmountOrder(Trigger.new);
    }
    if(Trigger.isAfter) {
        MyOrder.CalculateTurnoverAccounts(Trigger.new, Trigger.OldMap);
    }
}