import { LightningElement, track, api, wire } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
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
            const data = await createHorse({ objectApiName: HORSE_OBJECT.objectApiName, leadId: this.leadId});
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
        rows.forEach(row => {
            let horse = row.horse;
            horses.push(horse);
        });
        console.log("STRINGIFIED HORSES:" + JSON.stringify(horses));

        // SEND JSON STRINGIFIED HORSES TO updateHorses()
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
    }
}