@isTest
public with sharing class TestTurnoverAccount {
    /* Turnover amount is the total amount  */
    @isTest
    public static void TestUpdatingTurnoverAfterInsert() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 1, 1, 1000, 100);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
        Test.stopTest();
        //THEN : assert resu
        for(AggregateResult sor : SumOfResults) {
            //1 account * 1 order * 
            System.assertEquals(900, sor.get('totality'));
        }
    }
    @isTest
    public static void  testUpdatingTurnoverAfterDeletion() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.testupdateStatusAndDeleteOrderItem(2,2,4,10,10);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
        Test.stopTest();
        //THEN : assert result
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(null, sor.get('totality'));
        }
    }
    @isTest
    public static void  TestAccountCreation() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */        
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(5, 1, 1, 1, 1);        
        List<Account> numberOfAccounts;
        //WHEN : execute test
        Test.startTest();
        numberOfAccounts = [SELECT ID FROM Account];
        Test.stopTest();
        //THEN : assert result
        for(Account noa : numberOfAccounts) {
            System.assertEquals(5, numberOfAccounts.size());
        }
    }
    @isTest
    public static void  TestOrderCreation() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1,50,1,1,1);
        List<Order> numberOfOrders;
        //WHEN : execute test
        Test.startTest();
        numberOfOrders= [SELECT ID FROM Order];
        Test.stopTest();
        //THEN : assert result
        for(Order noo : numberOfOrders) {
            System.assertEquals(50, numberOfOrders.size());
        }
    }
    @isTest
    public static void TestOrderItemCreation() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1,1,20,1,1);
        List<OrderItem> numberOfOrderItems;
        //WHEN : execute test
        Test.startTest();
        numberOfOrderItems= [SELECT ID FROM OrderItem];
        Test.stopTest();
        //THEN : assert result
        for(OrderItem noi : numberOfOrderItems) {
            System.assertEquals(20, numberOfOrderItems.size());
        }
    }
}