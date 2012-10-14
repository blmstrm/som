require_relative 'node'
class SOM
  attr_accessor :learningRate, :lrStart , :maxIterations, :xSize, :ySize, :nodeMap, :bmu, :distance2bmu
  def initialize(lrate,maxIt, x, y, weightCount)
    @lrStart = lrate
    @maxIterations = maxIt
    @xSize = x
    @ySize = y
    @nodeMap = Array.new(x) { Array.new(y) {Node.new(weightCount,maxIt)}}
    @nodeMap.radiusStart = [x,y].max/2
    @distance2bmu = -1
  end

  def adjustWeights(node,inputVector)
    [@node.Weights,@inputVector].transpose.each do | nodeWeight, inputWeight|
    nodeWeight = nodeWeight +(@learningRate*(inputWeight - nodeWeight))
    end
  end

  def decreaseLearningRate(iteration)
    @learningRate =  @lrStart * Math.exp(-iteration/@maxIterations)
  end

  def getBMU(inputVector)
    distance = 0
    nodeMap.each{|node|
      [inputVector, node.Weights].transpose.each do | nodeWeight, inputWeight|
      distance += (inputWeight - nodeWeight)^2
      end
      distance = Math.sqrt(distance)

      if distance < distance2bmu || distance2bmu == -1
        bmu = node
        distance2bmu = distance
      end
    }
  end
end
