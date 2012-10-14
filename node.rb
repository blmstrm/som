class Node
  attr_accessor :X, :Y, :Weights, :BMUradius, :radiusStart, :maxIterations
  def initialize(nrOfWeights,maxIt)
    @X = x
    @Y = y
    @maxIterations = maxIt
    @Weights = Array.new(nrOfWeight)
    @Weigths.map!{|x|rand()}
  end

  def calculateRadius(iteration)
    @BMUradius = radiusStart*Math.exp(-iteration/(maxIterations/Math.log(radiusStart)))
  end
end
