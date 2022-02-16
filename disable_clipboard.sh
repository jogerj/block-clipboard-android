#!/data/data/com.termux/files/usr/bin/bash

installed=$(adb --version | grep "Android Debug Bridge");
if [[ ! $installed ]]; then pkg install android-tools; fi;

if [[ ! $(adb devices | grep localhost | grep device) ]]; then
  conn=$(adb connect localhost | grep connected);
  if [[ ! $conn ]]; then
    read -p "Enter ADB Pairing Port: [skip pairing] " pairport;
    if [[ $pairport ]]; then adb pair localhost:$pairport; fi;
    read -p "Enter ADB Connect Port: [5555] " connport;
    if [[ ! $connport ]]; then connport=5555; fi;
    conn=$(adb connect localhost:$connport);
    echo $conn;
    if [[ ! $(echo $conn | grep connected) ]]; then exit; fi;
  fi;
fi;

adb shell cmd appops query-op --user 0 READ_CLIPBOARD allow;
echo "Select a package to disable READ_CLIPBOARD permission"
read -p "Enter package name: " pkgname;
if [[ $pkgname ]]; then adb shell cmd appops set $pkgname READ_CLIPBOARD ignore; fi;
