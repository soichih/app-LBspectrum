#!/bin/bash

if [ -f jobid ]; then
    qdel `cat jobid`
fi

if [ -f pid ]; then
    kill `cat pid`
fi
