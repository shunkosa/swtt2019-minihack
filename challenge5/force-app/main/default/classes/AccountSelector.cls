public with sharing class AccountSelector {
    @AuraEnabled(cacheable=true)
    public static Account selectById(String accountId) {
        List<Account> result = [
            SELECT BillingAddressVerificationStatus__c
            FROM Account
            WHERE Id = :accountId
        ];
        return (result.isEmpty()) ? null : result[0];
    }

    public static List<Account> selectByIds(Set<Id> accountIds) {
        return [
            SELECT BillingState, BillingCity, BillingPostalCode, BillingStreet, BillingAddressVerificationStatus__c
            FROM Account
            WHERE Id IN :accountIds
        ];
    }
}
