module GenerateArray
	module_function

	def my_array(n, distrib)
		(0...n).to_a.map { distrib }
	end
end