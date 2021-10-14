public class OrderTriggerRender {
    public void CalculateNetAmountOrder(List<Order> newOrders) {
        /* This is the before trigger method.
        net amount is calculated with : (total mount - shipmentCost)
        the method takes a Trigger.new as parameter, which corresponds 
        to a list of Order, "newOrders". */
        for(Order o : newOrders) {
            /* for each order of this list, if there is a shipment cost, then
            calculate net amount. If not, set value of net amount equal to total amount */
            if(o.ShipmentCost__c != null) {
                o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            } else { 
                o.NetAmount__c = o.TotalAmount;
            }
        }}
    public void CalculateTurnoverAccounts(List<Order> newOrders, Map<Id, Order> mapOldOrders) {
        //create new set of IDs, then query for accounts-turnover and orders-netAmount with new set of ids
        set<Id> setAccountIds = new set<Id>();
        //for each orders in the list of triggered orders, add the new set of Ids to AccountID
        //for each order of the triggered orders list, if relative account id is not null, add this id to the list of account ids
        for(Order o : newOrders) {
            if (o.AccountId != null) {
            setAccountIds.add(o.AccountId);
        }}
        //query elements from Account & Orders that we need.
        List<Account> accountListToUpdate = [SELECT Id, Chiffre_d_affaire__c, 
        (SELECT Id,TotalAmount, NetAmount__c FROM Orders WHERE Status = 'Activated') 
        FROM Account WHERE Id IN : setAccountIds];

        //for each account in the queried list (create decimal variable)
        for(Account a : accountListToUpdate) {
            Decimal ChiffreAffaire = 0;
            //for each order in each account of the list add net amount to the variable ChiffreAffaire.
            for(Order o : a.Orders) {
                ChiffreAffaire += o.NetAmount__c;
            }
            a.Chiffre_d_affaire__c = ChiffreAffaire;
        }
        //Outside the loop, we update the account list and their orders.
        update accountListToUpdate;
    }
}