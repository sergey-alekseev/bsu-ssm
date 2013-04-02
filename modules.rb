# encoding: utf-8

module MathFunc
	
	# Константы
	M = 2 ** 31
	N = 1000
	DELTA = 1.96039491
	PI = 0.3

	# Матожидание
	def m(a)
  	a.inject(:+) / N
	end

	# Проверка
	def check(a, mu, d)
  m = m(a)
  ksi1 = m - mu
  s2 = a.map { |ai| (ai - m) ** 2 }.reduce(:+).to_f / (a.size - 1)
  ksi2 = s2 - d
  "ksi1: #{ksi1}, ksi2: #{ksi2}"
	end

end
