#!/usr/bin/python
import sys

# Initializing the variable we are going to loop on
current_node = None
current_dist = None
current_path = None
neighbors = []

# input comes from STDIN
for line in sys.stdin:
    # Parse the input from mapper.py
    line = line.strip('\n')
    key, value = line.split('\t')
    value_clean = value[1:-1].split(',')

    # Giving new names for more clarity
    node = key
    neighbor = value_clean[1]
    dist = value_clean[0]
    path = value_clean[2]

    # Regrouping the neighbors for similar keys (since they are sorted by Hadoop but not grouped)

    # Append the neighbors if key is similar
    if current_node == node:
        neighbors.append(neighbor)
    # Printing what we have so far if the key is different, and then moving to the next node if key is different
    else:
        if current_node:
            # Write result to STDOUT
            print '%s\t(%s,%s,%s)' % (current_node, current_dist, neighbors, current_path)
        # Moving to the next node
        current_node = node
        current_dist = dist
        current_path = path
        neighbors = [neighbor]

# We do not forget to print the last element not printed by the for loop
if current_node == node:
    print '%s\t(%s,%s,%s)' % (current_node, current_dist, neighbors, current_path)
