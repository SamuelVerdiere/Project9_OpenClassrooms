
@isTest
public class TestDataFactory {
    @isTest
    static void TestCreatePriceBookEntry() {
        /* this test method creates a product, 
        a pricebook entry standard and custom */
        //Create product
        Product2 testProduct = new Product2(Name = 'SmartPhone Samsung Galaxy S22', ProductCode = 'GS2223', Family = 'SmartPhone', IsActive = true);
        //possible de créer d'autres produits ? Pourquoi Product2 ?
        insert testProduct;
        //Insert the product in the standard price book (if necessary)
        PricebookEntry testStandardPBE = new PricebookEntry(Pricebook2Id = priceBook.Id, Product2Id = testProduct.Id, UnitPrice = 1000.00, UseStandardPrice = false, IsActive = true);
        insert testStandardPBE;
        //create custom price book
        Pricebook2 testPriceBook = new Pricebook2(Name = 'Price Book Standard', IsActive = true);
        insert testPriceBook;
        //get the standard price book ID
        Pricebook2 testStandardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];
        //Insert the product in the custom price book
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = priceBook.Id, Product2Id = product.Id, UnitPrice = 1000.00, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
    }
    @isTest
    static void TestCreateAccountWithOrder(Integer numberOfTestAccounts, Integer numberOfTestOrderPerAccount) {
        //récupérer id de testUserFactory
        //variables de date mydate + futureDate
        //Liste de comptes et d'ordres
        //boucles for incrémentées pour création de comptes
        //créer comptes dans liste de comptes + orders dans liste d'order

        // Create Accounts with an Order
		List<Account> accts = new List<Account>();

		for (Integer i = 0; i < numAccts; i++) {
			Account a = new Account(Name = 'Test Account USD' + i, OwnerId = u.Id);
			accts.add(a);
		}
		insert accts;
		List<Order> ords = new List<Order>();
		for (Integer j = 0; j < numAccts; j++) {
			Account acct = accts[j];
			for (Integer k = numOrdersPerAcct * j; k < numOrdersPerAcct * (j + 1); k++) {
				ords.add(
					new Order(
						AccountId = acct.Id,
						EffectiveDate = System.today(),
						ShipmentCost__c = 2,
						Pricebook2Id = pbeCustom.Pricebook2Id,
						Status = 'Draft'
					));}}
		insert ords;
}
    @isTest
    static void TestCreateOrderItem() {

    }
    
}

