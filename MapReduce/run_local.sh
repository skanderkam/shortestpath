#!/bin/sh

INPUT_FILE="$1"
START="$2"
END="$3"

init() {
  TMP_DIR="$(pwd)/MapReduce/tmp/"

  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"

  END_FILENAME="_end.txt"
  END_FILE="$TMP_DIR$END_FILENAME"
  echo "$END" > "$END_FILE"

  # Create tmp directory
  if [ ! -d "$TMP_DIR" ]
  then
    mkdir -p "$TMP_DIR"
  fi
}

launch_job() {
  TMP_FILENAME="output.txt"
  TMP_FILE="$TMP_DIR$TMP_FILENAME"

  TMP_DATA_FILENAME="data.txt"
  TMP_DATA_FILE="$TMP_DIR$TMP_DATA_FILENAME"

  cat "$INPUT_FILE" | ./MapReduce/0_Preprocessing/mapper.py | sort -k1,1 -s | ./MapReduce/0_Preprocessing/reducer.py > "$TMP_FILE"

  cat "$TMP_FILE" > "$TMP_DATA_FILE"

  while [ "$START" != "$END" ]; do
        cat "$TMP_DATA_FILE" | ./MapReduce/1_Iterative/mapper.py | sort -k1,1 -s | ./MapReduce/1_Iterative/reducer.py > "$TMP_FILE"
        cat "$TMP_FILE" > "$TMP_DATA_FILE"
        START=$(cat "$START_FILE")
  done

  while read -r -a line; do 
        if [ "${line[0]}" == "$END" ]; then
            echo "${line[*]}"
        fi
    done < "$TMP_DATA_FILE"
}

run_job() {
  if [ ! -f "$INPUT_FILE" ] 
  then
    echo "Input file not found"
    elif [ "$(cat "$INPUT_FILE" | ./MapReduce/0_Preprocessing/init.py)" == "0" ]
    then
        echo "Start node or end node unreachable"
    else
        launch_job
  fi
}

init
run_job