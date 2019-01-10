#!/usr/bin/env bash
#
# vim: set ft=sh:
# Based on https://gist.github.com/briantjacobs/7753bf850ca5e39be409
# Based on https://gist.github.com/pkuczynski/8665367

function parse_yaml() {
  local prefix=$2
  local s
  local w
  local fs
  s='[[:space:]]*'
  w='[a-zA-Z0-9_]*'
  fs="$(echo @|tr @ '\034')"
  sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
  awk -F"$fs" '{
  indent = length($1)/2;
  vname[indent] = $2;
  for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
          vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
          printf("%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, $3);
      }
  }' | sed 's/_=/+=/g' | xargs echo
}
 
function yaml_to_bash_vars () {
  vars=$(parse_yaml $1)
  echo $vars
  sleep 1
  for var in $vars; do
    echo $var
  done
}

function main () {
  yaml_to_bash_vars $1
}

# from here is for bpkg
function yaml () {
  #main $@
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f yaml
else
  yaml ${@}
  exit $?
fi