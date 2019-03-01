#!/bin/sh

START="$1"
END="$2"

init() {
  mkdir /home/hadoop/tmp

  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"

  mv "$START_FILE" /home/hadoop/tmp
}

launch_job() {
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -file /home/hadoop/tmp/_start.txt \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/mapper.py \
  -mapper /home/hadoop/mapper.py \
  -file /home/hadoop/reducer.py \
  -reducer /home/hadoop/reducer.py  
}

init
launch_job