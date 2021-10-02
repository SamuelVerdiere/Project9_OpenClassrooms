@isTest
public with sharing class TestOrderPageController {
    public static void testPositivePermission() {
        /* the test method from the factory takes as parameters :
        - The Number of Accounts needed
        - The Number of Orders per Accound needed
        - The quantity of Items per order
        - The Unit Price of each item
        - The Shipment Cost for each item */
        Profile IdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];        
        User testUser = new User(FirstName='Jordan',
                       LastName = 'HAL',
                       Alias = 'hjord',
                       Email = 'jordan.hal@example.com',
                       Username = 'jhal@example.com',
                       ProfileId = IdProfile.id,
                       EmailEncodingKey = 'UTF-8',
                       TimeZoneSidKey = 'GMT+2',
                       LocaleSidKey = 'fr_FR',
                       LanguageLocaleKey = 'fr_FR'
                       );
        insert testUser;
        TestDataFactory.TestCreateAccountsOrdersItemsForPageController(1, 2, 2, 10, 1);
        List<AggregateResult> SumOfResults;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            SumOfResults = [SELECT SUM(TotalAmount) totality FROM Order];            
        }
        test.stopTest();
        //THEN : assert
        for (AggregateResult sor : SumOfResults) {
            System.assertEquals(36, sor.get('totality'));
        }}

    public static void testNegativePermission() {
        //GIVEN : create data
        Profile IdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];        
        User testUser = new User(FirstName='Jordan',
                       LastName = 'HAL',
                       Alias = 'hjord',
                       Email = 'jordan.hal@example.com',
                       Username = 'jhal@example.com',
                       ProfileId = IdProfile.id,
                       EmailEncodingKey = 'UTF-8',
                       TimeZoneSidKey = 'GMT+2',
                       LocaleSidKey = 'fr_FR',
                       LanguageLocaleKey = 'fr_FR'
                       );
        insert testUser;
        TestDataFactory.TestCreateAccountsOrdersItemsForPageController(1, 2, 2, 10, 1);
        List<Contact> canSeeContacts;
        //WHEN : perform test
        test.startTest();
        System.runAs(testUser) {
            canSeeContacts = [SELECT Id FROM Contact];
        }
        test.stopTest();
        //THEN : assert
        system.assert(canSeeContacts.size() != 0, 'this element cannot let the user see contacts');
    }
}