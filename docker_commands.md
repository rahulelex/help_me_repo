# Some Useful Docker Commands
### Note :)
Use ctrl + f to search command if you know it partially.


## To use docker commands without sudo, run below mentioned 3 commands
> $ sudo usermod -aG docker ${USER}
> $ sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
> $ sudo chmod g+rwx "$HOME/.docker" -R

<sub> -- Helping Logs -- </sub>
<sub>"Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get"http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json": dial unix/var/run/docker.sock: connect: permission denied" </sub>
Simply just change ** /var/run/docker.sock ** permission using chown and chmod, in the above log case.


##  ------------------------------ BASIC COMMANDS --------------------------
### To check docker Engine's server and client installed version information
> $ sudo docker version

### Docker engine start, stop and restart example
> $ sudo systemctl start docker
> $ sudo systemctl stop docker
> $ sudo systemctl restart docker

### To check currently running docker container
> $ sudo docker ps

### To check all docker container run history
> $ sudo docker ps -a

### This command is used to access the running container
<sub>sudo docker exec -interactive_terminal  docker_id bash</sub>
> $ sudo docker exec -it c9 bash

### To stop running container
<sub>sudo docker stop "starting digits of container"</sub>
> $ sudo docker stop c9

### To kill running container
<sub> sudo docker kill "starting digits of container" </sub>
> $ sudo docker kill c9

### This command is used to delete a stopped container
<sub> sudo docker rm "starting digits of container" </sub>
> $ sudo docker rm c9

### This command is used to delete an image from local storage
<sub> sudo docker rmi <image_id> </image_id></sub>
> $ sudo docker rmi fd484f19954f

### To copy files or folders
#### Copy from local to Docker
> $ sudo docker cp some_file_path CONTAINER_id:/work

#### Copy from Docker to local
> $ sudo docker cp CONTAINER_id:file_path local_destination_path

#### Copy from Docker to Docker
> $ sudo docker cp CONTAINER_id:source_file_path CONTAINER_id:dest_file_path

-----------------------------------------------------------------------------------

## -------------------------- DOCKER IMAGE OPERATION --------------------------------
### Docker pull will get download image from docker hub if do not exist locally
> $ docker pull ubuntu:18.04

### Load tar to docker image
### sudo docker load --input tar_file_name.tar
> $ sudo docker load --input ros-gazebo.tar

### To commit docker changes for deployment (Stop docker before commit)
> $ sudo docker commit 9e8af776f8 repository_name:tag_name

### Save docker image to tar
> $ docker save -o tar_name.tar repository_name:tag_name

### To check all images which are loaded
> $ sudo docker images

-------------------------------------------------------------------------------------

## ---------------------------------- RUNNING DOCKER ----------------------------------
### Docker run command from image and its add on
> $ sudo docker run -itd  repository_name:tag_name

#### Options
#### Add volume
-v host_path:docker_path
-v /home/root1/docker/robot1:/home/code
#### add port
-p 6080:80
#### add network
--network=ROS_NWK_ROBOT
####add capabilities
--cap-add=NET_ADMIN
#### detached mode
-d
#### --net ROS_NW --ip 10.0.1.2

#### Start docker with network host
> $ docker run -tid --privileged --net=host --pid=host --ipc=host --volume /:/host --name=onboarding_docker onboard_agv:1_0

#### Some examples:
> $ sudo docker run -itd -v /home/ubuntu/docker/robot1:/home/code --name robot1 -p 6680:80 repository_name:tag_name
> $ sudo docker run -it -d --network=ROS_NWK_ROBOT repository_name:tag_name
> $ sudo docker run -it --name=docker_name --cap-add=NET_ADMIN -p 6080:80 -p 1194:1194 repository_name:tag_name
##### Swarm network with data path port
> $ docker swarm init --listen-addr 192.168.200.149:3377 --advertise-addr 192.168.200.149 --data-path-port 5789

--------------------------------------------------------------------------------------------


## --------------------------------------------- NETWORKING in DOCKER --------------------------
### Leave docker swarm network if connected to anyone
> $ sudo docker swarm leave --force

### Initialise docker swarm for networking
<sub> If host have multiple address use below command to specify address to be used in swarm init </sub>
> $ sudo docker swarm init --advertise-addr 10.10.21.20

###
docker swarm init --listen-addr 10.10.32.149:3377 --advertise-addr 10.10.32.149 --data-path-port 5789

### Then join from another system using command displayed by above command
> $ docker swarm join --token SWMTKN-1-0e1xv3cdstlmqqi79hfklqjnonz4wjbtl4jtfveey6f6fsv6h4-2bhk1yunnv8vrcc1vb16yxsxp 20.20.21.20:2377

### Use this command for to check which nodes have joined network
> $ sudo docker node ls

### Get swarm join tocken as worker
> $ sudo docker swarm join-token worker

### To create network with overlay with encryption
> $ sudo docker network create --opt encrypted=true --driver overlay --attachable ROS_NWK_ENCRYPTED

