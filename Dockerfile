#FROM debian:stretch
#FROM debian:buster
FROM debian:bullseye



ARG VNC_RESOLUTION

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
#RUN apt-get update && apt-get install --no-install-recommends -y keyboard-configuration  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y gnome-icon-theme xorg xserver-xorg \
    xserver-xorg-video-dummy

RUN apt-get install --no-install-recommends -y apt-utils 
# 
RUN apt-get install --no-install-recommends -y lxde 
RUN apt-get install --no-install-recommends -y wget rsync
RUN apt-get install --no-install-recommends -y tightvncserver
#RUN apt-get install --no-install-recommends -y tigervnc-common tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer
RUN apt-get install --no-install-recommends -y curl nano vim lxde-core
RUN apt-get install --no-install-recommends -y lxrandr sudo

RUN  apt-get install --no-install-recommends -y firefox-esr filezilla rxvt-unicode-256color

# Python
RUN  apt-get install --no-install-recommends -y python3 python3-pip 
RUN  pip3 install --upgrade pip
RUN  pip3 install virtualenv
RUN  pip3 install jupyter

# R-base and LibreOffice
RUN  apt-get install --no-install-recommends -y r-base libreoffice maven default-jdk  

# RStudio should be run on own server, does not work well locally
# RUN wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2021.09.0-351-amd64.deb
# RUN apt-get install -f --no-install-recommends -y ./rstudio-2021.09.0-351-amd64.deb

RUN mkdir /store && mkdir /cp_home

# INSTALL ECLIPSE
#RUN wget wget https://mirror.umd.edu/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-jee-2021-12-R-linux-gtk-x86_64.tar.gz -P /opt

# NB! archive gets unzipped when added!!!! Violates PLS (Principle of Least Surprise :-) )
#ADD files/eclipse-jee-2021-12-R-linux-gtk-x86_64.tar.gz /opt
#RUN ls -al /store /opt
#RUN cd /opt && tar xvzf /store/eclipse-jee-2021-12-R-linux-gtk-x86_64.tar.gz

# Chrome does not get correctly installed this way...
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN   apt-get install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb

#We need some more networking resources
RUN   apt-get install --no-install-recommends -y iputils-ping


#
RUN rm -rf /var/lib/apt/lists/*

#RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
#RUN echo -e "live\nlive" | passwd root
#RUN echo -e "linuxpassword\nlinuxpassword" | passwd
ADD vuser /etc/sudoers.d/vuser
RUN chmod 0440 /etc/sudoers.d/vuser 

RUN groupadd  vuser && useradd -m -g vuser vuser
RUN chattr -a /tmp/hsperfdata_root
RUN chattr -i /tmp/hsperfdata_root
RUN chmod a+rwx /tmp/hsperfdata_root
RUN rm -rf /tmp/hsperfdata_root


#USER root
USER vuser
RUN mkdir ~/.vnc && echo 123456 | vncpasswd -f > ~/.vnc/passwd
RUN chmod 0600 ~/.vnc/passwd
ADD xstartup  /home/vuser/.vnc/xstartup
#RUN chmod a+x ~/.vnc/xstartup


#RUN mkdir /root/.vnc && echo 123456 | vncpasswd -f > /root/.vnc/passwd
#RUN chmod 0600 /root/.vnc/passwd
##ADD xstartup  /root/.vnc/xstartup
#RUN chmod a+x  /root/.vnc/xstartup
#COPY /home cp_home

ENV USER vuser
#ENV PROTO tcp

WORKDIR /home/vuser
EXPOSE 5901
CMD USER=vuser && export USER && rm -rf /tmp/* && vncserver -geometry 1536x1024  :1 && DISPLAY=127.0.0.1:1 && export DISPLAY && xterm
#CMD USER=vuser && export USER && rm -rf /tmp/* && vncserver
#CMD ["/usr/bin/vncserver", "-fg"]
#CMD USER=root && export USER && /usr/bin/vncserver && bash
#
#
# sudo docker build --build-arg VNC_RESOLUTION=1536x1024 -t tyder/lxde1 .
# sudo docker run -p 5901:5901 --rm --name lxde1 tyder/lxde1 &
# sudo docker run -p 5902:5902 tyder/lxde1

