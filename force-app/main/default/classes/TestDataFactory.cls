
@isTest
public class TestDataFactory {
    public static void TestCreateAndUpdateAccountProductsOrdersItems(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount, 
    Integer ItemQuantity, Integer PriceUnit, Integer CostShipment) {
        /* this test method creates a user, product, a pricebook entry standard and custom, orders and orders items*/
        //Create product
        Product2 testProduct = new Product2(Name = 'Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), 
        Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
        insert testPriceBook;
        //get the standard price book ID
        //Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = testPriceBook.Id, 
        Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
        /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
        created and number of orders per account, by putting numbers in parameters. */
        //then variables for dates
        Date myDate = Date.today();
        Date futureDate = mydate.addDays(8);
        //Finally create lists for accounts and orders
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrderz = new List<Order>();
        //Then create 2 for loops, each increments depending on the number of accounts/orders.
        for (Integer i = 0; i < numberOfTestAccounts; i++) {
        //Create new accounts
        Account accountForTest = new Account(Name = 'Account for Testing ' + i);
        //place these accounts in the list
        testAccounts.add(accountForTest);
        }
        //create these accounts from the list.
        insert testAccounts;
        //this for loop increments depending of number of accounts selected
        for(Integer a = 0; a < numberOfTestAccounts; a++) {
        //accounts in the for loop are the ones from previous for loop
            Account testaccts = testAccounts[a];
            //this second for loop increments : starting with number of orders by increment;
            //as long as the index doesn't reach the number of order per acccount, which is at least 1, 
            //then increment. 
            for(Integer o = numberOfTestOrderPerAccount * a; o < numberOfTestOrderPerAccount * (a + 1); o++) {
                //on the test order list, add new orders whose account id is found in the list of accounts; 
                //the effective date is from the date variable; select a shipment cost and the product ID from the testPriceBookEntry. 
                //Finally, important the status is set on "draft".
                testOrderz.add(new Order(AccountID = testaccts.id, EffectiveDate = myDate, ShipmentCost__c = CostShipment, 
                Pricebook2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft'));
        }
        //finally the list of orders is created and has a corresponding account, id and status.
        try {
        insert testOrderz;
        } catch(Exception e) {
            System.debug('this occured: ' + e.getMessage());
        }
        }
        // Create Accounts with an Order
        //Create a list of Order Items
        List<OrderItem> testOrderItem = new List<OrderItem>();
        //starting at 0, as long as the number of order isn't reached, increment
        for (Integer oi = 0; oi < numberOfTestOrderPerAccount; oi++) {
        //variable testOrds corresponds to the testOrders list indexed with this for loop
            Order testOrds = testOrderz[oi];
            //this second for loop increments: starting with number of tests by increments;
            //as long as the index doesn't reach the number of accounts times the orders per account,
            //then increment.
            for(Integer napo = numberOfTestAccounts * ItemQuantity * oi; napo < numberOfTestAccounts * ItemQuantity * (oi + 1); napo++ ) {
                //in the orderItem list, add an order item, which price and quantity are determined by method parameter
                testOrderItem.add(new OrderItem(OrderID =testOrds.Id, Product2Id = testProduct.Id, PricebookEntryId = testPriceBookEntry.Id,
                    UnitPrice = testPriceBookEntry.UnitPrice, Quantity = ItemQuantity)
                );}}
                //insert the list of order items
        insert testOrderItem;
		//Update Status on Order to "Ordered"
		List<Order> listOfOrdersToUpdate = new List<Order>();
		for (Order ord : testOrderz) {
			ord.Status = 'Activated';
			listOfOrdersToUpdate.add(ord);
		}
        try {
		update listOfOrdersToUpdate;
        } catch (Exception e) {
            System.debug('it\'s here' + e.getMessage());
        }
    }
    public static void testupdateStatusAndDeleteOrderItem(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount, 
     Integer ItemQuantity, Integer PriceUnit, Integer CostShipment) {
        /* this test method creates a user, product, a pricebook entry standard and custom, orders and orders items*/
        //Create product
        Product2 testProduct = new Product2(Name = 'Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), 
        Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
        insert testPriceBook;
        //get the standard price book ID
        //Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = testPriceBook.Id, 
        Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
        /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
        created and number of orders per account, by putting numbers in parameters. */
        //then variables for dates
        Date myDate = Date.today();
        Date futureDate = mydate.addDays(8);
        //Finally create lists for accounts and orders
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrderz = new List<Order>();
        //Then create 2 for loops, each increments depending on the number of accounts/orders.
        for (Integer i = 0; i < numberOfTestAccounts; i++) {
        //Create new accounts
        Account accountForTest = new Account(Name = 'Account for Testing ' + i);
        //place these accounts in the list
        testAccounts.add(accountForTest);
        }
        //create these accounts from the list.
        insert testAccounts;
        //this for loop increments depending of number of accounts selected
        for(Integer a = 0; a < numberOfTestAccounts; a++) {
        //accounts in the for loop are the ones from previous for loop
            Account testaccts = testAccounts[a];
            //this second for loop increments : starting with number of orders by increment;
            //as long as the index doesn't reach the number of order per acccount, which is at least 1, 
            //then increment. 
            for(Integer o = numberOfTestOrderPerAccount * a; o < numberOfTestOrderPerAccount * (a + 1); o++) {
                //on the test order list, add new orders whose account id is found in the list of accounts; 
                //the effective date is from the date variable; select a shipment cost and the product ID from the testPriceBookEntry. 
                //Finally, important the status is set on "draft".
                testOrderz.add(new Order(AccountID = testaccts.id, EffectiveDate = myDate, ShipmentCost__c = CostShipment, 
                Pricebook2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft'));
        }
        //finally the list of orders is created and has a corresponding account, id and status.
        try {
        insert testOrderz;
        } catch(Exception e) {
            System.debug('this occured: ' + e.getMessage());
        }
        }
        // Create Accounts with an Order
        //Create a list of Order Items
        List<OrderItem> testOrderItem = new List<OrderItem>();
        //starting at 0, as long as the number of order isn't reached, increment
        for (Integer oi = 0; oi < numberOfTestOrderPerAccount; oi++) {
        //variable testOrds corresponds to the testOrders list indexed with this for loop
            Order testOrds = testOrderz[oi];
            //this second for loop increments: starting with number of tests by increments;
            //as long as the index doesn't reach the number of accounts times the orders per account,
            //then increment.
            for(Integer napo = numberOfTestAccounts * ItemQuantity * oi; napo < numberOfTestAccounts * ItemQuantity * (oi + 1); napo++ ) {
                //in the orderItem list, add an order item, which price and quantity are determined by method parameter
                testOrderItem.add(new OrderItem(OrderID =testOrds.Id, Product2Id = testProduct.Id, PricebookEntryId = testPriceBookEntry.Id,
                    UnitPrice = testPriceBookEntry.UnitPrice, Quantity = ItemQuantity)
                );}}
                //insert the list of order items
        insert testOrderItem;
		//Update Status on Order to "Ordered"
		List<Order> listOfOrdersToUpdate = new List<Order>();
		for (Order ord : testOrderz) {
			ord.Status = 'Activated';
			listOfOrdersToUpdate.add(ord);
		}
        try {
		update listOfOrdersToUpdate;
        } catch (Exception e) {
            system.debug('it happened here' + e.getMessage());
        }

        delete testOrderItem;
 }
 public static void TestCreateAccountsOrdersItemsForPageController(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount, Integer ItemQuantity, Integer PriceUnit, Integer CostShipment) {
    /* this test method creates a product, a pricebook entry standard and custom, orders and orders items*/
    Product2 testProduct = new Product2(Name = 'Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
    insert testProduct;
    //Insert the product in the standard price book (if necessary)
    PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), 
    Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
    insert testStandardPBE;
    //create custom price book
    Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
    insert testPriceBook;
    //get the standard price book ID
    //Insert the product in the custom price book
    PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = testPriceBook.Id, 
    Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
    insert testPriceBookEntry;
    /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
    created and number of orders per account, by putting numbers in parameters. */
    //then variables for dates
    Date myDate = Date.today();
    Date futureDate = mydate.addDays(8);
    //Finally create lists for accounts and orders
    List<Account> testAccounts = new List<Account>();
    List<Order> testOrderz = new List<Order>();
    //Then create 2 for loops, each increments depending on the number of accounts/orders.
    for (Integer i = 0; i < numberOfTestAccounts; i++) {
    //Create new accounts
    Account accountForTest = new Account(Name = 'Account for Testing ' + i);
    //place these accounts in the list
    testAccounts.add(accountForTest);
    }
    //create these accounts from the list.
    insert testAccounts;
    //this for loop increments depending of number of accounts selected
    for(Integer a = 0; a < numberOfTestAccounts; a++) {
    //accounts in the for loop are the ones from previous for loop
        Account testaccts = testAccounts[a];
        //this second for loop increments : starting with number of orders by increment;
        //as long as the index doesn't reach the number of order per acccount, which is at least 1, 
        //then increment. 
        for(Integer o = numberOfTestOrderPerAccount * a; o < numberOfTestOrderPerAccount * (a + 1); o++) {
            //on the test order list, add new orders whose account id is found in the list of accounts; 
            //the effective date is from the date variable; select a shipment cost and the product ID from the testPriceBookEntry. 
            //Finally, important the status is set on "draft".
            testOrderz.add(new Order(AccountID = testaccts.id, EffectiveDate = myDate, ShipmentCost__c = CostShipment, 
            Pricebook2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft'));
    }
    //finally the list of orders is created and has a corresponding account, id and status.
    try {
    insert testOrderz;
    } catch(Exception e) {
        System.debug('this occured: ' + e.getMessage());
    }
    }
    // Create Accounts with an Order
    //Create a list of Order Items
    List<OrderItem> testOrderItem = new List<OrderItem>();
    //starting at 0, as long as the number of order isn't reached, increment
    for (Integer oi = 0; oi < numberOfTestOrderPerAccount; oi++) {
    //variable testOrds corresponds to the testOrders list indexed with this for loop
        Order testOrds = testOrderz[oi];
        //this second for loop increments: starting with number of tests by increments;
        //as long as the index doesn't reach the number of accounts times the orders per account,
        //then increment.
        for(Integer napo = numberOfTestAccounts * ItemQuantity * oi; napo < numberOfTestAccounts * ItemQuantity * (oi + 1); napo++ ) {
            //in the orderItem list, add an order item, which price and quantity are determined by method parameter
            testOrderItem.add(new OrderItem(OrderID =testOrds.Id, Product2Id = testProduct.Id, PricebookEntryId = testPriceBookEntry.Id,
                UnitPrice = testPriceBookEntry.UnitPrice, Quantity = ItemQuantity)
            );}}
            //insert the list of order items
    insert testOrderItem;
    //Update Status on Order to "Ordered"
    List<Order> listOfOrdersToUpdate = new List<Order>();
    for (Order ord : testOrderz) {
        ord.Status = 'Activated';
        listOfOrdersToUpdate.add(ord);
    }
    update listOfOrdersToUpdate;
}}