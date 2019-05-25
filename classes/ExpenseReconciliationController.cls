public with sharing class ExpenseReconciliationController {

    private Integer pageNumber;
    private Integer pageSize;
    private Integer totalPageNumber;
    integer Var ;
    Map<Id,Invoice_Expense__c> ieMap;
    Map<Id,Invoice_Expense__c> ieExLogMap;
    
    Map<Id,Expense_Log__c> expenseLogMap = new Map<Id,Expense_Log__c>();
    
    
 /********************************* Pagination Start **************************/   
  //Variable Declaration For the Pagination  
  //With defining a few parameters such as Total Pages, Current Page Number and Page size 
  // I managed paging successfully.
  
     public List<ExpenseComposite> exp1{get;set;}
     public Integer getPageNumber()
     {
      return pageNumber;
     }
     public Integer getPageSize()
     {
      return pageSize;
     }
     public Boolean getPreviousButtonEnabled()
      {
        return !(pageNumber > 1);
      }
      
      
   public Boolean getNextButtonDisabled()
    {
      if (expenses== null) return true;
   else
     return ((pageNumber * pageSize) >= expenses.size());
    }
    
   
   // To get the total Number Of Pages For Example If our pagesize is 3 
   //  and total number of records are 10 the there will be 4 pages 
    
   public Integer getTotalPageNumber()
   {
    if (totalPageNumber == 0 && expenses!=null)
    {
       totalPageNumber = expenses.size() / pageSize;
       Integer mod = expenses.size() - (totalPageNumber * pageSize);
       if (mod > 0)
        totalPageNumber++;
     }
   return totalPageNumber;
    }

  //Constructor
  //expenses is holding all the records 
  //exp1 is holding only that data which is user seeing in one page 
   
    public ExpenseReconciliationController() {
        exp1 = new List <ExpenseComposite> ();
        pageNumber = 0;
        totalPageNumber = 0;
        Var = 0;
        pageSize = 30;
        //ViewData();
        init();
        initComposite();
        BindData(1);

    }
    
 //Pagination Logic 
 
  // The whole idea here is to create two lists on the controller object which one 
  //   keeps the original records (all records) and the second one temporarily keeps 
  //   only what should be shown to the user.
       
    private void BindData(Integer newPageIndex)
    {
    exp1.clear();
    try
       {
          Transient Integer counter = 0;
          Transient Integer min = 0;
           Transient Integer max = 0;
         if (newPageIndex > pageNumber)
            {
                min = pageNumber * pageSize;
                max = newPageIndex * pageSize;
             } 
       else
         {
            max = newPageIndex * pageSize;
            min = max - pageSize;
            
         }
         system.debug('+++++' + max);
         system.debug('+++++' + min);
         system.debug('+++++' +expenses.size());
         system.debug('+++++' +expenses);
        for(ExpenseComposite a : expenses)
        {
        counter++;
        if (counter > min && counter <= max)
        exp1.add(a);
        }
        system.debug('+++++' +exp1);
        pageNumber = newPageIndex;
        if (exp1  == null || exp1.size() <= 0)
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
        }
        
        catch(Exception ex)
        {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }
    
    
        
        public PageReference nextBtnClick() {
        ++var;
        exp1.clear();
        BindData(pageNumber + 1);
        return null;
        }
        
        public PageReference previousBtnClick() {
        exp1.clear();
        ++var ;
        BindData(pageNumber - 1);
        return null;
        }
    
 /* --------------------------------------------pagination end ----------------------*/   
    
       boolean dosort = false;
       
        public String sortField {get;set;}
   
   public void setSortField (String sortField) {
    
    
    this.sortField = sortField;
   }
   
   public String getSortField () {
    
    return sortField;
    
   }
   
       public String lastOrder = null;
       
    public void doSort() {
        Set <Id> expId = new Set<Id> ();
        for(ExpenseComposite e : exp1)
        {
        	if (e.expenseLog!=null) {
          	 expId.add(e.expenseLog.Id);
        	}
        }
        
        dosort = true;
        
                if (lastOrder!=null) {
                    
                    if (lastOrder.equals('asc')) {
                        lastOrder = 'desc';
                    }
                    else {
                        lastOrder = 'asc';
                    }
                    
                }
                else {
                    lastOrder = 'asc';
                    
                }
                
                String order = lastOrder;
              
              
              
             
             //Commented
             // superSort.sortList(expenseLogs,sortField,order);
             
           //Added the Query to perform the sorting  
           
           
           
           if (('Is_Finalized__c').equals(sortField))  {
           	
           		System.debug('Is Finalized');
           	
           	invoiceExpenses =  database.query('select id,selected_vendor__c,vendor__c,name,expense_log__r.vendor__r.name,expense_log__r.vendor__r.id,expense_log__r.amount__c,amount__c,invoice__r.project__r.name,invoice__r.is_finalized__c,invoice__r.expense_markup_percentage__c,Actual_Markup_Percent__c from invoice_expense__c order by invoice__r.is_finalized__c '+ order);
           	
           	
           }
           
           else {
           				expenseLogs =  database.query('select id,name,vendor_sort__c,vendor__c,vendor_invoice_number__c,vendor__r.name,vendor__r.id,amount__c,date__c,selected_vendor__c, check_number__c,project__c from Expense_Log__c order by '+sortField+' '+order+'');
           
           } 
          // expenseLogs =  database.query('select id,name,vendor_sort__c,vendor__c,vendor_invoice_number__c,vendor__r.name,vendor__r.id,amount__c,date__c,selected_vendor__c, check_number__c,project__c from Expense_Log__c where Id IN :expId order by '+sortField+' '+order+'');     
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ expenseLogs);
                
                  initSort();
    
    
    }
    
    
    
    
    List<Expense_Log__c> expenseLogs = new List<Expense_Log__c>();
    
    List<Vendor__c> vendors = [select id,name from Vendor__c];
    
    public String vendorId {get;set;}

    public Vendor__c vendorName {get;set;}
    
   public List<ExpenseComposite> expenses = new List<ExpenseComposite>();
    

    

        List<Invoice_Expense__c> invoiceExpenses = new List<Invoice_Expense__c>();
        
    public ExpenseReconciliationController(ApexPages.StandardController controller) {
                        init();

                        
                        initComposite();
                        
                        
          }
          
          public Invoice_Expense__c getIEForLog(Expense_Log__c expenseLog) {   
          	try{
          		/*       
	          	List<Invoice_Expense__c> invoices =  ieExLogMap.get(expenseLog.Id);        
	          	        
	          	if(invoices.isEmpty()==false){        
		            for (Invoice_Expense__c ie:invoices) {                
		                return ie;                
		            }
	          	}else{
	          		return null;
	          	} 
	          	*/
	          	
	          			
	          					Invoice_Expense__c ie = ieExLogMap.get(expenseLog.Id);
	          	
	          					//System.debug('Returning IE for log: '+ie.name);
	          					return ie;
	          		
	          
	          	         	
          	}catch(Exception e){
          		
          		System.debug('Got exception here!! '+e);
          		return null;
          	}
            
            //ieMap.get(idIE);
            
            
            
            return null;
            
            
          }
          
           public Expense_Log__c getLogForIE(Invoice_Expense__c ie) {
            
            //for (Expense_Log__c exp:expenseLogs) {
                
              //  if (ie.Expense_Log__c==exp.id) {
                    
                //    return exp;
               // }
                
            //}
            
            return expenseLogMap.get(ie.expense_log__c);
            
            
            
          }
          
          public void initSort() {
          
          expenses = new List<ExpenseComposite>();
           exp1 = new List <ExpenseComposite> ();
           
           
                      if (('Is_Finalized__c').equals(sortField))  {
                      	
                      	
                      	            for (Invoice_Expense__c ie:invoiceExpenses) {
                      	            	
                      	            	ExpenseComposite comp = new ExpenseComposite();
                      	            	comp.invoiceExpense = ie;
                      	            	
                      	            	Expense_Log__c exp = this.getLogForIE(ie);
                      	            	
                      	            	if (ie!=null&&exp!=null) {
						                        if (ie.amount__c!=null&&exp.amount__c!=null) {
						                            if (exp.amount__c!=0&&ie.amount__c!=0) {
						                                
						                            
						                        ie.actual_markup_percent__c = ((ie.amount__c-exp.amount__c)/exp.amount__c)*100;
						                            }
						                            }
                        				}
                      	            	
                      	            	comp.expenseLog = exp;
                      	            	
                      	            	exp1.add(comp);
                      	            	
                      	            	
                      	            }
                      	
                      	
                      	
                      	
                      }else {
           
           
           
           
            for (Expense_Log__c log:expenseLogs) {
                
                        ExpenseComposite comp = new ExpenseComposite();
                        
                        expenseLogMap.put(log.id,log);
                        
                        comp.expenseLog = log;
                        Invoice_Expense__c ie = this.getIEForLog(log);
                        
                        if (ie!=null) {
                        if (ie.amount__c!=null&&log.amount__c!=null) {
                            if (log.amount__c!=0&&ie.amount__c!=0) {
                                
                            
                        ie.actual_markup_percent__c = ((ie.amount__c-log.amount__c)/log.amount__c)*100;
                            }
                            }
                        }
                                                
                        comp.invoiceExpense = ie;
                        
                        
                     //   expenses.add(comp);
                     
                     	
                        exp1.add(comp);
                     
            }
                
                
               }
               
             expenses = exp1.clone();  
               system.debug('++++++++++++++++++++++++' + pageNumber);
               if(Var == 0)
                 BindData(1); 
               else
                 BindData(pageNumber);   
          system.debug('++++++++++++++++++++++++' + exp1);
          
          
          }
          
          public void initComposite()  {
            
            
               expenseLogs = [select id,name,vendor_sort__c,vendor__c,vendor_invoice_number__c,vendor__r.name,vendor__r.id,amount__c,date__c,selected_vendor__c, check_number__c,project__c from Expense_Log__c order by date__c desc limit 500  ];
               
               for (Expense_Log__c log:expenseLogs) {
               
               log.vendor_sort__c = log.vendor__r.name;
               log.Selected_Vendor__c = log.Vendor__c;
                
                        ExpenseComposite comp = new ExpenseComposite();
                        
                        comp.expenseLog = log;
                        Invoice_Expense__c ie = this.getIEForLog(log);
                        
                        if (ie!=null) {
                        if (ie.amount__c!=null&&log.amount__c!=null) {
                            if (log.amount__c!=0&&ie.amount__c!=0) {
                                
                            
                        ie.actual_markup_percent__c = ((ie.amount__c-log.amount__c)/log.amount__c)*100;
                            }
                            }
                        }
                        
                        comp.invoiceExpense = ie;
                        
                        
                        
                        expenses.add(comp);
                        
                
                
                
               }
            
            
          } 
          
          public List<ExpenseComposite> getExpenses () {
            
                return this.expenses;
            
          }
          
          public void setExpenses(List<ExpenseComposite> expenses) {
          
              this.expenses = expenses;
          }
          
          
          public void init() {
                          
                System.debug('Init');
                ieMap = new Map<Id,Invoice_Expense__c>();
                //ieExLogMap = new Map<Id,List<Invoice_Expense__c>>();
                ieExLogMap = new Map<Id,Invoice_Expense__c>(); // This is the map of 
                
                
                
				//List<Invoice_Expense__c> expenseLogInvoices = new List<Invoice_Expense__c>();
                
                List<Invoice_Expense__c> lstIExpenses = [select id, expense_log__c, selected_vendor__c,vendor__c,name,expense_log__r.vendor__r.name,expense_log__r.vendor__r.id,expense_log__r.amount__c,amount__c,invoice__r.project__r.name,invoice__r.is_finalized__c,invoice__r.expense_markup_percentage__c from Invoice_Expense__c];
                
                for(Invoice_Expense__c ie:lstIExpenses){
                	//List<Invoice_Expense__c> expenseLogInvoices = new List<Invoice_Expense__c>();
                	ie.selected_vendor__c = ie.vendor__c;
                	ieMap.put(ie.Id,ie);
                	ieExLogMap.put(ie.expense_log__c,ie);
                	
                }
                
                System.debug('After init, '+ieMap.size());
                
                
                
                invoiceExpenses = ieMap.values();
                
                for (Invoice_Expense__c ie:invoiceExpenses) {
                	
                	System.debug('IE: '+ie.name + 'IE: '+ie.id+' Expense: '+ie.expense_log__c);
                }
                
                /*for(Invoice_Expense__c ie:lstIExpenses){
                	List<Invoice_Expense__c> expenseLogInvoices = new List<Invoice_Expense__c>();
                	ie.selected_vendor__c = ie.vendor__c;
                	ieMap.put(ie.Id,ie);
                	for(Invoice_Expense__c expenseLogInvoice:lstIExpenses){
                		
                		if(ie.Expense_Log__c==expenseLogInvoice.Expense_Log__c){
	                    	expenseLogInvoices.add(ie);
	                    }
	                }
	                ieExLogMap.put(ie.Expense_Log__c,expenseLogInvoices);
                }               
                
                invoiceExpenses = ieMap.values();
                */
                
                
                
                
          }
          
           public List<selectOption> VendorList {get {
        List<selectOption> myVendorList = new List<selectOption>();
        for (Vendor__c vend : [select Name,id from Vendor__c])
            myVendorList.add(new selectOption(vend.id, vend.name));
        return myVendorList;
        }
        private set;
    }
          
        
          
          public void saveChanges() {
          
               Invoice_Expense__c[] invoiceExpenses = new Invoice_Expense__c[0];
              
              Expense_Log__c[] expenseLogs = new Expense_Log__c[0];
                        //expenses
             
                     for (ExpenseComposite comp: exp1) {
                     
                             System.debug('Check number, vendor: '+comp.expenseLog.check_number__c+ ' : '+comp.expenseLog.selected_vendor__c);
                             
                             
                              if (comp.expenseLog.selected_vendor__c!=null) {
                                
                                    String id =     comp.expenseLog.selected_vendor__c;
                                    
                                    if (id.equals('--None---')) {
                                        comp.expenseLog.Vendor__c = null;
                                    } else {
                                        comp.expenseLog.Vendor__c = comp.expenseLog.Selected_Vendor__c;
                                    }
                                    
                                
                             }
                             
                             
                             if (comp.invoiceExpense!=null) {
                             invoiceExpenses.add(comp.invoiceExpense);
                             }
                             expenseLogs.add(comp.expenseLog);
                             
                     }
                     
                     update invoiceExpenses;
                     update expenseLogs;
          
          }
          
}