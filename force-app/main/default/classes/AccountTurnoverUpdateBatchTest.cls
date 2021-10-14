@isTest
public with sharing class AccountTurnoverUpdateBatchTest {
    /* This test class will perform many methods relative to the batch for updating Account turnover.
    It will test standard scenario, extreme scenarii and conditions inside the batch's logic. */

    @isTest
    static void AssumeAllAccountsAreUpdated() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create date
        Integer numOfAccount = 208;
        Integer numOfOrders = 252;
        Integer numOfOrderItems = 10;
        Integer UnitPrices = 6500;
        Integer ShipCosts = 500;
        Decimal expectedTurnover = Decimal.valueOf((numOfAccount * numOfOrders * numOfOrderItems * UnitPrices) - (numOfOrders * ShipCosts));
        DataFactory.createOrders(numOfAccount, numOfOrders, numOfOrderItems, UnitPrices, ShipCosts);
        List<Account> UpdateAccounts = new List<Account>();
        List<Account> AccountsUpdated = new List<Account>();
        UpdateAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status='Draft') FROM Account];
        for(Account acc : UpdateAccounts) {
        for(Order ord : acc.Orders) {
            ord.Status = 'Activated'; 
        }}
        update UpdateAccounts;
        //WHEN : execute test
        Test.startTest();
        AccountTurnoverUpdateBatch atub = new AccountTurnoverUpdateBatch();
        Id batchId = Database.executeBatch(atub);
        Test.stopTest();
        //THEN : assert result
        AccountsUpdated = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')];
        for(Account a : AccountsUpdated) {
            System.assertEquals(numOfAccount, AccountsUpdated.size(), 'ERROR : Not all Accounts were updated.');
        }
        for(Account acc : AccountsUpdated) {
            System.assertEquals(expectedTurnover, acc.Chiffre_d_affaire__c, 'Error : incorrect turnover value'); 
        }
    }
}
// 58 500 000 - 225 000
// ship cost : 225 000
