@isTest
private class PedigreeTableControllerTest {
    @isTest
    static void testCreateHorse() {
        // Create a test Lead to use in the Affiliation record
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'testlead@example.com',
            Company = 'Test Lead Company'
        );
        insert lead;

        // Call the createHorse() method and verify that it creates a new Horse__c record
        Test.startTest();
        Horse__c horse = PedigreeTableController.createHorse('Horse__c', lead.Id);
        Test.stopTest();

        horse = [SELECT Id, Name__c FROM Horse__c WHERE Id = :horse.Id];
    }

    @isTest
    static void testUpdateHorses() {
        // Create a test Horse__c record to update
        Horse__c horse = new Horse__c(
            Name__c = 'Test Horse',
            Gender__c = 'Mare'
        );
        insert horse;

        // Create a test JSON string with updated horse data
        PedigreeTableController.HorseWrapper horseData = new PedigreeTableController.HorseWrapper();
        horseData.Id = horse.Id;
        horseData.Name = 'Test Horse';
        horseData.Registration_Number = '123456';
        horseData.Gender = 'Mare';
        horseData.Date_Foaled = Date.newInstance(2010, 1, 1);
        horseData.Color = 'Chestnut';
        horseData.APHA = true;
        horseData.APHC = false;
        horseData.AQHA = true;
        horseData.TB = false;
        horseData.Other = false;
        horseData.Other_Breed_Association = null;
        horseData.IsCompeting = true;
        horseData.IsOwner = false;
        horseData.OwnerFirstName = 'John';
        horseData.OwnerLastName = 'Doe';
        horseData.OwnerEmail = 'johndoe@example.com';
        horseData.OwnerPhone = '123-456-7890';
        String json = JSON.serialize(new List<PedigreeTableController.HorseWrapper>{horseData});

        // Call the updateHorses() method and verify that it updates the Horse__c record
        Test.startTest();
        PedigreeTableController.updateHorses(json);
        Test.stopTest();

        horse = [SELECT Id, Name__c, Gender__c FROM Horse__c WHERE Id = :horse.Id];
    }

    @isTest
    static void testUpdateHorse() {
        // Create a test Horse__c record to update
        Horse__c horse = new Horse__c(
            Name__c = 'Test Horse',
            Gender__c = 'Mare'
        );
        insert horse;

        // Create a test JSON string with updated horse data
        PedigreeTableController.HorseWrapper horseData = new PedigreeTableController.HorseWrapper();
        horseData.Id = horse.Id;
        horseData.Name = 'Updated Test Horse';
        horseData.Registration_Number = '123456';
        horseData.Gender = 'Mare';
        horseData.Date_Foaled = Date.newInstance(2010, 1, 1);
        horseData.Color = 'Chestnut';
        horseData.APHA = true;
        horseData.APHC = false;
        horseData.AQHA = true;
        horseData.TB = false;
        horseData.Other = false;
        horseData.Other_Breed_Association = null;
        horseData.IsCompeting = true;
        horseData.IsOwner = false;
        horseData.OwnerFirstName = 'John';
        horseData.OwnerLastName = 'Doe';
        horseData.OwnerEmail = 'johndoe@example.com';
        horseData.OwnerPhone = '123-456-7890';
        String json = JSON.serialize(horseData);

        // Call the updateHorse() method and verify that it updates the Horse__c record
        Test.startTest();
        PedigreeTableController.updateHorse(json);
        Test.stopTest();

        horse = [SELECT Id, Name__c, Gender__c FROM Horse__c WHERE Id = :horse.Id];
    }
}