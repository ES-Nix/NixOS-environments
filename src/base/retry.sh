#!/usr/bin/env bash

# Adapted from
# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
#
# Example usage:
# retry 5 ls -ltr foo


set -x

retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in 0.5 seconds..."
            _=$(( attempt_num++ ))
            sleep 0.5
        fi
    done
}

retry "$@"
