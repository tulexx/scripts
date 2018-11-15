#!/usr/bin/env bash

DIR=$1
OLD_PATTERN=$2
NEW_PATTERN=$3

if [ -z "$DIR" ] || [ -z "$OLD_PATTERN" ] || [ -z "$NEW_PATTERN" ]; then
  echo -e "Usage:\n";
  echo -e "./link_rename DIRECTORY OLD_PATTERN NEW_PATTERN\n";
  exit;
fi

while read -r line
do
  CUR_LINK_PATH="$(readlink "$line")"
  NEW_LINK_PATH="$CUR_LINK_PATH"
  NEW_LINK_PATH="${NEW_LINK_PATH/"$OLD_PATTERN"/"$NEW_PATTERN"}"
  echo "New link path:"
  echo "$NEW_LINK_PATH"
  if [[ -z "$RUN" ]]; then
    read -n 1 -p "Continue? [y|N]:" < /dev/tty char
    if [[ "$char" != 'y' ]]; then
      exit 1;
    fi
    RUN='y'
  fi

  rm "$line"
  ln -s "$NEW_LINK_PATH" "$line"
done <<< $(find "$DIR" -type l)

