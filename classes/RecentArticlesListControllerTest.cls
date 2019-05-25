/*****************************************************************************
 * Description : Test class for RecentArticlesListController
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
private class RecentArticlesListControllerTest {
    private static Integer size = 5;
    static testMethod void getArticleSortWrapsTest(){
        /*FAQ__kav testFAQ = new FAQ__kav(UrlName = 'testFAQ', Title = 'testFAQ', Language = 'en_US');
        insert testFAQ;
        KnowledgeArticleVersion articleFAQ = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion WHERE Title = 'testFAQ' 
        AND Language = 'en_US' 
        AND PublishStatus = 'Draft' 
        AND ArticleType = 'FAQ__kav'];
        
        How_To__kav testHowTo = new How_To__kav(UrlName = 'testHowTo', Title = 'testHowTo', Language = 'en_US');
        insert testHowTo;
        KnowledgeArticleVersion articleHowTo = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion WHERE Title = 'testHowTo' 
        AND Language = 'en_US' 
        AND PublishStatus = 'Draft' 
        AND ArticleType = 'How_To__kav'];*/
        
        Knowledge__kav testProblem = new Knowledge__kav(UrlName = 'testProblem', Title = 'testProblem', Language = 'en_US');
        insert testProblem;
        KnowledgeArticleVersion articleProblem = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion WHERE Title = 'testProblem' 
        AND Language = 'en_US' 
        AND PublishStatus = 'Draft' 
        AND ArticleType = 'Knowledge__kav'];
        
        
        //KbManagement.PublishingService.publishArticle(articleFAQ.KnowledgeArticleId, true);
        //KbManagement.PublishingService.publishArticle(articleHowTo.KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(articleProblem.KnowledgeArticleId, true);
        
        //system.assertEquals(3, RecentArticlesListController.getArticleSortWraps(size).size());
        system.assertEquals(1, RecentArticlesListController.getArticleSortWraps(size).size());
    }
}