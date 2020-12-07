window._snapinsSnippetSettingsFile = (function() {
 
    // Logs that the snippet settings file was loaded successfully
    //console.log("Snippet settings file loaded.");
   
    embedded_svc.snippetSettingsFile.extraPrechatFormDetails = [{
      "label":"First Name", 
      "transcriptFields": ["FirstName__c"]
    },{
      "label":"Last Name", 
      "transcriptFields": ["LastName__c"]
    },{
      "label":"Email", 
      "transcriptFields": ["Email__c"]
    }];
  })();