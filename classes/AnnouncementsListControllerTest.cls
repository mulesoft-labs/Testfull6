/*****************************************************************************
 * Description : Test class for AnnouncementsListController
 *
 *        
 * Author      : Wade Liu (Perficient)
 * Date        : 05/31/2016
 * Version     : 1.0
 *
 * Version History : 
 * 
 *****************************************************************************/
@isTest
private class AnnouncementsListControllerTest {
    private static Integer size = 5;
    static testMethod void getAnnouncementWrapsTest(){
        Announcement__kav testAnnouncement = new Announcement__kav(UrlName = 'AnnouncementsListControllerTest', Title = 'AnnouncementsListControllerTest', Critical__c = true, Language = 'en_US');
        insert testAnnouncement;
        KnowledgeArticleVersion article = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion WHERE Title = 'AnnouncementsListControllerTest' 
        AND Language = 'en_US' 
        AND PublishStatus = 'Draft' 
        AND ArticleType = 'Announcement__kav'];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
        system.assertEquals('AnnouncementsListControllerTest', AnnouncementsListController.getAnnouncementWraps(size)[0].Title);
    }
}