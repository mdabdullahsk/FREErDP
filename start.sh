#!/bin/bash

# DBUS সার্ভিস চালু করা
service dbus start

# XRDP সার্ভিস চালু করা
service xrdp start

# X11 permissions ঠিক করা
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# কনটেইনার সচল রাখা
tail -f /var/log/xrdp-sesman.log
