@isTest
private class Test_Update_AvgHoursPerWeek {

    static testMethod void updateProjectEmployeeHours() {
		List<Project__c> lstTestProjects = new List<Project__c>();
        List<Pricing_Sheets__c> lstTestRole = new List<Pricing_Sheets__c>();
        RecordType rtProject = [Select Id From RecordType Where Name = 'Fixed Fee Project'];
        User usr = [Select Id From User Limit 1];
        
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.BillingCountry = 'US';
        insert testAcc;
        
        Project__c testProj = new Project__c();
        testProj.Account__c = testAcc.Id;
        testProj.Name='Test Project 1 Month';
        testProj.Projected_Completion_Date__c = System.today()+10;        
        testProj.Project_Limit__c = 10000;
        testProj.RecordTypeId = rtProject.Id;
        testProj.Project_Status__c = 'Active';
        
        Project__c testProj1 = new Project__c();
        testProj1.Account__c = testAcc.Id;
        testProj1.Name='Test Project 1 Month';
        testProj1.Projected_Completion_Date__c = System.today().addDays(2);
        testProj1.Start_Date__c=System.today()-1;
        testProj1.Project_Limit__c = 10000;
        testProj1.RecordTypeId = rtProject.Id;
        testProj1.Project_Status__c = 'Active';
        
        lstTestProjects.add(testProj);        
        lstTestProjects.add(testProj1);
        
        insert lstTestProjects;
        
        Pricing_Sheets__c testRole = new Pricing_Sheets__c();
        testRole.Name = 'Test Role';
        testRole.Principal_Consultant_Rate__c = 20;
        testRole.Project__c = lstTestProjects[0].Id;        
        
        Pricing_Sheets__c testRole1 = new Pricing_Sheets__c();
        testRole1.Name = 'Test Role';
        testRole1.Principal_Consultant_Rate__c = 20;
        testRole1.Project__c = lstTestProjects[1].Id; 
        
        lstTestRole.add(testRole);
        lstTestRole.add(testRole1);        
        
        insert lstTestRole;
        
        Employee__c employee = new Employee__c();
        employee.Name = 'Victor Vargas';
        employee.User__c = usr.Id;
        employee.Hourly_Rate__c = 20;
        
        insert employee;
        
        Resource_Allocation__c testResAll = new Resource_Allocation__c();
        testResAll.Project__c = lstTestProjects[0].Id;
		testResAll.Employee__c = employee.Id;
        testResAll.Role__c = lstTestRole[0].Id;
        testResAll.Hours_Per_Week__c = 10;     
        testResAll.Start_Date__c=System.today();
        testResAll.End_Date__c=System.today().addDays(30);   
        insert testResAll;        
        testResAll.Hours_Per_Week__c = 20;        
        update testResAll;        
        delete testResAll;
        
        Resource_Allocation__c testResAllEmp = new Resource_Allocation__c();        
		testResAllEmp.Employee__c = employee.Id;
        testResAllEmp.Role__c = lstTestRole[0].Id;
        testResAllEmp.Start_Date__c=System.today();
        testResAllEmp.End_Date__c=System.today().addDays(30);
        testResAllEmp.Hours_Per_Week__c = 10;        
        insert testResAllEmp;        
        testResAllEmp.Hours_Per_Week__c = 20;        
        update testResAllEmp;        
        delete testResAllEmp;
        
        Resource_Allocation__c testResAllProj = new Resource_Allocation__c();
        testResAllProj.Project__c = lstTestProjects[0].Id;		
        testResAllProj.Role__c = lstTestRole[0].Id;
        testResAllProj.Hours_Per_Week__c = 10;        
        testResAllProj.Start_Date__c=System.today();
        testResAllProj.End_Date__c=System.today().addDays(30);
        insert testResAllProj;        
        testResAllProj.Hours_Per_Week__c = 20;        
        update testResAllProj;        
        delete testResAllProj;
	}
	
