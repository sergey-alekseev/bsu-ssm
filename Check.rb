module Check
	module_function

	def check(a, mu, d, n)
	  m = exp_value(a, n)
	  ksi1 = m - mu
	  s2 = varia(a, m)
	  ksi2 = s2 - d
	  puts "ksi1: #{ksi1}, ksi2: #{ksi2}"
	  return ksi1, ksi2
	end
end