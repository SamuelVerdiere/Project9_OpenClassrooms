global class UpdateTurnoverBatch implements Database.Batchable<sObject>{
    /*batch qui implémente la database batchable pour mettre à jour le CA des comptes*/
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        /* revoir la requête : start est appelée au début du job apex.
        elle collecte les records sur lesquels l'opération doit être faite.
        Ce srecords seront divisés en sous tâche et passés à execute*/
        return Database.getQueryLocator('SELECT Id FROM Account');
        /*Ici  Database.getQueryLocator retourne un Query Locator qui exécute les listes de requêtes 
        SOQL sélectionnées qui peuvent être itérées dans le batch apex ou 
        utilisées pour afficher de grands ensembles dans VF.
         */
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){ 
        /*execute pratique l'opération qu'on veut faire sur les records
        qu'on a récupérés avec start */
        /* La méthode ici prend une liste de comptes  */
        Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
        /*cette ligne crée une nouvelle Map depuis la liste, en utilisant
        un constructeur spécial; puis prend l'ensemble des clés de la Map
        par la méthode keyset(). La map sort ensuite du scope et son heap space
        est libéré = efficace pour le gouverneur*/
        AP01Account.updateChiffreAffaire(setAccountIds);  //cette fonction ni cette classe n'existent ?
    }
     
    global void finish(Database.BatchableContext info){     
        /* s'exécute après la fin de tous les batches. */
    } 
 }