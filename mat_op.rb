module MatOp
  def MathExp(a, n=1000)
    a.reduce(:+).to_f / n
  end
end

