public with sharing class Utils{ 
 
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
		return getCreatableFieldsSOQL(objectName, whereClause, null);
    }
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause, List<String> excludedFields){
        Set<String> excludedFieldsSet = new Set<String>();
        if(excludedFields != null){
            for(Integer i=0; i < excludedFields.size();i++){
                String excludeFiledName = excludedFields.get(i);
                excludedFieldsSet.add(excludeFiledName.toLowerCase());
            }
        }

 
        if (whereClause == null || whereClause == ''){ return null; }
 
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
 
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         String selects = 'SELECT ' + selectFields.get(0);

        for (Integer i = 1; i < selectFields.size(); i++) {

            if (excludedFieldsSet.contains(selectFields.get(i).tolowercase())) continue;

            selects += ', ' + selectFields.get(i);
        }
        
        System.debug('Returning this dynamic soql: ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause);
 
        return selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
 
    }
}