@isTest
private class TestOrderTriggerAfterUpdate {
    @isTest private static void TestOrderTriggerAfterUpdate() {
        Account testAccount = new Account(Name = 'Test Account 1');
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert testProduct;
 
        //Create the PricebookEntry
        PricebookEntry testPriceBook = new PricebookEntry( 
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert testPriceBook;

        Order testOrder = new Order(AccountId = testAccount.Id);
        insert testOrder;

        OrderItem testOrderItem = new OrderItem (OrderId = testOrder.Id, PricebookEntryId = testPriceBook.Id, Quantity=10, UnitPrice = 150);
        insert testOrderItem;
        OrderItem testOrderItem2 = new OrderItem (OrderId = testOrder.Id, PricebookEntryId = testPriceBook.Id, Quantity=20, UnitPrice = 1000);
        insert testOrderItem2;

        //ce test n'a pas d'assert ?
    }
}