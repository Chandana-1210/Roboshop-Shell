#!/bin/bash
echo "it allows all arguments passed as a single string : $*"
echo "it allows all arguments passed as a seperate words : $@"
echo "current directory: $PWD"
echo "who is running this: $USER"
echo "home directory: $HOME"
echo "script_name: $0"
echo "Process id : $$"
sleep 10&
echo "Process id of last script:$!"
echo "exit status of script:$?"
echo "it shows arguments passed count:$#"