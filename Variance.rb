module Variance
	module_function
	
	def varia(a, m)
		a.map { |ai| (ai - m)**2 }.reduce(:+) / (N - 1)
	end
end