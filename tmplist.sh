#!/bin/bash

USEPS="yes"
OPTS_PS="auxfwww"

#OUTPUT_DIR="/home/alejandro/testoutput"
BASEDIR="/home/alejandro/testoutput"
LOG_SUFFIX=$(date +%Y%m%d-%H%M%S)

dir1="/home/alejandro/tmp"
dir2="/home/alejandro/tmp2"
string1="ttest"

# create output file
create_output_file() {
  local OUTPUT_FILE="$1"
  if [[ -d "${OUTPUT_FILE}" ]]; then
    echo "Target file already exists: ${OUTPUT_FILE}"
    exit
  else
    #print the data to the output file
    echo "${DATE}" > "${OUTPUT_FILE}"
  fi
}

# check to see if the output directory exists
check_output_file() {
  local OUTPUT_FILE="$1"
  if [[ ! -r "${OUTPUT_FILE}" ]]; then
    echo "The output file does not exist: ${OUTPUT_FILE}"
    exit
  fi
}

# print a blank line to the specified file
print_blankline() {
  local LOGFILE="$1"
  echo " " >> "${LOGFILE}"
}

# manage item report
run_item_report() {
  local item="$1"
  local ITEM_FILE="${BASEDIR}/${item}_${LOG_SUFFIX}.log"

  if [[ "${SNAPSHOT,,}" == "yes" ]]; then
    ITEM_FILE="${SNAPSHOTSDIR}/${item}.log_snapshot_${DATE}"
  fi

  create_output_file "${ITEM_FILE}"
  check_output_file "${ITEM_FILE}"
  eval "print_${item}" "${ITEM_FILE}"
}

# print output of "ps auxfww" to the specified file
print_ps() {
  local LOGFILE="$1"
  ps ${OPTS_PS} >> "${LOGFILE}"
}

#---starting execution here---
# run the ps report
if [[ "${USEPS,,}" == "yes" ]]; then
  run_item_report "ps"
fi


#if [ -d $dir1 ]

#[[ $(

#then
#  echo "exists"
#else
#  echo "nope"
#fi

