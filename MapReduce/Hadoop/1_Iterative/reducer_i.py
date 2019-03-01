#!/usr/bin/python
import sys

# Initializing the start variable
start_file = open('_start.txt', 'r')
start = start_file.readline(1)
start_file.close()

# Initializing the variables we are going to loop on
current_node = None
current_dist = float('inf')
current_path = None
current_neighbors = []

# Initializing the variables we are going to loop on to find the new start point
min_dist = float('inf')
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
                
                # Replacing the overall minimum if distance is inferior
                if current_dist < min_dist:
                    min_dist = current_dist
                    min_node = current_node
                    
            # Moving to the next node
            current_node = node
            current_dist = dist
            current_path = path
            current_neighbors = neighbors

# We do not forget to print the last element not printed by the for loop
if current_node == node and current_node != start:
    print '%s\t(%s/%s/%s)' % (current_node, current_dist, neighbors, current_path)

# We do not forget to find the new minimum one last time (not computed by the for loop)
if current_dist < min_dist:
    min_dist = current_dist
    min_node = current_node

# Writing the new start node
# start = min_node
# if start is None:
#     start = "None"
# start_file = open('_start.txt', 'w')
# start_file.write(start)
# start_file.close()