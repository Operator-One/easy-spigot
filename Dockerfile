# Use Rocky Linux as the base image
FROM alpine/alpine:latest

#Open Ports
EXPOSE 25565/tcp
EXPOSE 19132/udp

#Set Private Repo HTTP Token uncomment to use for below.
#ARG GITHUB_TOKEN
#ARG REPO_OWNER
#ARG REPO_NAME

# Install dependencies
RUN apk add curl git jq openjdk17
RUN addgroup servergroup && adduser -D -G servergroup serveruser
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
#Set these files to your own fork for customization. Uncomment to use 
#Set a flag in your docker build command to include your http token to be passed off as ARG "--build-arg GITHUB_TOKEN=<YOUR_HTTP_TOKEN> --build-arg REPO_OWNER=owner-user --build-arg REPO_NAME=repo_name"
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/banned-ips.json -o banned-ips.json
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/banned-players.json -o banned-players.json
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/ops.json -o ops.json
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/server.properties -o server.properties
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/spigot.yml -o spigot.yml
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/whitelist.json -o whitelist.json
#Plugins -----------------
#Essentials
#WORKDIR /home/serveruser/minecraft-server/plugins/Essentials
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/config.yml -o config.yml
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/custom_items.yml -o custom_items.yml
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/items.json -o items.json
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/kits.yml -o kits.yml
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/motd.txt -o motd.txt
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/tpr.yml -o tpr.yml
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/Essentials/upgrades-done.yml -o upgrades-done.yml
#SetHome
#WORKDIR /home/serveruser/minecraft-server/plugins/SetHome
#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/plugins/SetHome/config.yml -o config.yml
# Command to run the SpigotMC server and Minecraft Connect executable
RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
CMD java -jar -Xmx4G -Xms512M -XX:+UseZGC /home/serveruser/minecraft-server/spigot.jar