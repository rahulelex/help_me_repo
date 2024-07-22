# Base image
FROM ros:melodic-ros-base

# Update package repositories and install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gpg \
    gnupg \
    git \
    zip \
    curl \
    python3 \
    dirmngr \
    gnupg2 \
    swi-prolog \
    python-pip \
    iputils-ping \
    net-tools \
    nano 

# Install dependency libraries
RUN pip install --no-cache-dir bottle \ 
    pip install --no-cache-dir shapely \
    pip install --no-cache-dir paho-mqtt \
    pip install --no-cache-dir requests \
    pip install --no-cache-dir python-dotenv

# Add Google Linux signing key
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Import the GPG key for the ROS repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Import the ROS package repository key
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# Setup and create workspace
RUN mkdir -p /home/ubuntu/catkin_ws/src/costmap_prohibition_layer
RUN git clone -b kinetic-devel https://github.com/rst-tu-dortmund/costmap_prohibition_layer.git  /home/ubuntu/catkin_ws/src/costmap_prohibition_layer/.

# Install Ros Melodic packages
RUN apt-get update && apt-get install -y \
    ros-melodic-ros-base \
    ros-melodic-ros-controllers \
    ros-melodic-navigation \
    ros-melodic-velodyne-pointcloud \
    ros-melodic-rosbridge-server \
    ros-melodic-twist-mux \
    ros-melodic-robot-localization \
    ros-melodic-jackal-description \
    ros-melodic-tf2-web-republisher \
    ros-melodic-web-video-server \
    ros-melodic-interactive-marker-proxy \
    ros-melodic-rospy-message-converter \
    python3-rosdep \
    ros-melodic-laser-filters \
    iproute2 \
    avahi-daemon \
    dbus

#Remove any old rosdep init config
RUN /bin/bash -c "rm -rf /etc/ros/rosdep/sources.list.d/20-default.list"

# Initialize and update rosdep
RUN rosdep init && rosdep update

# Copy base_packages.zip file to the Docker image which includes base packages
COPY base_packages.zip /home/ubuntu/catkin_ws/
# Unzip the file
RUN unzip /home/ubuntu/catkin_ws/base_packages.zip -d /home/ubuntu/catkin_ws/src
# Remove package zip file
RUN rm /home/ubuntu/catkin_ws/base_packages.zip

# Clone FKIE Multimaster package from github repo
# Create multimaster package
RUN mkdir -p /home/ubuntu/catkin_ws/src/multimaster
# Clone ros package FKIE Multimaster from github
RUN git clone https://github.com/fkie/multimaster_fkie.git /home/ubuntu/catkin_ws/src/multimaster/.

# Set the ROS_PYTHON_VERSION environment variable to 2
ENV ROS_PYTHON_VERSION=2
#update the package dependency information
RUN rosdep update
#Automatically install all dependencies
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && rosdep install -i -r --as-root pip:false --reinstall -y --rosdistro melodic --from-paths /home/ubuntu/catkin_ws/src/multimaster"
#Ignore MQTT Client Package
RUN touch /home/ubuntu/catkin_ws/src/vts-common-utils/mqtt_client/CATKIN_IGNORE
 # Build the catkin workspace with ROS Melodic
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && cd /home/ubuntu/catkin_ws && catkin_make -j3"
# Configure environment variables for ROS
RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc && \
    echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc && \
    echo 'ip_value=\"\$(ip a s eth0 | egrep -o '\''inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'\'' | cut -d'\'' '\'' -f2)\"' >> /root/.bashrc \
    && echo 'export ROS_MASTER_URI=http://\$ip_value:11311' >> /root/.bashrc \
    && echo 'export ROS_HOSTNAME=\$ip_value' >> /root/.bashrc \
    && echo 'export ROS_IP=\$ip_value' >> /root/.bashrc \
    && echo 'source /home/ubuntu/catkin_ws/devel/setup.bash' >> /root/.bashrc \
    && source /root/.bashrc"

# Clean up the package cache and remove unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#ADD service to start dbus & avahi-daemon on boot
RUN sed -i '0,/exec/{s/exec/service dbus start\n&/}' /ros_entrypoint.sh
RUN sed -i '0,/exec/{s/exec/service avahi-daemon start\n&/}' /ros_entrypoint.sh

# Set the entrypoint command
CMD ["bash"]