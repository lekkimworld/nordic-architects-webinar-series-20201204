public with sharing class QuoteLineItemBot {
    
    @InvocableMethod(label='Get Quote Line Items')
    public static List<List<QuoteLineItemEntry>> getQuoteLineItems(List<String> quoteId) {
        List<QuoteLineItem> items = [select id, Product2Id,Product2.Name, Quantity, Subtotal from quoteLineItem where QuoteId in :quoteId];
        List<List<QuoteLineItemEntry>> ret_final = new List<List<QuoteLineItemEntry>>();
        List<QuoteLineItemEntry> ret = new List<QuoteLineItemEntry>();
        for(QuoteLineItem i: items) {
            QuoteLineItemEntry qlid = new QuoteLineItemEntry();
            qlid.Id = i.Id;
            qlid.ProductId = i.Product2Id;
            qlid.ProductName = i.Product2.Name;
            qlid.Quantity = i.Quantity;
            qlid.Subtotal = i.Subtotal;
            ret.add(qlid);
        }
        ret_final.add(ret);
        return ret_final;
    }

    public class QuoteLineItemData {
        @AuraEnabled @InvocableVariable public Id Id;

        @InvocableVariable
        public Id ProductId;
        @InvocableVariable
        public String ProductName;
        @InvocableVariable
        public Double Quantity;
        @InvocableVariable
        public Double Subtotal;

    }
}