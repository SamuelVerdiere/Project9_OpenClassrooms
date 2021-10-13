global class AccountTurnoverUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Integer processedRecords = 0;
	global Database.QueryLocator start(Database.BatchableContext info) {
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        return Database.getQueryLocator([SELECT Id, Chiffre_d_affaire__c, 
        (SELECT AccountId, 
        NetAmount__c 
        FROM Orders
        WHERE Status ='Activated') 
        FROM Account]
        );
    }

    global void execute(Database.BatchableContext info, List<Account> scope){      
        //Set<Id> setAccountIds = (new Map<Id, SObject>(scope)).keySet();
        for(Account a : scope) {
            a.Chiffre_d_affaire__c = 0;
                if(a.Orders != null && a.Orders.size() > 0) {
                    for(Order o : a.Orders) {
                        if(o.NetAmount__c != null) {
                    a.Chiffre_d_affaire__c += o.NetAmount__c;
                }}}
                processedRecords += 1;
            }
                update scope;
    }

    global void finish(Database.BatchableContext info){     
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :info.getJobId()
        ];
        System.debug(job);
        System.debug('There were ' + processedRecords + ' records processed.');
    } 
 }