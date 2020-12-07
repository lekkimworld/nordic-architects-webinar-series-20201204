public class EinsteinChatBotController { 
 
    public class QuoteOutput { 
     
        @InvocableVariable( required=true ) 
        public String sQuoteNumber; 
        @InvocableVariable( required=true ) 
        public String sStatus; 
        @InvocableVariable( required=true ) 
        public String sId;
        @InvocableVariable( required=true ) 
        public String sName;  
    } 
     
    public class QuoteInput { 
     
        @InvocableVariable( required=true ) 
        public String quoteContact; 
         
    } 
 
    @InvocableMethod(label='Get Quote For ContactID') 
    public static List < QuoteOutput > getQuote( List < QuoteInput > listquoteInputs ) { 
     
        Set<String> contactIds = new Set<String>(); 
 
        // contact id from the input
        for (QuoteInput quoteInput : listquoteInputs) {
          contactIds.add(quoteInput.quoteContact);
          System.debug('ContactID:' + quoteInput.quoteContact);
        }

        List < QuoteOutput > objOutputs = new List < QuoteOutput >();
        QuoteOutput objOutput = new QuoteOutput(); 
       
        for ( Quote objQuote : [ SELECT Status, QuoteNumber, Id, Name FROM Quote WHERE ContactId IN: contactIds AND Status!='Rejected']) {
           
            //objOutput.sStatus = objOutput.sStatus == null ? objQuote.Status : ( objOutput.sStatus + ', ' + objQuote.Status ) ;
            //objOutput.sQuoteNumber = objOutput.sQuoteNumber == null ? objQuote.QuoteNumber : ( objOutput.sQuoteNumber + ', ' + objQuote.QuoteNumber ) ; 
            objOutput.sStatus = objQuote.Status;
            objOutput.sQuoteNumber = objQuote.QuoteNumber;
            objOutput.sId = objQuote.Id;
            objOutput.sName = objQuote.Name;
        }
        //objOutput.sStatus = 'Draft';
        //objOutput.sQuoteNumber = '3332223';          
        objOutputs.add( objOutput );                     
        return objOutputs; 
     
    } 
 
}