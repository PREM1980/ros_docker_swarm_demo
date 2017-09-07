FROM ros:indigo-ros-base
# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository "ppa:patrickdk/general-lucid" && \
    apt-get update && apt-get install -y \
    ros-indigo-ros-tutorials \
    iperf3 \
    dnsutils \
    ros-indigo-common-tutorials && \
    rm -rf /var/lib/apt/lists/

ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
# Modified entrypoint
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/tini", "--", "/ros_entrypoint.sh"]
