# encoding: utf-8
require './mat_op.rb'
include MatOp
require './initialize_const.rb'
include MathConst
require './check.rb'
include Check

# Бернулли
def bernulli(probability)
  rand() <  probability ? 1 : 0
end

probability = 0.7

psevdoRandom = (0...N).to_a.map { bernulli(probability) }
p "Бернулли: #{psevdoRandom}"

# Проверка
mean = probability
disp = probability * (1-probability)
realMath = MathExp(psevdoRandom)

check_p(psevdoRandom, mean, disp)

# Биномиальное
def binomial(realMath, probability)
  psevdoRandom = (0...realMath).to_a.map { rand() }
  funcX = psevdoRandom.map{ |ai| parametr(probability - ai) }.inject(:+)
end

def parametr(varible)
  varible <= 0 ? 0 : 1
end

realMath, probability = 5, 0.25
psevdoRandom = (0...N).to_a.map { binomial(realMath, probability) }
p "Биномиальное: #{psevdoRandom}"

# Проверка
mean = realMath * probability
disp = realMath * probability * (1-probability)
realMath = MathExp(psevdoRandom)

check_p(psevdoRandom, mean, disp)

# Однородная цепь Маркова
S = [ 0, 1, 2 ]
T = 1000
Pi = [ 0.33333, 0.33333, 0.33334 ]
P = [ [ 0.1, 0.2, 0.7 ], [ 0.3, 0.4, 0.3 ], [ 0.6, 0.2, 0.2 ] ]

def markov(probability)
  q = [ 0, probability[0], probability[0..1].inject(:+), probability[0..2].inject(:+) ]
  psevdoRandom = rand()
  (1..3).each { |i| return S[i-1] if (q[i-1]...q[i]).member?(psevdoRandom) }
end

def count(a)
  h = Hash.new
  a.uniq.each { |e| h[e] = a.count(e).to_f / a.count }
  h
end

p "Markov Pi: #{count( (0...T).to_a.map { markov(Pi) } )}"

a = [ markov(Pi) ]
(1...T).each { |i| a << markov(P[S.index(a[i-1])]) }
puts "Вывести средние доли нулей, единиц и двоек в n смоделированных последовательностях."
p count(a)
