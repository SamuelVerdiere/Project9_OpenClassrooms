@isTest
public with sharing class TestNetAmountOrder {
    @isTest
    public static void TestNetAmountMultipleOrders() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 15, 1, 1000, 0);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            //15 orders at 1000 means 
            System.assertEquals(15000, sor.get('total'));
        }
    }
    @isTest
    public static void TestNetAmountWithShipmentCost() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 5, 1, 2000, 500);
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            //15 orders at 2000 = 10 000, minus 5*500 = 2500 = 7500 
            System.assertEquals(7500, sor.get('total'));
        }
    }
    @isTest
    public static void TestNetAmountEqualsTurnover() {
         /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 1, 1, 1000, 50);
        List<AggregateResult> CompareResults;
        //WHEN: execute test
        Test.startTest();
        CompareResults = [SELECT SUM(Account.Chiffre_d_affaire__c) totalCA, SUM(NetAmount__c) totalNA FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult cr : CompareResults) {
        System.assertEquals(cr.get('totalCA'), cr.get('totalNA'));
    }}
    // @isTest
    // public static void TestNetAmountNotEqualToTurnover() {
    //     /* the test method from the factory takes as parameters :
    //     - The Number of Accounts needed
    //     - The Number of Orders per Accound needed
    //     - The quantity of Items per order
    //     - The Unit Price of each item
    //     - The Shipment Cost for each item */
    //     //GIVEN : create data
    //     TestDataFactory.TestCreateAccountWithTurnover(1, 1, 1, 1000, 50);
    //     List<AggregateResult> CompareResults;
    //     //WHEN : execute test
    //     Test.startTest();
    //     CompareResults = [SELECT SUM(Account.Chiffre_d_affaire__c) totalCA, SUM(NetAmount__c) totalNA FROM Order];
    //     Test.stopTest();
    //     //THEN : assert result
    //     for(AggregateResult cr : CompareResults) {
    //     System.assertNotEquals(cr.get('totalCA'), cr.get('totalNA'));
    //     }
    // }

    @isTest
    public static void TestNetAmountIfNoOrderItems() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        TestDataFactory.testupdateStatusAndDeleteOrderItem(1, 1, 3, 1000, 100);
        List<AggregateResult> SumOfResults;
        // WHEN : execute tests
        Test.startTest();
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
        Test.stopTest();
        //THEN Assert results:
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(null, sor.get('total'));
        }}
    }