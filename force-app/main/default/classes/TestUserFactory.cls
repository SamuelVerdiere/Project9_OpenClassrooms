/* This class is used to create users for testing purposes. 
Users can be of any profile, depending of the needs.
*/
@isTest
public with sharing class TestUserFactory {
    /* The TestCreateStandardUser creates a
    standard user for testing. */
    @isTest
    static TestCreateStandardUser() {
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
        return testUser;
}}