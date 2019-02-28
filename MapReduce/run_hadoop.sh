#!/bin/sh

START="$1"
END="$2"

init() {
  TMP_DIR="$(pwd)/MapReduce/tmp/"

  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"

  cat "$START_FILE"

}

launch_job() {
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/mapper_test.py \
  -mapper /home/hadoop/mapper_test.py \
  -file /home/hadoop/reducer.py \
  -reducer /home/hadoop/reducer.py
}

init