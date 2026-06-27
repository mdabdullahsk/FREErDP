FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386

# প্রয়োজনীয় প্যাকেজ ও VLC ইনস্টলেশন
RUN apt update && apt install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 \
    firefox-esr \
    vlc \
    && apt clean && rm -rf /var/lib/apt/lists/*

# একটি সাধারণ ইউজার তৈরি করা (desktopuser) এবং তাকে sudo গ্রুপে যুক্ত করা
RUN useradd -m -s /bin/bash desktopuser && \
    echo "desktopuser:password" | chpasswd && \
    usermod -aG sudo,audio,video desktopuser

# X11 কনফিগারেশন
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# তৈরি করা ইউজারের জন্য XFCE4 সেশন সেটআপ
RUN echo "startxfce4" > /home/desktopuser/.xsession && \
    chown desktopuser:desktopuser /home/desktopuser/.xsession

# dbus এর জন্য machine-id তৈরি
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

# XRDP কনফিগারেশন
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    echo "exec startxfce4" > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh

RUN adduser xrdp ssl-cert

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
