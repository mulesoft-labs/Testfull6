trigger setApproverStatusRecall on SBQQ__Quote__c (before update) {
    Set<Id> quotesToProcess = new Set<id>();
    for(SBQQ__Quote__c q: Trigger.new){
        SBQQ__Quote__c prev = Trigger.oldMap.get(q.Id);
        if(prev.ApprovalStatus__c != q.ApprovalStatus__c && q.ApprovalStatus__c == 'Rejected'){
            quotesToProcess.add(q.Id);
        }
    }
    if(quotesToProcess.size() > 0){
        List<sbaa__Approval__c> approvals = [SELECT ID,sbaa__Status__c FROM sbaa__Approval__c WHERE Quote__c in: quotesToProcess];
        if(approvals.size() > 0){
            for(sbaa__Approval__c a:approvals){
                a.sbaa__Status__c = 'Recalled';
            }
            update approvals;
        }
    }
}