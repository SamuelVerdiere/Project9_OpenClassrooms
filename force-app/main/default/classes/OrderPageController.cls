public with sharing class OrderPageController {
	//this class gets SumOfOrders value for the visualforce page
	public decimal SumOfOrders {
		get {
			//refine the SOQL query to only get "Total Amount" from Order with "activated" status
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
			return (decimal) groupedResults.get('total');
		}
		set;
}}