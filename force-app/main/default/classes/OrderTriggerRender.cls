public with sharing class OrderTriggerRender {
    public OrderTriggerAfter() {
        //après l'update des ordres;
        //on crée un nouvel ensemble d'ID
        set<Id> setAccountIds = new set<Id>();
        //on crée un indice de trigger.new; la liste de comptes requête Id, CA pour les comptes dont l'ID = id des objets triggered
        Order newOrder= trigger.new[i];
        List<Account> accountListToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
        //pour chaque objet triggered, le CA du compte est calculé en = CA du compte + montant total des orders
        for(integer i=0; i< trigger.new.size(); i++) {
            accountListToUpdate.Chiffre_d_affaire__c = accountListToUpdate.Chiffre_d_affaire__c + newOrder.TotalAmount;
        }
        //en dehors de la boucle on met à jour les comptes
        update accountListToUpdate;
    }
    public OrderTriggerBefore() {
        //avant l'update des ordres
        //new trigger
        Order newOrder= trigger.new[0];
        //le net amount est calculé en montant total - coût de livraison
        newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }
}