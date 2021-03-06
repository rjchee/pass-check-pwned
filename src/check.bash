#!/bin/bash

set -o pipefail

SCRIPT_VERSION="1.0.0"
CHECK_USAGE_STRING="Usage: $PROGRAM $COMMAND [--help,-h] [--version] [--line=line-number,-l line-number] [--short-output,-s] [--verbose,-v] pass-names"

check_usage () {
  echo "$CHECK_USAGE_STRING"
}

check_version () {
  echo "pass-check v$SCRIPT_VERSION"
}

cmd_check () {
  local short_output=false selected_line=1 verbose=false
  opts="$($GETOPT -o hl:sv -l help,version,line:,short-output,verbose -n pass-check -- "$@")"
  [[ $? -eq 0 ]] || die "$CHECK_USAGE_STRING"
  eval set -- "${opts[@]}"
  while true; do case $1 in
    -h|--help) check_usage; return 0 ;;
    --version) check_version; return 0 ;;
    -l|--line) selected_line="$2"; shift 2 ;;
    -s|--short-output) short_output=true; shift ;;
    -v|--verbose) verbose=true; shift ;;
    --) shift; break ;;
  esac done
  [[ $selected_line =~ ^[0-9]+$ ]] || die "Line $selected_line is not a number."
  local targets="$@"
  if [ "$#" -eq 0 ]; then
    # no arguments means check every password
    targets=$(find "$PREFIX/" -name "*.gpg" | sed -e "s|^$PREFIX/||" | sed -e "s|.gpg$||")
  fi

  local all_clear=1
  for path in $targets; do
    if $verbose; then
      echo "Checking $path..." >&2
    fi
    local pass sha_hash response
    pass=$(cmd_show $path | tail -n +${selected_line} | head -n 1)
    sha_hash=$(echo -n $pass | sha1sum | cut -d' ' -f1 | sed "s/.*/\U&/")
    response=$(curl -s -H "User-Agent: Pass-Password-Store-Checker/$SCRIPT_VERSION" "https://api.pwnedpasswords.com/range/${sha_hash:0:5}" | grep --color=never ${sha_hash:5})
    if [ $? -eq 0 ]; then
      local count=$(echo "$response" | cut -d':' -f2 | sed 's/.$//')
      if $verbose; then
        echo >&2
      fi
      if $short_output; then
        echo "$path:$count"
      else
        echo "$path has been pwned $count time(s)."
      fi
      if $verbose; then
        echo >&2
      fi
      all_clear=0
    fi
  done

  if ! $short_output && [[ $all_clear -eq 1 ]]; then
    echo "No pwned passwords found."
  fi
}

cmd_check "$@"
