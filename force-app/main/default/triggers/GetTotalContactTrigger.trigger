trigger GetTotalContactTrigger on Contact (after update, after delete) {
    Set<ID> setId = new Set<ID>();
    
    if (Trigger.isUpdate) {
        for(Contact ct : Trigger.new) {
            if (ct.AccountId != null) {
                setId.add(ct.AccountId);
            }
        }
    }

    for(Contact ct : Trigger.old) {
        if (ct.AccountId != null) {
            setId.add(ct.AccountId);
        }
    }

    List<Account> accounts = [SELECT Id, (SELECT Id FROM Account.Contacts WHERE Active__c = TRUE) FROM Account WHERE Id IN :setId];

    if (!accounts.isEmpty()) {
        for(Account account : accounts) {
            account.Total_Contacts__c = account.Contacts.size();
        }
        update accounts;
    }
}