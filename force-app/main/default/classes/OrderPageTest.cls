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
        List<AggregateResult> SumOfResults;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            SumOfResults = [SELECT SUM(TotalAmount) totality FROM Order];            
        }
        test.stopTest();
        //THEN : assert
        for (AggregateResult sor : SumOfResults) {
            System.assertEquals(100, sor.get('totality'));
        }}
}