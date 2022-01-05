#!/bin/bash

if [[ ! -e $1 ]]; then
    echo "$1 is not an existing file or directory"
    exit 1
fi

scp -r "$1" nbaehler@helvetios.epfl.ch:/home/nbaehler/workspace/
