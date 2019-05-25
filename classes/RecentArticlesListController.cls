/*****************************************************************************
 * Description : Contrller class for RecentlyUpdatesArticles 
 * lightning component
 *
 *        
 * Author      : Wade Liu (Perficient)
 * Date        : 05/26/2016
 * Version     : 1.0
 *
 * Version History : 
 * 
 *****************************************************************************/
global class RecentArticlesListController {
    
    // articles only for FAQ__kav, How_To__kav and Knowledge__kav types
    private static List<KnowledgeArticleVersion> getArticles(Integer size){
        size = Integer.valueOf(size);
        return [SELECT Id, UrlName, Title, LastPublishedDate 
        FROM KnowledgeArticleVersion WHERE PublishStatus = 'online' 
        AND Language = 'en_US' 
        //AND ArticleType IN ('FAQ__kav', 'How_To__kav', 'Knowledge__kav') 
        //Wade Liu changed the query only on Knowledge type
        AND ArticleType = 'Knowledge__kav'
        ORDER BY LastPublishedDate DESC LIMIT :size];
    }
    
    global class ArticleSortWrap implements Comparable {
        @AuraEnabled
        public ArticleWrap art;
        
        // Constructor
        public ArticleSortWrap(ArticleWrap artWrap) {
            art = artWrap;
        }
        
        // Compare articles based on the article last publish date.
        global Integer compareTo(Object compareTo) {
            // Cast argument to ArticleSortWrap
            ArticleSortWrap compareToArticle = (ArticleSortWrap)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (art.LastPublishedDateSort < compareToArticle.art.LastPublishedDateSort) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (art.LastPublishedDateSort > compareToArticle.art.LastPublishedDateSort) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            
            return returnValue;       
        }
    }
    
    public class ArticleWrap{
        @AuraEnabled
        public String Title{get;set;}
        @AuraEnabled
        public String UrlName{get;set;}
        @AuraEnabled
        public String LastPublishedDate{get;set;}
        public Datetime LastPublishedDateSort{get;set;}
        
        public ArticleWrap(String TitleIN, String UrlNameIN, Datetime LastPublishedDateIN){
            Title = TitleIN;
            UrlName = UrlNameIN;
            LastPublishedDateSort = LastPublishedDateIN;
            Date toDate = Date.valueOf(LastPublishedDateIN);
            Integer day = toDate.day();
            Integer month = toDate.month();
            Integer year = toDate.year();
            if(month < 10){
                LastPublishedDate = '0' + month + '-';
            }
            else{
                LastPublishedDate = month + '-';
            }
            if(day < 10){
                LastPublishedDate = LastPublishedDate + '0' + day + '-';
            }
            else{
                LastPublishedDate = LastPublishedDate + day + '-';
            }
            LastPublishedDate = LastPublishedDate + year;
        }
    }
    
    @AuraEnabled
    public static List<ArticleSortWrap> getArticleSortWraps(Integer size){
        size = Integer.valueOf(size);
        List<ArticleWrap> articleWrapList = new List<ArticleWrap>();
        List<ArticleSortWrap> resultList = new List<ArticleSortWrap>();
        List<KnowledgeArticleVersion> articleList = getArticles(size);
        if(articleList != null && !articleList.isEMpty()){
            for(KnowledgeArticleVersion art : articleList){
                ArticleWrap articleWrap = new ArticleWrap(art.Title, art.UrlName, art.LastPublishedDate);
                articleWrapList.add(articleWrap);
                resultList.add(new ArticleSortWrap(articleWrap));
            }
        }
        resultList.sort();
        return resultList;
        
    }
}