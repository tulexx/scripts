#!/bin/bash
# Adjust the following variables as necessary
REMOTE=origin
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BATCH_SIZE=50

# check if the branch exists on the remote
if git show-ref --quiet --verify refs/remotes/$REMOTE/$BRANCH; then
  # if so, only push the commits that are not on the remote already
  range=$REMOTE/$BRANCH..HEAD
else
  # else push all the commits
  range=HEAD
fi
# range=f911b0259b69b1d..a83fd7c2d982c
# range=HEAD
# count the number of commits to push
n=$(git log --first-parent --format=format:x $range | wc -l)

# push each batch
for i in $(seq $n -$BATCH_SIZE 1); do
  # get the hash of the commit to push
  h=$(git log --first-parent --reverse --format=format:%H --skip $i -n1)

  echo -e "\033[0;33m====================================\033[0m"
  echo -e "Pushing $h...\n"

  git push -f $REMOTE $h:refs/heads/$BRANCH

  if [ ! $? -eq 0 ]
  then
    echo -e "\033[0;31mPush did not succeed\033[0m\n"
    exit 1
  fi
done
# push the final partial batch
git push -f $REMOTE HEAD:refs/heads/$BRANCH
