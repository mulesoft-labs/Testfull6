/*****************************************************************************
 * Description : controller class for Downloads_Library lightning component
 * Quote
 *
 *        
 * Author      : Wade Liu (Perficient)
 * Date        : 05/18/2016
 * Version     : 1.0
 *
 * Version History : 
 * 03/20/2017 - Eno Gjerasi - Limit downloads to latest versions only (IsLatest = TRUE)
 * 
 *****************************************************************************/
public without sharing class DownloadsListController {
    private static List<ContentVersion> getDownloads(String libraryId, Integer size, String filter, String orderSeq) {
        size = Integer.valueOf(size);
        if(libraryId != null && libraryId != ''){
            if(filter.toUpperCase() == 'VERSION__C'){
                filter = 'Version_Formula__c';
            }
            if(orderSeq.toUpperCase() == 'DESC'){
                orderSeq = orderSeq + ' NULLS LAST';
            }
            String queryStr = 'SELECT Id, Title, Version__c, Release_Date__c, Checksum, ContentDocumentId ' +
            'FROM ContentVersion WHERE ContentDocument.ParentId =\''+libraryId + '\' AND Public__c = true '+ 
            'AND IsLatest = TRUE ORDER BY ' + filter + ' ' + orderSeq + ' LIMIT ' + size;
            return Database.query(queryStr);
        }
        else return null;
    } 
    
    @AuraEnabled
    public static String getLibraryTitle(String libraryId){
        String result = '';
        List<ContentWorkspace> workspaces = new List<ContentWorkspace>();
        workspaces = [SELECT Name FROM ContentWorkspace WHERE Id =:libraryId];
        if(!workspaces.isEmpty()){
            result = workspaces[0].Name;
        }
        return result;
    }
    
    public class DownloadWrap{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Title{get;set;}
        @AuraEnabled
        public String Version{get;set;}
        @AuraEnabled
        public String Checksum{get;set;}
        @AuraEnabled
        public String Release_Date{get;set;}
        
        public DownloadWrap(){}
        
        public DownloadWrap(String IdIN, String TitleIN, String VersionIN, Date Release_DateIn, String ChecksumIN){
            Id = IdIN;
            Title = TitleIN;
            Version = VersionIN;
            if(Release_DateIn != null){
                Date toDate = Release_DateIn;
                Integer day = toDate.day();
                Integer month = toDate.month();
                Integer year = toDate.year();
                if(month < 10){
                    Release_Date = '0' + month + '-';
                }
                else{
                    Release_Date = month + '-';
                }
                if(day < 10){
                    Release_Date = Release_Date + '0' + day + '-';
                }
                else{
                    Release_Date = Release_Date + day + '-';
                }
                Release_Date = Release_Date + year;
            }
            else{
                Release_Date = '';
            }
            Checksum = ChecksumIN;
        }
    }
    
    @AuraEnabled
    public static List<DownloadWrap> getDownloadWraps(String libraryId, Integer size, String filter, String orderSeq) {
        size = Integer.valueOf(size);
        List<ContentVersion> downloadtList = getDownloads(libraryId, size, filter, orderSeq);
        List<DownloadWrap> resultList = new List<DownloadWrap>();
        if(downloadtList != null && !downloadtList.isEMpty()){
            for(ContentVersion download : downloadtList){
                DownloadWrap downloadWrap = new DownloadWrap(download.Id, download.Title, download.Version__c, download.Release_Date__c, download.Checksum);
                resultList.add(downloadWrap);
            }
        }
        return resultList;
    }
    
    @AuraEnabled
    public static DownloadWrap getCurrentDownloadWrap(String downloadId) {
        List<ContentVersion> downloadtList = new List<ContentVersion>();
        downloadtList = [SELECT Id, Title, Version__c, Release_Date__c, Checksum, ContentDocumentId 
            FROM ContentVersion WHERE Id =:downloadId LIMIT 1];
        
        DownloadWrap result = new DownloadWrap();
        if(!downloadtList.isEMpty()){
            ContentVersion download = downloadtList[0];
            result = new DownloadWrap(download.Id, download.Title, download.Version__c, download.Release_Date__c, download.Checksum);
        }
        return result;
    }
}