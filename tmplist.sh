#!/bin/bash

FOLDERSTATS="yes"

PATH=/bin:/usr/bin:/sbin:/usr/sbin
BASEDIR="/home/alejandro/testoutput"
LOG_SUFFIX=$(date +%Y%m%d-%H%M%S)
DATE=`date +%Y-%m-%d_%H:%M:%S`
DIR1="/home/alejandro/tmp"
STRING1="*ttest*"

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
# create the output log file for any 'item' and then call the function that creates the content
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

print_folderstats() {
  local LOGFILE="$1"
  print_blankline  "${LOGFILE}"
  echo "### CONTENT OF /home/alejandro/tmp ###" >> "${LOGFILE}"
  ls -alh /home/alejandro/tmp  >> "${LOGFILE}"
  print_blankline  "${LOGFILE}"
  find_tmp_folder "${LOGFILE}" "${DIR1}"
}

find_tmp_folder() {
  local LOGFILE="$1"
  targets=($(find $2 -name "${STRING1}"))
  
  echo "##############################################" >> "${LOGFILE}"
  echo "### NUMBER OF APACHE PRIVATE TMP FOLDERS IS ${#targets[@]}" >> "${LOGFILE}" 
  for FOLDER in ${targets[@]}; do
    echo "### ${FOLDER}" >> "${LOGFILE}" 
  done
  echo "##############################################" >> "${LOGFILE}"
  print_blankline  "${LOGFILE}"

  for FOLDER in ${targets[@]}; do
    print_blankline  "${LOGFILE}"
    echo "# STAT APACHE PRIVATE FOLDER:" >> "${LOGFILE}"
    stat ${FOLDER} >> ${LOGFILE}
    print_blankline  "${LOGFILE}"
    echo "# CONTENT OF ${FOLDER}" >> "${LOGFILE}"
    ls -alh ${FOLDER} >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    echo "# STAT PRIVATE-TMP SUB FOLDER:" >> "${LOGFILE}"
    stat ${FOLDER}/tmp >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    echo "# CONTENT OF ${FOLDER}/tmp" >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    ls -alh ${FOLDER}/tmp >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    echo "# NUMBER OF FILES IN ${FOLDER}/tmp" >> "${LOGFILE}"
    ls -l "${FOLDER}/tmp" | egrep -c '^-' >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    echo "# NEWEST FILE:" >> "${LOGFILE}"
    find "${FOLDER}/tmp" -maxdepth 1 -type f -printf '%T+ %p\n' | sort | tail -n 1 >> "${LOGFILE}"
    print_blankline  "${LOGFILE}"
    echo "##############################################" >> "${LOGFILE}"
  done
}


###############################
#---STARTING EXECUTION HERE---#
###############################

# run the folderstats report
if [[ "${FOLDERSTATS,,}" == "yes" ]]; then
  run_item_report "folderstats"
fi
