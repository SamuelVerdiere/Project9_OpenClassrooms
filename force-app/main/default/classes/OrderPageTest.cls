@isTest
public with sharing class OrderPageTest {
    /* This test class will perform tests relative to the Order Page.
    It will test permissions about this Order Page. */

    @TestSetup
    static void createUser(){
    DataFactory.createUser();
    }
    @isTest
    public static void readAmountPermission() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        //GIVEN
        User testUser = [SELECT Id FROM User WHERE LastName = 'HAL'];     
        DataFactory.createOrders(1, 1, 1, 100, 10);
        OrderPageController orderPage = new OrderPageController();
       // Decimal groupedResults = orderPage.SumOfOrders;
        List<AggregateResult> SumOfResults;
        List<Order> OrderUpdate = new List<Order>();
        OrderUpdate = [SELECT Id, Status, NetAmount__c, TotalAmount 
        FROM Order WHERE Status = 'Draft'];
        //WHEN : perform test
        test.startTest();
        //the user wants to get the sum of total amounts
            for(Order ord : OrderUpdate) {
                    ord.Status = 'Ordered';
            }
            update OrderUpdate;
        System.runAs(testUser) {
            SumOfResults = [SELECT SUM(TotalAmount) totality 
            FROM Order WHERE Status = 'Ordered'];
        }
        Decimal groupedResults = orderPage.SumOfOrders;
        test.stopTest();
        //THEN : assert
        for (AggregateResult sor : SumOfResults) {
            //the user is able to see the total amount
            System.assertEquals(100, sor.get('totality'));
            System.assertEquals(1, OrderUpdate.size());
            System.assertEquals(100, OrderPage.SumOfOrders);
            System.assertEquals(groupedResults, sor.get('totality'));
        }}
}