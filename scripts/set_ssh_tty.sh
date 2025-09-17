#!/bin/bash
# set_ssh_tty.sh — Append SSH_TTY=True to ~/.bashrc (deduplicated)

TARGET_FILE="$HOME/.bashrc"
LINE='export SSH_TTY=True'

# Create the file if it does not exist
touch "$TARGET_FILE"

# Exit if the line already exists
grep -qxF "$LINE" "$TARGET_FILE" && {
  echo "Already exists, no need to append."
  exit 0
}

# Append and notify
echo "$LINE" >> "$TARGET_FILE"
echo "Appended to the end of $TARGET_FILE."

# Reload ~/.bashrc to apply changes immediately
source "$TARGET_FILE"
echo "Reloaded $TARGET_FILE."
