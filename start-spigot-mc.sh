#!/bin/sh

nohup java -jar -Xmx4G -Xmx2G -XX:+UseZGC /home/serveruser/minecraft-server/spigot.jar > spigot.log 2>&1 &
nohup java -jar /home/serveruser/minecraft-server/bedrock-connect.jar nodb=true > bedrock-connect.log 2>&1 &