######################
##  INITIALIZATION  ##
######################

startNode, endNode = 0, 710

# Preparing the environment
from pyspark.sql.functions import monotonically_increasing_id
import timeit

# Loading and formatting the txt file
rawFile = sc.textFile("../data/road_sf.txt")
file = rawFile.map(lambda x: (x.split('\t')[0], x.split('\t')[2], [x.split('\t')[0],  x.split('\t')[2]], float(x.split('\t')[1]), 0))
columns = ["startPath", "endPath", "totalPath", "cumDistance", "ignore"]


# Creating and formatting a DataFrame
df = spark.createDataFrame(file, schema = columns)
df = df.withColumn("id", monotonically_increasing_id()) # adding the ID column
df = df.select(["id"] + columns) # arranging the order of the columns



######################
##       LOOP       ##
######################

# (1) Checking that the startNode and the endNode exist
if df.filter(df.startPath == startNode).count() == 0:
    print("The startNode is not valid.")
elif df.filter(df.endPath == endNode).count() == 0:
    print("The endNode is not valid.")
else:
    #
    # (2) Creating a temporary table (for SQL usage)
    df.createOrReplaceTempView("df")
    numberIterations = 0
    bestPathFound = False
    noRoadToEndNode = False
    start = timeit.default_timer()
    #
    while not bestPathFound and not noRoadToEndNode:
        current = timeit.default_timer()
        numberIterations = numberIterations + 1
        print("Iteration number ", numberIterations, " - Time elapsed:", round(current-start,0), "s")
        #
        # (3) Identifying the closest point "x" from the starting node
        #
        while True:
            closestNeighbor1 = spark.sql('SELECT id, startPath, endPath, totalPath, minCumDistance FROM df JOIN (SELECT min(CumDistance) as minCumDistance FROM df WHERE startPath = {} AND ignore = 0) dfMin ON df.cumDistance = dfMin.minCumDistance'.format(startNode)).collect()
            if len(closestNeighbor1) == 0:
                print("There is no path from node {} to node {}.".format(startNode, endNode))
                noRoadToEndNode = True
                break
        #
            elif closestNeighbor1[0]["endPath"] == str(endNode):
                print("Shortest path found!")
                bestPathFound = True
                break
        #
        # (4) Identifying the closest point from "x"
        #
            closestNeighbor2 = spark.sql('SELECT id, startPath, endPath, totalPath, minCumDistance FROM df JOIN (SELECT min(CumDistance) as minCumDistance FROM df WHERE startPath = {} AND ignore = 0) dfMin ON df.cumDistance = dfMin.minCumDistance'.format(closestNeighbor1[0]["endPath"])).collect()
        #
        # (5) Verifying that "x" has at least one neighbor
        #
            if len(closestNeighbor2) == 0: # if "x" doesn't have neighbor
                df = spark.sql('SELECT id, startPath, endPath, totalPath, CumDistance, CASE WHEN ignore = 1 THEN 1 WHEN id = {} THEN 1 ELSE 0 END AS ignore FROM df'.format(closestNeighbor1[0]['id']))
                df.createOrReplaceTempView("df")
            else:
                break # "x" has at least one neighbor -> we can continue
        #
        if bestPathFound or noRoadToEndNode:
            break
        #
        # (6) Merging the two paths & removing the rows used for the merge
        #
        newId = spark.sql('SELECT MAX(id) FROM df').collect()[0]["max(id)"] + 1
        totalPath1 = []
        for x in closestNeighbor1[0]['totalPath']:
            totalPath1.append(x)
        totalPath2 = []
        for x in closestNeighbor2[0]['totalPath']:
            totalPath2.append(x)
        newRow = spark.createDataFrame([(newId, 
                                         closestNeighbor1[0]['startPath'], 
                                         closestNeighbor2[0]['endPath'],
                                         totalPath1 + totalPath2[1:],
                                         float(closestNeighbor1[0]['minCumDistance']) + float(closestNeighbor2[0]['minCumDistance']),
                                         0)])
        #
        df = spark.sql("SELECT * FROM df WHERE id != {} AND id != {}".format(closestNeighbor1[0]['id'], closestNeighbor2[0]['id']))
        #
        df = df.union(newRow)
        df.createOrReplaceTempView("df")
    #
    if bestPathFound:
        spark.sql('SELECT * FROM df WHERE startPath = {} AND endPath = {}'.format(startNode, endNode)).show()