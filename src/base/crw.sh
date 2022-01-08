#!/usr/bin/env bash

BIN_NAME=$1
cat "$(readlink -f "$(which "${BIN_NAME}")")"