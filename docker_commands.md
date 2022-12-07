# Some Useful Docker Commands
### Note :)
Use ctrl + f to search command if you know it partially.


## To use docker commands without sudo, run below mentioned 3 commands
```sh
sudo usermod -aG docker ${USER}
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

<sub> Log: "Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get"http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json": dial unix/var/run/docker.sock: connect: permission denied" </sub>

Simply just change **/var/run/docker.sock** permission using chown and chmod, in the above log case.


##  ------------------------------ BASIC COMMANDS --------------------------
### To check docker Engine's server and client installed version information
```sh
sudo docker version
```

### Docker engine start, stop and restart example
```sh
sudo systemctl start docker
sudo systemctl stop docker
sudo systemctl restart docker
```

### To check currently running docker container
```sh
sudo docker ps
```

### To check all docker container run history
```sh
sudo docker ps -a
```

### This command is used to access the running container
<sub>sudo docker exec -interactive_terminal  docker_id bash</sub>
```sh
sudo docker exec -it c9 bash
```

### To stop running container
<sub>sudo docker stop "starting digits of container"</sub>
```sh
sudo docker stop c9
```

### To kill running container
<sub> sudo docker kill "starting digits of container" </sub>
```sh
sudo docker kill c9
```

### This command is used to delete a stopped container
<sub> sudo docker rm "starting digits of container" </sub>
```sh
sudo docker rm c9
```

### This command is used to delete an image from local storage
<sub> sudo docker rmi <image_id> </image_id></sub>
```sh
sudo docker rmi fd484f19954f
```

### To copy files or folders
#### Copy from local to Docker
```sh
sudo docker cp some_file_path CONTAINER_id:/work
```

#### Copy from Docker to local
```sh
sudo docker cp CONTAINER_id:file_path local_destination_path
```

#### Copy from Docker to Docker
```sh
sudo docker cp CONTAINER_id:source_file_path CONTAINER_id:dest_file_path
```
-----------------------------------------------------------------------------------

## -------------------------- DOCKER IMAGE OPERATION --------------------------------
### Docker pull will get download image from docker hub if do not exist locally
```sh
docker pull ubuntu:18.04
```

### Load tar to docker image
<sub>sudo docker load --input tar_file_name.tar</sub>
```sh
sudo docker load --input ros-gazebo.tar
```

### To commit docker changes for deployment (Stop docker before commit)
```sh
sudo docker commit 9e8af776f8 repository_name:tag_name
```

### Save docker image to tar
```sh
docker save -o tar_name.tar repository_name:tag_name
```

### To check all images which are loaded
```sh
sudo docker images
```
-------------------------------------------------------------------------------------

## ---------------------------------- RUNNING DOCKER ----------------------------------
### Docker run command from image and its add on
```sh
sudo docker run -itd  repository_name:tag_name
```

#### Options
#### Add volume
-v host_path:docker_path
-v /home/root1/docker/robot1:/home/code
#### add port
-p 6080:80
#### add network
--network=ROS_NWK_ROBOT
#### add capabilities
--cap-add=NET_ADMIN
#### detached mode
-d
--net ROS_NW --ip 10.0.1.2

#### Start docker with network host
```sh
docker run -tid --privileged --net=host --pid=host --ipc=host --volume /:/host --name=onboarding_docker onboard_agv:1_0
```

#### Some examples:
```sh
sudo docker run -itd -v /home/ubuntu/docker/robot1:/home/code --name robot1 -p 6680:80 repository_name:tag_name
sudo docker run -it -d --network=ROS_NWK_ROBOT repository_name:tag_name
sudo docker run -it --name=docker_name --cap-add=NET_ADMIN -p 6080:80 -p 1194:1194 repository_name:tag_name
```
--------------------------------------------------------------------------------------------


## --------------------------------------------- NETWORKING in DOCKER --------------------------
### Leave docker swarm network if connected to anyone
```sh
sudo docker swarm leave --force
```
### Initialise docker swarm for networking
<sub> If host have multiple address use below command to specify address to be used in swarm init </sub>
```sh
sudo docker swarm init --advertise-addr 30.30.31.30
```

### Then join from another system using command displayed by above command
```sh
docker swarm join --token SWMTKN-1-0e1xv3cdstlmqqi79hfklqjnonz4wjbtl4jtfveey6f6fsv6h4-2bhk1yunnv8vrcc1vb16yxsxp 30.30.31.30:2377
```

### Use this command for to check which nodes have joined network
```sh
sudo docker node ls
```

### Get swarm join tocken as worker
```sh
sudo docker swarm join-token worker
```

### To create network with overlay with encryption
```sh
sudo docker network create --opt encrypted=true --driver overlay --attachable ROS_NWK_ENCRYPTED
```

### To create network with overlay without encryption
```sh
sudo docker network create --driver overlay --attachable ROS_NWK_UNENCRYPTED
sudo docker network create --driver overlay --subnet 10.0.2.0/24 --attachable ROS_NWK_UNENCRYPTED
```
### After create network command you will see something like this
6xhxdrjtc1hr6v4b8uyvgsp6a7

### To disconnect / connect network to running docker 
<sub>sudo docker network operation network_name docker_name or id </sub>

```sh
sudo docker network disconnect ROS_NWK_ENCRYPTED docker1
sudo docker network connect ROS_NWK_ENCRYPTED docker1
```
---------------------------------------------------------------------------------------------


## ----------------------------------- PORTRAINER SETUP ---------------------------------------
### To pull portainer with latest Tag in linux
```sh
sudo docker pull portainer/portainer:latest
```

### First, create the volume that Portainer Server will use to store its database:
```sh
sudo docker volume create portainer_data
```

### By default, Portainer generates and uses a self-signed SSL certificate to secure port 9443
<sub> But below command has changed it to HTTP port 9000 </sub>
```sh
sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:2.9.3
```

### To open portainer  in a web browser use 
> https://localhost:9000

--------------------------------------------------------------------------------------------

## ---------------------------- To use GPU with container -----------------------------------
### A). By using --gpus all
Versions earlier than Docker 19.03 used to require nvidia-docker2 and the --runtime=nvidia flag.
Since Docker 19.03, you need to install nvidia-container-toolkit package and then use the --gpus all flag.

#### 1. Install the nvidia-container-toolkit package 
https://github.com/NVIDIA/nvidia-docker

#### 2. Add the package repositories For Debian based OSes
```sh
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

