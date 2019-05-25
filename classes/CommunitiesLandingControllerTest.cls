/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 * 
 * Elmar Chen: added assertion on 06/08/15
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference r = Network.communitiesLanding();
        if(r==null){
        	System.assertEquals(null, controller.forwardToStartPage());
        } else {
        	System.assertEquals(r.getUrl(), controller.forwardToStartPage().getUrl());
        }
      }
}