public class HelloWorldController {
    public HelloWorldController (){
    }
    public HelloWorldController (ApexPages.StandardController std){
        std.getRecord();
    }
}