public class StaticBlockClass {
    static{
        system.debug('Insider');
        
        
    }
    
    public StaticBlockClass(){
        system.debug('Constructor');
    }
    
    public static void statMethod(){
        system.debug('statMethod');
    } 
}