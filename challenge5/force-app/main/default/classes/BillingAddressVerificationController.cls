public with sharing class BillingAddressVerificationController {

    public class Input {
        @InvocableVariable(required=true)
        public Id accountId;
    }

    @InvocableMethod(label='取引先の請求住所を検証')
    public static void verifyAccountBillingAddress(List<Input> inputs){
        List<Account> accounts = getAccounts(inputs);
        BillingAddressVerificationImpl verifyJob = new BillingAddressVerificationImpl(accounts);
        System.enqueueJob(verifyJob);
    }

    private static List<Account> getAccounts(List<Input> inputs) {
        Set<Id> accountIds = new Set<Id>();
        for (Input i : inputs) {
            accountIds.add(i.accountId);
        }
        return AccountSelector.selectByIds(accountIds);
    }

}
