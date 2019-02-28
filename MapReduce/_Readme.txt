## LOCAL EXECUTION

To run the MapReduce locally make sure you are in the shortestpath directory and run:

> MapReduce/run_local.sh <graph-data-path> <start-node> <end-node>

Example:
> MapReduce/run_local.sh data/simple_example.txt 1 4


## HADOOP EXECUTION

To run the MapReduce on Hadoop, run:

> MapReduce/run_hadoop.sh <hdfs-input-path> <hdfs-output-path> <local-preprocessing-mapper-path> <local-preprocessing-reducer-path> <local-mapper-path> <local-reducer-path> <start-node> <end-node>

Example:


