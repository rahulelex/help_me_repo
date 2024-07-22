______________________________________________________________
#### Creds
Anydesk.  
Id: 476387951 
password: Yankees1!

### docker image and tag
```sh
$ devicetechnology/font_phase2:LAB_DEMO_AWS
```
Running docker container
```sh
$ sudo docker run -itd --name aws_MEC -p 7090:80 -p 8090:8090 -p 3001:3001 -p 3002:3002 -p 3060:3060 -p 5000:5000/udp --privileged devicetechnology/font_phase2:LAB_DEMO_AWS
```

______________________________________________________________