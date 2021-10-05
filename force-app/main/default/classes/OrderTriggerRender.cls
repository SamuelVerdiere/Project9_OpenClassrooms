public with sharing class OrderTriggerRender {
    public void CalculateTurnoverAccounts(List<Order> newOrders) {
        //après l'update des ordres
        set<Id> setAccountIds = new set<Id>();
        for(Order o : newOrders) {
            setAccountIds.add(o.AccountId);
        }
        //on crée un indice de trigger.new; la liste de comptes requête Id, CA pour les comptes dont l'ID = id des objets triggered
        //récupérer tous les orders pour chaque account avec une requête imbriquée
        List<Account> accountListToUpdate = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id,NetAmount__c FROM Orders) FROM Account WHERE Id IN : setAccountIds];
        //pour chaque objet triggered, le CA du compte est calculé en = CA du compte + montant total des orders
        for(Account a : accountListToUpdate) {
            Decimal ChiffreAffaire = 0;
            for(Order o : a.Orders) {
                ChiffreAffaire = ChiffreAffaire + o.NetAmount__c; //ajouté champ ???
                //on obtient la liste des ordres du compte en question ^ puis on calcule 
            }
            //on donne à la variable int la valeur qu'on a calculée juste avant
            a.Chiffre_d_affaire__c = ChiffreAffaire;
        }
        //en dehors de la boucle on met à jour les comptes
        update accountListToUpdate;
    }
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
}}}
//créer account + orders + produits et tester ! 