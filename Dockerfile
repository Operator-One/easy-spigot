# Use Rocky Linux as the base image
FROM rockylinux/rockylinux:latest

# Install dependencies
RUN dnf install -y bind-utils wget git java-1.8.0-openjdk.x86_64 jq java-17-openjdk.x86_64
RUN groupadd -r servergroup && useradd -r -g servergroup serveruser
USER serveruser
RUN mkdir -p $HOME/minecraft-server
RUN mkdir -p $HOME/minecraft-backup
RUN mkdir -p $HOME/minecraft-server/plugins

# Create a working directory for BuildTools
WORKDIR $HOME

# Download the latest BuildTools.jar
ADD https://github.com/Operator-One/easy-spigot/raw/main/build-server-docker.sh $HOME/build-server-docker.sh
ADD https://github.com/Operator-One/easy-spigot/raw/main/start-spigot-mc.sh $HOME/minecraft-server

RUN chmod +x $HOME/build-server-docker.sh
RUN ./build-server-docker.sh

# Set the working directory to where the server jar is
WORKDIR $HOME/minecraft-server

# Expose the Minecraft server port
EXPOSE 25565
EXPOSE 19132
EXPOSE 19133
EXPOSE 53

# Command to run the SpigotMC server and Minecraft Connect executable
CMD ./$HOME/minecraft-server/start-spigot-mc.sh
