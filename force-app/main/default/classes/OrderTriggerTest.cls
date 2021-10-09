@isTest
public with sharing class OrderTriggerTest {
    /* This test class will perform many methods relative to the Order Triggers.
    It will test standard scenario, extreme scenariis, conditions inside the triggers logic
    such as comparing net and total amount and difference caused by shipment cost. */

    /* TESTS IN BEFORE TRIGGER CONTEXT */
    @isTest
    public static void CalculateNetAmountMultipleObjects() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(2, 3, 6, 1000, 100);
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Activated'; }
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            //2 accounts, each has 3 orders = 6 orders. Each order has 6 order items at 1000$ = 36000$ 
            // minus 6 * 100 shipment cost (per order) = 35400$: 
            System.assertEquals(35400, sor.get('total'));
        }
    }
    @isTest
    public static void CalculateAmountWith200Orders() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(200, 1, 1, 1000, 0);
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Activated'; }
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(200000, sor.get('total'));
        }
    }
    @isTest
    public static void CheckIfNetAmountEqualsTotalAmount() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(10, 2, 3, 1000, 0);
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Activated'; }
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) netamt, SUM(TotalAmount) totalamt FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            System.assertEquals(sor.get('netamt'), sor.get('totalamt'));
        }
    }
    @isTest
    public static void CalculateDifferenceByShipmentCost() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(10, 2, 3, 1000, 500);  
        // 10*2*3*1000 = 60 000, minus 10*2*500 = 10 000
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Activated'; }
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) netamt, SUM(TotalAmount) totalamt FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
        Decimal getNetAmt = (Decimal)sor.get('netamt');
        Decimal gettotalamt = (Decimal)sor.get('totalamt');
            System.assertEquals(10000, (gettotalamt - getNetAmt));
        }
    }
    @isTest
    public static void CheckIfChangeOccuredInOrder() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(10, 2, 3, 500, 0);
        List<AggregateResult> SumOfResults;
        List<AggregateResult> BeforeResults;
        List<AggregateResult> FinalResult;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount, (SELECT Id, UnitPrice, OrderId FROM OrderItems) 
        FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Activated'; }
        update UpdateOrders;
        BeforeResults = [SELECT SUM(NetAmount__c) oldamt FROM Order];
        for(Order upor : UpdateOrders) {
            for(OrderItem oi : upor.OrderItems) {
                            oi.UnitPrice = 1000; }}
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) newamt FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            for(AggregateResult br : BeforeResults) {
            Decimal oldPrice = (Decimal)br.get('oldamt');
            Decimal newPrice = (Decimal)sor.get('newamt');
            System.assertEquals(oldPrice, newPrice, 'Difference is : ' + (newPrice - oldPrice) + ' . '); //VOIR SI POSSIBLE ?
    }}
    }
    /* TESTS IN AFTER TRIGGER CONTEXT */
    @isTest
    public static void UpdateTurnoverAfterNetAmount() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(2, 3, 6, 1000, 0);
        List<AggregateResult> SumOfResults;
        List<AggregateResult> Netamonts;
        //List<Order> UpdateOrders = new List<Order>();
        List<Account> UpdateAccounts = new List<Account>();
        UpdateAccounts = [SELECT Id, Chiffre_d_affaire__c,  (SELECT Id,NetAmount__c FROM Orders WHERE Status='Draft') FROM Account];
        //UpdateOrders = [SELECT Id, Status, NetAmount__c FROM Order];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Account acc : UpdateAccounts) {
            for(Order ord : acc.Orders) {
                ord.Status = 'Activated';
            }}
        update UpdateAccounts;
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) turnover FROM Account];
        Netamonts = [SELECT SUM(NetAmount__c) netamt FROM Order];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            for(AggregateResult na : Netamonts) {
            //the turnover must be updated and = to net amount after order is updated
            System.assertEquals(sor.get('turnover'), sor.get('netamt'));
        }}
    }
    }