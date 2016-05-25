#!/bin/sh
#

doIt() {
    rsync --exclude ".git/" --exclude ".DS_Store" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" --exclude "LICENSE-MIT.txt" \
        --exclude ".ssh" --exclude ".aws" \
        -avh --no-perms . ~;
}

if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
    doIt;
else
    echo "This may overwrite existing files in your home directory. Are you sure? (y/n)";
    read -r _reply;
    if echo "$_reply" | grep -q "^[Yy]$"; then
        doIt;
    fi;
fi;
unset doIt;
