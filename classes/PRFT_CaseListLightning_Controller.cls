public class PRFT_CaseListLightning_Controller {
    
    public static final Integer MAX_LIMIT = 2000;
    public static final Integer PAGE_SIZE = 2000;
    
    @auraEnabled
    public static String getViewIdByName(String viewName ){ 
        ListView view = (String.isEmpty(viewName)) 
            ? null 
            : [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND DeveloperName = :viewName];
        return (view != null) ? view.Id : '';
    }
    
    @auraEnabled
    public static List<String> getColumns(String fieldSetName, String ObjectName) {
        List<String> columns = new List<String>();

        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(ObjectName);
        Schema.FieldSet fieldSetObj = sObjType.getDescribe().FieldSets.getMap().get(fieldSetName);
        Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
        
        for (Schema.FieldSetMember fieldSetMember : fieldSetObj.getFields()) {
            Schema.Sobjectfield f = fieldMap.get(fieldSetMember.getFieldPath());
            Schema.DescribeFieldResult fDescribe = f.getDescribe();
            Schema.DisplayType displayType = fDescribe.getType();
            if (displayType == Schema.DisplayType.Reference) {
                columns.add(fDescribe.getRelationshipName() + ' Name');
            } else {
                columns.add(fieldSetMember.getLabel());
            }
        }        
        return columns;
    }
    
    @AuraEnabled
    public static List<List<Object>> getFilteredCaseList(String viewName , String fieldSetName, String objectName){
        String filterId = PRFT_CaseListLightning_Controller.getViewIdByName(viewName);
        ObjectListView objListView = PRFT_CaseListLightning_Controller.getObjectListView(fieldSetName, objectName);
        System.debug('query = ' + objListView.query);

        ApexPages.StandardSetController caseSetCtrl = PRFT_CaseListLightning_Controller.getController(objListView.query, filterId, PAGE_SIZE);
        List<SObject> cases = PRFT_CaseListLightning_Controller.getAllCases(caseSetCtrl);

        List<List<Object>> result =  PRFT_CaseListLightning_Controller.caseToList(cases, objListView.columns, objectName);
        //objListView.dataSet = result;
        return result;
    }
    
    public static ObjectListView getObjectListView(String fieldSetName, String objectName) {
        ObjectListView objListView = new ObjectListView();
        List<ObjectListView.Column> columns = new List<ObjectListView.Column>();
        
        String query = 'SELECT Id, ';
        String fieldsList = '';
        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(ObjectName);
        Schema.FieldSet fieldSetObj = sObjType.getDescribe().FieldSets.getMap().get(fieldSetName);
        
        Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
        for (Schema.FieldSetMember fieldSetMember : fieldSetObj.getFields()) {
            Schema.Sobjectfield f = fieldMap.get(fieldSetMember.getFieldPath());
            Schema.DescribeFieldResult fDescribe = f.getDescribe();

            System.debug('fieldPath = ' + fieldSetMember.getFieldPath());
            query += fieldSetMember.getFieldPath() + ', ';
            
            ObjectListView.Column column = new ObjectListView.Column();
            columns.add(column);
            column.label = fDescribe.getLabel();
            column.apiName = fieldSetMember.getFieldPath();
            Schema.DisplayType displayType = fDescribe.getType();
            if (displayType == Schema.DisplayType.Reference) {
                column.columnType = 'reference';
                query += fDescribe.getRelationshipName() + '.Name, ';
                column.relationshipName = fDescribe.getRelationshipName();
                column.label = fDescribe.getRelationshipName() + ' Name';
            } else {
                if (displayType == Schema.DisplayType.DATE) {
                    column.columnType = 'date';
                } else if (displayType == Schema.DisplayType.DATETIME) {
                    column.columnType = 'datetime';
                } else {
                    column.columnType = 'string';
                }
            }
            
            column.isName = fDescribe.isNameField();
            
            System.debug('label = ' + fieldSetMember.getLabel() 
                         + ' isname = ' + fDescribe.isNameField() + 
                         ' reference = ' + (fDescribe.getType() == Schema.DisplayType.Reference) );
        }
        query = query.substring(0, query.length()-2) + ' FROM Case LIMIT ' + MAX_LIMIT;
        //System.debug('query = ' + query);
        
        objListView.columns = columns;
        objListView.query = query;
        return objListView;
    }
    
    public static ApexPages.StandardSetController getController(String query, String filterId, Integer pageSize) {
        ApexPages.StandardSetController caseSetCtrl = 
            new ApexPages.StandardSetController(Database.getQueryLocator(query));   //Database.query(query)
        caseSetCtrl.setPageSize(pageSize);
        caseSetCtrl.setFilterId(filterId);
        
        return caseSetCtrl;        
    }
    
    public static List<SObject> getAllCases(ApexPages.StandardSetController caseSetCtrl) {
        List<SObject> cases = new List<SObject>();
        
        cases.addAll(caseSetCtrl.getRecords());
        while(caseSetCtrl.getHasNext()) {
            caseSetCtrl.next();
            cases.addAll(caseSetCtrl.getRecords());
        }
        
        return cases;        
    }
    
    public static List<List<Object>> caseToList(List<Case> cases, List<ObjectListView.Column> columns, String objectName) {
        List<List<Object>> results = new List<List<Object>>();
        for (Case c : cases) {
            List<Object> caseData = new List<Object>();
            results.add(caseData);
            
            for (ObjectListView.Column columnInfo : columns) {
                
                if (columnInfo.columnType == 'reference') {
                    
                    Sobject lookupObj = c.getSObject(columnInfo.relationshipName);
                    String href = '';
                    String value = '';
                    if (lookupObj != null) {
                       href = (String) c.get(columnInfo.apiName);
                       value = (String)lookupObj.get('Name');
                        caseData.add(System.Label.Support_Community_URL + columnInfo.relationshipName.toLowerCase() + '/' + href + '$#@$' + value);
                    } else {
                        caseData.add('');
                    }
                } else if (columnInfo.columnType == 'date') {
                    Date d = (c.get(columnInfo.apiName) == null) ? null : (Date)c.get(columnInfo.apiName);
                    String dt = (d == null) ? '' : DateTime.newInstance(d.year(), d.month(), d.day()).format('MM-dd-YYYY');
                    caseData.add(dt);
                } else if (columnInfo.columnType == 'datetime') {
                    Datetime d = (c.get(columnInfo.apiName) == null) ? null : (Datetime)c.get(columnInfo.apiName);
                    String dt = (d == null) ? '' : d.format('MM-dd-YYYY HH:mm');
                    caseData.add(dt);
                } else if (columnInfo.isName) {
                    caseData.add(System.Label.Support_Community_URL + objectName.toLowerCase() + '/' + c.get('Id') + '$#@$' + c.get(columnInfo.apiName));
                } else {
                    caseData.add(c.get(columnInfo.apiName) == null ? '' : c.get(columnInfo.apiName));
                }
                
            }
        }
        return results;
    }   
}