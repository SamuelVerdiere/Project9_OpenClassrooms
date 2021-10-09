public with sharing class OrderTriggerRender {
    public void CalculateNetAmountOrder(List<Order> newOrders) {
        //avant l'update des ordres
        //le net amount est calculé en montant total - coût de livraison
        for(Order o : newOrders) {
            //si le shipment cost n'est pas renseigné = net amout égal total amount
            if(o.ShipmentCost__c != null) {
        o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            } else { 
                o.NetAmount__c = o.TotalAmount;
            }
        }}
    public void CalculateTurnoverAccounts(List<Order> newOrders, Map<Id,Order> mapOldOrders) { //, Map<Id,Order> mapOldOrders
        //create new set of IDs, then query for accounts-turnover and orders-netAmount with new set of ids
        set<Id> setAccountIds = new set<Id>();
        //for each orders in the list of triggered orders, add the new set of Ids to AccountID
        List<Account> accountListToUpdate = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id,NetAmount__c FROM Orders) 
        FROM Account WHERE Id IN : setAccountIds];
        for(Order o : newOrders) {
            setAccountIds.add(o.AccountId);
        }
        //for each account in the queried list (create decimal variable)
        for(Account a : accountListToUpdate) {
            Decimal ChiffreAffaire = 0;
            //for each order in the account list, get netAmount's previous value
            for(Order o : a.Orders) {
                Order oldOrder = mapOldOrders.get(o.Id);
                Decimal oldAmount = oldOrder.NetAmount__c;
                //if order status is Activated and net amount has changed; calculate turnover sum
                if((o.Status == 'Activated') && (o.NetAmount__c != oldAmount)) {
                ChiffreAffaire = ChiffreAffaire + o.NetAmount__c; 
            }}
            a.Chiffre_d_affaire__c = ChiffreAffaire;
        }
        //update the list of accounts with correct turnover
        update accountListToUpdate;
    }
}