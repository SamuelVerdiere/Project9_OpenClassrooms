@isTest
public with sharing class OrderTriggerTest {
    /* This test class will perform many methods relative to the Order Triggers.
    It will test standard scenario, extreme scenariis, conditions inside the triggers logic
    such as comparing net and total amount and difference caused by shipment cost. */
    @isTest
    public static void TestNetAmountMultipleObjects() {
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
    public static void TestAmountWith200Orders() {
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
    public static void TestIfNetAmountEqualsTotalAmount() {
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
    public static void TestDifferenceByShipmentCost() {
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


    // @isTest
    // public static void TestNetAmountWithShipmentCost() {
    //     /* the test method from the factory takes as parameters :
    //     - The Number of Accounts needed
    //     - The Number of Orders per Accound needed
    //     - The quantity of Items per order
    //     - The Unit Price of each item
    //     - The Shipment Cost for each item */
    //     //GIVEN : create data
    //     TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 5, 1, 2000, 500);
    //     List<AggregateResult> SumOfResults;
    //     //WHEN : execute test
    //     Test.startTest();
    //     SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
    //     Test.stopTest();
    //     //THEN : Assert result
    //     for(AggregateResult sor : SumOfResults) {
    //         //15 orders at 2000 = 10 000, minus 5*500 = 2500 = 7500 
    //         System.assertEquals(7500, sor.get('total'));
    //     }
    // }
    // @isTest
    // public static void TestNetAmountEqualsTurnover() {
    //      /* the test method from the factory takes as parameters :
    //     - The Number of Accounts needed
    //     - The Number of Orders per Accound needed
    //     - The quantity of Items per order
    //     - The Unit Price of each item
    //     - The Shipment Cost for each item */
    //     //GIVEN : create data
    //     TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 1, 1, 1000, 50);
    //     List<AggregateResult> CompareResults;
    //     //WHEN: execute test
    //     Test.startTest();
    //     CompareResults = [SELECT SUM(Account.Chiffre_d_affaire__c) totalCA, SUM(NetAmount__c) totalNA FROM Order];
    //     Test.stopTest();
    //     //THEN : Assert result
    //     for(AggregateResult cr : CompareResults) {
    //     System.assertEquals(cr.get('totalCA'), cr.get('totalNA'));
    // }}
    // // @isTest
    // // public static void TestNetAmountNotEqualToTurnover() {
    // //     /* the test method from the factory takes as parameters :
    // //     - The Number of Accounts needed
    // //     - The Number of Orders per Accound needed
    // //     - The quantity of Items per order
    // //     - The Unit Price of each item
    // //     - The Shipment Cost for each item */
    // //     //GIVEN : create data
    // //     TestDataFactory.TestCreateAccountWithTurnover(1, 1, 1, 1000, 50);
    // //     List<AggregateResult> CompareResults;
    // //     //WHEN : execute test
    // //     Test.startTest();
    // //     CompareResults = [SELECT SUM(Account.Chiffre_d_affaire__c) totalCA, SUM(NetAmount__c) totalNA FROM Order];
    // //     Test.stopTest();
    // //     //THEN : assert result
    // //     for(AggregateResult cr : CompareResults) {
    // //     System.assertNotEquals(cr.get('totalCA'), cr.get('totalNA'));
    // //     }
    // // }

    // @isTest
    // public static void TestNetAmountIfNoOrderItems() {
    //     /* the test method from the factory takes as parameters :
    //     - The Number of Accounts needed
    //     - The Number of Orders per Accound needed
    //     - The quantity of Items per order
    //     - The Unit Price of each item
    //     - The Shipment Cost for each item */
    //     //GIVEN : create data
    //     TestDataFactory.testupdateStatusAndDeleteOrderItem(1, 1, 3, 1000, 100);
    //     List<AggregateResult> SumOfResults;
    //     // WHEN : execute tests
    //     Test.startTest();
    //     SumOfResults = [SELECT SUM(NetAmount__c) total FROM Order];
    //     Test.stopTest();
    //     //THEN Assert results:
    //     for(AggregateResult sor : SumOfResults) {
    //         System.assertEquals(null, sor.get('total'));
    //     }}
    //     @isTest
    //     public static void TestUpdatingTurnoverAfterInsert() {
    //         /* the test method from the factory takes as parameters :
    //         - The Number of Accounts needed
    //         - The Number of Orders per Accound needed
    //         - The quantity of Items per order
    //         - The Unit Price of each item
    //         - The Shipment Cost for each item */
    //         //GIVEN : create data
    //         TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(1, 1, 1, 1000, 100);
    //         List<AggregateResult> SumOfResults;
    //         //WHEN : execute test
    //         Test.startTest(); //Insérer un update de champ d'order ici //créer order et tester sa mise à jour
    //         //récupérer les order = on en prend 1 ou tous et on le met à jour (statut, ou un autre champ)
    //         SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
    //         Test.stopTest();
    //         //THEN : assert result => on vérifie que la maj s'est bien déroulée et le trigger déclenché => le calcul du CA est-il OK ?
    //         for(AggregateResult sor : SumOfResults) { //on peut faire le calcul d'un seul élément pour voir s'il a le bon résultat
    //             //1 account * 1 order * 1 order item * 1000$ minus ship cost 100$ = 900
    //             System.assertEquals(900, sor.get('totality')); //le calcul dans le trigger est il égal à mon calcul ?
    //         }
    //     }
    //     @isTest
    //     public static void  testUpdatingTurnoverAfterDeletion() {
    //         /* the test method from the factory takes as parameters :
    //         - The Number of Accounts needed
    //         - The Number of Orders per Accound needed
    //         - The quantity of Items per order
    //         - The Unit Price of each item
    //         - The Shipment Cost for each item */
    //         //GIVEN : create data
    //         TestDataFactory.testupdateStatusAndDeleteOrderItem(2,2,4,10,10);
    //         List<AggregateResult> SumOfResults;
    //         //WHEN : execute test
    //         Test.startTest();
    //         SumOfResults = [SELECT SUM(Chiffre_d_affaire__c) totality FROM Account WHERE Id IN (SELECT AccountId FROM Order)];
    //         Test.stopTest();
    //         //THEN : assert result
    //         for(AggregateResult sor : SumOfResults) {
    //             //since we delete order items, the turnover should be 0
    //             System.assertEquals(null, sor.get('totality'));
    //         }
    //     }
        // @isTest
        // public static void  TestAccountCreation() {
        //     /* the test method from the factory takes as parameters :
        //     - The Number of Accounts needed
        //     - The Number of Orders per Accound needed
        //     - The quantity of Items per order
        //     - The Unit Price of each item
        //     - The Shipment Cost for each item */        
        //     //GIVEN : create data
        //     DataFactory.createOrders(200, 1, 1, 1, 1);        
        //     List<Account> numberOfAccounts;
        //     //WHEN : execute test
        //     Test.startTest();
        //     numberOfAccounts = [SELECT ID FROM Account];
        //     Test.stopTest();
        //     //THEN : assert result
        //     for(Account noa : numberOfAccounts) {
        //         //simply create 5 accounts
        //         System.assertEquals(200, numberOfAccounts.size());
        //     }
        // }
        // @isTest
        // public static void  TestOrderCreation() {
        //     /* the test method from the factory takes as parameters :
        //     - The Number of Accounts needed
        //     - The Number of Orders per Accound needed
        //     - The quantity of Items per order
        //     - The Unit Price of each item
        //     - The Shipment Cost for each item */
        //     //GIVEN : create data
        //     TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(2,10,1,1,1);
        //     List<Order> numberOfOrders;
        //     //WHEN : execute test
        //     Test.startTest();
        //     numberOfOrders= [SELECT ID FROM Order];
        //     Test.stopTest();
        //     //THEN : assert result
        //     for(Order noo : numberOfOrders) {
        //         //create 2 accounts, each with 10 orders, therefore 20 orders
        //         System.assertEquals(20, numberOfOrders.size());
        //     }
        // }
        // @isTest
        // public static void TestOrderItemCreation() {
        //     /* the test method from the factory takes as parameters :
        //     - The Number of Accounts needed
        //     - The Number of Orders per Accound needed
        //     - The quantity of Items per order
        //     - The Unit Price of each item
        //     - The Shipment Cost for each item */
        //     //GIVEN : create data
        //     TestDataFactory.TestCreateAndUpdateAccountProductsOrdersItems(2,2,20,1,1);
        //     List<OrderItem> numberOfOrderItems;
        //     //WHEN : execute test
        //     Test.startTest();
        //     numberOfOrderItems= [SELECT ID FROM OrderItem];
        //     Test.stopTest();
        //     //THEN : assert result
        //     for(OrderItem noi : numberOfOrderItems) {
        //         //create 2 accounts, each with 2 orders, each with 20 order items = 2*2*20 = 80
        //         System.assertEquals(80, numberOfOrderItems.size());
        //     }
        // }
    }