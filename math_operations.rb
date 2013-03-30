module MathOperations

  def mean_value( a )
    a.reduce(:+) / a.size
  end
  
end
