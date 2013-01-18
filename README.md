som
===

Implementation of a self-organizing map.

Create a new map object with
`````ruby
tmpSom =  SOM.new(learningRate,maxIterations,xSize,ySize,weightCount)
`````

Train the map with
`````ruby
tmpSom.train(dataSet)
`````
where dataSet is a 2D-array of weightCount length vertices.
    
After training render a csv file with
`````ruby
tmpSom.export2cvs('filename')
`````
make filename out to be whatever you please.

TODO:
* Speed up training. Possibly through multi-threading.
* Enable hexagonal neighbourhoods while training.
* Enable hexagonal shaped maps.
* Add comments to code
