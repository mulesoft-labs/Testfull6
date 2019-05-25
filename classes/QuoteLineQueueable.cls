public class QuoteLineQueueable implements Queueable {
    List<SBQQ__Quoteline__c> quotelines;
    
    public QuoteLineQueueable(List<SBQQ__Quoteline__c> qls){
        quotelines = qls;
    }
    
    public void execute(QueueableContext context) {
        update quotelines;
    }
}