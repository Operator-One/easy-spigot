# Use Rocky Linux as the base image
FROM rockylinux/rockylinux:latest

#Open Ports
EXPOSE 25565/tcp
EXPOSE 19132/udp

# Install dependencies
RUN dnf install -y bind-utils wget git jq java-1.8.0-openjdk.x86_64 java-17-openjdk.x86_64
RUN groupadd -r servergroup && useradd -r -g servergroup serveruser
RUN mkdir -p /home/serveruser/minecraft-server
RUN mkdir -p /home/serveruser/minecraft-backup
RUN mkdir -p /home/serveruser/minecraft-server/plugins
# Set build directory
WORKDIR /home/serveruser

# Download needed files
ADD https://raw.githubusercontent.com/Operator-One/easy-spigot/main/build-server-docker.sh /home/serveruser/build-server-docker.sh

RUN chmod +x /home/serveruser/build-server-docker.sh
RUN /home/serveruser/build-server-docker.sh

# Set the working directory to where the server jar is
WORKDIR /home/serveruser/minecraft-server

RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
WORKDIR /home/serveruser/minecraft-server
#Set these files to your own fork for customization. 
#Base server -------------
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/banned-ips.json /home/serveruser/minecraft-server
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/banned-players.json /home/serveruser/minecraft-server
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/ops.json /home/serveruser/minecraft-server
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/server.properties /home/serveruser/minecraft-server
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/spigot.yml /home/serveruser/minecraft-server
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/whitelist.json /home/serveruser/minecraft-server
#Plugins -----------------
#Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/config.yml /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/custom_items.yml /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/items.json /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/kits.yml /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/motd.txt /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/tpr.yml /home/serveruser/minecraft-server/plugins/Essentials
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/Essentials/upgrades-done.yml /home/serveruser/minecraft-server/plugins/Essentials
#SetHome
ADD https://github.com/Operator-One/easy-spigot/raw/main/config/plugins/SetHome/config.yml /home/serveruser/minecraft-server/plugins/SetHome
# Command to run the SpigotMC server and Minecraft Connect executable
CMD /etc/alternatives/jre_17_openjdk/bin/java -jar -Xmx4G -Xms512M -XX:+UseZGC /home/serveruser/minecraft-server/spigot.jar