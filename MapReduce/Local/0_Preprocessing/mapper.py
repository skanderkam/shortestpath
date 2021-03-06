#!/usr/bin/python
import sys

# Initializing the start variable
start_file = open('MapReduce/Local/tmp/_start.txt', 'r')
start = start_file.readline(1)

# Initialization Map
for line in sys.stdin:
    # Parse the input from the graph
    line = line.strip('\n')
    line = line.split('\t')
    
    # Distance = infinity by default
    dist = float('inf')

    # Distance = 0 if the node is the start
    if line[0] == start:
        dist = 0
    print '%s\t(%s,(%s;%s),%s)' % (line[0], dist, line[2], line[1], " ")