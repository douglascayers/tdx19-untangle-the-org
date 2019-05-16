trigger AccountRatingChangeEvtTrigger on Account_Rating_Change__e ( after insert ) {

    System.debug( 'AccountRatingChangeEvtTrigger' );

    List<Case> coldCases = new List<Case>();
    Set<ID> warmAccountIds = new Set<ID>();

    for ( Account_Rating_Change__e evt : Trigger.new ) {
        System.debug( evt );
        switch on ( evt.New_Rating__c ) {
            when 'Cold' {
                coldCases.add( new Case(
                    OwnerId = evt.CreatedById,
                    AccountId = evt.AccountId__c,
                    Subject = 'Account needs warming up',
                    Type = 'Cold'
                ));
            }
            when 'Warm' {
                warmAccountIds.add( evt.AccountId__c );
            }
            when 'Hot' {
                warmAccountIds.add( evt.AccountId__c );
            }
        }
    }

    if ( coldCases.size() > 0 ) {
        insert coldCases;
    }

    if ( warmAccountIds.size() > 0 ) {
        System.enqueueJob( new SyncAccountsJob( warmAccountIds ) );
    }

}