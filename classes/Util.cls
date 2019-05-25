public class Util {
    public static final String CONFIG_NAME ='Default';
    public static final String String_TYPE ='String';
    public static ATST_Settings__c getSettings () {
        ATST_Settings__c atstSettings = null;
        Map<String, ATST_Settings__c> settingsMap =  ATST_Settings__c.getAll();
        if(settingsMap != null && settingsMap.containsKey(Util.CONFIG_NAME)) {
            atstSettings  = settingsMap.get(Util.CONFIG_NAME);
        }
        return atstSettings;
    }  
}