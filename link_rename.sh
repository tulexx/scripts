#!/usr/bin/env bash

DIR=$1
OLD_PATTERN=$2
NEW_PATTERN=$3
RUN=$4

while read -r line
do
  # echo $line
  CUR_LINK_PATH="$(readlink "$line")"
  NEW_LINK_PATH="$CUR_LINK_PATH"
  NEW_LINK_PATH="${NEW_LINK_PATH/"$OLD_PATTERN"/"$NEW_PATTERN"}"
  echo "New link path:"
  echo "$NEW_LINK_PATH"
  if [[ -z "$RUN" ]]; then
    read -n 1 -p "Continue?:" < /dev/tty char
    if [[ "$char" != 'y' ]]; then
      exit 1;
    fi
    RUN='y'
  fi

  rm "$line"
  ln -s "$NEW_LINK_PATH" "$line"
done <<< $(find "$DIR" -type l)

