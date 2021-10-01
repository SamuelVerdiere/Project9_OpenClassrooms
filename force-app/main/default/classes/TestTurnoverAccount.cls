@isTest
public with sharing class TestTurnoverAccount {
    public static void  TestUpdatingTurnoverAfterInsert() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 2, 2, 10, 1);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
        Test.stopTest();
        //THEN : assert resu
        for(AggregateResult sor : SumOfResults) {
            //1 account * 2 orders * 2 items * 10€ - 1*2 shipment cost = 38
            System.assertEquals(38, sor.get('totality'));
        }
    }
    public static void  testUpdatingTurnoverAfterDeletion() {
        //GIVEN : create data
        TestDataFactory.testupdateStatusAndDeleteOrderItem(2,2,4,100,10);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
        Test.stopTest();
        //THEN : assert result
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(0, sor.get('totality'));
        }
    }
    public static void  TestAccountCreation() {
        //GIVEN : create data        
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(162, 2, 2, 10, 1);
        List<Account> numberOfAccounts;
        //WHEN : execute test
        Test.startTest();
        numberOfAccounts = [SELECT ID FROM Account WHERE Name LIKE '%Testing%'];
        Test.stopTest();
        //THEN : assert result
        for(Account noa : numberOfAccounts) {
            System.assertEquals(162, numberOfAccounts.size());
        }
    }
    public static void  TestOrderCreation() {
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(10,50,2,10,1);
        List<Order> numberOfOrders;
        //WHEN : execute test
        Test.startTest();
        numberOfOrders= [SELECT ID FROM Order];
        Test.stopTest();
        //THEN : assert result
        for(Order noo : numberOfOrders) {
            System.assertEquals(500, numberOfOrders.size());
        }
    }
    public static void  TestOrderItemCreation() {
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(25,1,10,10,1);
        List<OrderItem> numberOfOrderItems;
        //WHEN : execute test
        Test.startTest();
        numberOfOrderItems= [SELECT ID FROM OrderItem];
        Test.stopTest();
        //THEN : assert result
        for(OrderItem noi : numberOfOrderItems) {
            System.assertEquals(250, numberOfOrderItems.size());
        }
    }
}