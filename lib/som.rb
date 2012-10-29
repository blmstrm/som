require 'csv'
require_relative 'node'

class SOM
  attr_accessor :learningRate, :lrStart , :maxIterations, :xSize, :ySize, :nodeMap, :bmu, :distance2bmu, :radiusStart, :radius, :timeConstant
  def initialize(lrate,maxIt, x, y, weightCount)
    startX = 0
    startY = 0
    @lrStart = lrate
    @learningRate = @lrStart
    @maxIterations = maxIt
    @xSize = x
    @ySize = y
    @nodeMap = Array.new(x) { Array.new(y) {Node.new(weightCount,maxIt)}}

    @nodeMap.each{|row|
      row.each{|node|
        node.X = startX
        node.Y = startY
        startX = startX +1
      }
      startX=0
        startY = startY +1
    }
    @radiusStart = [x,y].max/2
    @radius = radiusStart
    @distance2bmu = -1
    @bmu = @nodeMap.first.first
    @timeConstant = maxIt / Math.log(@radiusStart)
  end

  def decreaseRadius(iteration)
    if @radius > 0 then
      @radius = @radiusStart * Math.exp(-(iteration/@timeConstant))
    end
  end

  def adjustWeights(inputVector,iteration)
    counter = 0
    @nodeMap.each{|row|
      row.each{|node|
        if Math.sqrt((node.X-@bmu.X)**2+(node.Y-@bmu.Y)**2) <  @radius
          [node.Weights,inputVector].transpose.each do | nodeWeight, inputWeight|
          bmuInfluence = Math.exp(-(getXYdistance(node.X,node.Y,@bmu.X,@bmu.Y)**2/(2*Math.sqrt(@radius))))
          nodeWeight = nodeWeight +(bmuInfluence*@learningRate*(inputWeight - nodeWeight))
          node.Weights[counter] = nodeWeight
          counter += 1
          end
          counter = 0
        end
      }
    }
  end

  def getXYdistance(aX,aY,bX,bY)
    return Math.sqrt((aX-bX)**2 + (aY-bY)**2)
  end

  def getDistance(vertexA,vertexB)
    distance = 0
    [vertexA, vertexB].transpose.each do | valueA, valueB|
    distance += (valueA - valueB)**2
    end
    return  distance = Math.sqrt(distance)
  end


  def decreaseLearningRate(iteration)
    @learningRate = @lrStart*Math.exp(-(iteration/@maxIterations))
  end

  def getBMU(inputVector)
    @distance2bmu = -1
    distance = 0
    @nodeMap.each{|row|
      row.each{|node|
        distance = getDistance(inputVector,node.Weights)
        if distance < @distance2bmu || @distance2bmu == -1
          @bmu = node
          @distance2bmu = distance

        end
        distance = 0
      }
    }
  end


  def populateUvalue()
    x = @nodeMap.count
    y = @nodeMap.first.count
    i = 0
    j = 0
    distance = 0

    while i < y do
      while j < x do
        #CurrentNode
        currentNode =  @nodeMap[i][j]
        #top row
        if i == 0 then
          bottomNode = @nodeMap[i+1][j]
          #top left corner
          if j == 0 then
            rightNode = @nodeMap[i][j+1]
            distance +=  getDistance(currentNode.Weights,bottomNode.Weights)
            distance += getDistance(currentNode.Weights,rightNode.Weights)
            currentNode.uValue = distance / 2
            #calculate distance

            #top right corner
          elsif j == x - 1 then
            leftNode = @nodeMap[i][j-1]
            distance += getDistance(currentNode.Weights,bottomNode.Weights)
            distance += getDistance(currentNode.Weights,leftNode.Weights)
            currentNode.uValue = distance / 2


            #everyother node on first row
          else
            rightNode = @nodeMap[i][j+1]
            leftNode = @nodeMap[i][j-1]
            distance += getDistance(currentNode.Weights,bottomNode.Weights)
            distance += getDistance(currentNode.Weights,leftNode.Weights)
            distance += getDistance(currentNode.Weights,rightNode.Weights)
            currentNode.uValue = distance / 3

            #calculate distance
          end

          #bottom row 
        elsif i == (y - 1) then
          topNode = @nodeMap[i-1][j]
          #bottom left corner
          if j == 0 then
            rightNode = @nodeMap[i][j+1]
            distance += getDistance(currentNode.Weights,topNode.Weights)
            distance += getDistance(currentNode.Weights,rightNode.Weights)

            currentNode.uValue = distance / 2
            #bottom rightcorner
          elsif j == x-1 then
            leftNode = @nodeMap[i][j-1]
            #every other node on the last row
            distance += getDistance(currentNode.Weights,topNode.Weights)
            distance += getDistance(currentNode.Weights,leftNode.Weights)
            currentNode.uValue = distance / 2
          else 
            rightNode = @nodeMap[i][j+1]
            leftNode = @nodeMap[i][j-1]

            distance += getDistance(currentNode.Weights,topNode.Weights)
            distance += getDistance(currentNode.Weights,leftNode.Weights)
            distance += getDistance(currentNode.Weights,rightNode.Weights)
            currentNode.uValue = distance / 3
          end
          #First column 
        elsif j == 0 then
          topNode =  @nodeMap[i-1][j]
          bottomNode =  @nodeMap[i+1][j]
          rightNode =  @nodeMap[i][j+1]

          distance += getDistance(currentNode.Weights,topNode.Weights)
          distance += getDistance(currentNode.Weights,bottomNode.Weights)
          distance += getDistance(currentNode.Weights,rightNode.Weights)
          currentNode.uValue = distance / 3

          #Last column
        elsif j == x -1 then
          topNode =  @nodeMap[i-1][j]
          bottomNode =  @nodeMap[i+1][j]
          leftNode =  @nodeMap[i][j-1]

          distance += getDistance(currentNode.Weights,topNode.Weights)
          distance += getDistance(currentNode.Weights,bottomNode.Weights)
          distance += getDistance(currentNode.Weights,leftNode.Weights)
          currentNode.uValue = distance / 3

          #All other nodes
        else
          topNode =  @nodeMap[i-1][j]
          bottomNode =  @nodeMap[i+1][j]
          leftNode =  @nodeMap[i][j-1]
          rightNode =  @nodeMap[i][j+1]

          distance += getDistance(currentNode.Weights,topNode.Weights)
          distance += getDistance(currentNode.Weights,bottomNode.Weights)
          distance += getDistance(currentNode.Weights,leftNode.Weights)
          distance += getDistance(currentNode.Weights,rightNode.Weights)
          currentNode.uValue = distance / 4
        end
        distance = 0
        j = j +1
      end
      j = 0
      i = i +1
    end
  end

  def train(dataSet)
    @maxIterations.times do |iterations|
      dataSet.shuffle!
      puts 'Iteration ' + (iterations+1).to_s
      dataSet.each{|vertex| 
        self.getBMU(vertex)
        self.adjustWeights(vertex,iterations+1)
      }
      self.decreaseLearningRate(iterations+1)
      self.decreaseRadius(iterations+1)
    end
      self.populateUvalue()
  end

  def export2cvs(filename)
    File.delete(filename)
    File.open(filename,"w"){|file|
      @nodeMap.each{|row|
        row.each{|node|
          file.puts((node.X).to_s+','+(node.Y).to_s+','+(node.uValue).to_s)
        }
        file.puts("\n")  
      }
    }
  end
end
