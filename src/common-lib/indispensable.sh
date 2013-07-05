#! /usr/bin/env bash

# by torstein.k.johansen@gmail.com

# You may override this log file in your script, otherwise, you'll get
# a log file called .<myscript>.log in your home directory.
log_file=$HOME/.$(basename $0).log

function run() {
  if [[ -n "$log_file" ]]; then
    "$@" 1>> $log_file 2>> $log_file
  else
    "$@"
  fi

  if [ $? -gt 0 ]; then
    print "The command <$@> failed :-("
    exit 1
  fi
}

function print() {
  echo "[$(basename $0)]" "$@"
}

function print_and_log() {
  print "$@"
  if [[ -n "$log_file" || -w $(dirname $log_file) ]]; then
    echo "$@" >> $log_file
  fi
}

function make_dir() {
  for el in "$@"; do
    if [ ! -d "$el" ]; then
      run mkdir -p "$el"
    fi
  done
}

function get_human_time() {
  local seconds_worked=$1

  local days=$(( seconds_worked / ( 60 * 60 * 24 ) ))
  local seconds_left=$(( seconds_worked - ( $days * 60 * 60 * 24 ) ))
  local hours=$(( seconds_left / ( 60 * 60 ) ))
  local seconds_left=$(( seconds_left - ( $hours * 60 * 60 ) ))
  local minutes=$(( seconds_left / 60 ))
  local seconds_left=$(( seconds_left - $minutes * 60 ))

  echo "${hours}h ${minutes}m ${seconds_left}s"
}

