@isTest
public class DataFactory {
    public static void createOrders(Integer numberOfAccounts, Integer numberOfOrders, 
    Integer ItemQuantity, Integer PriceUnit, Integer CostShipment) {
        /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
        created and number of orders per account, by putting numbers in parameters.
        this test method creates a user, product, a pricebook entry standard and custom, orders and orders items*/
        //Create product
        Product2 testProduct = new Product2(
            Name = 'Samsung Galaxy S22', 
            ProductCode = 'GS2223', 
            Family = 'SmartPhone', 
            IsActive = true);
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), 
            Product2Id = testProduct.Id, 
            UnitPrice = PriceUnit, 
            UseStandardPrice = false, 
            IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(
            Name = 'Price Book Standard', 
            IsActive = true);
        insert testPriceBook;
        //get the standard price book ID
        //Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id, 
            Product2Id = testProduct.Id, 
            UnitPrice = PriceUnit, 
            UseStandardPrice = false, 
            IsActive = true);
        insert testPriceBookEntry;
        //then variables for dates
        Date myDate = Date.today();
        Date futureDate = mydate.addDays(8);  
        //Finally create lists for accounts, orders and order items
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrderz = new List<Order>();
        List<OrderItem> testOrderItem = new List<OrderItem>();
        //Then create 2 for loops, each increments depending on the number of accounts/orders.
        for (Integer i = 0; i < numberOfAccounts; i++) {
        //Create new accounts
        Account accountTest = new Account(Name = 'Account for Testing ' + i);
        //place these accounts in the list
        testAccounts.add(accountTest);
        }
        //create these accounts from the list.
        insert testAccounts;
        /* Now accounts are created, depending on variable "numberOfAccounts". */

        //this for loop increments depending of number of accounts selected
        for(Integer a = 0; a < testAccounts.size(); a++) {
        //accounts in the for loop are the ones from previous for loop
            Account testaccts = testAccounts[a];
            /* This second for loop increments : starting with number of orders by increment;
            as long as the index doesn't reach the number of order per acccount, which is at least 1, 
            then increment.*/
            for(Integer o = 0 ; o < numberOfOrders ; o++) { 
                /*On the test order list, add new orders whose account id is found in the list of accounts; 
                the effective date is from the date variable; select a shipment cost and the product ID from the testPriceBookEntry. 
                Finally, important the status is set on "draft".*/
                testOrderz.add(new Order(
                AccountID = testaccts.id, 
                EffectiveDate = myDate, 
                ShipmentCost__c = CostShipment, 
                Pricebook2Id = testPriceBookEntry.Pricebook2Id, 
                Status = 'Draft'));
        }
        }
        insert testOrderz;
        /* Now Orders are created, depending on variable "numberOfOrders".*/

        //Create items for each order
        //starting at 0, as long as the number of order isn't reached, increment
        for (Integer oi = 0; oi < testOrderz.size(); oi++) {
        //variable testOrds corresponds to the testOrders list indexed with this for loop
            Order testOrds = testOrderz[oi];
            /* This second for loop increments: starting with number of tests by increments;
            as long as the index doesn't reach the number of accounts times the orders per account,
            then increment.*/
            for(Integer ori = 0; ori < ItemQuantity; ori++ ) {
                //in the orderItem list, add an order item, which price and quantity are determined by method parameter
                testOrderItem.add(new OrderItem(
                OrderID =testOrds.Id, 
                Product2Id = testProduct.Id, 
                PricebookEntryId = testPriceBookEntry.Id,
                UnitPrice = testPriceBookEntry.UnitPrice, 
                Quantity = 1)
                );}}
                //insert the list of order items
        insert testOrderItem;
        update testOrderz;
        update testAccounts;
        //update accounts, orders and items.
}
    /* This test method creates an user with standard permission, 
    for testing purposes. */
    public static User createUser() {
    Profile IdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];        
    User testUser = new User(FirstName='Jordan',
                   LastName = 'HAL',
                   Alias = 'hjord',
                   Email = 'jordan.hal@example.com',
                   Username = 'jhal@example.com',
                   ProfileId = IdProfile.id,
                   EmailEncodingKey = 'UTF-8',
                   TimeZoneSidKey = 'GMT',
                   LanguageLocaleKey = 'en_US',
                   LocaleSidKey = 'en_US'
                   );
    insert testUser;
    return testUser;
    }
}