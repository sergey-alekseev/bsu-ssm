module ExpectedValue
	module_function

	def exp_value(a, n)
		a.reduce(:+) / n
	end
end