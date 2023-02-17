@isTest
private class LeadConvertActionTest {
    @isTest
    static void testConvertLeads() {
        // Create a test lead
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Status = 'New');
        insert testLead;

        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test contact
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test@test.com', AccountId = testAccount.Id);
        insert testContact;

        // Create a test user
        User testUser = new User(Username = 'testuser@test.com', Email = 'testuser@test.com',
            FirstName = 'Test', LastName = 'User', Alias = 'testuser', TimeZoneSidKey = 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'es_US', EmailEncodingKey = 'UTF-8', ProfileId = UserInfo.getProfileId());
        insert testUser;

        // Set up the lead convert action request with all required fields
        List<LeadConvertAction.LeadConvertActionRequest> requests = new List<LeadConvertAction.LeadConvertActionRequest>();
        LeadConvertAction.LeadConvertActionRequest request = new LeadConvertAction.LeadConvertActionRequest();
        request.leadId = testLead.Id;
        request.convertedStatus = 'Qualified';

        // Set the account and contact IDs
        request.accountId = testAccount.Id;
        request.contactId = testContact.Id;

        // Set the owner ID to the test user
        request.ownerId = testUser.Id;

        // Set the opportunity name
        request.opportunityName = 'Test Opportunity';

        // Add the request to the list
        requests.add(request);

        // Call the lead convert action
        Test.startTest();
        List<LeadConvertAction.LeadConvertActionResult> results = LeadConvertAction.convertLeads(requests);
        Test.stopTest();

        // Verify that the lead was converted and the account, contact, and opportunity were created
        System.assertEquals(true, [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id][0].IsConverted);
        System.assertNotEquals(null, [SELECT Id FROM Account WHERE Id = :results[0].accountId]);
        System.assertNotEquals(null, [SELECT Id FROM Contact WHERE Id = :results[0].contactId]);
        System.assertNotEquals(null, [SELECT Id FROM Opportunity WHERE Name = :request.opportunityName]);

        // Attempt to convert the lead again with the same account and contact IDs
        // This should fail because the account and contact IDs are already in use
        requests.clear();
        request.accountId = testAccount.Id;
        request.contactId = testContact.Id;
        requests.add(request);

        // Call the lead convert action again
        Test.startTest();
        try {
            results = LeadConvertAction.convertLeads(requests);
        } catch (LeadConvertAction.ConvertLeadActionException e) {
            // Verify that the exception message indicates that the account and contact IDs are already in use
            System.assertEquals('The account and/or contact IDs specified are already in use.', e.getMessage());
        }
        Test.stopTest();
    }
}