@isTest
public class DataFactory {
    public static void createOrders(Integer numberOfAccounts, Integer numberOfOrders, 
    Integer ItemQuantity, Integer PriceUnit, Integer CostShipment) {
        /*This test method creates accounts with orders. In the test invocation, we can choose number of accounts
        created and number of orders per account, by putting numbers in parameters.
        this test method creates a user, product, a pricebook entry standard and custom, orders and orders items*/
        //Create product
        Product2 testProduct = new Product2(Name = 'Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
        insert testPriceBook;
        //get the standard price book ID and Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = testPriceBook.Id, Product2Id = testProduct.Id, UnitPrice = PriceUnit, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
        //create variables for dates
        Date myDate = Date.today();
        Date futureDate = mydate.addDays(8);  
        //Finally create lists for accounts, orders and order items
        List<Account> testAccounts = new List<Account>();
        List<Order> testOrderz = new List<Order>();
        List<OrderItem> testOrderItem = new List<OrderItem>();
        //Then create 2 for loops, each increments depending on the number of accounts/orders.
        for (Integer i = 0; i < numberOfAccounts; i++) {
        //Create new accounts and place them in the list, then insert them
        Account accountTest = new Account(Name = 'Account for Testing ' + i);
        testAccounts.add(accountTest);
        }
        insert testAccounts;
        /* Now accounts are created, depending on variable "numberOfAccounts". */

        //this for loop increments depending of number of accounts selected;
        //accounts in the for loop are the ones that were just inserted
        for(Integer a = 0; a < testAccounts.size(); a++) {
            Account testaccts = testAccounts[a];
            /* For each of these account, increment depending on the number of orders  
            and add created orders in the list. The status of each order is set on "draft" */
            for(Integer o = 0 ; o < numberOfOrders ; o++) { 
                testOrderz.add(new Order(AccountID = testaccts.id, EffectiveDate = myDate, ShipmentCost__c = CostShipment, Pricebook2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft'));}}
        insert testOrderz;
        /* Now Orders are created, depending on variable "numberOfOrders".*/

        //Create items for each order
        // the first for loop will iterate on each orders from the previous list;
        for (Integer oi = 0; oi < testOrderz.size(); oi++) {
            Order testOrds = testOrderz[oi];
            /* For each of these orders, increment depending on the number of item quantity 
            and add created order items in the list. The price of each item is in the parameter */
            for(Integer ori = 0; ori < ItemQuantity; ori++ ) {
                testOrderItem.add(new OrderItem(OrderID =testOrds.Id, Product2Id = testProduct.Id, PricebookEntryId = testPriceBookEntry.Id,UnitPrice = testPriceBookEntry.UnitPrice, Quantity = 1));}}
        insert testOrderItem;
    }
    /* This test method creates an user with standard permission, 
    for testing purposes. */
    public static User createUser() {
    Profile IdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];        
    User testUser = new User(FirstName='Jordan',LastName = 'HAL',Alias = 'hjord',Email = 'jordan.hal@example.com',Username = 'jhal@example.com',ProfileId = IdProfile.id,EmailEncodingKey = 'UTF-8',TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
    insert testUser;
    return testUser;
    }}