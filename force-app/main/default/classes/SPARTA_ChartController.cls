/**
 * @description       : 
 * @author            : xyz
 * @group             : 
 * @last modified on  : 2021-07-04
 * @last modified by  : ABC
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-07-04   ABC                                   Initial Version
**/
public class SPARTA_ChartController {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getOpportunities(){
        return [SELECT SUM(ExpectedRevenue) expectRevenue, SUM(Amount) amount, StageName stage 
               FROM Opportunity WHERE StageName NOT IN ('Closed Won') GROUP BY StageName LIMIT 20];
    }
}