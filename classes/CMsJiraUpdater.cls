Public Class CMsJiraUpdater
{
  /**
  * Class constants for configuration
  * We should likely override this with a constants class that is project-wide
  */
  private static final String API_ENDPOINT = 'callout:support_jira_sfdc_integration_endpoint/api/jira_link/';
  
    public static void updateCases(String casesJson, String Method)
    {
        // Instantiate a new http object
        Http h = new Http();
    
        // Instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT);
        req.setMethod(Method);
        
        //System.debug('Changed cases are: ' + cases);
        String JsonRequest = casesJson;
        req.setHeader('Content-type', 'application/json');
        req.setBody(JsonRequest);
        System.debug('API request body is: ' + JsonRequest);
    
        // Send the request, and receive a response
        HttpResponse res = h.send(req);
        String echoedReply = res.getBody();
        System.debug('Service reply body: ' + echoedReply);
    }
    
    // TODO: Extract method in abstract class
    /**
    * Input is a serialized Map<String, List<Case>> where key is JIRA number to change
    */
    @Future(callout=true)
    public static void createJiraLink(String casesJson)
    {
      System.debug('Creating Jira Case links for: '+ casesJson);
      String jiraCaseLinks = caseSobjectToCustomJson(casesJson);
        updateCases(jiraCaseLinks, 'POST');
    }
    
    /**
    * Input is a serialized Map<String, List<Case>> where key is JIRA number to change
    */
    @Future(callout=true)
    public static void destroyJiraLink(String casesJson)
    {
      System.debug('Deleting Jira Case links for: '+ casesJson);
      String jiraCaseLinks = caseSobjectToCustomJson(casesJson);
        updateCases(jiraCaseLinks, 'DELETE');
    }
    
    /**
    * Input is a serialized Map<String, List<Case>> where key is JIRA number to change
    */
    @Future(callout=true)
    public static void updateJiraLink(String casesJson)
    {
      System.debug('Updating Jira Case links for: '+ casesJson);
      String jiraCaseLinks = caseSobjectToCustomJson(casesJson);
        updateCases(jiraCaseLinks, 'PUT');      
    }
    
    /**
       Casts a Map<String, List<Case>> in JSON format into an array of internal JiraCaseLink objects.
       Then returns the new array as a JSON string.
    */
    private static String caseSobjectToCustomJson(String casesJson)
    {
      Map<String, List<Case>> cases = (Map<String, List<Case>>) JSON.deserialize(casesJson, Map<String, List<Case>>.class);
      System.debug('After deserialization we got ' + cases.size() + ' pairs' );
      List<JiraCaseLink> jiraCaseLinks = new List<JiraCaseLink>();
      for (String jiraId : cases.keySet())
        for (Case c : cases.get(jiraId))
          jiraCaseLinks.add(new JiraCaseLink(c, jiraId));
      JSONGenerator gen = JSON.createGenerator(true);
        gen.writeObject(jiraCaseLinks);
      return gen.getAsString();
    }
    
    /**
      Internal class that will be the information serialized and sent to the API
      This class is simpler and flatter than a SalesForce object
    */
    private class JiraCaseLink
    {
      String JiraId, CaseId, CaseNumber, AccountName, Status, Severity;
      
      /**
        Creates a new instance of this class populating the inner context with the information of the case passed as parameter.
        The second parameter defines the JiraId field, should be one of the values within the case. This is not validated.
      */
      public JiraCaseLink (Case c, String jira_Id)
      {
        // TODO Null check
        System.debug(logginglevel.FINE, 'Initializing a JiraCaseLink');
        System.debug(logginglevel.FINEST, c);
        System.debug(logginglevel.FINEST, jira_id);
        JiraId = Jira_Id;
        CaseId = c.Id;
        CaseNumber = c.CaseNumber;
        Id AccountId = c.AccountId; // Seems to be coming out null, add logging
        System.debug(logginglevel.FINER, 'Looking up AccountName for ' + AccountId);
        AccountName = [SELECT Name FROM Account WHERE Id = :AccountId].Name;
        System.debug(logginglevel.FINER, 'Obtained: ' + AccountName);     
        Status = c.Status;
        Severity = c.Priority;
        System.debug(logginglevel.FINE, 'Initialized a JiraCaseLink');
        System.debug(logginglevel.FINEST, this);
      }
    }
    
}