#### 3. Running the docker with GPU support
```sh
docker run --name my_all_gpu_container --gpus all -t nvidia/cuda
```

<sub>Please note, the flag --gpus all is used to assign all available gpus to the docker container. </sub>


### B). To assign specific gpu to the docker container (in case of multiple GPUs available in your machine)
#### 1. Find your nvidia devices
```sh
ls -la /dev | grep nvidia
```

#### 2. Run Docker container with nvidia driver pre-installed
```sh
sudo docker run -itd --device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm tleyden5iwx/ubuntu-cuda /bin/bash
```
--------------------------------------------------------------------------------------------


## -------------------------------- Cleanup (prune) ------------------------------------------
### To clean up everything in docker without volumes
```sh
docker system prune 
```

### To also prune volumes, add the --volumes flag:
```sh
docker system prune --volumes
```

 WARNING! This will remove:
 - all stopped containers
 - all networks not used by at least one container
 - all volumes not used by at least one container
 - all dangling images
 - all build cache
--------------------------------------------------------------------------------------------
### To automate docker
##### Create a filename.sh file and write
```sh
#!/bin/bash
source /root/.bashrc
source /opt/ros/melodic/setup.bash
source /home/ubuntu/workspace/devel/setup.bash
value="$(ip a s eth0 | egrep -o 'inet > [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)"
export ROS_MASTER_URI=http://$value:11311
export ROS_HOSTNAME=$value
export ROS_IP=$value
#write you code to run scripts. Below are examples:
bash any_script.sh
#roslaunch package launch_file.launch 2>&1 &
```
##### After saving above with filename.sh 
##### Write below comamnd in ros_entrypoint.sh before #exec "$@"
```sh
bash filename.sh
```
--------------------------------------------------------------------------------------------
