public with sharing class AffiliationQuery {
    @InvocableMethod(label='Query Affiliation Records by Lead Id and Competing Horse')
    public static List<Integer> queryAffiliations(List<String> leadIds) {
        Integer count = [SELECT COUNT() 
                         FROM Affiliation__c 
                         WHERE Lead__c IN :leadIds AND Horse__r.IsCompeting__c = true];
        return new List<Integer>{ count };
    }
}