@isTest
private class SampleLookupControllerTest {
    @isTest
    static void testSearch() {
        // Create test data
        List<Horse__c> horses = new List<Horse__c>();
        for (Integer i = 0; i < 10; i++) {
            Horse__c horse = new Horse__c(
                Name = 'Test Horse ' + i,
                Gender__c = 'Mare',
                Registration_Number__c = '12345'
            );
            horses.add(horse);
        }
        insert horses;

        // Call the search method
        List<LookupSearchResult> results = SampleLookupController.search('Test', new List<String>());

        // Assert that the results are correct
        System.assertEquals(5, results.size(), 'Wrong number of results returned');
        for (LookupSearchResult result : results) {
            System.assertEquals('Horse', result.entityType, 'Wrong entity type returned');
            System.assertEquals('custom:custom47', result.iconName, 'Wrong icon name returned');
            System.assertTrue(result.title.contains('Test Horse'), 'Wrong title returned');
            System.assertTrue(result.subtitle.contains('Mare • 12345'), 'Wrong subtitle returned');
        }
    }
}
