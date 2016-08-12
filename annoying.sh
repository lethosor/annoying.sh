#!/usr/bin/env bash

if [ -z "$__as_command" ]; then
    __as_command=$(command which command)
    if [ -z "$__as_command" ]; then
        return
    fi
fi


# Command replacements: aliases

alias cat='true'
alias clear='echo "Screen cleared!"'
alias date='date -d "now + $RANDOM days"'
alias sudo='sudo echo'


# Command replacements: functions

function cd {
    PWD="$1";
}

function command {
    local reply=
    while [[ ! $reply =~ ^[Nn]$ ]]; do
        read -p "Are you sure you want to use \"command\"? [y/N] " -n 1 -r reply
        echo >/dev/tty
    done
}

function exit {
    if [ -n "$SHELL" ]; then
        "$SHELL"
    fi
}

function ps {
    "$__as_command" ps "$@" | grep -v sleep
}

function pwd {
    echo $PWD;
}

function which {
    "$__as_command" which which;
}

function w {
    "$__as_command" w | sed s/$USER/root/;
}

function who {
    "$__as_command" who | sed s/$USER/root/;
}

function whoami {
    echo 'root';
}


# More elaborate annoying features

function delay_prompt_command {
    export PROMPT_COMMAND="$PROMPT_COMMAND sleep 0.001s;"
}
export PROMPT_COMMAND="$PROMPT_COMMAND delay_prompt_command;"

function annoying_bell {
    local stop=
    while [ -z "$stop" ]; do
        sleep $(($RANDOM % 300))s || stop=1
        echo -ne '\007' >/dev/tty || stop=1
    done
}
annoying_bell & disown
