public class ObjectListView {

    @auraEnabled
    public String query {get;set;}
    
    @auraEnabled
    public List<List<Object>> dataSet {get;set;}

    @auraEnabled
    public List<Column> columns {get;set;}

    public class Column {
	    @auraEnabled
        public String label {get;set;}

	    @auraEnabled
        public Boolean isName {get;set;}

	    @auraEnabled
        public String columnType {get;set;}
        
        @auraEnabled
        public String apiName {get;set;}
        
        public String relationshipName {get;set;}
    }
}