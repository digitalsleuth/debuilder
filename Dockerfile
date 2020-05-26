FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update -y && apt-get -qq upgrade -y && apt-get -qq install -y sudo gnupg debhelper python-all python-setuptools devscripts quilt ant autotools-dev software-properties-common \
git pbuilder ubuntu-dev-tools apt-file dh-make bzr-builddeb ssh vim nano wget && mkdir /run/sshd

RUN wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2019.2 bionic main" | sudo tee /etc/apt/sources.list.d/saltstack.list && \
apt-get update -y && apt-get install -y salt-minion

RUN groupadd -r remnux && \
useradd -r -g remnux -d /home/remnux -s /bin/bash -c "REMnux User" remnux && \
mkdir /home/remnux && chown -R remnux:remnux /home/remnux && \
usermod -a -G sudo remnux && \
echo 'remnux:remnux' | chpasswd

RUN echo export DEBFULLNAME=\"REMnux Distribution\" >> /home/remnux/.bashrc && \
echo export DEBEMAIL=\"distro@remnux.org\" >> /home/remnux/.bashrc && \
echo export DISTRIBUTION=bionic >> /home/remnux/.bashrc && \
echo alias sign-package=\'debuild -S -k28CD19DB\' >> /home/remnux/.bashrc && \
echo source .bashrc >> /home/remnux/.bash_profile

RUN wget -O /usr/local/bin/remnux https://github.com/REMnux/remnux-cli/releases/download/v1.1.5/remnux-cli-linux && chmod +x /usr/local/bin/remnux
RUN sudo remnux install --mode=addon --user=remnux

#IF root is required for ssh access
#RUN echo 'root:root' | chpasswd 
#RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
#RUN echo export DEBFULLNAME=\"REMnux Distribution\" >> ~/.bashrc && \
#echo export DEBEMAIL=\"distro@remnux.org\" >> ~/.bashrc && \
#echo export DISTRIBUTION=bionic >> ~/.bashrc && \
#echo alias sign-package=\'debuild -S -k28CD19DB\' >> ~/.bashrc && \
#echo source .bashrc >> ~/.bash_profile

EXPOSE 22/tcp
CMD ["/usr/sbin/sshd", "-D"]
