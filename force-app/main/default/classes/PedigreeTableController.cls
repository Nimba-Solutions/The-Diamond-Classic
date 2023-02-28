public without sharing class PedigreeTableController {
    public class HorseWrapper {
        @AuraEnabled public Boolean APHA;
        @AuraEnabled public Boolean APHC;
        @AuraEnabled public Boolean AQHA;
        @AuraEnabled public Boolean TB;
        @AuraEnabled public Boolean Other;
        @AuraEnabled public Boolean IsCompeting;
        @AuraEnabled public Boolean IsOwner; // Lots to do here!
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Registration_Number;
        @AuraEnabled public String Gender;
        @AuraEnabled public Date Date_Foaled;
        @AuraEnabled public String Sire;
        @AuraEnabled public String Dam;
        @AuraEnabled public String Color;
        @AuraEnabled public String Other_Breed_Association;
        @AuraEnabled public String OwnerFirstName;
        @AuraEnabled public String OwnerLastName;
        @AuraEnabled public String OwnerEmail;
        @AuraEnabled public String OwnerPhone;
    }

    @AuraEnabled
    public static Horse__c createHorse(String objectApiName, String leadId) {
        System.debug('Lead Id: '+ leadId);
        Horse__c horse = new Horse__c(
            Registration_Number__c = null,
            Name__c = null,
            Gender__c = null,
            Date_Foaled__c = null,
            Sire__c = null,
            Dam__c = null,
            Color__c = null,
            APHA__c = false,
            APHC__c = false,
            AQHA__c = false,
            TB__c = false,
            Other__c = false,
            Other_Breed_Association__c = null,
            IsCompeting__c = false
        );
        insert horse;

        // Create an Affiliation record and set the Horse and Application fields
        Affiliation__c affiliation = new Affiliation__c();
        affiliation.Horse__c = horse.Id;
        affiliation.Lead__c = leadId;
        insert affiliation;

        return horse;
    }

   @AuraEnabled
    public static void updateHorses(string horses) {
        //wrapper class doesn't like __c and it's too late to care rn
        horses = horses.replace('__c', '');
        system.debug('Horse JSON: ' + horses);

        List<HorseWrapper> parsedJson = (List<HorseWrapper>) JSON.deserialize(horses, List<HorseWrapper>.class);
        List<Affiliation__c> affiliations = new List<Affiliation__c>();

        List<Horse__c> horsesToUpdate = new List<Horse__c>();
        for (HorseWrapper recordData : parsedJson) {
            system.debug('recordData: '+ recordData);
            Horse__c horse = new Horse__c();
            horse.Id = recordData.Id;
            horse.Registration_Number__c = recordData.Registration_Number;
            horse.Name__c = recordData.Name;
            horse.Gender__c = recordData.Gender;
            horse.Date_Foaled__c = recordData.Date_Foaled;
            horse.Sire__c = recordData.Sire;
            horse.Dam__c = recordData.Dam;
            horse.Color__c = recordData.Color;
            horse.APHA__c = recordData.APHA;
            horse.APHC__c = recordData.APHC;
            horse.AQHA__c = recordData.AQHA;
            horse.TB__c = recordData.TB;
            horse.Other__c = recordData.Other;
            horse.Other_Breed_Association__c = recordData.Other_Breed_Association;
            horse.IsCompeting__c = recordData.IsCompeting;
            horsesToUpdate.add(horse);

            String ownerEmail = recordData.OwnerEmail;
            system.debug('ownerEmail: '+ ownerEmail);
            
            // Check if the Form Submitter is the Owner
            if (recordData.IsOwner == false || recordData.IsOwner == null) {
                
                // Create the affiliation record for the Owner
                Affiliation__c affiliation = new Affiliation__c();
                affiliation.Owner__c = true;
                affiliation.Horse__c = recordData.Id;

                String accountId;

                // Check if the owner has an Account already
                List<Account> accounts = Database.query('SELECT Id FROM Account WHERE Email__c =: ownerEmail LIMIT 1');
                if (!accounts.isEmpty()) {
                    accountId = accounts[0].Id;
                }
                if (accountId != null) {
                    affiliation.Account__c = accountId;
                } else {
                    // Check if the owner has a Lead already
                    String leadId;
                    List<Lead> leads = Database.query('SELECT Id FROM Lead WHERE Email =: ownerEmail LIMIT 1');
                    if (!leads.isEmpty()) {
                        leadId = accounts[0].Id;
                    }

                    if (leadId != null) {
                        affiliation.Lead__c = leadId;
                    } else {
                        Lead newLead = new Lead();
                        newLead.FirstName = recordData.OwnerFirstName;
                        newLead.LastName = recordData.OwnerLastName;
                        newLead.Phone = recordData.OwnerPhone;
                        newLead.Email = recordData.OwnerEmail;
                        newLead.Company = recordData.OwnerFirstName + ' ' + recordData.OwnerLastName + '\'s Account';
                        insert newLead;
                        affiliation.Lead__c = newLead.Id;
                    } 
                }
                affiliations.add(affiliation);
            }
        }
        if (affiliations.size() > 0) {
            insert affiliations;
        }
        update horsesToUpdate;
    }
    
    @AuraEnabled
    public static void updateHorse(string horseJson) {
        //wrapper class doesn't like __c and it's too late to care rn
        horseJson = horseJson.replace('__c', '');
        system.debug('Horse JSON: ' + horseJson);

        HorseWrapper recordData = (HorseWrapper) JSON.deserialize(horseJson, HorseWrapper.class);

        system.debug('Horse OBJ: ' + recordData);

        Horse__c horse = new Horse__c();
        horse.Id = recordData.Id;
        horse.Registration_Number__c = recordData.Registration_Number;
        horse.Name__c = recordData.Name;
        horse.Gender__c = recordData.Gender;
        horse.Date_Foaled__c = recordData.Date_Foaled;
        horse.Sire__c = recordData.Sire;
        horse.Dam__c = recordData.Dam;
        horse.Color__c = recordData.Color;
        horse.APHA__c = recordData.APHA;
        horse.APHC__c = recordData.APHC;
        horse.AQHA__c = recordData.AQHA;
        horse.TB__c = recordData.TB;
        horse.Other__c = recordData.Other;
        horse.Other_Breed_Association__c = recordData.Other_Breed_Association;
        horse.IsCompeting__c = recordData.IsCompeting;
        update horse;
    } 

}