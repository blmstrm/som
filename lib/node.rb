class Node
  attr_accessor :X, :Y, :Weights, :BMUradius, :radiusStart, :maxIterations, :uValue
  def initialize(nrOfWeights,maxIt)
    @maxIterations = maxIt
    @Weights = Array.new(nrOfWeights)
    @Weights.map!{|weight|rand()}
    @uValue = 0
  end

  def calculateRadius(iteration)
    @BMUradius = radiusStart*Math.exp(-iteration/(maxIterations/Math.log(radiusStart)))
  end
end
