#!/bin/sh

launch_job() {
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/mapper_test.py \
  -mapper /home/hadoop/mapper_test.py \
  -file /home/hadoop/reducer.py \
  -reducer /home/hadoop/reducer.py
}

launch_job