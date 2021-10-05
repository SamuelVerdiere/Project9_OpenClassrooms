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
        //THEN : assert result
        for(AggregateResult sor : SumOfResults) {
            //1 account * 1 order * 1 order item * 1000$ minus ship cost 100$ = 900
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
            //since we delete order items, the turnover should be 0
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
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(200, 1, 1, 1, 1);        
        List<Account> numberOfAccounts;
        //WHEN : execute test
        Test.startTest();
        numberOfAccounts = [SELECT ID FROM Account];
        Test.stopTest();
        //THEN : assert result
        for(Account noa : numberOfAccounts) {
            //simply create 5 accounts
            System.assertEquals(200, numberOfAccounts.size());
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
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(2,10,1,1,1);
        List<Order> numberOfOrders;
        //WHEN : execute test
        Test.startTest();
        numberOfOrders= [SELECT ID FROM Order];
        Test.stopTest();
        //THEN : assert result
        for(Order noo : numberOfOrders) {
            //create 2 accounts, each with 10 orders, therefore 20 orders
            System.assertEquals(20, numberOfOrders.size());
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
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(2,2,20,1,1);
        List<OrderItem> numberOfOrderItems;
        //WHEN : execute test
        Test.startTest();
        numberOfOrderItems= [SELECT ID FROM OrderItem];
        Test.stopTest();
        //THEN : assert result
        for(OrderItem noi : numberOfOrderItems) {
            //create 2 accounts, each with 2 orders, each with 20 order items = 2*2*20 = 80
            System.assertEquals(80, numberOfOrderItems.size());
        }
    }
}