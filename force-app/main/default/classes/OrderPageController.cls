public with sharing class OrderPageController {
        public decimal SumOfOrders{
            get{
                AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
                return (decimal)groupedResults.get('total');
            }
            set;
        }
}