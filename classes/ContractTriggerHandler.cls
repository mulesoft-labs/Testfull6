/**
 * Description : Class to work with trigger handler    
 *
 * Author      : Nikhil (Perficient)
 * Date        : 12/16/2015
 * Version     : 1.0
 *
 * Version History : Nikhil  12/16/2015 Initial Development
 * Version History : Sid Sah 12/20/2017 Complying to Trigger Handler Pattern
 *
 */
public with sharing class ContractTriggerHandler extends CMsBaseTriggerHandler{
    Contract[] updatedContracts = Trigger.new;
    Map<Id, SObject> oldContractMap = Trigger.oldMap;
    static List<Id> accIds = new List<Id>();
    static SBQQ__Subscription__c[] activeCoresOnAccount;

    public override void afterUpdate() {
        set<Id> activatedContract = new set<Id>();
        for(Contract c : updatedContracts){
            if(!c.Assets_Converted__c && c.Status.equalsIgnoreCase('Activated')){
                activatedContract.add(c.id);
            }
        }
        if(!activatedContract.IsEmpty()){
            generateSubscriptionsOnContractActivate(activatedContract);
        }
    }


    /**
 * Description : OnAfterUpdate:create subscriptions (asset) when a contract is activated and use the contract related Subscriptions
 * (steelbrick object) to generate the Subscriptions (assets). No action is required if the contract is de-activated.
 * If a new contract is activated leave existing subscriptions (assets) as is and
 * create the new subscriptions (assets) based on the new subscriptions related to contract.
 */
    public static void generateSubscriptionsOnContractActivate(set<Id> activatedContract){
        Map<id,List<SBQQ__Subscription__c>> idContractLineItemmap=new Map<id,List<SBQQ__Subscription__c>>();
        Asset[] ast = new Asset[]{};
        Contract[] cntrct = new Contract[]{};
        set<Id> assetCopiedContract = new set<Id>();
        SBQQ__Subscription__c[] CLI = [SELECT SBQQ__Contract__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Account__c,SBQQ__Quantity__c,
                SBQQ__Product__c,SBQQ__ProductName__c,Product_Code__c
        FROM SBQQ__Subscription__c
        WHERE SBQQ__Contract__c = :activatedContract];
        for(SBQQ__Subscription__c clitem: CLI){
            accIds.add(clitem.SBQQ__Account__c);//Populating the accIds. Used later to get all Active Cores on Account
            if(idContractLineItemmap.containskey(clitem.SBQQ__Contract__c)){
                idContractLineItemmap.get(clitem.SBQQ__Contract__c).add(clitem);
            }
            else{
                List<SBQQ__Subscription__c> clitemlist=new List<SBQQ__Subscription__c>();
                clitemlist.add(clitem);
                idContractLineItemmap.put(clitem.SBQQ__Contract__c,clitemlist);
            }
        }
        for(id aci: activatedContract){
            if(idContractLineItemmap.containskey(aci)){
                if(idContractLineItemmap.get(aci) != null){
                    Asset a = new Asset();
                    for(SBQQ__Subscription__c o: idContractLineItemmap.get(aci)){
                        a = new Asset();
                        a.AccountId = o.SBQQ__Account__c;
                        a.Product2Id = o.SBQQ__Product__c;
                        a.Start_Date__c = o.SBQQ__StartDate__c;
                        a.End_Date__c = o.SBQQ__EndDate__c;
                        a.Quantity = o.SBQQ__Quantity__c;
                        a.Name =o.SBQQ__ProductName__c;
                        a.SBQQ__CurrentSubscription__c = o.Id;
                        ast.add(a);
                        assetCopiedContract.add(aci);
                    }
                }
            }
        }

        if(!ast.isEmpty()){
            try {
                insert ast;
            } catch (system.Dmlexception e) {
                system.debug (e);
            }
        }
        //Querying Asset again to retrive the ProductCode from the SBQQ__CurrentSubscription__c lookup
        List<asset> assetList = [SELECT Id,AccountId,Product2Id, Start_Date__c,End_Date__c,Quantity, Name,SBQQ__CurrentSubscription__c,
                SBQQ__CurrentSubscription__r.Product_Code__c FROM Asset WHERE id IN :ast];

        //Querying SBQQ__CurrentSubscription__c to find the Active Cores on Account
        activeCoresOnAccount = [SELECT SBQQ__Contract__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Account__c,SBQQ__Quantity__c,
                SBQQ__Product__c,SBQQ__ProductName__c,Product_Code__c
        FROM SBQQ__Subscription__c
        WHERE SBQQ__Account__c = :accIds AND
        SBQQ__StartDate__c <= TODAY AND SBQQ__EndDate__c >= TODAY];

        //Create License Keys and Populate Attachments related list from the Activated Contract
        generateLicenseKeys(assetList, activatedContract);

        if(!assetCopiedContract.isEmpty()){
            for(id aci: assetCopiedContract){
                Contract c = new Contract(Id = aci,Assets_Converted__c=true);
                cntrct.add(c);
            }

            if(!cntrct.isEmpty()){
                try {
                    update cntrct;
                } catch (system.Dmlexception e) {
                    system.debug (e);
                }
            }
        }
    }

    private static void generateLicenseKeys(Asset[] assets, set<Id> activatedContract) {
        List<License__c> licenses = new List<License__c>();
        List<Attachment> attList = new List<Attachment>();

        for(Asset a : assets) {
            if(CSMsAttachLicenseKey__c.getValues(a.SBQQ__CurrentSubscription__r.Product_Code__c) != null &&
                    CSMsAttachLicenseKey__c.getValues(a.SBQQ__CurrentSubscription__r.Product_Code__c).Require_License_Key__c){
                //Now check if in Custom setting Needs_Attachment_if_Cores__c is true?
                if(!CSMsAttachLicenseKey__c.getValues(a.SBQQ__CurrentSubscription__r.Product_Code__c).Needs_Attachment_if_Cores__c
                        || accountHasActiveCoreProducts(a.SBQQ__CurrentSubscription__r.Product_Code__c)) {
                    License__c lic = new License__c();
                    lic.Product__c = a.Id;//This is the master-detail relationship
                    lic.Issue_Date__c = a.Start_Date__c;
                    lic.Expiration_Date__c = a.End_Date__c;
                    lic.Subscription__c = a.SBQQ__CurrentSubscription__c;
                    licenses.add(lic);
                }
            }
        }

        if(!licenses.isEmpty()){
            try {
                insert licenses; //Licenses records got created
            } catch (system.Dmlexception e) {
                system.debug (e);
            }
        }
        List<Id> licKeyReqIds = new List<Id>();
        List<Licence_Key_Request__c> licKeyRequests = [SELECT Request_Status__c, Generation_Date__c, Contract__c
        FROM Licence_Key_Request__c WHERE contract__c IN :activatedContract AND Request_Status__c = 'Completed'
        ORDER BY Generation_Date__c desc Limit 1];
        for(Licence_Key_Request__c lkr : licKeyRequests){
            licKeyReqIds.add(lkr.Id);
        }
        if(licKeyReqIds.size() > 0) {
            //Query to pick only the license Key(.lic extension) from the Notes/Attachment
            String soql = Utils.getCreatableFieldsSOQL('Attachment', 'ParentId IN :licKeyReqIds AND Name Like \'%.lic\' ORDER BY createddate desc LIMIT 1');
            List<Attachment> atts = (List<Attachment>) Database.query(soql);
            if (atts.size() > 0) {
                for (integer i = 0; i < licenses.size(); i++) {
                    Attachment att1 = atts[0].clone(false, false);
                    att1.ParentId = licenses[i].Id;
                    attList.add(att1);
                }
            }
        }
        try {
            insert attList; //Attachments records got created
        } catch (system.Dmlexception e) {
            system.debug (e);
        }
    }

    private static Boolean accountHasActiveCoreProducts(String prodCode) {
        if(CSMsAttachLicenseKey__c.getValues(prodCode) != null && CSMsAttachLicenseKey__c.getValues(prodCode).Needs_Attachment_if_Cores__c){
            for(SBQQ__Subscription__c s: activeCoresOnAccount){
                if(CSMsAttachLicenseKey__c.getValues(s.Product_Code__c) != null && CSMsAttachLicenseKey__c.getValues(s.Product_Code__c).Require_License_Key__c
                        && CSMsAttachLicenseKey__c.getValues(s.Product_Code__c) !=null
                        && CSMsAttachLicenseKey__c.getValues(s.Product_Code__c).Needs_Attachment_if_Cores__c == false){
                    return true;
                }
            }
        }
        return false;
    }
}