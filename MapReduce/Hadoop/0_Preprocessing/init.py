#!/usr/bin/python
import sys

# Initializing the start variable
start_file = open('MapReduce/Local/tmp/_start.txt', 'r')
start = start_file.readline(1)

end_file = open('MapReduce/Local/tmp/_end.txt', 'r')
end = end_file.readline(1)

# Initialization of the variables
Is_start = False
Is_end = False

for line in sys.stdin:
    # Parse the input from the graph
    line = line.strip('\n')
    line = line.split('\t')

    if line[0] == start :
        Is_start = True
    
    if line[2] == end :
        Is_end = True

Is_correct = Is_end * Is_start
print(Is_correct)