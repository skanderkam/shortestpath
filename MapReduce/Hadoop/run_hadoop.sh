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
  # Preprocessing
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -file /home/hadoop/tmp/_start.txt \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/mapper.py \
  -mapper /home/hadoop/mapper.py \
  -file /home/hadoop/reducer.py \
  -reducer /home/hadoop/reducer.py

  hdfs dfs -rm -r /user/hadoop/wc/input/*
  hdfs dfs -mv /user/hadoop/wc/output/* /user/hadoop/wc/input
  hdfs dfs -rm -r /user/hadoop/wc/output

  #First MapReduce
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -file /home/hadoop/tmp/_start.txt \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/mapper_i.py \
  -mapper /home/hadoop/mapper_i.py \
  -file /home/hadoop/reducer_i.py \
  -reducer /home/hadoop/reducer_i.py \
  -D mapred.reduce.tasks=1
}

init
launch_job