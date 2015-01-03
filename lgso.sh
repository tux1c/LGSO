#!/bin/bash
# Linux Game Saves Organizer - A script that organizes game saves.
# Copyright (C) 2014 Yan A.

# Current version
version=1.30

# Variables
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
readonly SRC_DIR="$XDG_DATA_HOME/games"


OUTPUT=0
BACKUP=0
RESTORE=0
DRYRUN=0


main() {
   check_update "$(curl -s https://raw.githubusercontent.com/Tux1c/Tux1c.github.io/master/projfiles/lgso/version.txt)"

   read_flags "$@"

   if [[ "$RESTORE" -eq 1 ]]; then
      restore
   fi

   # Checks if SRC_DIR exists, if not, creates it.
   if [ ! -d "$SRC_DIR" ]; then
      run mkdir -p "$SRC_DIR"
   fi

   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO is now organizing your save files..."
   fi

   local COUNTER=0
   local MOVED=0

   local OLD_DIR=""
   local NEW_DIR=""

   # Reads line by line from the online database.
   while read -r line; do
      # Increases counter - needed to determine if the vars are ready to work with.
      let ++COUNTER

      # Checks if line is a name of a game.
      if [[ "$line" =~ ^# ]]; then
         NEW_DIR="${SRC_DIR}/${line:2}"
      # Else, it will assume the line is a location of the game save.
      else
         OLD_DIR="${HOME}${line}"
      fi

      # Runs check if: variables are ready to work with && LGSO wasn't applied to specific directory. Then creates a new dir (if needed), moves the files and creates a new symlink.
      if (( COUNTER%2 == 0 )) && [[ -d "$OLD_DIR" && ! -L "$OLD_DIR" ]]; then
         move_save "$OLD_DIR" "$NEW_DIR" \
            && let ++MOVED
         [[ "$OUTPUT" -eq 1 ]] \
            && echo ""
      fi
   done < <(curl -s https://raw.githubusercontent.com/Tux1c/Tux1c.github.io/master/projfiles/lgso/lgsolist.txt)

   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO has moved $MOVED games".
   fi

   if [[ "$BACKUP" -eq 1 ]]; then
      backup
   fi
}

run() {
    if (( "$DRYRUN" == 0 )); then
        "$@"
    else
        echo "$@"
    fi
}

check_update() {
   [[ "$1" == "$version" ]] \
      && return

   if [[ "$(printf "${version}\n${1}"| sort -V)" == "$(printf "${version}\n${1}")" ]]; then
      echo "Your LGSO version is outdated!"
      echo "You are using LGSO $version while the most recent version is $1"
      echo "It is important for you to keep this script up to date!"
      echo "Please visit https://github.com/Tux1c/LGSO and update to the latest version!"
      exit 1
   fi
}

read_flags() {
   for i in $@; do
      case "$i" in
         -s|-silent) OUTPUT=-1;;
         -v|-verbose) OUTPUT=1;;
         -b|-backup) BACKUP=1;;
         -d|-dir) echo dir;;
         -D|-dry-run) DRYRUN=1;;
         -r|-restore) RESTORE=1;;
         *)
            echo "Unknown parameter $i, aborting."
            exit 1
            ;;
      esac
   done
}

move_save() {
   local -r OLD_DIR="$1"
   local -r NEW_DIR="$2"

   if [[ ! -d "$NEW_DIR" ]]; then
      if [[ "$OUTPUT" -eq 1 ]]; then
         echo "Source path: $OLD_DIR"
         echo "Destination path: $NEW_DIR"
      fi
   fi

   if [[ "$OUTPUT" -eq 1 ]]; then
      echo "Copying $OLD_DIR to $NEW_DIR"
   fi

   run rm -rf "$NEW_DIR/"
   run cp -a "$OLD_DIR/." "$NEW_DIR"

   if ! verify_cp "$NEW_DIR" "$OLD_DIR"; then
      echo "Failed to copy $OLD_DIR, cleaning up"
      run rm -fr "$NEW_DIR"
      return 1
   fi

   if [[ "$OUTPUT" -eq 1 ]]; then
      echo "Creating symlink in $OLD_DIR to $NEW_DIR"
   fi
   run rm -rf "$OLD_DIR"
   run ln -s "$NEW_DIR" "$OLD_DIR"

   return 0
}

verify_cp() {
   (( "$DRYRUN" == 1 )) \
      && return 0
   diff -qr "$1" "$2" > /dev/null 2>&1
   return $?
}

backup() {
   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO will now backup your save files"
   fi
   if [[ -f "$XDG_DATA_HOME/games_backup.tar.gz" ]]; then
      run rm "$XDG_DATA_HOME/games_backup_old.tar.gz" >/dev/null 2>&1
      run mv "$XDG_DATA_HOME/games_backup.tar.gz" "$XDG_DATA_HOME/games_backup_old.tar.gz"
   fi

   run tar czf "$XDG_DATA_HOME/games_backup.tar.gz" "$SRC_DIR" >/dev/null 2>&1
}

restore() {
   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "Restoring"
   fi

   exit 0
}

# Runs LGOS
main "$@"
