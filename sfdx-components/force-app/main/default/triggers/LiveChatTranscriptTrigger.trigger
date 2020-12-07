trigger LiveChatTranscriptTrigger on LiveChatTranscript (after insert, after update) {
    List<LiveChatTranscript> toUpdate = new List<LiveChatTranscript>();

    for(LiveChatTranscript lct : Trigger.NEW) {
        if(lct.Email__c != null && lct.ContactId == null) {
            
            List<Contact> ccs = [SELECT id, accountid from contact where email = :lct.Email__c];
            if(ccs != null && ccs.size() > 0) {
                toUpdate.add(( new LiveChatTranscript(
                    id = lct.id,
                    ContactId = ccs[0].id,
                    AccountId = ccs[0].AccountId
                )));
            }   
        }
    }
    if(toUpdate.size() > 0) {
        update toUpdate;
    }
}