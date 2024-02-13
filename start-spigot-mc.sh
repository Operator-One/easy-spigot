#!/bin/sh

echo "Starting the Minecraft Server"
java -jar -Xmx4G -Xmx2G -XX:+UseZGC $HOME/minecraft-server/spigot.jar &
first_pid=$!

# Start the second program in the background
echo "Starting Bedrock Connect"
java -jar -Xmx4G -Xmx2G -XX:+UseZGC $HOME/minecraft-server/bedrock-connect.jar &
second_pid=$!

# Wait for all background processes to exit
wait $first_pid
wait $second_pid