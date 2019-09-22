import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAnimals from '@salesforce/apex/AnimalController.getAnimalsByParkId';

export default class FoundAnimalCarousel extends NavigationMixin(LightningElement) {
    @api recordId;

    @wire(getAnimals, {parkId : '$recordId'})
    animals;

    navigateToRecord(event) {
        if (!event.target.dataset.id) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Animal__c',
                recordId: event.target.dataset.id,
                actionName: 'view'
            }
        });
    }
}