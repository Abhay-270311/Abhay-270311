public class B2CPO implements PurchaseOrder {
    public Decimal Discount(){
        return 0.25;
    }
    
    public void Announce(){
        system.debug('B2BCO');
    }
}