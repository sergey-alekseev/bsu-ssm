# encoding: utf-8
require 'modules.rb'
include MathFunc

def mkm(a0, b = a0, n = N)
  a = [a0]
  (1..n).each { |i| a[i] = (b * a[i - 1]).modulo(M) }
  a[1..n].map { |a| a / M.to_f }
end

p a = mkm(7 ** 6)

# Тест «совпадения моментов»
  mu = 0.5
  D = 1.0 / 12
  m = m(a)
  ksi1 = m - mu
  s2 = a.map { |ai| (ai - m) ** 2 }.inject(:+) / (N - 1)
  ksi2 = s2 - D

puts check(a, mu, D)

def c1(n = N)
  Math.sqrt(12 * n)
end
def c2(n = N)
  ((n - 1).to_f / n) * (0.0056 * n ** -1 + 0.0028 * n ** -2 - 0.0083 * n ** -3) ** -0.5
end

puts c1 * ksi1.abs < DELTA ? "H0: mu = 0.5" : "H1: mu != 0.5"
puts c2 * ksi2.abs < DELTA ? "H0: D = 1/12" : "H1: D != 1/12"

# Метод Макларена-Марсальи
K = 32
D1, D2 = mkm(7 ** 6, 7 ** 6, N + K), mkm(5 ** 11)

def mmm(b = D1, c = D2, k = K, n = N)
  a,v = [],[]
  (0..k - 1).each { |i| v[i] = b[i] }
  (0..n - 1).each do |t|
    s = (c[t] * k).floor
    a[t] = v[s]
    v[s] = b[t + K]
  end
  a
end

p a = mmm

# Тест «ковариация»
def r(j)
  j >= 1 ? 0 : 1.0 / 12
end

def r_(j, a, n = N)
  m = m(a)
  ( 1.0 / (n - j - 1)) * (0..n - j - 1).map { |i| a[i] * a[i + j] }.inject(:+) - (n.to_f / (n - 1)) * m ** 2
end

def c(j)
  j >= 1 ? 1 : Math.sqrt(2)
end

(0..25).each do |j|
  puts (r_(j, a) - r(j)).abs < (c(j) * DELTA) / (12 * Math.sqrt(N - 1)) ? "H0" : "H1"
end