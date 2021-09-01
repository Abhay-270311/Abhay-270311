public class Config {
    public class BoxAppSettings {
        public String clientID;
        public String clientSecret;
        public AppAuth appAuth;
    }
    public class AppAuth {
        public String privateKey;
        public String passphrase;
        public String publicKeyID;
    }
    public BoxAppSettings boxAppSettings;
    public String enterpriseID;
}
/*
 * 
 * jsonstr = jsonstr.replace('\n','\\n');
system.debug(jsonstr);
Config cg = (Config) JSON.deserialize(jsonStr, Config.Class);
jsonstr: ==>
{
  "boxAppSettings": {
    "clientID": "9ss9sfbxp0snfisbudkneb3y5m2pxscs",
    "clientSecret": "5K3HcK5WQEXkkvNuz6q9o5U8lYh5DAVX",
    "appAuth": {
      "publicKeyID": "rx05f840",
      "privateKey": "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIIhyWXZj/swECAggA\nMBQGCCqGSIb3DQMHBAh8qJE+iq3n4ASCBMiKmw0L3oFp/Q3S8M3/BNBUZMKVK2qc\n9zNw9HnVkjR6CB4ftjX8NYjUfP2gr0xtXix67WTupcYFVVYlP0xZlnNwkkj1yGee\nWlUK9nejrU90v9AuOn+BZPdhIrYzL4XhFbTgNculRPDw29ug4a5xIgjUwGsm/hRU\nfeFYZmYxtb1zfDYRiz1B+dM0rQJv5LQlYWsoeDe3tOSW4P1zDCA4wsrwdf2dtll8\n5tt6gu6fU7XPqrII3XJVZEySUrLoiYUJq45vzFyVax9q+ChoqrzaB7XF2pK+gIMZ\n3YSJHWByauDkCZ2T4xMlIoaFnRZr71HRmb8xdY/ygobX+0hK3kL4ltbfrJgksrhb\nmvVERbwDD0XGvpOo1Hc7pT5QrstIsJmQRc14m4LZVDHmcvFCWGU8Q1DT/IpVSEZF\nCYgQQ27yTKxp3QY9FOkMo8lEqIitbMWbwkZAGoaHciSRYowQNv5nAdR6mZYdZJLC\nF3wVk/UUYvkZAdzkkNTm/a7+C36l2Tl9SPFNa8biLFipZ+bvY0wa2K9SWUc5eS3g\n0PANaRcvLxSldzohdx2eyCCbAOoxHbRfYOTQ0akd02K8JzDwMOcE2lSdMm/Ct9pz\nTiUZJO2WkWrRC/chN4KjEeA3kokSKxK9I8l4lM6jw96DX9Qn3U3z80OLpnlSel+d\nLyhSUIGYRd137dNYGy7KlIurdY6OaHn42Z8IvPa9sU8cOvunkfEXgb3scU268sp2\nIsVQuFkIfthkibJWsr0Rj1Atb+2pIHTGARQCCBNQfAoKr74uD7eutZqRgFdoPGGD\nyXUc32yzu8ymp/ymjuqgdRAKk0YKsEmr+Bov5ETg42FSkESLWqG+oVNERRQtzqxM\nbjVlYDyu1T0a9O+LeQFPeW/HYPjZ2MJkMcPd5YL49MG9iuZRdgC1v3e/aq4DIshF\nNOS+k+hD3juesn8bg3PPZmkXlUSGuhUIaabYuLYzBp5KsBUXewr9fbM7LmF5dQmv\nJdnMsNr9guiJanBmvh2M7QAXte1vXr5HVRPiWZMw+DCeQRhatSBnX183rioQpjmD\nGf187g03XyuTh++GQCYfD0Dww5rub09nUXefc0AdK+2pww770oE2Rv7bqGRm9aQc\nVYufPzj7mX56ogtyNPWy4Ftf+csv9YoSvxwhJjgfthgJ3L7I7tyUeLBm+C4eQytn\ndz8MzhkkjkQ3HqaayknEFDYygX7LJSnOMS9m3IuJDnuUk7NBwhD6Qw09eoBWyRTe\nlVGZTIMRV3AaHiGCrZBn8xevXwPdrzPTl0Af+jpRelNej6asMyBiAuYtWn2vNVlv\nD6k56NNj/kZmV24ImXS2g4YNQXhcmmiuXPE+yF4ZSiSdti6M28Qn+lGCuCE0oH9p\nr0yF72lIBUbTYrYfe1vgR/PrPruEk4iXuDnPUJPSCXgUpOegzY8dJrLezfx0zjE2\neejjIuqPc2PjviDbZnhrao2bwLBK1LFGx8HfktiZcvwiXtjKD0cfDr5Oo+xyZRn/\nKznXShbBNoDMFcWnt9//puCpvI4PJe/JU2hwnM9x4ChR5nFbV2fTG7co7xBLRf6x\nlp3GFSbBzDANeToEJEnmNgd1gxWvQlhR3jabEsT/etOvSi/U+5TM/VMu6Zt+Pf+C\nbI0=\n-----END ENCRYPTED PRIVATE KEY-----\n",
      "passphrase": "196a164605dc8312951b5f19957ba49e"
    }
  },
  "enterpriseID": "821720131"
} */