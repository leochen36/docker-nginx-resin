#uname -r 
#  3.10.0-229.el7.x86_64

sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF


yum install docker-engine

service docker start



#test docket
# sudo docker run hello-world
#Unable to find image 'hello-world:latest' locally
#    latest: Pulling from hello-world
#    a8219747be10: Pull complete
#    91c95931e552: Already exists
#    hello-world:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
#    Digest: sha256:aa03e5d0d5553b4c3473e89c8619cf79df368babd1.7.1cf5daeb82aab55838d
#    Status: Downloaded newer image for hello-world:latest
#    Hello from Docker.
#    This message shows that your installation appears to be working correctly.
#
#    To generate this message, Docker took the following steps:
#     1. The Docker client contacted the Docker daemon.
#     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
#            (Assuming it was not already locally available.)
#     3. The Docker daemon created a new container from that image which runs the
#            executable that produces the output you are currently reading.
#     4. The Docker daemon streamed that output to the Docker client, which sent it
#            to your terminal.
#
#    To try something more ambitious, you can run an Ubuntu container with:
#     $ docker run -it ubuntu bash
#
#    For more examples and ideas, visit:
#     http://docs.docker.com/userguide/