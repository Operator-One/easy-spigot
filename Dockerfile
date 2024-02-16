# Use Rocky Linux as the base image
FROM rockylinux/rockylinux:latest

#Open Ports
EXPOSE 25565
EXPOSE 19132
EXPOSE 19133
EXPOSE 53

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
ADD https://raw.githubusercontent.com/Operator-One/easy-spigot/main/start-spigot-mc.sh /home/serveruser/minecraft-server/start-spigot-mc.sh
RUN chmod +x /home/serveruser/minecraft-server/start-spigot-mc.sh

RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
# Command to run the SpigotMC server and Minecraft Connect executable
CMD ./home/serveruser/minecraft-server/start-spigot-mc.sh
