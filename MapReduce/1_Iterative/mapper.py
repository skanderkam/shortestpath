#!/usr/bin/python
import sys

# Initializing the start variable
start_file = open('MapReduce/tmp/_start.txt', 'r')
start = start_file.readline(1)
start_file.close()

# Iterative Map
for line in sys.stdin:
    # Parse the input from the reducer
    line = line.strip('\n')
    key, value = line.split('\t')
    value_clean = value[1:-1].split('/') # Clean the parentheses
    
    # Assigning new names for more clarity
    node = key
    neighbors = value_clean[1]
    if neighbors != ' ' :
        neighbors = value_clean[1][1:-1].split(', ')
            
    path = value_clean[2]

    # Print the line in all cases
    print(line)

    # If the node is the start then print the line and print a new line for each of its neighbors
    if node == start and neighbors != ' ':

        # Transforming the distance into an integer for the purpose of computation
        dist = int(value_clean[0])
        
        for neighbor in neighbors:

            neighbor = neighbor[2:-2].split(';')
            
            # Assigning new names for more clarity
            neighbor_node = neighbor[0]
            neighbor_path = path + ' ' + node # Path becomes the initial path followed by the new neighbor visited
            neighbor_neighbors = ' ' # Will be completed by the reduce part
            neighbor_dist = int(neighbor[1]) + dist # Transforming into integers for the purpose of computation

            print '%s\t(%s/%s/%s)' % (neighbor_node, neighbor_dist, neighbor_neighbors, neighbor_path)