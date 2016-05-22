defmodule ArithmeticTest do
  use ExUnit.Case
  doctest Arithmetic

  import Expect

  expect "gcd(x, 0) == gcd(0, x) == x"  do
    assert Arithmetic.gcd(48, 0) == 48
    assert Arithmetic.gcd(0, 48) == 48
  end

  expect "gcd(x, 1) == gcd(1, x) == 1"  do
    assert Arithmetic.gcd(48, 1) == 1
    assert Arithmetic.gcd(1, 48) == 1
  end

  expect "gcd(12, 48) == gcd(48, 12) == 12"  do
    assert Arithmetic.gcd(48, 12) == 12
    assert Arithmetic.gcd(12, 48) == 12
  end

  expect "gcd(36, 48) == gcd(48, 36) == 12"  do
    assert Arithmetic.gcd(48, 36) == 12
    assert Arithmetic.gcd(36, 48) == 12
  end

  expect "gcd(-14, 21) == gcd(21, -14) == 7"  do
    assert Arithmetic.gcd(21, -14) == 7
    assert Arithmetic.gcd(-14, 21) == 7
  end

  expect "lcm(12, 48) == lcm(48, 12) == 48"  do
    assert Arithmetic.lcm(12, 48) == 48
    assert Arithmetic.lcm(48, 12) == 48
  end

   expect "lcm(-14, 21) == lcm(21, -14) == 42"  do
    assert Arithmetic.lcm(-14, 21) == 42
    assert Arithmetic.lcm(21, -14) == 42
  end

  expect "prime list < 100 to have 25 primes" do
    list = Arithmetic.gen_prime 100
    assert list == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
    assert Kernel.length(list) == 25
  end

  expect "prime_dec(1517) is 41 * 37" do
    assert Arithmetic.prime_dec(1517) == [[41, 1], [37, 1]]
  end

  expect "prime_dec(12_345_654_321) is 37 ^ 2 * 13 ^ 2 * 11 ^ 2 * 7 ^ 2 * 3 ^ 2" do
    assert Arithmetic.prime_dec(12_345_654_321) == [[37, 2], [13, 2], [11, 2], [7, 2], [3, 2]]
  end

  expect "prime_dec(-12_345_654_321) is 37 ^ 2 * 13 ^ 2 * 11 ^ 2 * 7 ^ 2 * 3 ^ 2 * -1" do
    assert Arithmetic.prime_dec(-12_345_654_321) ==
      [[37, 2], [13, 2], [11, 2], [7, 2], [3, 2], [-1, 1]]
  end

  expect "idemtpotence of prime_dec(12_345_654_321) |> check_prime_dec" do
    m = 12_345_654_321
    n = Arithmetic.prime_dec(m) |> Arithmetic.check_prime_dec
    assert n == m
  end

  expect "idemtpotence of prime_dec(1517) |> check_prime_dec" do
    m = 1517
    n = Arithmetic.prime_dec(m) |> Arithmetic.check_prime_dec
    assert n == m
  end

  expect "idemtpotence of prime_dec(0) |> check_prime_dec" do
    m = 0
    n = Arithmetic.prime_dec(m) |> Arithmetic.check_prime_dec
    assert n == m
  end

  expect "idemtpotence of prime_dec(-1) |> check_prime_dec" do
    m = -1
    n = Arithmetic.prime_dec(m) |> Arithmetic.check_prime_dec
    assert n == m
  end

  expect "0^0 to raise Arithmetic.UndefFormError" do
    try do
      Arithmetic.pow(0, 0)

    rescue
      [Arithmetic.UndefFormError] -> true
        # NO-OP
    after
      true
    end
  end

  expect "divisors(96) == [1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 96]" do
    assert Arithmetic.divisors(96) == [1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 96]
  end

  expect "divisors(1) == [1]" do
    assert Arithmetic.divisors(1) == [1]
  end

  expect "divisors(1024) == [1, 2, 4, 8, 16, 32, 32, 64, 128, 256, 512, 1024]" do
    assert Arithmetic.divisors(1024) == [1, 2, 4, 8, 16, 32, 32, 64, 128, 256, 512, 1024]
  end

  # [ [3, 0, 1.0], [2.0, 1, 2.0], [2, 1, 2.0], [19683, 3, 27.0]] |>
  #     Enum.each( fn([x, n, res]) ->
  #       # IO.puts " -- got: x:#{x} n:#{n} res:#{res}"

  #       expect "nth_root(#{x}, #{n}) == #{res}" do
  #         assert Arithmetic.nth_root(x, n) == res
  #       end
  #     end)

  expect "nth_root(3, 0) == 1.0" do
    assert Arithmetic.nth_root(3, 0) == 1.0
  end

  expect "nth_root(2.0, 1) == 2.0" do
    assert Arithmetic.nth_root(2.0, 1) == 2.0
  end

  expect "nth_root(19683, 3) == 27.0" do
    assert Arithmetic.nth_root(19683, 3) == 27.0
  end

  expect "nth_root_with_prec(2, 2, 500) == 1.414..." do
    assert Arithmetic.nth_root_with_prec(2, 2, 500) == {"1.41421356237309504880168872420969807856967187537694807317667973799073247846210703885038753432764157273501384623091229702492483605585073721264412149709993583141322266592750559275579995050115278206057147010955997160597027453459686201472851741864088919860955232923048430871432145083976260362799525140798968725339654633180882964062061525835239505474575028775996172983557522033753185701135437460340849884716038689997069900481503054402779031645424782306849293691862158057846311159666871301301561856898723723", 501}
  end

  expect "nth_root_with_prec(10, 3, 200) == 1.414..." do
    assert Arithmetic.nth_root_with_prec(10, 3, 200) == {"2.15443469003188372175929356651935049525934494219210858248923550634641110664834080018544150354324327610126122049178092044655750510008327495712067537780933193273058365348926382812549693140387838279686331", 201}
  end

end