### To create network with overlay without encryption
> $ sudo docker network create --driver overlay --attachable ROS_NWK_UNENCRYPTED
> $ sudo docker network create --driver overlay --subnet 10.0.2.0/24 --attachable ROS_NWK_UNENCRYPTED

###### To create network with overlay without encryption with port
docker swarm init --listen-addr 10.10.32.149:3377 --advertise-addr 10.10.32.149 --data-path-port 5789

### After create network command you will see something like this
6xhxdrjtc1hr6v4b8uyvgsp6a7

### To disconnect / connect network to running docker 
<sub>sudo docker network operation network_name docker_name or id </sub>
> $ sudo docker network disconnect ROS_NWK_ENCRYPTED docker1
> $ sudo docker network connect ROS_NWK_ENCRYPTED docker1

---------------------------------------------------------------------------------------------


## ----------------------------------- PORTRAINER SETUP ---------------------------------------
### To pull portainer with latest Tag in linux
> $ sudo docker pull portainer/portainer:latest

### First, create the volume that Portainer Server will use to store its database:
> $ sudo docker volume create portainer_data

### By default, Portainer generates and uses a self-signed SSL certificate to secure port 9443
<sub> But below command has changed it to HTTP port 9000 </sub>
> $ sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer:latest

### To open portainer  in a web browser use 
> https://localhost:9000

--------------------------------------------------------------------------------------------

## ---------------------------- To use GPU with container -----------------------------------#
### A). By using --gpus all
Versions earlier than Docker 19.03 used to require nvidia-docker2 and the --runtime=nvidia flag.
Since Docker 19.03, you need to install nvidia-container-toolkit package and then use the --gpus all flag.

#### 1. Install the nvidia-container-toolkit package 
https://github.com/NVIDIA/nvidia-docker

#### 2. Add the package repositories For Debian based OSes
> $ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
> $ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
> $ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
> $ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
> $ sudo systemctl restart docker

#### 3. Running the docker with GPU support
> $ docker run --name my_all_gpu_container --gpus all -t nvidia/cuda
<sub>Please note, the flag --gpus all is used to assign all available gpus to the docker container. </sub>


### B). To assign specific gpu to the docker container (in case of multiple GPUs available in your machine)
#### 1. Find your nvidia devices
> $ ls -la /dev | grep nvidia

#### 2. Run Docker container with nvidia driver pre-installed
> $ sudo docker run -itd --device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm tleyden5iwx/ubuntu-cuda /bin/bash

--------------------------------------------------------------------------------------------


## -------------------------------- Cleanup (prune) ------------------------------------------
#### Clean syatem storage which is occupied by dangling images 
> $ sudo docker builder prune

### To clean up everything in docker without volumes
> $ docker system prune 

### To also prune volumes, add the --volumes flag:
> $ docker system prune --volumes

 WARNING! This will remove:
         - all stopped containers
         - all networks not used by at least one container
         - all volumes not used by at least one container
         - all dangling images
         - all build cache
--------------------------------------------------------------------------------------------
### To automate docker
#### Create a sh file and write
"""
#!/bin/bash
source /root/.bashrc
source /opt/ros/melodic/setup.bash
source /home/ubuntu/workspace/devel/setup.bash
value="$(ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)"
export ROS_MASTER_URI=http://$value:11311
export ROS_HOSTNAME=$value
export ROS_IP=$value
bash any_script.sh
roslaunch package launch_file.launch 2>&1 &
"""
#### After saving above with filename.sh 
#### Write in ros_entrypoint.sh "bash filename.sh"
--------------------------------------------------------------------------------------------

### “Temporary failure resolving …” error
##### https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error
#### There are two parts to your question:

#### 1. fixing temporary resolve messages
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
sudo apt-get update

#### 2. fixing the package management issues
#### If this fixes your temporary resolving messages then you can permanently add a DNS server to your system:
echo "nameserver 8.8.8.8" | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null

_____________________________________________________________________________________________________
### Docker security

1. Disable root user login
2. Change login shell
#### Docker file
From ubuntu:18.04
LABEL maintainer="Rahul Gupta"
RUN groupadd -r alexis && useradd -r -g alexis alexis
RUN chsh -s /usr/sbin/nologin root

# Environmental variables
ENV HOME /home/alexis
ENV DEBIAN_FRONTEND=noninteractive
-----------------------------------------------------------------------

3. Disable capabilities
##### Disable all capabilities except required or needed
```sh
docker run --cap-drop all -cap-ad NET_ADMIN -it -u alexis <image_id> /bin/bash
```

4. Disable write premission and enable it only to some specific directories
```sh
docker run --read-only --tmpfs /opt -it <image_id> /bin/bash
```

5. Create isolate docker container or disable inter docker communication
step 1. create network
step 2. create container with this newly created test-net network
```sh
docker network create --driver bridge -o "com.docker.network.bridge.enable_icc"="false" test-net
```
_____________________________________________________________________________________________________