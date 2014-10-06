#!/bin/bash

SRC_DIR="/usr/share/games"
NEW_DIR=""
OLD_DIR=""
COUNTER=0

# Checks if SRC_DIR exists, if not, creates it.
if [ ! -d "$SRC_DIR" ]; then
   echo "LGSO will now ask you for your root password in order to create the needed files, it may ask for it again, depending on your SUDO settings."
   sudo mkdir $SRC_DIR
fi

# Analyzes games and organizes.
echo "LGSO will now start to organize."

# Reads line by line from gamelist.txt
while read line; do

# Increase counter - needed to determine if the vars are ready to work with.
let COUNTER=COUNTER+1

   # If line is a game name, it will define it.
   if [[ $line == *#* ]]; then
      NEW_DIR=$SRC_DIR
      NEW_DIR+="/"
      NEW_DIR+=${line:2}
   # Else, it will assume the line is a location of the game save.
   else
      OLD_DIR=$SRC_FOLDER
      OLD_DIR+=$HOME
      OLD_DIR+=$line
   fi

   # Checks if vars are ready to work with & if the save wasn't copied yet.
   if [ $((COUNTER%2)) -eq 0 ]; then
      if [ ! -d "$NEW_DIR" ]; then
         sudo mkdir $NEW_DIR
         sudo cp -r $OLD_DIR/. $NEW_DIR
         sudo rm -rf $OLD_DIR
         sudo ln -s $NEW_DIR $OLD_DIR
      fi
   fi
done < gamelist.txt
echo "LGSO is done :D"
