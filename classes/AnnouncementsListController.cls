/*****************************************************************************
 * Description : Controller class for Announcements lightning component
 *
 *        
 * Author      : Wade Liu (Perficient)
 * Date        : 05/12/2016
 * Version     : 1.0
 *
 * Version History : 
 * 
 *****************************************************************************/
public class AnnouncementsListController {

    private static List<Announcement__kav> getAnnouncements(Integer size) {
        size = Integer.valueOf(size);
        return [SELECT Id, UrlName, Title, LastPublishedDate, Critical__c 
        FROM Announcement__kav WHERE PublishStatus = 'online' and Language = 'en_US' 
        ORDER BY Critical__c DESC, LastPublishedDate DESC LIMIT :size];
    }   
    
    public class AnnouncementWrap{
        @AuraEnabled
        public String Title{get;set;}
        @AuraEnabled
        public String UrlName{get;set;}
        @AuraEnabled
        public String LastPublishedDate{get;set;}
        
        public AnnouncementWrap(String TitleIN, String UrlNameIN, Datetime LastPublishedDateIN){
            Title = TitleIN;
            UrlName = UrlNameIN;
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
    public static List<AnnouncementWrap> getAnnouncementWraps(Integer size) {
        size = Integer.valueOf(size);
        List<Announcement__kav> announcementList = getAnnouncements(size);
        List<AnnouncementWrap> resultList = new List<AnnouncementWrap>();
        if(announcementList != null && !announcementList.isEMpty()){
            for(Announcement__kav announcement : announcementList){
                AnnouncementWrap announcementWrap = new AnnouncementWrap(announcement.Title, announcement.UrlName, announcement.LastPublishedDate);
                resultList.add(announcementWrap);
            }
        }
        return resultList;
        
    }
}