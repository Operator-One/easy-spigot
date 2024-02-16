# Use Rocky Linux as the base image
FROM rockylinux/rockylinux:latest

#Open Ports
EXPOSE 25565
EXPOSE 19132
EXPOSE 19133
EXPOSE 53

# Install dependencies
RUN dnf install -y bind-utils wget git java-1.8.0-openjdk.x86_64 jq java-17-openjdk.x86_64
RUN groupadd -r servergroup && useradd -r -g servergroup serveruser
RUN mkdir -p /home/serveruser/minecraft-server
RUN mkdir -p /home/serveruser/minecraft-backup
RUN mkdir -p /home/serveruser/minecraft-server/plugins
# Set build directory
WORKDIR /home/serveruser

# Download needed files
ADD https://github.com/Operator-One/easy-spigot/raw/main/build-server-docker.sh /home/serveruser/build-server-docker.sh
ADD https://github.com/Operator-One/easy-spigot/raw/main/start-spigot-mc.sh /home/serveruser/minecraft-server

RUN chmod +x /home/serveruser/build-server-docker.sh
RUN /home/serveruser/build-server-docker.sh

# Set the working directory to where the server jar is
WORKDIR /home/serveruser/minecraft-server

RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
# Command to run the SpigotMC server and Minecraft Connect executable
CMD /home/serveruser/minecraft-server/start-spigot-mc.sh
