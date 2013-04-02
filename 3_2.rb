require './math.rb'
include Math

# encoding: utf-8
N = 1000

# Проверка
def check(a, mu, d)
  m = E(a)
  ksi1 = m - mu
  s2 = a.map { |ai| (ai - m) ** 2 }.reduce(:+).to_f / (a.size - 1)
  ksi2 = s2 - d
  "ksi1: #{ksi1}, ksi2: #{ksi2}"
end

# N(m, s2)
def standard_normal(n = 48)
  Math.sqrt(12.to_f/n) * ((1..n).map { rand }.reduce(:+) - n/2)
end

m = 1
s2 = 9

def standard(normal, m, s2)
  normal*Math.sqrt(s2) + m
end
a = (1..N).map { standard(standard_normal, m, s2) }
p "N(#{m}, #{s2}): #{a}"
puts "N(#{m}, #{s2}) check: #{check(a, m, s2)}"

# χ 2 (m)
def xi2(m)
  (1..m).map { standard_normal ** 2 }.reduce(:+)
end

m = 4
mu1 = m
d1 = 2*m

a = (1..N).map { xi2(m) }
p "Xi^2, m=#{m}: #{a}"
puts "Xi^2, m=#{m} check: #{check(a, mu1, d1)}"

# Стьюдента (t-распределение) t(m)
m = 6
mu2 = 0
d2 = m.to_f/(m-2)

def student(m)
  (standard_normal).to_f / Math.sqrt(xi2(m).to_f / m)
end

a = (1..N).map { student(m) }
p "Student, m=#{m}: #{a}"
puts "Student, m=#{m} check: #{check(a, mu2, d2)}"

# из смеси двух распределений
Pi = 0.3

a = (1..N).map { rand < 1 - Pi ? standard(standard_normal, mu1, d1) : standard(standard_normal, mu2, d2) }
p "mix: #{a}"
# puts "\nCмеси проверка: #{check(a, mu2, d2)}"
