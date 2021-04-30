# Pihole-404
A nice 404 page for pihole with an acompanying automatic script that can be used to whitelist the domain with the click of a button.

![This is what your 404 page will look like. Of course, you can also customize it.](./Screenshot.png)

## Table of Contents
* [The Problem](#the-problem)
* [The Solution](#the-solution)
* [Step 1](#step-1)
* [Step 2](#step-2)

## The Problem:
Setting up a Pihole is awesome and pretty easy. But what happens when a page you want to go to is blocked? You get a boring 404 error. And what if you want to go to the webpage? First, you have to go to your pihole's website. Then you have to login. Next, you need to go to whitelist and type in the domain. This is great, but what if you don't know the password or a client has problems? Pihole-404 to the rescue! This simple script will add a button that lets you email the admin. This email will be read by an automatic python script and the domain will be whitelisted!

## Step 1: Install Pihole and Get it Working
Head over to https://github.com/pi-hole/pi-hole

## Step 2: 
Clone this repository:
`git clone https://github.com/BennyThePythonCoder/Pihole-404.git`
Navigate to the project folder:
`cd /Downloads/Pihole-404/`
Run the installer script:
`sudo sh install.sh`
And everything should work!
