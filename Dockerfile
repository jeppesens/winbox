FROM ubuntu:18.04

# Install wine
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN dpkg --add-architecture i386
RUN apt-get autoclean && apt-get clean -y && apt-get autoremove -y
## Fix dependency hell
RUN apt-get install -y libgnutls30 libldap-common libgpg-error0 libxml2 libasound2-plugins libsdl2-2.0-0 libfreetype6 libdbus-1-3 libsqlite3-0 \
    wget gnupg gnupg1 gnupg2 software-properties-common pulseaudio
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key && apt-key add winehq.key
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
RUN apt-add-repository ppa:cybermax-dexter/sdl2-backport
RUN apt update && apt install -y --install-recommends winehq-stable
# Installing Winetricks
RUN wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    cp winetricks /usr/local/bin



# Installing VNC
## Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
	xvfb xauth x11vnc \
	x11-utils x11-xserver-utils \
	&& rm -rf /var/lib/apt/lists/*
RUN mkdir -p /Xauthority

## start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900


# Installing WinBox from mikrotik
RUN apt-get update \
    && apt-get install --yes --no-install-recommends ca-certificates \
    && wget -O winbox.exe https://mt.lv/winbox


# Running
ADD entrypoint.sh entrypoint.sh
ADD vnc_service.sh vnc_service.sh
RUN chmod +x entrypoint.sh && chmod +x vnc_service.sh
CMD ./entrypoint.sh
