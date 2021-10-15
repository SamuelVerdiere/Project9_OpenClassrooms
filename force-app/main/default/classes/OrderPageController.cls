public with sharing class OrderPageController {
	//this class gets SumOfOrders value for the visualforce page
	public decimal SumOfOrders {
		get {
			//refine the SOQL query to only get "Total Amount" from Order with "Ordered" status
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Ordered'];
			return (decimal) groupedResults.get('total');
		}
		set;
}}