import { LightningElement, track, api, wire } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createHorse from '@salesforce/apex/PedigreeTableController.createHorse';
import updateHorses from '@salesforce/apex/PedigreeTableController.updateHorses';

import HORSE_OBJECT from '@salesforce/schema/Horse__c';

export default class PedigreeTable extends LightningElement {
    @api applicationId;
    @api leadId;
    @api availableActions = [];
    @api horses;

    async connectedCallback() {
        console.log("LEAD ID: "+ this.leadId);
        try {
            const data = await createHorse({ objectApiName: HORSE_OBJECT.objectApiName, leadId: this.leadId });
            data.Owner__c = true;
            this.horses = [data];
            this.idIndex = 1;
            console.log("INIT HORSES: " + JSON.stringify(this.horses));
        } catch (error) {
            console.error(error);
        }
    }

    handleAddHorse() {
        createHorse({ objectApiName: 'Horse__c', leadId: this.leadId })
            .then(newHorse => {
                // Add the new horse to the horses array and increment the ID index
                newHorse.Owner__c = true;
                this.horses = [...this.horses, newHorse];
                this.idIndex++;

                console.log("IN LWC: New Horse Added: " + JSON.stringify(this.horses));
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleRemoveHorse(event) {
        this.horses = this.horses.filter(horse => horse.id !== event.detail.horseId);
    }

    handleSubmit() {
        const rows = this.template.querySelectorAll('c-pedigree-table-row');
        const horses = [];

        // assume all fields are populated by default
        let allFieldsPopulated = true; 

        rows.forEach(row => {
            let horse = row.horse;
            horses.push(horse);

            // Define regular expressions for email and phone number formats
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const phoneRegex = /^\d{10}$/;

            // perform validation
            if (!horse.Name__c || !horse.Registration_Number__c || 
                !horse.Gender__c || !horse.Date_Foaled__c ||
                !horse.Sire__c || !horse.Dam__c || !horse.Color__c ||
                (horse.Other__c && !horse.Other_Breed_Association__c) ||
                (horse.Owner__c === false && (!horse.OwnerFirstName || !horse.OwnerLastName || 
                                              !emailRegex.test(horse.OwnerEmail) || !phoneRegex.test(horse.OwnerPhone)))
            ) {
                allFieldsPopulated = false;
            }
        });
        console.log("STRINGIFIED HORSES:" + JSON.stringify(horses));
        
        // check if validation succeeded
        if(allFieldsPopulated){
            updateHorses({horses:JSON.stringify(horses)})
            .then(result => {
                console.log('Data:'+ JSON.stringify(result));
            }) .catch(error => {
                console.log(error);
                this.error = error;
            }); 

            if (this.availableActions.find((action) => action === 'NEXT')) {
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
        } else {
            // show a toast message if not all required fields are populated
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Please fill in all required fields for each horse.',
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }
}