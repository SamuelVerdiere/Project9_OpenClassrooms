global class AccountTurnoverUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Integer processedRecords = 0;
	global Database.QueryLocator start(Database.BatchableContext info) {
        //we perform a precise query to get accounts with turnover and their relative orders, which are activated
        return Database.getQueryLocator([SELECT Id, Chiffre_d_affaire__c, 
        (SELECT AccountId, 
        NetAmount__c 
        FROM Orders
        WHERE Status ='Activated') 
        FROM Account]
        );
    }

    global void execute(Database.BatchableContext info, List<Account> scope){   
        //for each account in the scope, admit the turnover with value 0;
        for(Account a : scope) {
            a.Chiffre_d_affaire__c = 0;
            //then if relative orders exist and there is at least 1 of them,
                if(a.Orders != null && a.Orders.size() > 0) {
                    //for each order,
                    for(Order o : a.Orders) {
                        //if net amount exists, calculate the turnover value.
                        if(o.NetAmount__c != null) {
                    a.Chiffre_d_affaire__c += o.NetAmount__c;
                }}}
                //count 1 record done for the job
                processedRecords += 1;
            }
            //update the scope of account list
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