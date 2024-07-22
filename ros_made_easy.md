### Rospy code examples:
1. rospy.logdebug("-D- %s test msg.data= %0.3f wheel_latest = %0.3f" % (self.nodename, enc, variable2))
2. rospy.logdebug('Registration response: %s' % (res))
3. rospy.init_node('my_node', log_level=rospy.DEBUG)

___________________________________________________________________________________________________________
# Single ROS master

## Single ros master to send 
#value=192.168.200.54
#export ROS_MASTER_URI=http://$value:11311
#export ROS_IP=$value

## Single ros master to receive
#export ROS_MASTER_URI=http://192.168.200.107:11311
#export ROS_IP=192.168.200.54
____________________________________________________________________________________________________________

create a file killRos.sh 
You have to pass an argument <ros>

#!/bin/sh -e
for pid in `ps -ef | grep $1 | awk '{print $2}'` ; do kill $pid ; done
