require './mat_op.rb'
include MatOp
require './initialize_const.rb'
include MathConst
# мультипликативного конгруэнтного метода (МКМ)

def MKM(startValue, factor = startValue, n = N)
   psevdoRandom = [startValue]
   (1..n).each { |i| psevdoRandom[i] = (factor * psevdoRandom[i-1]).modulo(MODULE ) }
   psevdoRandom[0..n].map {|psevdoRandom| psevdoRandom / MODULE .to_f }
end

p psevdoRandom = MKM(7**6)
# p a = mkm(5 ** 7, 5 ** 5, N)

# Тест «совпадения моментов»

mean = 0.5
disp = 1.0 / 12

realMath = MathExp(psevdoRandom)
deviationMath = realMath - mean
realDisp = psevdoRandom.map { |ai| (ai - realMath) ** 2 }.reduce(:+) / (N - 1)
deviationDisp = realDisp - disp

puts "deviationMath: #{deviationMath}, deviationDisp: #{deviationDisp}"

def normFactor1(n = N)
  Math.sqrt(12 * n)
end

def normFactor2(n = N)
  ((n - 1).to_f / n) * (0.0056 * n ** -1 + 0.0028 * n ** -2 - 0.0083 * n ** -3) ** -0.5
end

puts normFactor1 * deviationMath.abs < DELTA ? "H0: mean = 0.5" : "H1: mean != 0.5"
puts normFactor2 * deviationDisp.abs < DELTA ? "H0: disp = 1/12" : "H1: disp != 1/12"

# Метод Макларена-Марсальи
K = 32
D1, D2 = MKM(7 ** 6, 7 ** 6, N + K), MKM(5 ** 11)
# K = 64
# D1, D2 = mkm(5 ** 7, 5 ** 5, N + K), mkm(2 ** 8 + 3, 2 ** 20 + 3, N)

def mmm(psevdoRandom1 = D1, psevdoRandom2 = D2, k = K, n = N)
  a, table= [], []
  (0..k - 1).each { |i| table[i] = psevdoRandom1[i] }
  (0..n - 1).each do |t|
    randomChoice = (psevdoRandom2[t] * k).floor
    a[t] = table[randomChoice]
    table[randomChoice] = psevdoRandom1[t + K]
  end
  a
end

p a = mmm

# Тест «ковариация»
def cov(varible)
  varible >= 1 ? 0 : 1.0 / 12
end

def markCov(varible, a, n = N)
  m = MathExp(a)
  ( 1.0 / (n - varible - 1)) * (0..n - varible - 1)
      .map { |i| a[i] * a[i+varible] }
      .reduce(:+) - (n.to_f / (n - 1)) * m ** 2
end

def parametr(varible)
  varible >= 1 ? 1 : Math.sqrt(2)
end

(0..25).each do |varible|
  puts (markCov(varible, a) - cov(varible))
  .abs < (parametr(varible) * DELTA) / (12 * Math.sqrt(N-1)) ? "H0" : "H1"
end
