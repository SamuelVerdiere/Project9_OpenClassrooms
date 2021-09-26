@isTest
public with sharing class TestOrderTriggerAfterUpdate {
    @isTest public TestOrderTriggerAfterUpdate() {
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

        OrderItem testOrderItem = new OrderItemItem (OrderId = testOrder.Id, PricebookEntryId = testPriceBook.Id, Quantity=10, UnitPrice = 150);
        insert testOrderItem;
        OrderItem testOrderItem = new OrderItemItem (OrderId = testOrder.Id, PricebookEntryId = testPriceBook.Id, Quantity=20, UnitPrice = 1000);
        insert testOrderItem;

        //ce test n'a pas d'assert ?
    }
}
