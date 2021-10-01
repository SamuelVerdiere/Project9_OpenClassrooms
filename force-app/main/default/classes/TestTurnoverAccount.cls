@isTest
public with sharing class TestTurnoverAccount {
    static testMethod TestUpdatingTurnoverAfterInsert() {
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items + number of items created
        //GIVEN : values created by these methods
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(200,50, 100);
        TestDataFactory.TestCreateOrderItem(200,50, 5);
        TestDataFactory.updateOrderStatus();
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
        Test.stopTest();
        //THEN : assert resu
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(600000, sor.get('totality'));
        }
    }
    static testMethod TestUpdatingTurnoverAfterDeletion() {
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items + number of items created
        //GIVEN : values created by these methods
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(200,50, 100);
        TestDataFactory.TestCreateOrderItem(200,50, 5);
        TestDataFactory.updateOrderStatus();
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
    static testMethod TestAccountCreation() {
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items + number of items created
        //GIVEN : values created by these methods
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(162,50, 100);
        TestDataFactory.TestCreateOrderItem(162,50, 5);
        TestDataFactory.updateOrderStatus();
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        numberOfAccounts = [SELECT ID FROM Account WHERE Name LIKE '%Testing%'];
        Test.stopTest();
        //THEN : assert result
        for(AggregateResult noa : numberOfAccounts) {
            System.assertEquals(162, numberOfAccounts.size());
        }
    }
    static testMethod TestOrderCreation() {
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items + number of items created
        //GIVEN : values created by these methods
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(10,10, 100);
        TestDataFactory.TestCreateOrderItem(10,10,5);
        TestDataFactory.updateOrderStatus();
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        numberOfOrders= [SELECT ID FROM Order];
        Test.stopTest();
        //THEN : assert result
        for(AggregateResult noo : numberOfOrders) {
            System.assertEquals(500, numberOfOrders.size());
        }
    }
    static testMethod TestOrderItemCreation() {
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items + number of items created
        //GIVEN : values created by these methods
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(10,5, 100);
        TestDataFactory.TestCreateOrderItem(10,5,5);
        TestDataFactory.updateOrderStatus();
        List<AggregateResult> SumOfResults;
        //WHEN : execute test
        Test.startTest();
        numberOfOrderItems= [SELECT ID FROM OrderItem];
        Test.stopTest();
        //THEN : assert result
        for(AggregateResult noi : numberOfOrderItems) {
            System.assertEquals(250, numberOfOrderItems.size());
        }
    }
}