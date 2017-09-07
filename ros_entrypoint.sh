#!/bin/bash
set -e

# setup ros environment
export ROS_IP=`grep '[0-9a-z]\{12\}' /etc/hosts | awk '{ print $1 }'`
source "/opt/ros/$ROS_DISTRO/setup.bash"
unset ROS_HOSTNAME
exec "$@"
