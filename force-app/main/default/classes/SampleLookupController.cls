public with sharing class SampleLookupController {
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        system.debug('IN SEARCH()');
        system.debug('search term: '+ searchTerm);
        // Prepare query parameters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
                Horse__c(Id, Name__c, Registration_Number__c, Gender__c WHERE id NOT IN :selectedIds)
            LIMIT :MAX_RESULTS
        ];

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Horses & convert them into LookupSearchResult
        String horseIcon = 'custom:custom47';
        Horse__c[] horses = (List<Horse__c>) searchResults[0];
        for (Horse__c horse : horses) {
            String subtitle = horse.Gender__c + ' • ' + horse.Registration_Number__c;
            results.add(new LookupSearchResult(horse.Id, 'Horse', horseIcon, horse.Name__c, subtitle));
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }
}