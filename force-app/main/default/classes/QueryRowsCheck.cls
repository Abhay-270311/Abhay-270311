public class QueryRowsCheck {
    public static string idLast = '';
    public static void queryRowsLimit(){
        List<Opportunity> optLL = new List<Opportunity> ();
        idLast = '';
        for(Integer i = 0;  i < 5; i++){
            
            loopQueries(i, optLL);
          //11
          //22
          //33  
        }
    }
    public static void  loopQueries(Integer cnt, List<Opportunity> optLL){
        if(cnt == 0){
            optLL = [select Id, Name From Opportunity order by Id asc LIMIT 10];
            
        } /* else {
            optLL = [select Id, Name From Opportunity where Id > :idLast order by Id asc LIMIT 10];
        }*/
        
        for(Opportunity opt: optLL){
            system.debug(opt.Name);
            idLast = opt.Id;
        }
        
    }
}