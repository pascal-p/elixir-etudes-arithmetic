defmodule Arithmetic do

  @epsilon 0.000_000_01

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
    gcd_(abs(m), abs(n))
  end

  defp gcd_(m, m), do: m

  defp gcd_(m, 0), do: m

  defp gcd_(0, n), do: n

  defp gcd_(m, n) when m == 1 or n == 1, do: 1

  defp gcd_(m, n) when m > n, do: gcd_(m - n, n)

  defp gcd_(m, n) when m < n, do: gcd_(m, n - m)

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
  Returns a list of the prime number less than n using the Sieve of Eratosthenes method

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
    gen_prime(3..n |>
      Enum.reject(fn(x) -> rem(x, 2) == 0 end), f_calc(n), [2])
  end

  defp gen_prime(list, limit, lr) do
    [x | _] = list
    if x < limit do
      redux(list) |> Enum.reverse |>
        gen_prime(limit, [x | lr])
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
    iex> Arithmetic.factorize(64, 2)
    {[2, 6], 1}  # 64 = 2 x 2 x 2 x 2 x 2 x 2 = 2^6

    iex> Arithmetic.factorize(65, 5)
    {[5, 1], 13}  # 65 = 5 x 13

    iex> Arithmetic.factorize(99, 3)
    {[3, 2], 11}  # 99 = 3 x 3 x 11
  """

  def factorize(n, x), do: factorize(n, x, 0)

  defp factorize(n, x, r) do
    if rem(n, x) == 0 do
      factorize(div(n, x), x, r + 1)
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
    prime_dec(n, pl, [])
  end

  def prime_dec(n) when is_integer(n) and n < 0 do
    prime_dec(abs(n)) ++ [[-1, 1]]
  end

  defp prime_dec(n, [], lr), do: [[n, 1] | lr]

  defp prime_dec(n, [x | cdr], lr) do
    cond do
      n == 1 -> lr
      rem(n, x) == 0 ->
        {[x, f], nr} = factorize(n, x)
        prime_dec(nr, cdr, [[x, f] | lr])
      true -> prime_dec(n, cdr, lr)
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
    pow(x, n, 1)
  end

  defp pow_(x, n) when n < 0 do
    1.0 / pow(x, abs(n), 1)
  end

  defp pow(x, 1, r), do: r * x

  defp pow(x, n, r) do
    if rem(n, 2) == 0 do
      pow(x * x, div(n, 2), r)
    else
      pow(x, n - 1, r * x)
    end
  end

  def divisors(0), do: []

  def divisors(1), do: [1]

  def divisors(n) when is_integer(n) and n > 0 do
    upbound = f_calc(n)
    divisors(n, 2..upbound |> Enum.into([]), [[n, 1]]) |>
      Enum.flat_map(fn(ary) -> ary end) |>
      Enum.sort
  end

  def divisors(n) when is_integer(n) and n < 0 do
    divisors(abs(n))
  end

  defp divisors(_, [], lr), do: lr

  defp divisors(n, [x | cdr], lr) do
    if rem(n, x) == 0 do
      divisors(n, cdr, [ [x, div(n, x)] | lr])
    else
      divisors(n, cdr, lr)
    end
  end

  @doc """
  Returns the n-th power of x, using the Newton-Raphson method

  ## Examples
     iex> Arithmetic.nth_root(36, 2) # square root of 36
     6.0

     iex> Arithmetic.nth_root(81, 2)
     9.0

     iex> Arithmetic.nth_root(2, 2)
     1.4142135623730951

     iex> Arithmetic.nth_root(1.728, 2)
     1.3145341380123987

     iex> Arithmetic.nth_root(27, 3) # cubic square of 27
     3.0

     iex> Arithmetic.nth_root(36, 1)
     36.0
  """

  # nth_root: float -> integer -> float
  def nth_root(x, 1), do: x * 1.0

  def nth_root(x, 0) when x != 0,  do: 1.0

  def nth_root(x, n) when is_integer(n) and n > 0 do
    nth_root(x, n, x / 2.0)
  end

  def nth_root(x, n, a) do
    pow = Arithmetic.pow(a, n - 1)
    f   = a * pow - x
    fp  = n * pow
    na  = a - f / fp
    if abs(na - a) < @epsilon do
      na
    else
      nth_root(x, n, na)
    end
  end


  @doc """
  nth_root_with_prec: integer -> integer -> integer -> tuple == { root, length in digits }

  Returns the n-th power of x, given the precision (using bisection method)

  ## Examples
     # square root of 2, 1000 digits:
     iex> Arithmetic.nth_root_with_prec(2, 2, 1000)
     {"1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927557999505011527820605714701095599716059702745345968620147285174186408891986095523292304843087143214508397626036279952514079896872533965463318088296406206152583523950547457502877599617298355752203375318570113543746034084988471603868999706990048150305440277903164542478230684929369186215805784631115966687130130156185689872372352885092648612494977154218334204285686060146824720771435854874155657069677653720226485447015858801620758474922657226002085584466521458398893944370926591800311388246468157082630100594858704003186480342194897278290641045072636881313739855256117322040245091227700226941127573627280495738108967504018369868368450725799364729060762996941380475654823728997180326802474420629269124859052181004459842150591120249441341728531478105803603371077309182869314710171111683916581726889419758716582152128229518488472", 1001 }

    # square root of 3, 1000 digits
    iex> Arithmetic.nth_root_with_prec(3, 2, 1000)
    {"1.7320508075688772935274463415058723669428052538103806280558069794519330169088000370811461867572485756756261414154067030299699450949989524788116555120943736485280932319023055820679748201010846749232650153123432669033228866506722546689218379712270471316603678615880190499865373798593894676503475065760507566183481296061009476021871903250831458295239598329977898245082887144638329173472241639845878553976679580638183536661108431737808943783161020883055249016700235207111442886959909563657970871684980728994932964842830207864086039887386975375823173178313959929830078387028770539133695633121037072640192491067682311992883756411414220167427521023729942708310598984594759876642888977961478379583902288548529035760338528080643819723446610596897228728652641538226646984200211954841552784411812865345070351916500166892944154808460712771439997629268346295774383618951101271486387469765459824517885509753790138806649619119622229571105552429237231921977382625616314688420328537166829386496119170497388363954959381", 1001 }

    # cubic root of 12734, with 100 decimales precision
    iex> Arithmetic.nth_root_with_prec(12734, 3, 100)
    {"23.3518673604058861118578567217233761801600256429182019352842797047831940543070611427067115879074632578", 102}

    # cubic root of 12734, with 1000 decimales precision
    iex> Arithmetic.nth_root_with_prec(12734, 3, 1000)
    {"23.3518673604058861118578567217233761801600256429182019352842797047831940543070611427067115879074632578413604523896595013786795909265338290643271375969001336551752602989069153318265284605055754701168285667903240733432765412876312271107709054659919454416298669498011786384855585958209298024966998101876373878348567228245302170367396660969444098300454097980649509714024726643880719334460262437604401177207884229592519256628558254567519820285139864724828361303609126151552352685344645405661251489501456804931584909048563115130101030330452183852771291191474745869373049546247044416299662207027077519367842427628286208852937630482499409551500589240489058236219758856056047913269284604284672538238717412408813959997332622120815461621499033437282276033040849600347611137220867208001651884725140178283970717439517252152668249251769724182085653139832315929570801525108297010818675362727905811024145415088597289157780233860715521923932686441193091186119710116649345634850205857230032137178180500074303459805680945", 1002 }

    # precision is irrelevant in this case:
    iex> Arithmetic.nth_root_with_prec(0, 3, 1)
    {0, 0}

    # precision is irrelevant in this case:
    iex> Arithmetic.nth_root_with_prec(1, 10, 1)
    {1, 0}

    # precision is irrelevant in this case:
    iex> Arithmetic.nth_root_with_prec(10.1, 1, 10)
    {10.1, 0}

  """

  def nth_root_with_prec(0, n, _) when n != 0, do: {0, 0}

  def nth_root_with_prec(1, _, _), do: {1, 0}

  # WARN: the 0 is meaningless here
  def nth_root_with_prec(x, 1, _), do: {x, 0}

  def nth_root_with_prec(x, n, ndigits)
  when is_integer(x) and x > 0
  and is_integer(n)
  and is_integer(ndigits)
  and n > 1 do
    # build the target root
    { ix, _ } = [Integer.to_string(x), String.duplicate("0", ndigits * n)]
    |> Enum.join
    |> Integer.parse
    # compute result, a tuple {s_res, s_len}
    lr = result(nth_root_aux(ix, n, ix, 0))
    # set the dot and return
    set_dot(x, n, lr) # { root, s_len }
  end

  def nth_root_aux(x, n, up_bound, low_bound) do
    nval  = div(up_bound + low_bound, 2)
    nroot = Arithmetic.pow(nval, n)
    if (up_bound - low_bound) == 1 do
      low_bound
    else
      cond do
        nroot > x -> nth_root_aux(x, n, nval, low_bound)
        nroot < x -> nth_root_aux(x, n, up_bound, nval)
        true -> nval
      end
    end
  end

  defp result(res) do
    s_res = Integer.to_string(res)
    [ s_res, String.length(s_res) ]
  end

  defp locate_dot(x, n) do
    Arithmetic.nth_root(x, n) |> f_calc_return |> Integer.to_string
    |> String.length
  end

  defp set_dot(x, n, [s_result, s_len]) do
    pos  = locate_dot(x, n)
    root = [ String.slice(s_result, 0, pos), ".", String.slice(s_result, pos, s_len - pos) ]
    |> Enum.join
    { root, s_len }
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
