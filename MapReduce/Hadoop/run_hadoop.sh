# Giving names to the variables
INPUT_FILE="$1"
START="$2"
END="$3"

init() {
  # Creating a temporary directory to store files
  mkdir /home/hadoop/tmp

  # Start file settings
  START_FILENAME="_start.txt"
  START_FILE="$TMP_DIR$START_FILENAME"
  echo "$START" > "$START_FILE"
  mv "$START_FILE" /home/hadoop/tmp

  # End file settings
  END_FILENAME="_end.txt"
  END_FILE="$TMP_DIR$END_FILENAME"
  echo "$END" > "$END_FILE"
  mv "$END_FILE" /home/hadoop/tmp
}

launch_job() {
   # Running the preprocessing MapReduce
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -file /home/hadoop/tmp/_start.txt \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/shortestpath/MapReduce/Hadoop/0_Preprocessing/mapper.py \
  -mapper /home/hadoop/shortestpath/MapReduce/Hadoop/0_Preprocessing/mapper.py \
  -file /home/hadoop/shortestpath/MapReduce/Hadoop/0_Preprocessing/reducer.py \
  -reducer /home/hadoop/shortestpath/MapReduce/Hadoop/0_Preprocessing/reducer.py
  
  # Storing the output in the data file for the next MapReduce Job
  hdfs dfs -rm -r /user/hadoop/wc/input/* # Removing what is in the input directory
  hdfs dfs -mv /user/hadoop/wc/output/* /user/hadoop/wc/input
  hdfs dfs -rm -r /user/hadoop/wc/output

  # Iterating the MapReduce until stopping condition is reached
  while [ "$START" != "$END" ] && [ "$START" != "None" ]; do
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -file /home/hadoop/tmp/_start.txt \
  -input /user/hadoop/wc/input \
  -output /user/hadoop/wc/output \
  -file /home/hadoop/shortestpath/MapReduce/Hadoop/1_Iterative/mapper.py \
  -mapper /home/hadoop/shortestpath/MapReduce/Hadoop/1_Iterative/mapper.py \
  -file /home/hadoop/shortestpath/MapReduce/Hadoop/1_Iterative/reducer.py \
  -reducer /home/hadoop/shortestpath/MapReduce/Hadoop/1_Iterative/reducer.py \

  # Storing the output in the data file for the next MapReduce Job
  hdfs dfs -rm -r /user/hadoop/wc/input/* # Removing what is in the input directory
  hdfs dfs -mv /user/hadoop/wc/output/* /user/hadoop/wc/input
  hdfs dfs -rm -r /user/hadoop/wc/output
  done

  if [ "$START" == "None" ] # Case when no path has been found
  then
    echo 'No path could be find between your start and end nodes'
    else # Case where a path has been found
    while read -r -a line; do 
        if [ "${line[0]}" == "$END" ]; then
            echo "${line[*]}"
        fi
    done < /user/hadoop/wc/output/*
    fi
}

run_job() {
  if [ ! -f /user/hadoop/wc/input/* ] 
  then
    echo "Input file not found"
    elif [ "$(cat /user/hadoop/wc/input/* | ./MapReduce/Hadoop/0_Preprocessing/init.py)" == "0" ]
    then
        echo "Start node or end node unreachable"
    else
        launch_job
  fi
}

init
run_job