	    static testMethod void updateProjectEmployeeHours_ProjectedDate_Today() {
		List<Project__c> lstTestProjects = new List<Project__c>();
        List<Pricing_Sheets__c> lstTestRole = new List<Pricing_Sheets__c>();
        RecordType rtProject = [Select Id From RecordType Where Name = 'Fixed Fee Project'];
        User usr = [Select Id From User Limit 1];
        
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.BillingCountry = 'US';
        insert testAcc;
        
        Project__c testProj = new Project__c();
        testProj.Account__c = testAcc.Id;
        testProj.Name='Test Project 1 Month';
        testProj.Projected_Completion_Date__c = System.today()+10;
        testProj.Project_Limit__c = 10000;
        testProj.RecordTypeId = rtProject.Id;
        testProj.Project_Status__c = 'Active';
        
        Project__c testProj1 = new Project__c();
        testProj1.Account__c = testAcc.Id;
        testProj1.Name='Test Project 1 Month';
        testProj1.Projected_Completion_Date__c = System.today().addDays(2);
        testProj1.Start_Date__c=System.today()-1;
        testProj1.Project_Limit__c = 10000;
        testProj1.RecordTypeId = rtProject.Id;
        testProj1.Project_Status__c = 'Active';
        
        lstTestProjects.add(testProj);        
        lstTestProjects.add(testProj1);
        
        insert lstTestProjects;
        
        Pricing_Sheets__c testRole = new Pricing_Sheets__c();
        testRole.Name = 'Test Role';
        testRole.Principal_Consultant_Rate__c = 20;
        testRole.Project__c = lstTestProjects[0].Id;        
        
        Pricing_Sheets__c testRole1 = new Pricing_Sheets__c();
        testRole1.Name = 'Test Role';
        testRole1.Principal_Consultant_Rate__c = 20;
        testRole1.Project__c = lstTestProjects[1].Id; 
        
        lstTestRole.add(testRole);
        lstTestRole.add(testRole1);        
        
        insert lstTestRole;
        
        Employee__c employee = new Employee__c();
        employee.Name = 'Victor Vargas';
        employee.User__c = usr.Id;
        employee.Hourly_Rate__c = 20;
        
        insert employee;
        
        Resource_Allocation__c testResAll = new Resource_Allocation__c();
        testResAll.Project__c = lstTestProjects[1].Id;
		testResAll.Employee__c = employee.Id;
        testResAll.Role__c = lstTestRole[1].Id;
        testResAll.Hours_Per_Week__c = 10;     
        testResAll.Start_Date__c=System.today();
        testResAll.End_Date__c=System.today().addDays(30);   
        insert testResAll;        
        testResAll.Hours_Per_Week__c = 20;        
        update testResAll;        
        delete testResAll;
        
        Resource_Allocation__c testResAllEmp = new Resource_Allocation__c();        
		testResAllEmp.Employee__c = employee.Id;
        testResAllEmp.Role__c = lstTestRole[1].Id;
        testResAllEmp.Start_Date__c=System.today();
        testResAllEmp.End_Date__c=System.today().addDays(30);
        testResAllEmp.Hours_Per_Week__c = 10;        
        insert testResAllEmp;        
        testResAllEmp.Hours_Per_Week__c = 20;        
        update testResAllEmp;        
        delete testResAllEmp;
        
        Resource_Allocation__c testResAllProj = new Resource_Allocation__c();
        testResAllProj.Project__c = lstTestProjects[1].Id;		
        testResAllProj.Role__c = lstTestRole[1].Id;
        testResAllProj.Hours_Per_Week__c = 10;        
        testResAllProj.Start_Date__c=System.today();
        testResAllProj.End_Date__c=System.today().addDays(30);
        insert testResAllProj;        
        testResAllProj.Hours_Per_Week__c = 20;        
        update testResAllProj;        
        delete testResAllProj;
	}
}