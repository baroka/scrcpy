```shell
Docker image for scrcpy (get FortiTokenMobile OTP). 

PREREQUISITES
 - Docker installed
 - Android phone on same network: 
   . Enable development options
   . Enable USB debug and security options
   . Enable TCP/IP debug. Run on shell: adb tcpip 5555
   . Install Clipper: https://github.com/majido/clipper
   . Install FortiTokenMobile
   . Unlock screen by dragging up

INSTALLATION
 - Docker compose example: 

# Scrcpy
  scrcpy:
    container_name: scrcpy
    image: baroka/scrcpy:latest
    restart: "no"
    network_mode: "host"
    security_opt:
      - no-new-privileges:true
    volumes:
      - $DOCKERDIR/fortimonitor/config/config:/scrcpy/config
    environment:
      - TZ=$TZ
      - PGID=$PGID
      - PUID=$PUID
      - DEVICE=$ADB_DEVICE
      - PORT=$ADB_PORT

 - $DOCKERDIR points to your local path with subdirectories with Docker repos
 - $DEVICE, $PORT. ADB connection parameters
```
