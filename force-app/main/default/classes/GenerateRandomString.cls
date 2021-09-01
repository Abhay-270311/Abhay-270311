public class GenerateRandomString
{
    public static string GenerateUUID()
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String guid = '';
        List<String> uniqueStrings = new List<String>(); 
        for(Integer i = 0; i<100;i++){
           /* while (guid.length() < 25) {
                Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
                guid += chars.substring(idx, idx+1);
            }
            system.debug('guid ' + guid);
            */
            guid = getUUID();
            if(uniqueStrings.contains(guid)){
                system.debug('Duplicate ' + guid);
                continue;
                
            } else {
                uniqueStrings.add(guid);
            }
        }
        system.debug(uniqueStrings.size());
        return guid;
    }
    
    public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        /*
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        system.debug('##########' + hexDigest );*/
        
        return guid;
    }
    
}