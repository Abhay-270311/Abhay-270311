public class B2BPO implements PurchaseOrder {
    public Decimal Discount(){
        return 0.5;
    }
    
    public void Announce(){
        system.debug('B2BPO');
        String str;
        try{
            if( str.length() > 1){
            system.debug('111');
        }
        }catch(Exception e){
            throw new myException('Ohana Exception!');
        }
        
    }
    
    public class myException extends Exception{}
}