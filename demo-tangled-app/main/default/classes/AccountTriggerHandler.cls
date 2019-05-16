public inherited sharing class AccountTriggerHandler {

	public void handleBeforeInsert( List<Account> newList ) {
    }

    public void handleAfterInsert( List<Account> newList, Map<ID, Account> newMap ) {
    }

    public void handleBeforeUpdate( List<Account> oldList, Map<ID, Account> oldMap,
                                    List<Account> newList, Map<ID, Account> newMap ) {
	}

    public void handleAfterUpdate( List<Account> oldList, Map<ID, Account> oldMap,
                                   List<Account> newList, Map<ID, Account> newMap ) {

        System.debug( 'AccountTriggerHandler' );

        List<Case> coldCases = new List<Case>();
		Set<ID> warmAccountIds = new Set<ID>();
		List<Task> prospectTasks = new List<Task>();

        for ( Account newAcct : newList ) {

            Account oldAcct = oldMap.get( newAcct.Id );

            // Service Package / App / Team
            if ( oldAcct.Rating != newAcct.Rating ) {
                switch on ( newAcct.Rating ) {
                    when 'Cold' {
                        coldCases.add( new Case(
                            AccountId = newAcct.Id,
                            Subject = 'Account needs warming up',
                            Type = 'Cold'
                        ));
                    }
                    when 'Warm' {
                        warmAccountIds.add( newAcct.Id );
                    }
                    when 'Hot' {
						warmAccountIds.add( newAcct.Id );
                    }
                }
            }

            // Sales Package / App / Team
            if ( oldAcct.Type != newAcct.Type ) {
                if ( newAcct.Type == 'Prospect' ) {
                    prospectTasks.add( new Task(
                        Subject = 'Call Account',
                        Type = 'Call',
                        ActivityDate = Date.today().addDays(5),
                        WhatId = newAcct.Id,
                        OwnerId = newAcct.OwnerId
                    ));
                }
            }

        }

		if ( prospectTasks.size() > 0 ) {
            insert prospectTasks;
        }

		if ( coldCases.size() > 0 ) {
            insert coldCases;
        }

		if ( warmAccountIds.size() > 0 ) {
			System.enqueueJob( new SyncAccountsJob( warmAccountIds ) );
        }

	}

	public void handleBeforeDelete( List<Account> oldList, Map<ID, Account> oldMap ) {
        // quick cleanup of test data
        delete [ SELECT Id FROM Case WHERE AccountId IN :oldList ];
        delete [ SELECT Id FROM Opportunity WHERE AccountId IN :oldList ];
        delete [ SELECT Id FROM Task WHERE AccountId IN :oldList ];
    }

    public void handleAfterDelete( List<Account> oldList, Map<ID, Account> oldMap ) {
    }

}