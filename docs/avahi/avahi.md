```
[root@archlinux sultan]# avahi-browse --all --ignore-local --resolve --terminate
+  wlan0 IPv4 653954325b42@LonelyScreen                     _raop._tcp           local
+  wlan0 IPv4 LonelyScreen                                  _airplay._tcp        local
=  wlan0 IPv4 653954325b42@LonelyScreen                     _raop._tcp           local
   hostname = [DESKTOP-4RF23M7.local]
   address = [10.10.1.205]
   port = [7000]
   txt = ["vv=2" "vs=220.68" "vn=65537" "tp=UDP" "sf=0x44" "pk=53f2df25f5fff15fa1fffffff54f2f4ffffffd1" "am=AppleTV3,2C" "md=0,1,2" "ft=0x5A7FFFF7,0x1E" "et=0,3,5" "da=true" "cn=0,1,2,3"]
=  wlan0 IPv4 LonelyScreen                                  _airplay._tcp        local
   hostname = [DESKTOP-4RF23M7.local]
   address = [10.10.1.205]
   port = [7000]
   txt = ["ch=2" "srcvers=220.68" "pk=53f2df25f5fff15fa1fffffff54f2f4ffffffd1" "model=AppleTV3,2C" "flags=0x44" "features=0x5A7FFFF7,0x1E" "deviceid=65:39:54:32:5B:42"]
``` 
```
[root@archlinux sultan]# cat /etc/avahi/services/nfs_Zephyrus_Music.service 
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">NFS Music Share on %h</name>
  <service>
    <type>_nfs._tcp</type>
    <port>2049</port>
    <txt-record>path=/data/shared/Music</txt-record>
  </service>
</service-group>
```
