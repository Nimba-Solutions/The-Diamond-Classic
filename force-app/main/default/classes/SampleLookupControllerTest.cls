@isTest
public class SampleLookupControllerTest {
    @isTest
    static void testSearch() {
        // Create test data
        Horse__c horse1 = new Horse__c(Name__c = 'Test Horse 1', Gender__c = 'Stallion', Registration_Number__c = '12345');
        Horse__c horse2 = new Horse__c(Name__c = 'Test Horse 2', Gender__c = 'Stallion', Registration_Number__c = '54321');
        insert new List<Horse__c> {horse1, horse2};

        // Call the search method with some parameters
        List<LookupSearchResult> results = SampleLookupController.search('Test', new List<String>());

        // Verify the results
        System.assertEquals(2, results.size());
        System.assertEquals('Horse', results[0].sObjectType);
        System.assertEquals('Test Horse 1', results[0].title);
        System.assertEquals('Stallion • 12345', results[0].subtitle);
        System.assertEquals('Horse', results[1].sObjectType);
        System.assertEquals('Test Horse 2', results[1].title);
        System.assertEquals('Stallion • 54321', results[1].subtitle);
    }
}