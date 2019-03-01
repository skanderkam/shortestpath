#!/bin/sh

START="$1"
END="$2"

init() {
  mkdir /home/hadoop/tmp

  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"

  mv "$START_FILE" /home/hadoop/tmp

  END_FILENAME="_end.txt"
  END_FILE="$TMP_DIR$END_FILENAME"
  echo "$END" > "$END_FILE"

  mv "$END_FILE" /home/hadoop/tmp

  ./home/hadoop/mapper_test.py
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