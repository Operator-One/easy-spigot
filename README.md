# easy-spigot

Early stages of development and testing. 

Simply build the image and deploy on Docker (after customizing it of course, see dockerfile for details). This will auto-update every build to whatever the latest version of
everything is. I will be making further improvements for persistence using Docker volumes. 

If hosting public, you'll need to forward some ports
  For Java MC - Port 25565/tcp
  For Bedrock MC - Port 19132/udp
  For Crossplay MC - Port 19133/udp
  For Crossplay DNS - Port 53

For Configuration, you will need to add the following build args to your docker build command:
--build-arg GITHUB_TOKEN=TOKEN --build-arg REPO_NAME=easy-spigot --build-arg REPO_OWNER=Operator-One --build-arg OWNER_EMAIL=cullen.guimond@guinet.us

Email is required for the PaperMC build, otherwise it'll crash. 
