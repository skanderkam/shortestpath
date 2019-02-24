# To run the MapReduce on the graph example, please follow the steps:

1. Write the id of the node you want to start with in the '_start.txt' file

2. Write the id of the node for which you want to find the shortest path from start node in the '_end.txt' file

3. Execute the following command in your terminal when your working directory is set on shortestpath 

> cat data/graph.txt | MapReduce/0_Preprocessing/mapper.py | sort -k1,1 -s | MapReduce/0_Preprocessing/reducer.py | MapReduce/1_Iterative/mapper.py | sort -k1,1 -s | MapReduce/1.Iterative/reducer.py

4. Append the ' MapReduce/1_Iterative/mapper.py | sort -k1,1 -s | MapReduce/1.Iterative/reducer.py ' command as many times as you need to the command of step 3 until the start file contains the id you entered in the end file




# Please note (if not already done) that you first need to grant permission to all the files:

> chmod +x MapReduce/0_Preprocessing/reducer.py
> chmod +x MapReduce/0_Preprocessing/mapper.py
> chmod +x data/graph.txt
> chmod +x data/_start.txt
> chmod +x data/_end.txt