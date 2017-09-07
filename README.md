# ROS Docker Swarm Demo
This demo runs a three node cluster of VMs to demonstrate ROS running with Docker Swarm. It uses vagrant to launch the VMs, and assumes VirtualBox. Two nodes participate in the swarm, and the third is meant to mimic an outside machine, such as an operator's laptop.

## Network Configuration
This uses the MACVLAN driver to communicate over the swarm. While containers are fully connected, and can be reached from the outside machine, and talk to the outside world, a single container may not communicate directly with its underlying host machine. See [this document](https://github.com/docker/libnetwork/blob/master/docs/macvlan.md) for further explanation.

**NOTE**: it looks like the portmapping does not work as expected, and opening all the ports on the container does not work. I am re-evaluating the use of this driver.

## To Run:
```
vagrant up
vagrant ssh ops
source /opt/ros/indigo/setup.bash
export ROS_MASTER_URI=http://192.168.33.101:11311
rostopic list
```
