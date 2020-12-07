public with sharing class QuoteLineItemEntry {
    public QuoteLineItemEntry() {

    }

        @AuraEnabled @InvocableVariable public Id Id;   
        @AuraEnabled @InvocableVariable
        public Id ProductId;
        @AuraEnabled @InvocableVariable
        public String ProductName;
        @AuraEnabled @InvocableVariable
        public Double Quantity;
        @AuraEnabled @InvocableVariable
        public Double Subtotal;
}