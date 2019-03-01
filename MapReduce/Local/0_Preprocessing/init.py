#!/usr/bin/python
import sys

# Initializing the start variable
start_file = open('MapReduce/Local/tmp/_start.txt', 'r')
start = start_file.readline(1)

# Initializing the end variable
end_file = open('MapReduce/Local/tmp/_end.txt', 'r')
end = end_file.readline(1)

# Initialization of the output variables
Is_start = False
Is_end = False

for line in sys.stdin:
    # Parse the input from the graph
    line = line.strip('\n')
    line = line.split('\t')

    if line[0] == start : # Is_start becomes true if the column of origin nodes contain the input start node
        Is_start = True
    
    if line[2] == end : # Is_end becomes true if the column of destination nodes contain the input end node
        Is_end = True

# Multiplying the two conditions
Is_correct = Is_end * Is_start

# 0 means input incorrect and 1 means input correct
print(Is_correct)