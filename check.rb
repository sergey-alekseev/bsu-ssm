require './mat_op.rb'
include MatOp
module Check
	def check_p(psevdoRandom, mean, disp)
	  realMath = MathExp(psevdoRandom)
	  deviationMath = realMath - mean
	  realDisp = psevdoRandom.map { |ai| (ai - realMath) ** 2 }.reduce(:+) / (N - 1)
	  deviationDisp = realDisp - disp
	  puts "deviationMath: #{deviationMath}, deviationDisp: #{deviationDisp}"
	end
end


