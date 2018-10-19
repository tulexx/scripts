#!/usr/bin/env bash

git filter-branch --prune-empty --tree-filter '
git lfs track "*.sql" "WKP.swf"
git add .gitattributes
git ls-files | xargs -d "\n" git check-attr filter | grep "filter: lfs" | sed -r "s/(.*): filter: lfs/\1/" | xargs -d "\n" -r -n 50 bash -c "git rm -f --cached \"\$@\"; git add \"\$@\"" bash \
' --tag-name-filter cat -- --all
