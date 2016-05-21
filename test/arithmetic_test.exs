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

end
