# 112-1-Quartus-FinalProject

This project is created by our team: 111321037 沈家樂， 111321044 李志恆 ， 111321041 張嘉驛

# What is this Project

We trying to recreate an Undertale-like playstyle game on FPGA

# Things its represent

on 8x8 RGB Matrix: 

Attack Round: Enemy will take damage when the line is in red color andother colors will not affect enemy's health point.
Defense Round: Red color represent as our control character; Blue, Green and white color is represent as Danmaku(which when our red dot touch will lose health).

On Others:
16 leds to represent our health bar and enemy's health bar.
Four 7-segment to show the win/lose screen on this game. (PASS/LOSE)

# How to play it 

We using 4-bits SW to make the charcater move at defense round and DIPSW to attack enemy at attack round
The game is endless loop until enemy is dead or our character health bar is being empty.

# what we tried to do but didn't done

Sound Effect: A game without sound effect is not very nice but due to time we cannot make it

# A short video which include all preview of this project

https://www.youtube.com/watch?v=_WfSISRq58A


