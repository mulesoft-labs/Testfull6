public class CMsAnypointOrganizationTriggerHandler extends CMsBaseTriggerHandler {
	private static Set<Id> masterIds = new Set<Id>();
	Map<Id, AnypointOrganization__c> oldMap = (Map<Id, AnypointOrganization__c>)Trigger.oldMap;
	static Decimal preProdVcoresTotalQty = 0.0;
	static Decimal prodVcoresTotalQty = 0.0;
	private static Set<Id> parentIds = new Set<Id>();


	public override void beforeInsert() {
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.new){
			org.status__c = 'Active';//Data Set only has Active Orgs
			if(org.Master_Parent_Anypoint_Organization__c == null){
				org.Master_Parent_PreProd_Vcores_Used__c = org.SandboxVcoresUsed__c;
				org.Master_Parent_Prod_Vcores_Used__c = org.ProductionVcoresUsed__c;
				org.Master_Parent_PreProd_Transaction__c = org.PreProd_Transaction__c;
				org.Master_Parent_PreProd_Spare__c = org.PreProd_Spare__c;
				org.Master_Parent_Prod_Transaction__c = org.Prod_Transaction__c;
				org.Master_Parent_Prod_Spare__c = org.Prod_Spare__c;
				org.Master_Parent_PreProd_Vcores_Total__c = org.SandboxVcoresTotal__c;
				org.Master_Parent_Prod_Vcores_Total__c = org.ProductionVcoresTotal__c;
			}
		}
	}

	public override void afterInsert() {
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.new){
			if(org.Master_Parent_Anypoint_Organization__c != null){
				masterIds.add(org.Master_Parent_Anypoint_Organization__c);
			}

			if(org.AnypointParentOrganizationId__c  != null){
				parentIds.add(org.AnypointParentOrganizationId__c );
			}
		}
		if(masterIds.size() > 0){
			updateMasterParentCount(masterIds);
		}
		if(parentIds.size() > 0){
			updateParentCount(parentIds);
		}
	}

	private void updateParentCount(set<Id> parentIdSet){
		System.debug(LoggingLevel.ERROR,'----->parentIdSet -->  '+ parentIdSet);
		List<AnypointOrganization__c> apOrgsToUpdate = new List<AnypointOrganization__c>();
		//Get a map of the AnypointOrganization__c with the number of children
		Map<Id, AnypointOrganization__c> apOrgsMap = new Map<Id,AnypointOrganization__c>([SELECT Id, AnypointParentOrganizationId__c FROM AnypointOrganization__c WHERE Id IN :parentIdSet]);

		//Query the Opportunity and the related children and add the size of the children to the Parent Contract
		for (AnypointOrganization__c ap : [SELECT Id, Name, AnypointParentOrganizationId__c, Num_of_Immediate_Children__c,(SELECT Id FROM Anypoint_Organizations__r)
		FROM AnypointOrganization__c WHERE Id IN :parentIdSet]) {
			apOrgsMap.get(ap.Id).Num_of_Immediate_Children__c = ap.Anypoint_Organizations__r.size();
			//add the child Contract in the map to a list so we can update it
			apOrgsToUpdate.add(apOrgsMap.get(ap.Id));
		}
		System.debug(LoggingLevel.ERROR,'-----> apOrgsToUpdate  --> '+ apOrgsToUpdate);
		//if(Trigger.isUpdate || (Trigger.isAfter && Trigger.isDelete)){
		update apOrgsToUpdate;
		// }
	}

	public override void beforeUpdate() {
		Set<Id> masterIds = new Set<Id>();
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.new){
			masterIds.add(org.Id);
		}
		System.debug(LoggingLevel.ERROR,'masterIds --> masterIds --> '+ masterIds);
		List<AnypointOrganization__c> childOrgs = [SELECT Id FROM AnypointOrganization__c WHERE status__c = 'Active' AND Master_Parent_Anypoint_Organization__c IN :masterIds];
		System.debug(LoggingLevel.ERROR,'childOrgs --> '+ childOrgs);
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.new){
			if(org.Master_Parent_Anypoint_Organization__c == null && childOrgs.size() == 0){
				org.Master_Parent_PreProd_Vcores_Used__c = org.SandboxVcoresUsed__c;
				org.Master_Parent_Prod_Vcores_Used__c = org.ProductionVcoresUsed__c;
				org.Master_Parent_PreProd_Transaction__c = org.PreProd_Transaction__c;
				org.Master_Parent_PreProd_Spare__c = org.PreProd_Spare__c;
				org.Master_Parent_Prod_Transaction__c = org.Prod_Transaction__c;
				org.Master_Parent_Prod_Spare__c = org.Prod_Spare__c;
				org.Master_Parent_PreProd_Vcores_Total__c = org.SandboxVcoresTotal__c;
				org.Master_Parent_Prod_Vcores_Total__c = org.ProductionVcoresTotal__c;
			}
		}
	}

	public override void afterUpdate() {
		Set<Id> masterParentIds = new Set<Id>();
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.new){
			masterParentIds.add(org.Id);
			if(org.AnypointParentOrganizationId__c  != null){
				parentIds.add(org.AnypointParentOrganizationId__c );
			}
		}
		System.debug(LoggingLevel.ERROR,'masterParentIds --> '+ masterParentIds);
		System.debug(LoggingLevel.ERROR,'masterIds --> masterIds --> '+ masterIds);
		List<AnypointOrganization__c> childOrgs = [SELECT Id FROM AnypointOrganization__c WHERE status__c = 'Active' AND Master_Parent_Anypoint_Organization__c IN :masterParentIds];

		for (AnypointOrganization__c oldOpp : (List<AnypointOrganization__c>)Trigger.old){
			if(oldOpp.Master_Parent_Anypoint_Organization__c != null){
				masterIds.add(oldOpp.Master_Parent_Anypoint_Organization__c);
			}
			if(oldOpp.AnypointParentOrganizationId__c  != null){
				parentIds.add(oldOpp.AnypointParentOrganizationId__c );
			}
		}

		System.debug(LoggingLevel.ERROR,'masterIds --> masterIds --> '+ masterIds);
		System.debug(LoggingLevel.ERROR,'parentIds --> parentIds --> '+ parentIds);

		//When we link an existing AnypointOrganization__c to be a child, Trigger.new will have value for Parent_AnypointOrganization__c
		for (AnypointOrganization__c newOpp : (List<AnypointOrganization__c>)Trigger.new){
			if(newOpp.Master_Parent_Anypoint_Organization__c != null){
				masterIds.add(newOpp.Master_Parent_Anypoint_Organization__c);
			}
		}
		if(masterIds.size() > 0) {
			updateMasterParentCount(masterIds);
		} else if(masterParentIds.size()>0 && childOrgs.size() > 0){
			System.debug(LoggingLevel.ERROR,'ELSE -->');
			updateMasterParentCount(masterParentIds);
		}

		if(parentIds.size() > 0){
			updateParentCount(parentIds);
		}
	}

	public override void afterDelete(){
		for (AnypointOrganization__c org : (List<AnypointOrganization__c>)Trigger.old) {
			if(org.Master_Parent_Anypoint_Organization__c  != null){
				masterIds.add(org.Master_Parent_Anypoint_Organization__c );
			}
			if(org.AnypointParentOrganizationId__c  != null){
				parentIds.add(org.AnypointParentOrganizationId__c );
			}
		}

		if(masterIds.size() > 0){
			updateMasterParentCount(masterIds);
		}
		if(parentIds.size() > 0){
			updateParentCount(parentIds);
		}
	}

	private void updateMasterParentCount(set<Id> masterIdSet){
		System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> updateMasterParentCount --> masterIdSet --> '+ masterIdSet);
		Map<Id, AnypointOrganization__c> masterToUpdate = new Map<Id, AnypointOrganization__c>();
		Map<id,AnypointOrganization__c> masterLocalOrgMap = New Map<id,AnypointOrganization__c>([SELECT Id, SandboxVcoresTotal__c, SandboxVcoresUsed__c, ProductionVcoresTotal__c, ProductionVcoresUsed__c, ProductionVcoresReassigned__c, SandboxVcoresReassigned__c,PreProd_Transaction__c,
				PreProd_Spare__c, Prod_Transaction__c , Prod_Spare__c
		FROM AnypointOrganization__c
		WHERE status__c = 'Active' AND Id IN :masterIdSet]);

		System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> updateMasterParentCount --> masterLocalOrgMap --> '+ masterLocalOrgMap);
		for(AnypointOrganization__c ao : masterLocalOrgMap.values()){
			if(ao != null){
				masterToUpdate.put(ao.Id, new AnypointOrganization__c(Id = ao.Id, Master_Parent_PreProd_Vcores_Used__c = 0,
						Master_Parent_Prod_Vcores_Used__c = 0, Master_Parent_PreProd_Spare__c = 0,Master_Parent_Prod_Spare__c = 0,
						Master_Parent_PreProd_Transaction__c = 0,Master_Parent_Prod_Transaction__c = 0));
			}
		}

		List<AnypointOrganization__c> apOrgsTotal = [SELECT  ProductionVcoresTotal__c , SandboxVcoresTotal__c FROM AnypointOrganization__c WHERE status__c = 'Active' AND Id IN :masterIdSet];
		for(AnypointOrganization__c ao : apOrgsTotal){
			preProdVcoresTotalQty = ao.SandboxVcoresTotal__c;
			prodVcoresTotalQty = ao.ProductionVcoresTotal__c;
		}
		List<aggregateResult> coresVcoresAggregateTotals = [SELECT  Master_Parent_Anypoint_Organization__c masterId,
				//SUM(SandboxVcoresTotal__c) PreProdVcoresTotal,
				SUM(SandboxVcoresUsed__c) PreProdVcoresUsed,
				//SUM(ProductionVcoresTotal__c) ProdVcoresTotal,
				SUM(ProductionVcoresUsed__c) ProdVcoresUsed,
				SUM(PreProd_Transaction__c) PreProdTransaction,
				SUM(PreProd_Spare__c) PreProdSpare,
				SUM(Prod_Transaction__c) ProdTransaction,
				SUM(Prod_Spare__c) ProdSpare
		FROM AnypointOrganization__c
		WHERE status__c = 'Active' AND Master_Parent_Anypoint_Organization__c IN :masterIdSet
		GROUP BY Master_Parent_Anypoint_Organization__c];

		System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> coresVcoresAggregateTotals --> '+ coresVcoresAggregateTotals);
		//Decimal preProdVcoresTotalQty = 0.0;
		//Decimal prodVcoresTotalQty = 0.0;
		Decimal preProdVcoresUsedQty = 0.0;
		Decimal prodVcoresUsedQty = 0.0;
		Decimal preprodTransactionQty = 0.0;
		Decimal preProdSpareQty = 0.0;
		Decimal prodTransactionQty = 0.0;
		Decimal prodSpareQty = 0.0;


		for(aggregateResult ar : coresVcoresAggregateTotals) {
			System.debug(LoggingLevel.ERROR,'----->---------->----->> ar --> '+ ar);
			AnypointOrganization__c ao = masterLocalOrgMap.get((Id)ar.get('masterId'));
			System.debug(LoggingLevel.ERROR,'-------> ao --> '+ ao);
			if(ao !=null){
				//preProdVcoresTotalQty = (ao.SandboxVcoresTotal__c == null ? 0:ao.SandboxVcoresTotal__c)+ ((ar.get('PreProdVcoresTotal') == null)?0:(Decimal)ar.get('PreProdVcoresTotal'));
				//prodVcoresTotalQty =  (ao.ProductionVcoresTotal__c == null ? 0:ao.ProductionVcoresTotal__c)+ ((ar.get('prodVcoresTotal') == null)?0:(Decimal)ar.get('prodVcoresTotal'));
				preProdVcoresUsedQty = (ao.SandboxVcoresUsed__c == null ? 0:ao.SandboxVcoresUsed__c)+ ((ar.get('preProdVcoresUsed') == null)?0:(Decimal)ar.get('preProdVcoresUsed'));
				prodVcoresUsedQty = (ao.ProductionVcoresUsed__c == null ? 0:ao.ProductionVcoresUsed__c)+ ((ar.get('prodVcoresUsed') == null)?0:(Decimal)ar.get('prodVcoresUsed'));
				preprodTransactionQty = (ao.PreProd_Transaction__c == null ? 0:ao.PreProd_Transaction__c)+ ((ar.get('PreProdTransaction') == null)?0:(Decimal)ar.get('PreProdTransaction'));
				preProdSpareQty = (ao.PreProd_Spare__c == null ? 0:ao.PreProd_Spare__c)+ ((ar.get('PreProdSpare') == null)?0:(Decimal)ar.get('PreProdSpare'));
				prodTransactionQty = (ao.Prod_Transaction__c == null ? 0:ao.Prod_Transaction__c)+ ((ar.get('ProdTransaction') == null)?0:(Decimal)ar.get('ProdTransaction'));
				prodSpareQty = (ao.Prod_Spare__c == null ? 0:ao.Prod_Spare__c)+ ((ar.get('ProdSpare') == null)?0:(Decimal)ar.get('ProdSpare'));

				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_PreProd_Vcores_Used__c, preProdVcoresUsedQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_Prod_Vcores_Used__c, prodVcoresUsedQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_PreProd_Transaction__c, preprodTransactionQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_PreProd_Spare__c, preProdSpareQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_Prod_Transaction__c, prodTransactionQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_Prod_Spare__c, prodSpareQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_PreProd_Vcores_Total__c, preProdVcoresTotalQty);
				masterToUpdate.get(ao.Id).put(Schema.AnypointOrganization__c.Master_Parent_Prod_Vcores_Total__c, prodVcoresTotalQty);

				System.debug(LoggingLevel.ERROR,'----->---------->----->----->----->> SID --> masterToUpdate  --> '+ masterToUpdate);
			}
		}
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  preProdVcoresUsedQty   --> '+ preProdVcoresUsedQty );
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  prodVcoresUsedQty   --> '+ prodVcoresUsedQty );
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  preprodTransactionQty   --> '+ preprodTransactionQty );
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  preProdSpareQty   --> '+ preProdSpareQty );
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  prodTransactionQty   --> '+ prodTransactionQty );
		System.debug(LoggingLEvel.ERROR, '2---> $$$$$$ -->  prodSpareQty   --> '+ prodSpareQty );

		if(!masterToUpdate.isEmpty()){
			CMsTriggerRunCounter.skipAnypointOrgTrigger = true;
			Database.update(masterToUpdate.values());
			CMsTriggerRunCounter.skipAnypointOrgTrigger = false;
		}

		List<AnypointOrganization__c> childrenToUpdate = new List<AnypointOrganization__c>();
		Map<id,AnypointOrganization__c> childApOrgMap = New Map<id,AnypointOrganization__c>([SELECT Id FROM AnypointOrganization__c WHERE status__c = 'Active' AND Master_Parent_Anypoint_Organization__c IN :masterIdSet]);
		System.debug(LoggingLevel.ERROR,'----->---------->----->----->-------> childApOrgMap --> '+ childApOrgMap);
		for(Id apOrgId : childApOrgMap.keySet()){
			System.debug(LoggingLEvel.ERROR, '3---> $$$$$$ -->  apOrgId   --> '+ apOrgId );

			AnypointOrganization__c ao = childApOrgMap.get(apOrgId);
			if(ao !=null){
				System.debug(LoggingLEvel.ERROR, '3---> $$$$$$ -->  ao   --> '+ ao );
				System.debug(LoggingLEvel.ERROR, '3---> $$$$$$ -->  preProdVcoresTotalQty   --> '+ preProdVcoresTotalQty );
				System.debug(LoggingLEvel.ERROR, '3---> $$$$$$ -->  prodVcoresTotalQty   --> '+ prodVcoresTotalQty );
				ao.Master_Parent_PreProd_Vcores_Total__c = preProdVcoresTotalQty;
				ao.Master_Parent_Prod_Vcores_Total__c =prodVcoresTotalQty;
				ao.Master_Parent_PreProd_Vcores_Used__c = preProdVcoresUsedQty;
				ao.Master_Parent_Prod_Vcores_Used__c = prodVcoresUsedQty;
				ao.Master_Parent_PreProd_Transaction__c = preprodTransactionQty;
				ao.Master_Parent_PreProd_Spare__c = preProdSpareQty;
				ao.Master_Parent_Prod_Transaction__c = prodTransactionQty;
				ao.Master_Parent_Prod_Spare__c = prodSpareQty;
				childrenToUpdate.add(ao);
			}
		}
		if(childrenToUpdate.size() > 0){
			CMsTriggerRunCounter.skipAnypointOrgTrigger = true;
			Database.update(childrenToUpdate);
			CMsTriggerRunCounter.skipAnypointOrgTrigger = false;
		}
	}

}