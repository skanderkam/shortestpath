#!/bin/sh

# Giving names to the variables
INPUT_FILE="$1"
START="$2"
END="$3"

init() {
  # Defining a temporary directory to store files
  TMP_DIR="$(pwd)/MapReduce/Local/tmp/"

  # Start file settings
  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"

  # End file settings
  END_FILENAME="_end.txt"
  END_FILE="$TMP_DIR$END_FILENAME"
  echo "$END" > "$END_FILE"

  # Creating the temporary directory if it does not exist
  if [ ! -d "$TMP_DIR" ]
  then
    mkdir -p "$TMP_DIR"
  fi
}

launch_job() {
  # Defining the output file
  TMP_FILENAME="output.txt"
  TMP_FILE="$TMP_DIR$TMP_FILENAME"

  # Defining the data file
  TMP_DATA_FILENAME="data.txt"
  TMP_DATA_FILE="$TMP_DIR$TMP_DATA_FILENAME"

  # Running the preprocessing MapReduce
  cat "$INPUT_FILE" | ./MapReduce/Local/0_Preprocessing/mapper.py | sort -k1,1 -s | ./MapReduce/Local/0_Preprocessing/reducer.py > "$TMP_FILE"

  # Storing the output in the data file for the next MapReduce Job
  cat "$TMP_FILE" > "$TMP_DATA_FILE"

  # Iterating the MapReduce until stopping condition is reached
  while [ "$START" != "$END" ] && [ "$START" != "None" ]; do
        cat "$TMP_DATA_FILE" | ./MapReduce/Local/1_Iterative/mapper.py | sort -k1,1 -s | ./MapReduce/Local/1_Iterative/reducer.py > "$TMP_FILE"
        cat "$TMP_FILE" > "$TMP_DATA_FILE"
        START=$(cat "$START_FILE") # Updating the start variable
  done

  if [ "$START" == "None" ] # Case when no path has been found
  then
    echo 'No path could be find between your start and end nodes'
    else # Case where a path has been found
    while read -r -a line; do 
        if [ "${line[0]}" == "$END" ]; then
            echo "${line[*]}"
        fi
    done < "$TMP_DATA_FILE"
    fi
}

run_job() {
  if [ ! -f "$INPUT_FILE" ] 
  then
    echo "Input file not found"
    elif [ "$(cat "$INPUT_FILE" | ./MapReduce/Local/0_Preprocessing/init.py)" == "0" ]
    then
        echo "Start node or end node unreachable"
    else
        launch_job
  fi
}

init
run_job