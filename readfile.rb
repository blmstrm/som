#!/home/kalle/.rvm/rubies/ruby-1.9.3-p125/bin/ruby -w

def readFile(inFile)
  file = File.new(inFile,"r")
  returnMatrix = Hash.new
  lines = 0
  y = 0
  while  (line = file.gets)
    if lines > 0
      returnMatrix[y] = line.split(',')
      y+=1
    end
    lines+=1
  end
  file.close
  return returnMatrix
end

def adjustMatrix(matrix)
  matrix.each{|key,array|
    case array[2]
    when "jan"
      array[2] = 1
    when "feb"
       array[2] = 2
    when "mar"
       array[2] = 3
    when "apr"
       array[2] = 4
    when "may"
       array[2] = 5
    when "jun"
       array[2] = 6 
    when "jul"
       array[2] = 7
    when "aug"
      array[2]  = 8
    when "sep"
       array[2] = 9
    when "oct"
       array[2] = 10
    when "nov"
       array[2] = 11
    when "dec"
       array[2] = 12
    end

    case array[3]
    when "mon"
       array[3] = 1
    when "tue"
       array[3] = 2
    when "wed"
       array[3]= 3
    when "thu"
       array[3]= 4
    when "fri"
      array[3] = 5
    when "sat"
      array[3] = 6
    when "sun"
      array[3] = 7
    end
  }
  return matrix
end
puts adjustMatrix(readFile("forestfires.csv"))[0][3]
