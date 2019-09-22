public with sharing class AnimalController {
    @AuraEnabled(cacheable=true)
    public static List<Animal__c> getAnimalsByParkId(String parkId) {
        List<ParkAnimalRelation__c> relations = [
            SELECT Animal__r.Id, Animal__r.Name, Animal__r.Description__c, Animal__r.Endangered__c, Animal__r.Image__c
            FROM ParkAnimalRelation__c
            WHERE Park__c = :parkId
        ];
        List<Animal__c> result = new List<Animal__c>();
        for (ParkAnimalRelation__c r : relations) {
            result.add(
                new Animal__c(
                Id = r.Animal__r.Id,
                Name = r.Animal__r.Name,
                Description__c = r.Animal__r.Description__c,
                Endangered__c = r.Animal__r.Endangered__c,
                Image__c = r.Animal__r.Image__c
                )
            );
        }
        return result;
    }
}
