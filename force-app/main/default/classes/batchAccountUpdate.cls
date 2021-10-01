global class batchAccountUpdate implements Database.Batchable<sObject> {
        global Database.QueryLocator start(Database.BatchableContext info){ 
            //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
            return Database.getQueryLocator('SELECT Id FROM Account');
             /* Pour collecter les records ou objets à passer à la méthode interface Execute,
             on appelle cette méthode START ; elle retourne un objet Database.QueryLocator 
             qui contient les records des objets passés à EXECUTE.
             Le Database.QueryLocator suffit pour générer la portée des objets dans la tâche batch;
             ici la limite gouverneur pour le nombre total de records retrouvés par les requêtes SOQL 
             est outrepassé. Ici le getQueryLocator retourne tous les records
             comptes et leur Id. */
        }
        global void execute(Database.BatchableContext info, List<Account> scope){      
            list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order];
            //place dans une liste d'Order l'Id, le montant total de l'ordre et l'ID du compte relatif
             for(integer i=0; i < scope.size(); i++){ // pour  chaque compte de la liste
                 Account myAccount = scope[i];       // qui est ici représenté par myAccount
                 myAccount.Chiffre_d_affaire__c = 0;     // on place le CA à zéro
                for(integer j=0; j < listOrders.size(); j++){        // pour chaque liste d'ordres (contenant)
                                                                     //l'Id, montant total et id du compte relatif à l'ordre
                    if(listOrders[j].AccountId == myAccount.Id){     //si l'Id du compte relatif à l'ordre itéré = celui de la liste
                                                                     //récupérée par le getQueryLocator
                        myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + listOrders[j].TotalAmount;
                        //alors le champ chiffre d'affaire du compte = 0 + montant total des ordres relatifs
                    }}}
            update scope;  //on met à jour l'ensemble de la portée
        }
        global void finish(Database.BatchableContext info){     
             /* s'exécute après la fin de tous les batches. */
        } 
     }