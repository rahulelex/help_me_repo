______________________________________________________________
#### Mount and Unmount
##### Mount 
> $ sudo mount -t ntfs /dev/sdb1 /media/
###### Unmount
> $ sudo umount /dev/sdb1

#### Automount
https://confluence.jaytaala.com/display/TKB/Mount+drive+in+linux+and+set+auto-mount+at+boot
______________________________________________________________
#### Change permission
#### Change permission from root to user
> $ sudo chown -R user:group directory/
______________________________________________________________
## Create SSL certificate
#### To install mkcert in ubuntu 18.04
> sudo apt install libnss3-tools
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert
______________________________________________________________
#### Follow steps to create ssl certificate:
1. Use below command to create certificate.
#### $ mkcert ip_address
> $ mkcert 192.168.0.120
2. Use below command to get path of rootCA.pem file
> $ mkcert -CAROOT
3. Use rootCA.pem file to use as certificate in browser.
___


echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
______________________________________________________________
## Linux script for CPU and RAM consumption

#!/bin/bash
# This script monitors CPU and memory usage

while :
do 
  # Get the current usage of CPU and memory
  cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')
  memUsage=$(free -m | awk '/Mem/{print $3}')

  # Print the usage
  echo "CPU Usage: $cpuUsage%"
  echo "Memory Usage: $memUsage MB"
 
  # Sleep for 1 second
  sleep 1
done
_________________________________________________________________

## Sync time between hosts using NTPDATE
Run command on host
$ ntpdate -s <ip-address-of-another-host>
Example: $ ntpdate -s 192.168.100.1
_________________________________________________________________

## Mongo db port forward command
$ microk8s kubectl port-forward --namespace default svc/vts-mongo-mongodb 27017:27017

______________________________________________________________________________________
## Display disk-file system storage
df -h 

## Linux dd command to clone and copy entire storage
sudo dd if=/dev/sdb of=/home/amantya/hal/docker_file/vts257/backup_hal_sdb.img bs=4M status=progress
________________________________________________________________________________________________________
## Symlink 
ln -s <source_absolute_path> <destination_path>
ln -s /home/ubuntu/hal/module_modnitoring module_monitoring
________________________________________________________________________________________________________

## Allow port in firewall
sudo ufw status
Status: inactive

sudo ufw allow 8080
__________________________________________________________________________________________________________

## Open folder from the terminal
```sh
nautilus .
```
_____________________________________________________________________________________________________