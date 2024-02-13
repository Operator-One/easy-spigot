#!/bin/sh

kill -9 $(cat spigot_pid.txt)
kill -9 $(cat bc_pid.txt)
