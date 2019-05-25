/*********************************************************************
*
*   File Name: OpportunityCloneHandler.cls
*
*   File Description: This class is to clone Opportunit and its child 
*                     records when opportunity is closed Won
*
**********************************************************************
*
*   Date    Author        Change
*  10/31/14  Rob          Initial Creation              
*
*********************************************************************/   

public class OpportunityCloneHandler
{
    public static Boolean cloneOpportunity = true;
    
   /**
   * Function to clone Opportunity and its child records
   */    
    public static void cloneOpportunity(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap)
    {
        if(oppList.size() == 1)
        {
            //cloneOpportunity = false;
            List<Opportunity> eligibleOpps = new List<Opportunity>();
            Set<Id> eligibleOppsIds = new Set<Id>();
            Map<Id,Id> eligibleOppIdOldOppId = new Map<Id,Id>();
            
            for(Opportunity o : oppList)
            {
                /* System.debug('???? Opportunity Info'+ o.Type + '???' + o.StageName + '???' + oldOppMap.get(o.Id).StageName);
                if((o.Type == 'New Business' || o.Type == 'Add-On Business' || o.Type == 'Renewal') && o.StageName == 'Closed Won' && o.StageName != oldOppMap.get(o.Id).StageName
                    && o.Sales_Channel__c != 'Advertising' && o.Contract_End_Date__c != null) */
                    eligibleOppsIds.add(o.Id);
            }
            
            String query = getCreatableFieldsSOQL('Opportunity');
            
            query = query + ' Where Id IN :eligibleOppsIds';
            System.debug('???'+query);
            
            eligibleOpps = Database.query(query);
            
            System.debug('????? size of elegible opps'+eligibleOpps.size());
            
            for(Opportunity o : eligibleOpps)
            {
                o.Opportunity_Id__c = o.Id;
                o.Stagename = 'Verbal Win';
                o.Probability = 75;
                o.Type = 'Renewal';
                o.Forecast__c = 'Likely';
                o.CloseDate = o.Closedate.addYears(1);
                o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId();
                if(o.Contract_End_Date__c != null)
                {
                    o.Contract_End_Date__c = o.Contract_End_Date__c.addYears(1);
                }
                String clonedOppName = o.Name + ' - ' + String.valueOf(o.CloseDate);
                if(clonedOppName.length() > 100)
                {
                    Integer overage = clonedOppName.length() - 100;
                    clonedOppName = o.Name.left(o.Name.length() - overage);
                    clonedOppName += ' - ' + String.valueOf(o.CloseDate);
                }
                o.Name = clonedOppName;
                
                if(o.Primary_Solution_Interest__c == null)
                {
                    o.Primary_Solution_Interest__c = 'SOA';
                }
            }
            
            List <Opportunity> clonedOppties = new List<Opportunity>();
            clonedOppties = eligibleOpps.deepclone(false,false,false);
            
            insert clonedOppties;
            if(clonedOppties.size()>0)
            System.debug('????? Id'+clonedOppties[0].Id);
            
            for(Opportunity o : clonedOppties)
            {
                eligibleOppIdOldOppId.put(o.Opportunity_Id__c, o.Id);
            }
            // OpportunityLineItem Cloning
            String querylineItem = getCreatableFieldsSOQL('OpportunityLineItem');
            querylineItem = querylineItem + ' Where OpportunityId IN :eligibleOppsIds';
            
            List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
            oppLineItemList = Database.query(querylineItem);
            
            List<OpportunityLineItem> oppLineItemToClone = new List<OpportunityLineItem>();
            
            for(OpportunityLineItem op : oppLineItemList)
            {
                OpportunityLineItem o = new OpportunityLineItem();
                sObject s = (sObject)o;
                
                for (Schema.SObjectField ft : Schema.getGlobalDescribe().get('opportunitylineitem').getDescribe().Fields.getMap().values()){ // loop through all field tokens (ft)
                    Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                    if (fd.isCreateable() && fd.getName() != 'TotalPrice'){ // field is creatable
                        String fieldName = fd.getName();
                        s.put(fieldName, op.get(fieldName));
                    }
                }
                OpportunityLineItem cloneOppLineItem = (OpportunityLineItem)s;
                cloneOppLineItem.OpportunityId = eligibleOppIdOldOppId.get(op.OpportunityId);
                if(op.ServiceDate != null)
                    cloneOppLineItem.ServiceDate = op.ServiceDate.addYears(1);
                if(op.Start_Date__c != null)
                    cloneOppLineItem.Start_Date__c = op.Start_Date__c.addYears(1);
                if(op.End_Date__c != null)
                    cloneOppLineItem.End_Date__c = op.End_Date__c.addYears(1);
                
                oppLineItemToClone.add(cloneOppLineItem);
            }

            insert oppLineItemToClone;

            
            // Cloning other generic child records
            for(OpportunityCloning__c oc : OpportunityCloning__c.getall().values())
            {
                String childQuery = getCreatableFieldsSOQL(oc.Name);
                childQuery = childQuery + ' Where ' + oc.OpportunityLookUpAPI_Name__c + ' IN :eligibleOppsIds';
                List<sObject> childRecords = (List<sObject>)Database.query(childQuery);
                List<sObject> clonedChildRecordsToInsert = new List<sObject>();
                for(sObject s : childRecords)
                {
                    Type t = Type.forName(oc.Name);
                    sObject sobj = (sObject) t.newInstance();
                    for( Schema.SObjectField ft : Schema.getGlobalDescribe().get(oc.Name.toLowerCase()).getDescribe().Fields.getMap().values())
                    {
                        Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                        if (fd.isCreateable() && fd.getName() != oc.OpportunityLookUpAPI_Name__c){ // field is creatable
                            String fieldName = fd.getName();
                            sobj.put(ft,s.get(fieldName));
                        }
                    }
                    sobj.put(oc.OpportunityLookUpAPI_Name__c, eligibleOppIdOldOppId.get((Id)s.get(oc.OpportunityLookUpAPI_Name__c)));
                    clonedChildRecordsToInsert.add(sobj);
                    
                }
                
                insert clonedChildRecordsToInsert;
                
            }
        }
        
    }
    
   /**
   * Function to generate query dynamically
   */ 
    
    public static string getCreatableFieldsSOQL(String objectName){
         
        String selects = '';

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
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
                 
        return 'SELECT ' + selects + ' FROM ' + objectName;
         
    }

}