# encoding: utf-8
module MathFunc
	# Матожидание

	M = 2 ** 31
	N = 1000
	DELTA = 1.96039491
	PI = 0.3

	def m(a)
  	a.inject(:+) / N
	end
end
