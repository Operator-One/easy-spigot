# Use Rocky Linux as the base image
FROM rockylinux/rockylinux:latest

#Open Ports
EXPOSE 25565/tcp
EXPOSE 19132/udp
EXPOSE 19133/udp
EXPOSE 53/tcp

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
# Command to run the SpigotMC server and Minecraft Connect executable
RUN nohup /etc/alternatives/jre_1.8.0/bin/java -jar /home/serveruser/minecraft-server/bedrock-connect.jar nodb=true > bedrock-connect.log 2>&1 &
CMD /etc/alternatives/jre_17_openjdk/bin/java -jar -Xmx4G -Xmx2G /home/serveruser/minecraft-server/spigot.jar