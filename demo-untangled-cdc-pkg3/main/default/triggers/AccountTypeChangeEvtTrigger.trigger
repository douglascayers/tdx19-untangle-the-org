trigger AccountTypeChangeEvtTrigger on Account_Type_Change__e ( after insert ) {

    System.debug( 'AccountTypeChangeEvtTrigger' );

    Set<ID> accountIds = new Set<ID>();
    for ( Account_Type_Change__e evt : Trigger.new ) {
        accountIds.add( evt.AccountId__c );
    }

    Map<ID, Account> accountsMap = new Map<ID, Account>([
        SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds
    ]);

    List<Task> prospectTasks = new List<Task>();

    for ( Account_Type_Change__e evt : Trigger.new ) {
        System.debug( evt );
        Account acct = accountsMap.get( evt.AccountId__c );
        if ( evt.New_Type__c == 'Prospect' ) {
            prospectTasks.add( new Task(
                Subject = 'Call Account',
                Type = 'Call',
                ActivityDate = Date.today().addDays(5),
                WhatId = acct.Id,
                OwnerId = acct.OwnerId
            ));
        }
    }

    if ( prospectTasks.size() > 0 ) {
        insert prospectTasks;
    }

}