# encoding: utf-8
require './mat_op.rb'
include MatOp
require './initialize_const.rb'
include MathConst
require './check.rb'
include Check

# N(m, s2)
def standard_normal(n = 48)
  Math.sqrt(12.to_f/n) * ((1..n)
  	.map { rand }
  	.reduce(:+) - n/2)
end

mean, disp = 1, 9

def standard(normal, mean, disp)
  normal*Math.sqrt(disp) + mean
end
psevdoRandom = (1..N).map { standard(standard_normal, mean, disp) }

p "N(#{mean}, #{disp}): #{psevdoRandom}"
puts "N(#{mean}, #{disp}) проверка: #{check_p(psevdoRandom, mean, disp)}"

# χ 2 (m)
def xi2(m)
  (1..m).map { standard_normal ** 2 }.reduce(:+)
end

m = 4
mean1 = m
disp1 = 2*m

psevdoRandom = (1..N).map { xi2(m) }
puts "Xi^2, m=#{m}: #{psevdoRandom}"
puts "Xi^2, m=#{m} проверка: #{check_p(psevdoRandom, mean1, disp1)}"

# Стьюдента (t-распределение) t(m)
m, mean2 = 6, 0
disp2 = m.to_f/(m-2)

def student(m)
  (standard_normal).to_f / Math.sqrt(xi2(m).to_f / m)
end

psevdoRandom= (1..N).map { student(m) }
p "Стьюдента, m=#{m}: #{psevdoRandom}"
puts "Стьюдента, m=#{m} проверка: #{check_p(psevdoRandom, mean2, disp2)}"

# из смеси двух распределений
Pi = 0.3

psevdoRandom= (1..N).map { rand < 1 - Pi ? standard(standard_normal, mean1, disp1) : standard(standard_normal, mean2, disp2) }
puts "Cмеси: #{psevdoRandom}"
# puts "\nCмеси проверка: #{check(a, mu2, d2)}"
