class Node
  attr_accessor :X, :Y, :Weights, :BMUradius, :radiusStart, :maxIterations
  def initialize(nrOfWeights,maxIt)
    @maxIterations = maxIt
    @Weights = Array.new(nrOfWeight)
    @Weigths.map!{|weight|rand()}
  end

  def calculateRadius(iteration)
    @BMUradius = radiusStart*Math.exp(-iteration/(maxIterations/Math.log(radiusStart)))
  end
end
