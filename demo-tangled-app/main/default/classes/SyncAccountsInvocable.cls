public inherited sharing class SyncAccountsInvocable {

    @InvocableMethod( label = 'Sync Accounts' )
    public static void execute( List<Request> requests ) {
        System.debug( 'SyncAccountsInvocable' );
		// do something with the accounts...
        // could make an http callout...
        // for simplicity, we'll just complete some tasks
        Set<ID> accountIds = getAccountIds( requests );
        for ( List<Task> tasks : [
            SELECT Id, Account.Type
            FROM Task
            WHERE WhatId IN :accountIds
	            AND Subject = 'Call Account'
				AND IsClosed = false
        ]) {
            for ( Task t : tasks ) {
				t.Status = 'Completed';
            }
            update tasks;
        }
    }

    public static Set<ID> getAccountIds( List<Request> requests ) {
        Set<ID> ids = new Set<ID>();
        for ( Request req : requests ) {
            if ( String.isNotBlank( req.accountId ) ) {
                ids.add( req.accountId );
            }
        }
        return ids;
    }

    public class Request {

        @InvocableVariable( label = 'Account ID' )
        public ID accountId;

    }

}