#!/usr/bin/env bash

set -x

# Virtual framebuffer settings
#-----------------------------
export VFB_DISPLAY_SIZE='1280x1024'
export VFB_COLOR_DEPTH=16
export VFB_DISPLAY_NUM=22
#-----------------------------

apt-get install --yes git && git clone https://github.com/openstack/murano-dashboard.git

apt-get install --yes firefox && \
             apt-get remove --yes firefox && \
             wget https://ftp.mozilla.org/pub/firefox/releases/46.0/linux-x86_64/en-US/firefox-46.0.tar.bz2 && \
             tar -xjf firefox-46.0.tar.bz2 && \
             rm -rf /opt/firefox && \
             mv firefox /opt/firefox46 && \
             ln -s /opt/firefox46/firefox /usr/bin/firefox

apt-get install --yes python-pip xvfb xfonts-100dpi xfonts-75dpi xfonts-cyrillic xorg dbus-x11 && \
          pip install --upgrade pip && \
          pip install -U selenium nose

