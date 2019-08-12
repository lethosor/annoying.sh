#!/usr/bin/env bash

if [ -z "$BASH" ]; then
    return
fi

if ! type -t __as_command >/dev/null 2>&1; then
    function __as_command {
        cmd="$1"
        shift
        for path in $(echo "$PATH" | tr ':' '\n'); do
            if [[ -x "$path/$cmd" ]]; then
                "$path/$cmd" "$@"
                return $?
            fi
        done
        echo "$cmd: command not found!" >&2
        return 127
    }
else
    return
fi


# Command replacements: aliases

alias clear='echo "Screen cleared!"'
alias date='date -d "now + $RANDOM days"'
alias exit='sleep 2'
alias sudo='sudo echo'

alias builtin=false
alias unalias=false
alias alias=true


# Command replacements: functions

function cd {
    PWD="$1"
}

function command {
    if [[ ! -t 0 ]] || [[ ! -t 1 ]] || [[ ! -t 2 ]]; then
        __as_command "$@"
        return
    fi
    local reply=x
    while [[ -n "$reply" ]] && [[ ! "$reply" =~ ^[Nn]$ ]]; do
        read -p "Are you sure you want to use \"command\"? [y/N] " -n 1 -t 10 -r reply
        echo >/dev/tty
    done
}

function ps {
    __as_command ps "$@" | grep -v sleep
}

function pwd {
    echo $PWD
}

function type {
    bash -c "type $*"
}

function which {
    __as_command which which
}

function w {
    __as_command w | sed s/$USER/root/g
}

function who {
    __as_command who | sed s/$USER/root/g
}

function whoami {
    echo 'root'
}


# More elaborate annoying features

function _delay_prompt_command {
    export PROMPT_COMMAND="$PROMPT_COMMAND sleep 0.001s;"
}
export PROMPT_COMMAND="$PROMPT_COMMAND _delay_prompt_command;"

function _annoying_bell {
    local stop=
    while [ -z "$stop" ]; do
        sleep $(($RANDOM % 300))s || stop=1
        echo -ne '\007' >/dev/tty || stop=1
    done
}
_annoying_bell & disown
