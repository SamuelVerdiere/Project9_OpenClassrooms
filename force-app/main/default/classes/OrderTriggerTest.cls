@isTest
public with sharing class OrderTriggerTest {
    /* This test class will perform many methods relative to the Order Triggers.
    It will test standard scenario, extreme scenarii, conditions inside the triggers logic
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
        Decimal expectedResult = 35400;
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        Test.stopTest();
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order WHERE Status = 'Ordered'];
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            Decimal result = (Decimal)sor.get('total');
            System.assertEquals(expectedResult, result, 'Error: incorrect net amount value');
        }
    }
    @isTest
    public static void CalculateAmountWith200Accounts() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(200, 1, 1, 1000, 0);
        Decimal expectedResult = 200000;
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        Test.stopTest();
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order WHERE Status = 'Ordered'];
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
            Decimal result = (Decimal)sor.get('total');
            System.assertEquals(expectedResult, result, 'Error : incorrect net amount value.');
        }
    }

    @isTest
    public static void CalculateWith200AccountsAndMoreOrders() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(200, 2, 3, 6500, 500);
        Decimal expectedResult = 7600000;
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, ShipmentCost__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        Test.stopTest();
        //THEN : Assert result
        SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order WHERE Status = 'Ordered'];
        for(AggregateResult sor : SumOfResults) {
            Decimal result = (Decimal)sor.get('total');
            System.assertEquals(expectedResult, result, 'Error : incorrect net amount value.');
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
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.ShipmentCost__c = null;
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        Test.stopTest();
        //THEN : Assert result
        SumOfResults = [SELECT SUM(NetAmount__c) netamt, SUM(TotalAmount) totalamt FROM Order WHERE Status = 'Ordered'];
        for(AggregateResult sor : SumOfResults) {
            Decimal expectedResult = (Decimal)sor.get('netamt');
            Decimal result = (Decimal)sor.get('totalamt');
            System.assertEquals(expectedResult, result, 'Error : incorrect amount value.');
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
        Decimal expectedResult = 10000;
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) netamt, SUM(TotalAmount) totalamt FROM Order WHERE Status = 'Ordered'];
        Test.stopTest();
        //THEN : Assert result
        for(AggregateResult sor : SumOfResults) {
        Decimal getNetAmt = (Decimal)sor.get('netamt');
        Decimal gettotalamt = (Decimal)sor.get('totalamt');
            System.assertEquals(expectedResult, (gettotalamt - getNetAmt), 'Error : incorrect value.');
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
        Decimal expectedResult = 60000;
        List<AggregateResult> SumOfResults;
        List<AggregateResult> BeforeResults;
        List<Order> UpdateOrders = new List<Order>();
        List<OrderItem> OrderItems = new List<OrderItem>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, TotalAmount, (SELECT Id, UnitPrice, OrderId FROM OrderItems) 
        FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Order ord : UpdateOrders) {
            ord.Status = 'Ordered'; }
        update UpdateOrders;
        BeforeResults = [SELECT SUM(NetAmount__c) oldamt FROM Order WHERE Status = 'Ordered'];
        Decimal oldPrice = (Decimal)BeforeResults[0].get('oldamt');
        for(Order upor : UpdateOrders) {
            for(OrderItem oi : upor.OrderItems) {
                            oi.UnitPrice = 1000; 
                OrderItems.add(oi);
                }
            upor.Description = 'This is test description.';
        }
        update OrderItems;
        update UpdateOrders;
        SumOfResults = [SELECT SUM(NetAmount__c) newamt FROM Order WHERE Status = 'Ordered'];
        Decimal newPrice = (Decimal)SumOfResults[0].get('newamt');
        Test.stopTest();
        //THEN : Assert result
        System.assertNotEquals(oldPrice, newPrice, 'Error : difference is : ' + (newPrice - oldPrice) + ' . ');
        System.assertEquals(expectedResult, newPrice, 'Error : incorrect value.');
    }
    
    /* TESTS IN AFTER TRIGGER CONTEXT */
    @isTest
    public static void UpdateTurnoverIfNetAmount() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(5, 7, 2, 1000, 0);
        List<AggregateResult> SumOfResults;
        List<AggregateResult> Netamounts;
        List<Order> UpdateOrders = new List<Order>();
        List<Account> UpdateAccounts = new List<Account>();
        UpdateAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status='Draft') FROM Account];
        //WHEN : execute test
        Test.startTest();
        //first update order status
        for(Account acc : UpdateAccounts) {
            for(Order ord : acc.Orders) {
                ord.Status = 'Ordered';
            }}
        update UpdateAccounts;
        for(Account acc: UpdateAccounts) {
            for(Order ord : acc.Orders) {
                ord.ShipmentCost__c = 250;
                UpdateOrders.add(ord);
            }}
        update UpdateOrders;
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) turnover FROM Account];
        Netamounts = [SELECT SUM(TotalAmount) totalamt FROM Order];
        Test.stopTest();
        //THEN : Assert result
        Decimal turnover = (Decimal)SumOfResults[0].get('turnover');
        Decimal totalamount = (Decimal)Netamounts[0].get('totalamt');
            //the turnover must be updated and = to total amount after order is updated
        System.assertNotEquals(totalamount, turnover, 'Error : difference is ' + (totalamount - turnover) + ' .');
        }

        @isTest
        public static void UpdateTurnoverWithNetAmountManyOrders() {
            /* the test method from the factory takes as parameters :
            - The Number of Accounts needed
            - The Number of Orders per Accound needed
            - The quantity of Items per order
            - The Unit Price of each item
            - The Shipment Cost for each item */
            //GIVEN : create data
            DataFactory.createOrders(1, 200, 1, 1250, 0);
            set<Id> setAccountIds = new set<Id>();
            List<AggregateResult> SumOfResults;
            List<AggregateResult> TotalAmounts;
            List<Order> UpdateOrders = new List<Order>();
            UpdateOrders = [SELECT Id, TotalAmount, NetAmount__c, AccountId FROM Order WHERE Status='Draft'];
            //WHEN : execute test
            Test.startTest();
            //first update order status
            for(Order ord : UpdateOrders) {
                    ord.Status = 'Ordered';
                    setAccountIds.add(ord.AccountId);
            }
            update UpdateOrders;
            for(Order ord : UpdateOrders) {
                    ord.ShipmentCost__c = 250;
            }
            update UpdateOrders;
            SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) turnover FROM Account WHERE Id IN : setAccountIds];
            TotalAmounts = [SELECT SUM(TotalAmount) totalamt FROM Order WHERE Status = 'Ordered'];
            Test.stopTest();
            //THEN : Assert result
            Decimal turnover = (Decimal)SumOfResults[0].get('turnover');
            Decimal totalAmt = (Decimal)TotalAmounts[0].get('totalamt');
            Decimal difference = totalAmt - turnover;
            Decimal expectedResult = 50000;
            //the turnover must be updated and = to total amount after order is updated
            //shipment cost is 250 * 200 = 50 000 so this must be the difference between total amount and turnover
            System.assertNotEquals(totalAmt, turnover, 'Error : Difference is ' + (difference));
            System.assertEquals(expectedResult, difference);
            }

    @isTest
    public static void TestWithTwoHundredAccounts() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        DataFactory.createOrders(200, 1, 1, 1000, 0);
        Decimal expectedResult = 200000;
        set<Id> setAccountIds = new set<Id>();
        List<AggregateResult> SumOfResults;
        List<Order> UpdateOrders = new List<Order>();
        UpdateOrders = [SELECT Id, Status, NetAmount__c, AccountId FROM Order WHERE Status = 'Draft'];
        //WHEN : execute test
        Test.startTest();
        //first update order status
            for(Order ord : UpdateOrders) {
                ord.Status = 'Ordered';
                ord.Description = 'Test Description.';
                setAccountIds.add(ord.AccountId);
        }
        update UpdateOrders;
        Test.stopTest();
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) total FROM Account WHERE Id IN : setAccountIds];
        Decimal total = (Decimal)SumOfResults[0].get('total');
        //THEN : assert result
        System.assertEquals(expectedResult, total, 'Error : incorrect value.');
    }
    
    @isTest
    public static void CalculateIfTurnoverIsnotNull() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN : create data
        set<Id> setAccountIds = new set<Id>();
        Date myDate = Date.today();
        Date futureDate = myDate.addDays(8);
        DataFactory.createOrders(2, 4, 1, 1000, 0);
        List<AggregateResult> SumOfResults;
        List<Account> UpdateAccounts = new List<Account>();
        List<Order> UpdateOrders = new List<Order>();
        UpdateAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, Status, NetAmount__c, AccountId, Pricebook2Id FROM Orders WHERE Status = 'Draft')FROM Account];
        //WHEN : execute test
        Test.startTest();
        for(Account acc : UpdateAccounts) {
        for(Order ord : acc.Orders) {
                ord.Status = 'Ordered';
                UpdateOrders.add(ord);
        }}
        update UpdateAccounts;
        update UpdateOrders;
        DataFactory.createOrders(2, 4, 1, 1000, 0);
        List<Account> addAccounts = new List<Account>();
        addAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, Status, NetAmount__c, AccountId, Pricebook2Id FROM Orders WHERE Status = 'Draft')FROM Account];
        for(Account accts : addAccounts) {
            for(Order ord : accts.Orders) {
                ord.Status = 'Ordered';
                UpdateOrders.add(ord);
        }}
        update addAccounts;
        update UpdateOrders;
        SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) total FROM Account];
        Decimal total = (Decimal)SumOfResults[0].get('total');
        Test.stopTest();
        //THEN : Assert result
        /* the turnover should be 16000 : 
        2 accounts, each 4 order at 1000 = 8000   */
        System.assertEquals(16000, total);
    }
}