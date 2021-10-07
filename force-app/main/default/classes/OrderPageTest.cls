@isTest
public with sharing class OrderPageTest {
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
       //REMETTRE DANS LA DATAFACTORY + TEST SETUP ou return datafactory.createuser();
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
            System.assertEquals(90, sor.get('totality'));
        }}
    
    @isTest
    public static void readAnotherObjectPermission() {
        //GIVEN : create data
        User testUser = [SELECT Id FROM User WHERE LastName = 'HAL'];
        DataFactory.createOrders(1, 2, 2, 10, 1);
        List<Contact> canSeeContacts;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            canSeeContacts = [SELECT Id FROM Contact];
        }
        test.stopTest();
        //THEN : assert
        system.assert(canSeeContacts.size() == 0, 'this element cannot let the user see contacts');
    }
}