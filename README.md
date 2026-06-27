docker build -t xrdp .

docker run -d -p 3389:3389 -v xrdp-user-home:/home/desktopuser --name xrdp-desktop-audio xrdp
