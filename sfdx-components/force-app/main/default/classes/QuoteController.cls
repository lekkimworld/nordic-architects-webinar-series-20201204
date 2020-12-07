global with sharing class QuoteController {
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteDocument> ListDocuments(Id quoteId) {
        return [select id, ContentVersionDocumentId, Document, Name from QuoteDocument where QuoteId = :quoteId];
    }

    @AuraEnabled
    public static List<ExternalQuote> listQuotes(Id contactId){
        try {
            //List<Quote> qs = [SELECT Id, Name, TotalPrice, CreatedDate from Quote where ContactId = :contactId order by CreatedDate desc LIMIT 10];
            List<QuoteDocument> qds = [select id, ContentVersionDocumentId, Document, Name, Quote.Id, Quote.Name, Quote.TotalPrice, Quote.CreatedDate, Quote.OpportunityId from QuoteDocument where Quote.ContactId = :contactId and Quote.Status <> 'Rejected' order by Quote.CreatedDate desc LIMIT 10];
            if(qds == null || qds.size() == 0) {
                throw new AuraHandledException('No QDS');
            }
            List<ExternalQuote> exqs = new List<ExternalQuote>();
            for(QuoteDocument q: qds) {
                ExternalQuote e = new ExternalQuote();
                e.Id = q.Quote.Id;
                e.Name = q.Quote.Name;
                e.CreatedDate = q.Quote.CreatedDate;
                e.TotalPrice = q.Quote.TotalPrice;
                e.OpportunityId = q.Quote.OpportunityId;
                
                List<ContentDistribution> contentDistributions = [ SELECT Id, Name, ContentDownloadUrl, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =: q.ContentVersionDocumentId ];
                
                
                if (contentDistributions != null && contentDistributions.size() > 0) {
                    System.debug(contentDistributions[0]);
                    System.debug('DOWNLOAD LINK: ' + contentDistributions[0].ContentDownloadUrl);
                    e.url = contentDistributions[0].DistributionPublicUrl; //ContentDownloadUrl;
                } else {
                    ContentDistribution newContentDistribution = new ContentDistribution();
                    newContentDistribution.Name = q.Name;
                    newContentDistribution.ContentVersionId = q.ContentVersionDocumentId;
                    newContentDistribution.PreferencesAllowViewInBrowser = true;
                    insert newContentDistribution;
                    ContentDistribution contentDistribution = [ SELECT Id, Name, ContentDownloadUrl, ContentDocumentId, DistributionPublicUrl FROM ContentDistribution WHERE Id =: newContentDistribution.Id LIMIT 1 ];
                    System.debug(contentDistribution);
                    System.debug('DOWNLOAD LINK: ' + contentDistribution.ContentDownloadUrl);
                    e.url = contentDistribution.DistributionPublicUrl; //ContentDownloadUrl;
                }
                //throw new QuoteControllerException('Size:'+e.url);
                exqs.add(e);
                
            }
            return exqs;

        } catch (Exception e) {
            throw new QuoteControllerException(e.getMessage());
        }
    }
    public class QuoteControllerException extends Exception {

    }
    global class ExternalQuote {
        @AuraEnabled global Id Id;
        @AuraEnabled global string Name;
        @AuraEnabled global string url;
        @AuraEnabled global Decimal TotalPrice;
        @AuraEnabled global DateTime CreatedDate;
        @AuraEnabled global Id OpportunityId;
       
    }
}