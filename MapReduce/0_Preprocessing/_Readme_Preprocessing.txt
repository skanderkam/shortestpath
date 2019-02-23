# To run the preprocessing on the graph example (with start node = 4), please execute the following command in your terminal when your working directory is set on shortestpath 

> cat data/graph.txt | MapReduce/0_Preprocessing/mapper.py | sort -k1,1 -s | MapReduce/0_Preprocessing/reducer.py



# Please note that you first need to grant permission to all the files:

> chmod +x MapReduce/0_Preprocessing/reducer.py
> chmod +x MapReduce/0_Preprocessing/mapper.py
> chmod +x data/graph.txt