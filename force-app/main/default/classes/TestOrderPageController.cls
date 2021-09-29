@isTest
public class testOrderPageController {
    TestUserFactory userdata = new TestUserFactory();
    TestDataFactory objdata  = new TestDataFactory();
    @isTest
    static void testPositivePermission() {
        //GIVEN : create user & data
        userdata.TestCreateStandardUser();
        objdata.TestCreatePriceBookEntry();
        
        //WHEN : perform test

        //THEN : assert

    }
}