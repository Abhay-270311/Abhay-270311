@isTest
private class AccountControllerTest{
    
    @isTest
    public static void getAccountTest(){
        Account a = new Account(Name = 'Test gv');
        insert a;
        AccountController.getaccount();
        System.assertEquals(1,AccountController.getaccount().size());
        AccountController.getOpps(a.id);
        System.assertEquals(0, AccountController.getOpps(a.id).size());
         
    }
}