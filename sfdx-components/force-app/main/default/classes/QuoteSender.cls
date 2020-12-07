public with sharing class QuoteSender {

    @AuraEnabled
    public static void sendQuote(Id quoteId, Id[] documentIds, string body) {
        try {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Get Quote Files
            QuoteDocument[] files = [select Name, Document from QuoteDocument where ContentVersionDocumentId in :documentIds];
            for(QuoteDocument d: files) {
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(d.Name); 
                efa.setBody(d.Document);
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }
            Quote q = [Select Name, Contact.Email from Quote where id = :quoteId ];

            email.setSubject('Quote for '+q.Name);
            String[] toAddresses = new String[]{ q.Contact.Email };
            email.setToAddresses( toAddresses );
            email.setHtmlBody(body);
            
            
            // Sends the email  
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}