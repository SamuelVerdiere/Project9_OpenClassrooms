
@isTest
public class TestDataFactory {
    @isTest
    static void TestCreatePriceBookEntry(Decimal PriceUnit) {
        /* this test method creates a product, 
        a pricebook entry standard and custom */
        //Create product
        Product2 testProduct = new Product2(Name = 'SmartPhone Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = priceBook.Id, Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
        insert testPriceBook;
        //get the standard price book ID
        Pricebook2 testStandardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];
        //Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = priceBook.Id, Product2Id = product.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
    }
    @isTest
    static void TestCreateAccountWithOrder(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount, Decimal CostShipment) {
        /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
        created and number of orders per account, by putting numbers in parameters. */
        //first we get created user id.
        Id UserId = testUser.Id;  //TODO : fix !unresolved!
        //then variables for dates
        Date myDate = Date.today();
        Date futureDate = mydate.addDays(8);
        //Finally create lists for accounts and orders
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrders = new List<Order>();
        //Then create 2 for loops, each increments depending on the number of accounts/orders.
        for (Integer i = 0; i < numberOfTestAccounts; i++) {
        //Create new accounts
        Account accountForTest = new Account(Name = 'Account for Testing' + i, OwnerId = UserId);
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
                testOrders.add(new Order(AccountID = testaccts.id, EffectiveDate = myDate, ShipmentCost__c = CostShipment, Product2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft'));
        }
        //finally the list of orders is created and has a corresponding account, id and status.
        insert testOrders;
        }}
        // Create Accounts with an Order
    @isTest
    static void TestCreateOrderItem(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount, Integer ItemQuantity) {
        //Create a list of Order Items
        List<OrderItem> testOrderItem = new List<OrderItem>();
        //starting at 0, as long as the number of order isn't reached, increment
        for (Integer oi = 0; oi < numberOfTestOrderPerAccount; oi++) {
        //variable testOrds corresponds to the testOrders list indexed with this for loop
            Order testOrds = testOrders[oi];
            //
            for(Integer napo = numberOfTestAccounts * oi; napo < numberOfTestAccounts * numberOfTestOrderPerAccount * (oi + 1); napo++ ) {
                testOrderItem.add(new OrderItem(
                    OrderID =testOrds.Id,
                    Product2Id = testProduct.Id,
                    PricebookEntryId = testPriceBookEntry.Id,
                    UnitPrice = testPriceBookEntry.UnitPrice,
                    Quantity = ItemQuantity
                ));}}
            insert testOrderItem;
        }  
    @isTest
    static void updateOrderStatus() {
		//Update Status on Order to "Ordered"
		List<Order> listOfOrdersToUpdate = new List<Order>();
		for (Order ord : testOrders) {
			ord.Status = 'Ordered';
			listOfOrdersToUpdate.add(ord);
		}
		update listOfOrdersToUpdate;
    }
    @isTest 
    static void updateStatusAndDeleteOrderItem() {
            //Update Status on Order to "Ordered"
            List<Order> listOfOrdersToUpdate = new List<Order>();
            for (Order ord : testOrders) {
                ord.Status = 'Ordered';
                listOfOrdersToUpdate.add(ord);
            }
            update listOfOrdersToUpdate;

            delete testOrderItem;
        }
}