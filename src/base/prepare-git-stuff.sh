#!/usr/bin/env bash


# It is hardcoded, but is it that bad?
cd /mnt/etc/nixos || echo 'The cd /mnt/etc/nixos failed!'

echo 'result' > .gitignore

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git init
git add .
git commit -m 'First commit'