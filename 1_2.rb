require_relative "math_operations"
include MathOperations
M = 2**31
N = 1000
delta = 1.96039491

#   Рефакторить лабы, это не лучший HM, лучше бы набросал пару классов  корявых
# классов.

# мультипликативного конгруэнтного метода (МКМ)
def mkm_generator(a0, b = a0, n = N)
  a = [a0]
  (1..n).each { |i| a[i] = (b * a[i-1]).modulo(M) }
  a[1..n].map { |a| a / M.to_f }
end

p a = mkm_generator(7**6)


# Тест «совпадения моментов»
expected_m = 0.5
expected_D = 1.0 / 12

calculated_m = mean_value(a)
puts "ksi1:" + (ksi1 = calculated_m - expected_m).to_s

centered_value = a.map { |value| (value - calculated_m)**2 }
puts "ksi2:" + (ksi2 = mean_value(centered_value) - expected_D).to_s

def get_c2(n = N)
  ((n - 1).to_f / n) * (0.0056 * n**-1 + 0.0028 * n**-2 - 0.0083 * n**-3)**-0.5
end

puts Math.sqrt(12*a.size) * ksi1.abs < delta ? "H0: mu = 0.5" : "H1: mu != 0.5"
puts get_c2(a.size) * ksi2.abs < delta ? "H0: D = 1/12" : "H1: D != 1/12"



# Метод Макларена-Марсальи
K = 32
D1, D2 = mkm_generator(7**6, 7**6, N + K), mkm_generator(5**11)

def mmm_generator(b = D1, c = D2, k = K, n = N)
  a,v = [],[]
  (0..k - 1).each { |i| v[i] = b[i] }
  (0..n - 1).each do |t|
    s = (c[t] * k).floor
    a[t] = v[s]
    v[s] = b[t + K]
  end
  a
end

p a = mmm_generator


# Тест «ковариация»
def expected_r(j)
  j >= 1 ? 0 : 1.0 / 12
end

def calculated_r(j, a)
  n = a.size-1
  correction = ((n + 1).to_f / n) * mean_value(a)**2
  (1.0 / (n - j)) * (0..n - j).map { |i| a[i] * a[i+j] }.reduce(:+) - correction
end

def get_c(j)
  j >= 1 ? 1 : Math.sqrt(2)
end

(0..25).each do |j|
  delta_r = (get_c(j) * delta) / (12 * Math.sqrt(a.size)) 
  puts (calculated_r(j, a) - expected_r(j)).abs < delta_r ? "H0" : "H1"
end
