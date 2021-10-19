@isTest
public with sharing class AccountTurnoverUpdateBatchTest {
    /* This test class will perform tests relative to the batch for updating Account turnover.
    It will test scenarios from the batch's logic. */

    @isTest
    static void AssumeAllAccountsAreUpdated() {
        //GIVEN : create variables and expected turnover
        Integer numOfAccount = 10;
        Integer numOfOrders = 100;
        Integer numOfOrderItems = 1;
        Integer UnitPrices = 6500;
        Integer ShipCosts = 500;
        Decimal expectedTurnover = Decimal.valueOf((numOfOrders * numOfOrderItems * UnitPrices) - (numOfOrders * ShipCosts));
        // create data and lists 
        DataFactory.createOrders(numOfAccount, numOfOrders, numOfOrderItems, UnitPrices, ShipCosts);
        List<Account> UpdateAccounts = new List<Account>();
        List<Account> AccountsUpdated = new List<Account>();
        List<Order> OrdersToUpdate = new List<Order>();
        UpdateAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status='Draft') FROM Account];
        //WHEN : execute test
        Test.startTest();
        for(Account acc : UpdateAccounts) {
            for(Order ord : acc.Orders) {
                ord.Status = 'Ordered'; 
                OrdersToUpdate.add(ord);
            }}
        update OrdersToUpdate;
        AccountTurnoverUpdateBatch atub = new AccountTurnoverUpdateBatch();
        Id batchId = Database.executeBatch(atub);
        Test.stopTest();
        //THEN : assert result
        AccountsUpdated = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')];
        //the first list of created account must be equal to the list of updated accounts
        for(Account a : AccountsUpdated) {
            System.assertEquals(numOfAccount, AccountsUpdated.size(), 'ERROR : Not all Accounts were updated.');
        }
        //the turnover for each account must be equal to the one expected, depending on the variables
        for(Account acc : AccountsUpdated) {
            System.assertEquals(expectedTurnover, acc.Chiffre_d_affaire__c, 'Error : incorrect turnover value. Expected: '
            + expectedTurnover + 'CA field: ' + acc.Chiffre_d_affaire__c); 
        }}
}