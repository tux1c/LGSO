#!/bin/bash
# Arranges game saves

# Current version
version=1.21

# Variables
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
readonly SRC_DIR="$XDG_DATA_HOME/games"
NEW_DIR=""
OLD_DIR=""


MOVED=0
OUTPUT=0
BACKUP=0
RESTORE=0


main() {
   curl -s https://raw.githubusercontent.com/Tux1c/Tux1c.github.io/master/projfiles/lgso/version.txt | while read line; do
      check_update "$line"
   done

   read_flags "$@"

   if [[ "$RESTORE" -eq 1 ]]; then
      restore
   fi

   # Checks if SRC_DIR exists, if not, creates it.
   if [ ! -d "$SRC_DIR" ]; then
      mkdir -p "$SRC_DIR"
   fi

   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO is now organizing your save files..."
   fi

   COUNTER=0

   # Reads line by line from the online database.
   curl -s https://raw.githubusercontent.com/Tux1c/Tux1c.github.io/master/projfiles/lgso/lgsolist.txt | while read line; do

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
      if (( COUNTER%2 == 0 )); then
         if [[ -d "$OLD_DIR" && ! -L "$OLD_DIR" ]]; then
            move_save
         fi
      fi
   done

   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO has moved $MOVED games".
   fi

   if [[ "$BACKUP" -eq 1 ]]; then
      backup
   fi
}

check_update() {
   if [[ $(echo "$version < $1"|bc) -eq 1 ]]; then
      echo "Your LGSO version is outdated!"
      echo "You are using LGSO $version while the most recent version is $line"
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
         -r|-restore) RESTORE=1;;
         *)
            echo "Unknown parameter $i, aborting."
            exit 1
            ;;
      esac
   done
}

move_save() {
   if [[ ! -d "$NEW_DIR" ]]; then
      if [[ "$OUTPUT" -eq 1 ]]; then
         echo "Source path: $OLD_DIR"
         echo "Destination path: $NEW_DIR"
      fi

      if [[ "$OUTPUT" -eq 1 ]]; then
         echo "Creating $NEW_DIR"
      fi

      mkdir "$NEW_DIR"
   fi

   if [[ "$OUTPUT" -eq 1 ]]; then
      echo "Moving $OLD_DIR to $NEW_DIR"
   fi

   rm -rf "$NEW_DIR/"
   cp -a "$OLD_DIR/." "$NEW_DIR"

   if verify_cp "$NEW_DIR" "$OLD_DIR"; then
      if [[ "$OUTPUT" -eq 1 ]]; then
         echo "Creating symlink in $OLD_DIR to $NEW_DIR"
      fi
      rm -rf "$OLD_DIR"
      ln -s "$NEW_DIR" "$OLD_DIR"
   else
      echo "Failed to move $OLD_DIR, cleaning up"
      rm -fr "$NEW_DIR"
   fi

   let ++MOVED
}

verify_cp() {
   diff -qr "$1" "$2" > /dev/null 2>&1
   return $?
}

backup() {
   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "LGSO will now backup your save files"
   fi
   if [ -f "$SRC_DIR/backup.tar.gz" ]; then
      rm "$SRC_DIR/backup_old.tar.gz" > /dev/null 2>&1
      mv "$SRC_DIR/backup.tar.gz" "$SRC_DIR/backup_old.tar.gz"
   fi

   tar czf "$SRC_DIR/backup.tar.gz" $SRC_DIR/* > /dev/null 2>&1
}

restore() {
   if [[ "$OUTPUT" -ne -1 ]]; then
      echo "Restoring"
   fi

   exit 0
}

# Runs LGOS
main "$@"
