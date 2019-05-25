global with sharing class UpdateLeadsBatch implements Database.Batchable<sObject> {
	
   global final String Query;
   global final String Entity;
   global final String Field;
   global final String Value;

   global UpdateLeadsBatch(String q, String e, String f, String v){
             Query=q; Entity=e; Field=f;Value=v;
   }
   
   global UpdateLeadsBatch(){
             Query = 'select id,name from Lead where isconverted=false';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      for(Sobject s : scope){ 
      }      update scope;
   }

   global void finish(Database.BatchableContext BC){

   }



}