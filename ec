#!/bin/sh
/usr/bin/env emacsclient -c -a "" -F "((fullscreen . maximized ))" "$@"
