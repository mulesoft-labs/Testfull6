@isTest
public class CMsJiraUpdater_Test_CalloutMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('callout:support_jira_sfdc_integration_endpoint/api/jira_link/', req.getEndpoint());
        // Might want to validate methods
        String jsonInput = req.getBody();

        System.debug(LoggingLevel.DEBUG, 'Mocking call to support_jira_sfdc_integration_endpoint/api/jira_link/');
        System.debug(LoggingLevel.FINE, 'Incoming request body: ' + jsonInput);
        
        List<Object> lst = (List<Object>) JSON.deserializeUntyped(jsonInput);
        
        for (Integer i = 0; i < lst.size(); i++) {
            Map<String, Object> m = (Map<String, Object>) lst[i];
            System.assertNotEquals('', m.get('Status'), 'Key Status cant be empty');
            System.assertNotEquals('', m.get('Severity'), 'Key Severity cant be empty');
            System.assertNotEquals('', m.get('JiraId'), 'Key JiraId cant be empty');
            System.assertNotEquals('', m.get('CaseNumber'), 'Key CaseNumber cant be empty');
            System.assertNotEquals('', m.get('CaseId'), 'Key CaseId cant be empty');
            System.assertNotEquals('', m.get('AccountName'), 'Key AccountName cant be empty');
            System.assertEquals('6', m.size().format(), 'Map must contain 6 keys');
        }
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(204);
        return res;
    }
}