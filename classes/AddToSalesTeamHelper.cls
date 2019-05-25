/*
* Name : AddToSalesTeamHelper
* Author : Rohit Mehta (Apprivo)
* Date : 31/01/2011
* Usage : Insert OpportunityTeamMember ,OpportunityShare and methods are called in AddToSalesTeam class.
*/
 public without sharing class AddToSalesTeamHelper{
   
    //insertTeamMember method for insert oppTeamMembers list 
    public static void insertTeamMember (List<OpportunityTeamMember> oppTeamMembers){
        if(oppTeamMembers != null && oppTeamMembers.size()>0){
            insert oppTeamMembers;
        }
    }
        
    //insertShare method for insert oppShares list  
    public static void insertShare (List<OpportunityShare> oppShares){
        if(oppShares != null && oppShares.size()>0){
            insert oppShares;
        }
    }
 }