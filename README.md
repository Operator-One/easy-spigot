# easy-spigot

Early stages of development and testing. 

Simply build the image and deploy on Docker (after customizing it of course, see dockerfile for details). This will auto-update every build to whatever the latest version of
everything is. I will be making further improvements for persistence using Docker volumes. 

If hosting public, you'll need to forward some ports
  For Java MC - Port 25565/tcp
  For Bedrock MC - Port 19132/udp
  For Crossplay MC - Port 19133/udp
  For Crossplay DNS - Port 53
