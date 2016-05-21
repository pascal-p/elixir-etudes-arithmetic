defmodule Arithmetic do

  @doc """
  Returns the greatest common divisor (always positive). gcd(n, 0) and gcd(0, n) return abs(n).

  ## Examples
     iex> Arithmetic.gcd(21, 14)
     7
     iex> Arithmetic.gcd(14, 21)
     7
     iex> Arithmetic.gcd(125, 46)
     1
     iex> Arithmetic.gcd(46, 125)
     1
     iex> Arithmetic.gcd(120, 36)
     12
     iex> Arithmetic.gcd(36, 120)
     12
     iex> Arithmetic.gcd(120, 1)
     1
     iex> Arithmetic.gcd(120, 1)
     1
     iex> Arithmetic.gcd(21, -14)
     7
     iex> Arithmetic.gcd(28_420, Arithmetic.gcd(33_810, 4_116))
     98
     iex> Arithmetic.gcd(7_976, 14_865)
     1
  """

  def gcd(m, n) when is_integer(n) and is_integer(m) do
    gcd_aux(abs(m), abs(n))
  end

  defp gcd_aux(m, m), do: m

  defp gcd_aux(m, 0), do: m

  defp gcd_aux(0, n), do: n

  defp gcd_aux(m, n) when m == 1 or n == 1, do: 1

  defp gcd_aux(m, n) when m > n do
    gcd_aux(m - n, n)
  end

  defp gcd_aux(m, n) when m < n do
    gcd_aux(m, n - m)
  end

  @doc """
  Returns the least common multiple (always positive). lcm(x, 0) and lcm(0, x) return zero.

  ## Examples
     iex> Arithmetic.lcm(48, 12)
     48
     iex> Arithmetic.lcm(12, 48)
     48
     iex> Arithmetic.lcm(-21, 14)
     42
     iex> Arithmetic.lcm(14, -21)
     42
     iex> Arithmetic.lcm(21, 0)
     0
     iex> Arithmetic.lcm(0, 21)
     0
  """

  def lcm(m, n) when is_integer(n) and is_integer(m) do
     m * n |> abs  |> div(gcd(m, n)) # <==> div(abs(m * n), gcd(m, n))
  end

  # internal helper
  # here any unary (mathematic) function would do
  defp f_calc(n, fun \\ &(:math.sqrt(&1))) when n > 0 do
    fun.(n) |> 
      f_calc_return
  end

  # here any binary (mathematic) function would do
  defp f_calc(x, n, fun) when n > 0 and x > 0  do
    fun.(x, n) |>
      f_calc_return    
  end

  defp f_calc_return(x), do: round(Float.ceil(x * 1.0))
  
  @doc """
  Returns a list of the prime number less than n using the Eratosthene sieve method

  ## Examples
    iex> Arithmetic.gen_prime 10
    [2, 3, 5, 7]
    iex> Arithmetic.gen_prime 20
    [2, 3, 5, 7, 11, 13, 17, 19]
    iex> Arithmetic.gen_prime 50
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
    iex> Arithmetic.gen_prime 1
    []
    iex> Arithmetic.gen_prime 100
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
    iex> Arithmetic.gen_prime -10
    []
    iex> Arithmetic.gen_prime 2
    [2]    
  """

  def gen_prime(n) when is_integer(n) and n < 2, do: []

  def gen_prime(2), do: [2]                                           

  def gen_prime(n) when is_integer(n) and n > 2  do
    gen_prime_aux(3..n |>
      Enum.reject(fn(x) -> rem(x, 2) == 0 end), f_calc(n), [2])
  end
  
  defp gen_prime_aux(list, limit, lr) do
    [x | _] = list
    if x < limit do
      redux(list) |> Enum.reverse |>
        gen_prime_aux(limit, [x | lr])
    else
      rl = lr |> Enum.reverse
      rl ++ list
    end
  end

  defp redux([car | cdr]) do
    Enum.reduce(cdr, [],
      fn(x, l) ->
        if rem(x, car) == 0 do
          l
        else
          [x | l]
        end
      end)
  end

  @doc """
  Returns how many times n can be divided by x, when x is a divisor of n

  ## Examples
    iex> Arithmetic.factors(64, 2)
    {[2, 6], 1}  # 64 = 2 x 2 x 2 x 2 x 2 x 2 = 2^6

    iex> Arithmetic.factors(65, 5)
    {[5, 1], 13}  # 65 = 5 x 13

    iex> Arithmetic.factors(99, 3)
    {[3, 2], 11}  # 99 = 3 x 3 x 11
  """

  def factors(n, x), do: factors_aux(n, x, 0)

  defp factors_aux(n, x, r) do
    if rem(n, x) == 0 do
      factors_aux(div(n, x), x, r + 1)
    else
      { [x, r], n }
    end
  end

  @doc """
  Returns the (unique) decomposition of n with prime factors

  ## Examples
    iex> Arithmetic.prime_dec 99
    [[11, 1], [3, 2]]

    iex> Arithmetic.prime_dec 4747
    [[101, 1], [47, 1]]

    iex> Arithmetic.prime_dec 474747
    [[47, 1], [37, 1], [13, 1], [7, 1], [3, 1]]

    iex> Arithmetic.prime_dec 4747
    [[101, 1], [47, 1]]

    iex> Arithmetic.prime_dec 474_747
    [[47, 1], [37, 1], [13, 1], [7, 1], [3, 1]]

    iex> Arithmetic.prime_dec 47_474_747
    [[137, 1], [101, 1], [73, 1], [47, 1]]

  """

  def prime_dec(0), do: [[0, 1]]
  
  def prime_dec(1), do: [[1, 1]]
  
  def prime_dec(n) when is_integer(n) and n > 1 do
    pl = gen_prime(f_calc(n))
    prime_dec_aux(n, pl, [])
  end

  def prime_dec(n) when is_integer(n) and n < 0 do
    prime_dec(abs(n)) ++ [[-1, 1]]
  end

  defp prime_dec_aux(n, [], lr), do: [[n, 1] | lr]
  
  defp prime_dec_aux(n, [x | cdr], lr) do
    cond do
      n == 1 -> lr      
      rem(n, x) == 0 ->
        {[x, f], nr} = factors(n, x)
        prime_dec_aux(nr, cdr, [[x, f] | lr])
      true -> prime_dec_aux(n, cdr, lr)        
    end
  end

  @doc """
  Returns product of all factors. 

  ## Examples
    iex> Arithmetic.prime_dec(99) |> Arithmetic.check_prime_dec
    99
    
    Arithmetic.prime_dec(47_474_747) |> Arithmetic.check_prime_dec
    47_474_747
  
    iex> Arithmetic.prime_dec(474_747) |> Arithmetic.check_prime_dec
    474_747

    Arithmetic.check_prime_dec []

  """
  def check_prime_dec([]), do: 0

  def check_prime_dec([[n, 1]]), do: n
  
  def check_prime_dec(factors) do
    factors |> Enum.reduce(1, fn([n, x], s) ->
      if x > 1 do
        f_calc(n, x, &(Arithmetic.pow(&1, &2))) * s
      else
        # x == 1 by construction
        n * s
      end
    end)
  end
  # x will be >= 1

  @doc """
  Returns x^n (float) using a divide and conquer approach
  
  ## Examples
    iex> Arithmetic.pow(2, 10)
    1024

    iex> Arithmetic.pow(32, 1) 
    32

    iex> Arithmetic.pow(32.0, 1) 
    32.0

    iex> Arithmetic.pow(32, 2)
    1024

    iex> Arithmetic.pow(32.0, 2)
    1024.0

    iex> Arithmetic.pow(1024, 5)
    1125899906842624

    iex> Arithmetic.pow(1024, -5)
    8.881784197001252e-16

    iex> Arithmetic.pow(1024, 0) 
    1

    iex> Arithmetic.pow(1024, 1)
    1024

    iex> Arithmetic.pow(-1024, 5)
    -1125899906842624

    iex> Arithmetic.pow(27, 9)
    7625597484987

  """
  
  def pow(x, n) when is_number(x) and is_integer(n), do: pow_(x, n)

  defp pow_(0, 0), do: raise Arithmetic.UndefFormError
  
  defp pow_(x, n) when n == 0 and x != 0, do: 1

  defp pow_(x, 1), do: x * 1

  defp pow_(x, n) when n > 0 do
    pow_aux(x, n, 1)
  end

  defp pow_(x, n) when n < 0 do
    1.0 / pow_aux(x, abs(n), 1)
  end

  defp pow_aux(x, 1, r), do: r * x

  defp pow_aux(x, n, r) do
    if rem(n, 2) == 0 do
      pow_aux(x * x, div(n, 2), r)
    else
      pow_aux(x, n - 1, r * x)
    end
  end


  #
  # Custom Exception
  #
  defmodule UndefFormError do
    
    defexception message: "Arithmetic Exception 0^0 non defined form", can_retry: false
    
    def full_message(me) do
      "Arithmetic eval failed: #{me.message}, retriable: #{me.can_retry}"
    end
  end

end
