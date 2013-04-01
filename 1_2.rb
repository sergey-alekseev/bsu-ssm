# мультипликативного конгруэнтного метода (МКМ)
require './Variance.rb'
require './ExpectedValue.rb'
require './Constants.rb'
require './Check.rb'

include Variance
include ExpectedValue
include Constants
include Check

def multiple_cong_meth(a0, b = a0, n = N)
  a = [a0]
  (1..n).each { |i| a[i] = (b * a[i - 1]).modulo(M) }
  a[1..n].map { |a| a / M.to_f }
end

p a = multiple_cong_meth(7**6)
# p a = multiple_cong_meth(5 ** 7, 5 ** 5, N)

# Тест «совпадения моментов»
mu = 0.5
d = 1.0 / 12

m = exp_value(a, N)
ksi1 = m - mu
s2 = varia(a, m)
ksi2 = s2 - d
puts "ksi1: #{ksi1}, ksi2: #{ksi2}"

def c1(n = N)
  Math.sqrt(12 * n)
end

def c2(n = N)
  var = 0.0056 * n**-1 + 0.0028 * n**-2 - 0.0083 * n**-3
  ((n - 1).to_f / n) * var**-0.5
end

puts c1 * ksi1.abs < DELTA ? "H0: mu = 0.5" : "H1: mu != 0.5"
puts c2 * ksi2.abs < DELTA ? "H0: D = 1/12" : "H1: D != 1/12"

# Метод Макларена-Марсальи
D1, D2 = multiple_cong_meth(7**6, 7**6, N + K), multiple_cong_meth(5**11)
# K = 64
# D1, D2 = multiple_cong_meth(5 ** 7, 5 ** 5, N + K), multiple_cong_meth(2 ** 8 + 3, 2 ** 20 + 3, N)

def meth_makl_mars(b = D1, c = D2, k = K, n = N)
  a, v = [], []
  (0..k - 1).each { |i| v[i] = b[i] }
  (0..n - 1).each do |t|
    s = (c[t] * k).floor
    a[t] = v[s]
    v[s] = b[t + K]
  end
  a
end

p a = meth_makl_mars

# Тест «ковариация»
def r(j)
  j >= 1 ? 0 : 1.0 / 12
end

def r_(j, a, n = N)
  m = exp_value(a, N)
  sum = (0..n - j - 1).map { |i| a[i] * a[i + j] }.reduce(:+)
  (1.0 / (n - j - 1)) * sum - (n.to_f / (n - 1)) * m**2
end

def c(j)
  j >= 1 ? 1 : Math.sqrt(2)
end

(0..25).each do |j|
  v = (r_(j, a) - r(j)).abs < (c(j) * DELTA) / (12 * Math.sqrt(N - 1))
  puts v ? "H0" : "H1"
end