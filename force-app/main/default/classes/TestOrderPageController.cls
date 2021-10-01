@isTest
public class testOrderPageController {
    @isTest
    static void testPositivePermission() {
        //GIVEN : create user & data
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items
        TestUserFactory.TestCreateStandardUser();
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(2, 2, 100);
        TestDataFactory.TestCreateOrderItem(2,2);
        TestDataFactory.updateOrderStatus();
        List<AggregateResult> SumOfResults;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            SumOfResults = [SELECT SUM(TotalAmount) totality FROM Order];            
        }
        test.stopTest();
        //THEN : assert
        Integer expect = '';
        for (AggregateResult sor : SumOfResults) {
            System.assertEquals((expect), sor.get('totality'));
        }}
    @isTest
    static void testNegativePermission() {
        //GIVEN : create user & data
        //PriceBook entry requests price of product as parameter
        //Account with Order equests number of account + order items + shipment cost
        //and Order Item requests number of account + order items
        TestUserFactory.TestCreateStandardUser();
        TestDataFactory.TestCreatePriceBookEntry(1000);
        TestDataFactory.TestCreateAccountWithOrder(2, 2, 100);
        TestDataFactory.TestCreateOrderItem(2,2,5);
        TestDataFactory.updateOrderStatus();
        List<Contacts> canSeeContacts;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            canSeeContacts = [SELECT Id FROM Contacts];
        }
        test.stopTest();
        //THEN : assert
        system.assertEquals(canSeeContacts.size() == 1, 'this element cannot let the user see contacts');
    }
}