# Arithmetic

A basic Arithmetic module in Elixir featuring tail recursion.
  - gcd, lcm
  - gen_prime (using the Sieve of Eratosthenes method)
  - prime_dec (finding the canonical decomposition in primne factors)
  - pow (using a divide and conquer method)
  - divisors

## TODO
  add more function
  packaging

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add arithmetic to your list of dependencies in `mix.exs`:

        def deps do
          [{:arithmetic, "~> 0.0.1"}]
        end

  2. Ensure arithmetic is started before your application:

        def application do
          [applications: [:arithmetic]]
        end
