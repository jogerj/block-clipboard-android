#!/bin/bash

if [[ ! $(adb --version | grep "Android Debug Bridge") ]]; then 
  if [[ $(command -v termux-setup-storage) ]]; then
    pkg install android-tools;
  else
    echo "adb not found!";
	exit;
  fi;
fi;
read -p "Enter hostname or IP address: [localhost] " address
if [[ ! $address ]]; then address="localhost"; fi;

if [[ ! $(adb devices | grep $address | grep device) ]]; then
  adb tcpip 5555;
  conn=$(adb connect $address:5555 | grep connected);
  if [[ ! $conn ]]; then
    echo "Click on Allow when prompted. If no prompt pops up, disable and re-enable USB debugging"
    read -p "Press ENTER to continue..."
    conn=$(adb connect $address);
    echo $conn;
    if [[ ! $(echo $conn | grep connected) ]]; then exit; fi;
  fi;
fi;

adb -s $address:5555 shell cmd appops query-op --user 0 READ_CLIPBOARD allow;
echo "Select a package to disable READ_CLIPBOARD permission"
read -p "Enter package name: " pkgname;
if [[ $pkgname ]]; then adb -s $address:5555 shell cmd appops set $pkgname READ_CLIPBOARD ignore; fi;
