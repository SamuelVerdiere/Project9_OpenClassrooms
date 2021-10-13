public class OrderTriggerRender {
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
    public void CalculateTurnoverAccounts(List<Order> newOrders, Map<Id, Order> mapOldOrders) {
        //create new set of IDs, then query for accounts-turnover and orders-netAmount with new set of ids
        set<Id> setAccountIds = new set<Id>();
        //for each orders in the list of triggered orders, add the new set of Ids to AccountID
        for(Order o : newOrders) {
            if (o.AccountId != null) {
            setAccountIds.add(o.AccountId);
        }}
        List<Account> accountListToUpdate = [SELECT Id, Chiffre_d_affaire__c, 
        (SELECT Id,TotalAmount FROM Orders WHERE Status = 'Activated') 
        FROM Account WHERE Id IN : setAccountIds];
        //for each order of the triggered orders list, if relative account id is not null, add this id to the list of account ids
        //for each account in the queried list (create decimal variable) and get turnover amount
        for(Account a : accountListToUpdate) {
            Decimal ChiffreAffaire = 0;
            //for each order in each account of the list : get old and new net amount
            for(Order o : a.Orders) {
                ChiffreAffaire = ChiffreAffaire + o.NetAmount__c;
            //on donne à la variable int la valeur qu'on a calculée juste avant
            }
            a.Chiffre_d_affaire__c = ChiffreAffaire;
        //en dehors de la boucle on met à jour les comptes
        }
        update accountListToUpdate;
    }
}