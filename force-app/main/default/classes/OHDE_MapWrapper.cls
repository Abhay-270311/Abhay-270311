public class OHDE_MapWrapper implements Comparable {
	
    public Map<String,String> record;

    public OHDE_MapWrapper(Map<String,String> record) {
        this.record = record;
    }
	
    public Integer compareTo(Object compareTo) {
        OHDE_MapWrapper compareToMap = (OHDE_MapWrapper)compareTo;
        if (record.get('label') == compareToMap.record.get('label')) return 0;
        if (record.get('label') > compareToMap.record.get('label')) return 1;
        return -1;        
    }
}