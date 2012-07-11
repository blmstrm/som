#!/home/kalle/.rvm/rubies/ruby-1.9.3-p125/bin/ruby -w
#Read file to matrix, strip end of line
  def file2Mtx(inFile,separator)
    file = File.new(inFile,'r')
    returnMatrix = Hash.new
    lines = 0
    y = 0
    while  (line = file.gets)
      if lines > 0
        returnMatrix[y] = line.strip.split(separator)
        y+=1
      end
      lines+=1
    end
    file.close
    return returnMatrix
  end

#Adjust "mon" to 1 etc
  def adjustWeekDay(matrix,column)
    matrix.each{|key,array|
      case array[column]
      when "mon"
        array[column] = 1
      when "tue"
        array[column] = 2
      when "wed"
        array[column]= 3
      when "thu"
        array[column]= 4
      when "fri"
        array[column] = 5
      when "sat"
        array[column] = 6
      when "sun"
        array[column] = 7
      end
    }
    return matrix
  end

#Adjust "jan" to 1 etc
  def adjustMonth(matrix,column)
    
    matrix.each{|key,array|
      case array[column]
      when "jan"
        array[column] = 1
      when "feb"
        array[column] = 2
      when "mar"
        array[column] = 3
      when "apr"
        array[column] = 4
      when "may"
        array[column] = 5
      when "jun"
        array[column] = 6 
      when "jul"
        array[column] = 7
      when "aug"
        array[column]  = 8
      when "sep"
        array[column] = 9
      when "oct"
        array[column] = 10
      when "nov"
        array[column] = 11
      when "dec"
        puts "dec"
        array[column] = 12
      end
    }
    return matrix
  end

mtx = file2Mtx("forestfires.csv",',')
mtx = adjustMonth(mtx,2)
mtx = adjustWeekDay(mtx,3)
puts mtx
