public with sharing class ResetDemo {
    public static void ResetDemo2() {
        string userName = 'johan@neidenmark.se.sso.badge.org';
        List<User> users = [SELECT id, UserName, ContactId, AccountId, IsActive from User where UserName = :userName];
        System.debug('Found '+users);
        for(User u: users) {
            Id contactId = u.ContactId;
            Id accountId = u.AccountId;
            u.UserName = u.UserName+'.old';
            u.IsActive = false;
            //u.ContactId = null;
            //u.AccountId = null;
            Contact c = [SELECT id, Email from Contact where Id = :contactId LIMIT 1];
            c.Email = c.Email + '.old';
            //update c;
            //System.debug('Deleted Contact');
            List<Quote> qs = [SELECT id from Quote where AccountId= :accountId];
            //delete qs;
            //System.debug('Deleted Quotes');
            List<Opportunity> os = [SELECT id from Opportunity where AccountId = :accountId];
            //delete os;
            //System.debug('Deleted Opps');

            update u;
            System.debug('Updated User');
            
            
        }
    }
    public static void ResetDemo1() {
        string userName = 'johan@neidenmark.se.sso.badge.org';
        List<User> users = [SELECT id, UserName, ContactId, AccountId, IsActive from User where UserName = :userName];
        System.debug('Found '+users);
        for(User u: users) {
            Id contactId = u.ContactId;
            Id accountId = u.AccountId;
            u.UserName = u.UserName+'.old';
            u.IsActive = false;
            //u.ContactId = null;
            //u.AccountId = null;
            Contact c = [SELECT id, Email, LastName from Contact where Id = :contactId LIMIT 1];
            c.Email = c.Email + '.old';
            c.LastName = 'junk';
            c.FirstName = 'junk';
            
            update c;
            Account a = [SELECT id, Name from Account where id = :accountId];
            a.Name = 'Junk';
            update a;
            System.debug('Deleted Contact');
            List<Quote> qs = [SELECT id from Quote where AccountId= :accountId];
            delete qs;
            System.debug('Deleted Quotes');
            List<Opportunity> os = [SELECT id from Opportunity where AccountId = :accountId];
            delete os;
            System.debug('Deleted Opps');

            //update u;
            //System.debug('Updated User');
        }
    }
}