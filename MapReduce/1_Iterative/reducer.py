#!/usr/bin/python
import sys

# Example
start = '4'
end = '8'

# Initializing the variables we are going to loop on
current_node = None
current_dist = float('inf')
current_path = None
current_neighbors = []

# Initializing the variables we are going to loop on to find the new start point
min_dist = None
min_node = None

# Iterative Reduce
for line in sys.stdin:
    # Parse the input from the reducer
    line = line.strip('\n')
    key, value = line.split('\t')
    value_clean = value[1:-1].split('/')

    # Giving new names for more clarity
    node = key
    neighbors = value_clean[1]
    path = value_clean[2]

    # Transforming into float for infinity values and integers otherwise
    if value_clean[0] == 'inf':
        dist = float(value_clean[0])
    else:
        dist = int(value_clean[0])

    if node != start: # Removing the start line
        # Replacing if the node is similar
        if current_node == node:
            if dist < current_dist:
                current_dist = dist
                current_path = path
            if neighbors != ' ':
                current_neighbors = neighbors
        # Printing what we have so far if the key is different, and then moving to the next node if key is different
        else:
            if current_node:
                # Write result to STDOUT
                print '%s\t(%s/%s/%s)' % (current_node, current_dist, current_neighbors, current_path)
            # Moving to the next node
            current_node = node
            current_dist = dist
            current_path = path
            current_neighbors = neighbors

# We do not forget to print the last element not printed by the for loop
if current_node == node and current_node != start:
    print '%s\t(%s/%s/%s)' % (current_node, current_dist, neighbors, current_path)