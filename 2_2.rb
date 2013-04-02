require './math.rb'
include Math

# encoding: utf-8
N = 1000

# Бернулли
def bernulli(p)
  rand() < p ? 1 : 0
end

p = 0.7
a = (0...N).to_a.map { bernulli(p) }
p "Bernoulli: #{a}"

# Проверка
mu = p
d = p * (1-p)
m = E(a)
ksi1 = m - mu
s2 = a.map { |ai| (ai - m) ** 2 }.inject(:+) / (N - 1)
ksi2 = s2 - d

puts "ksi1: #{ksi1}, ksi2: #{ksi2}"

# Биномиальное
def binomial(m, p)
  a = (0...m).to_a.map { rand() }
  x = a.map{ |ai| l(p - ai) }.inject(:+)
end

def l(z)
  z <= 0 ? 0 : 1
end

m, p = 5, 0.25
a = (0...N).to_a.map { binomial(m, p) }
p "Binomial: #{a}"

# Проверка
mu = m * p
d = m * p * (1-p)
m = E(a)
ksi1 = m - mu
s2 = a.map { |ai| (ai - m) ** 2 }.inject(:+) / (N - 1)
ksi2 = s2 - d

puts "ksi1: #{ksi1}, ksi2: #{ksi2}"

# Однородная цепь Маркова
S = [ 0, 1, 2 ]
T = 1000
Pi = [ 0.33333, 0.33333, 0.33334 ]
P = [ [ 0.1, 0.2, 0.7 ], [ 0.3, 0.4, 0.3 ], [ 0.6, 0.2, 0.2 ] ]

def markov(p)
  q = [ 0, p[0], p[0..1].inject(:+), p[0..2].inject(:+) ]
  a = rand()
  (1..3).each { |i| return S[i-1] if (q[i-1]...q[i]).member?(a) }
end

def count(a)
  h = Hash.new
  a.uniq.each { |e| h[e] = a.count(e).to_f / a.count }
  h
end

p "Markov Pi: #{count( (0...T).to_a.map { markov(Pi) } )}"

a = [ markov(Pi) ]
(1...T).each { |i| a << markov(P[S.index(a[i-1])]) }
#puts "Вывести средние доли нулей, единиц и двоек в n смоделированных последовательностях."
p count(a)
