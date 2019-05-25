/*********************************************************************
*
*   File Name: Opportunity10Percent.cls
*
*   File Description: Class handling Opportunity Trigger logic when
*   probability is 10%.
*
**********************************************************************
*
*   Date		Author			  Change
*	08/01/14	Rob				  Initial Creation							
*
*********************************************************************/		

public with sharing class Opportunity10Percent
{

	/**
	 * Updates an Opportunity's lead source to the Primary Contact's lead
	 * source when its probability is 10%. This only applies to the following types:
	 * - New Business
	 * - Add-On Business
	 * - Add-On Business - Renewal Price Uplift
	 * Also only applies to opportunities that were not converted from a lead
	 */		
	public static void setLeadSourceToPrimaryContactLeadSource(List<Opportunity> opportunities)	
	{
		// Set opportunity types that can be updated
		Set<String> opportunityTypes = new Set<String>();
		opportunityTypes.add('New Business');
		opportunityTypes.add('Add-On Business');
		opportunityTypes.add('Add-On Business - Renewal Price Uplift');

		// Get opportunities that need to be considered for update
		List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
		Set<Id> opportunityIdSet = new Set<Id>();
		for(Opportunity o : opportunities)
		{			
			if(o.Probability == 10 && opportunityTypes.contains(o.Type))
			{		
				opportunitiesToUpdate.add(o);
				opportunityIdSet.add(o.Id);
			}
		}

		// Get Map of primary contacts and their lead source
		Map<Id, String> primaryContactLeadSourceMap = getPrimaryContactLeadSources(opportunityIdSet);

		// Get Id set of opportunities converted from leads
		Set<Id> convertedOpportunityIds = getOpportunityIdsForConvertedOpportunities(opportunityIdSet);

		// Update opportunity's lead source
		for(Opportunity o : opportunitiesToUpdate)
		{
			// Make sure opportunity isn't converted from a lead
			if(!convertedOpportunityIds.contains(o.Id))
			{
				o.LeadSource = primaryContactLeadSourceMap.get(o.Id);
			}
		}
	}

	/**
	 * Returns a map of opportunity Ids and Lead Sources for the primary contact of an opportunity
	 */
	private static Map<Id, String> getPrimaryContactLeadSources(Set<Id> opportunityIdSet)
	{
		List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
		contactRoles = [SELECT OpportunityId, Contact.LeadSource FROM OpportunityContactRole 
                        Where OpportunityId in : opportunityIdSet AND IsPrimary = true];

        Map<Id, String> primaryContactLeadSourceMap = new Map<Id, String>();                
        for(OpportunityContactRole cr : contactRoles)
        {
        	primaryContactLeadSourceMap.put(cr.OpportunityId, cr.Contact.LeadSource);
        }

        return primaryContactLeadSourceMap;
	}

	/**
	 * Returns a set of opportunity Ids that were converted from a lead
	 */
	private static Set<Id> getOpportunityIdsForConvertedOpportunities(Set<Id> opportunityIdSet)
	{
		List<Lead> leads = new List<Lead>();
		leads = [select ConvertedOpportunityId from Lead where ConvertedOpportunityId in: opportunityIdSet];

		Set<Id> convertedOpportunityIdSet = new Set<Id>();
		for(Lead l : leads)
		{
			convertedOpportunityIdSet.add(l.ConvertedOpportunityId);
		}

		return convertedOpportunityIdSet;
	}

}