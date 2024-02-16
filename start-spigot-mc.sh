#!/bin/sh

nohup /etc/alternatives/jre_17_openjdk/bin/java -jar -Xmx4G -Xmx2G -XX:+UseZGC /home/serveruser/minecraft-server/spigot.jar > spigot.log 2>&1 &
nohup /etc/alternatives/jre_1.8.0/bin/java -jar /home/serveruser/minecraft-server/bedrock-connect.jar nodb=true > bedrock-connect.log 2>&1 &