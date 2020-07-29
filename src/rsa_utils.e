note
	description: "Summary description for {RSA_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RSA_UTILS

feature -- Access

	comprime (a, b: INTEGER_64): BOOLEAN
			-- Result `True`, if  the only positive integer (factor) that divides both of them is 1.
			--
		do
			Result := gcd (a, b) = 1
		ensure
			instance_free: class
		end

	gcd (m, n: INTEGER_64): INTEGER_64
			-- Greatest Common Divisor of `m' and 'n'.
		require
			m >= 0 and then n >= 0
		local
			value: INTEGER_64
		do
			if m > 0 and n > 0 then
				from
					Result := m
					value := n
				invariant
					gcd (Result, value) = gcd (m, n)
				until
					Result = value
				loop
					if Result > value then
						Result := Result - value
					else
						value := value - Result
					end
				variant
					Result.max (value)
				end
			else
				Result := m.max (n)
			end
		ensure
			Result = gcd (n, m)
			instance_free: class
		end

	modular_inverse (a, n: INTEGER_64): INTEGER_64
			-- Sets `Result` to the multiplicative inverse of a in the ring ℤ/nℤ .
			-- If a and n are not relatively prime, a has no multiplicative inverse in the ring ℤ/nℤ.
		note
			eis: "Modular multiplicative inverse", "src=https://en.wikipedia.org/wiki/Modular_multiplicative_inverse", "protocol=uri"
			eis: "Modular Inverse", "src=https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm", "protocol=uri"
		require
			are_comprime: comprime (a.abs, n.abs)
		local
			la, ln: INTEGER_64
			t, nt, r, nr, q, tmp: INTEGER_64
		do
			ln := if n < 0 then - n else n end
			la := if a < 0 then ln - (- a \\ ln) else a end
			t := 0
			nt := 1
			r := ln
			nr := la \\ ln
			from
			until
				nr = 0
			loop
				q := r // nr
				tmp := nt
				nt := t - q * nt
				t := tmp
				tmp := nr
				nr := r - q * nr
				r := tmp
			end
			if r > 1 then
				check False then
					Result := -1 -- No inverse
				end
			else
				if t < 0 then
					t := t + ln
				end
				Result := t
			end
		ensure
			instance_free: class
		end

	primes_through (a_limit: INTEGER): LINKED_LIST [INTEGER]
			-- Prime numbers through `a_limit'
		note
			eis:"Primes", "src=https://www.eiffel.org/doc/eiffel/Example-_Sieve_of_Eratosthenes", "protocol=uri"
		require
			valid_upper_limit: a_limit >= 2
		local
			l_tab: ARRAY [BOOLEAN]
		do
			create Result.make
			create l_tab.make_filled (True, 2, a_limit)
			across
				l_tab as ic
			loop
				if ic.item then
					Result.extend (ic.target_index)
					across ((ic.target_index * ic.target_index) |..| l_tab.upper).new_cursor.with_step (ic.target_index) as id
					loop
						l_tab [id.item] := False
					end
				end
			end
		ensure
			instance_free: class
		end

feature -- Primes

	Smallest_prime: INTEGER = 2

	Smallest_odd_prime: INTEGER = 3

	prime (a_bits: INTEGER): INTEGER_64
			-- Return a number p, of the given size, such that p is prime.
			-- require a_bits >= 2
			-- TODO check if there is a better way to generate
			-- Prime numbers of n bits.
		require
			valid_bits: a_bits >= 2
		local
			r: SALT_XOSHIRO_256_GENERATOR
			np: INTEGER_64
		do
			Result := higher_prime (random_generator (a_bits).new_random.abs)
		ensure
			result_is_prime: is_prime (Result)
		end

	is_prime (n: INTEGER_64): BOOLEAN
			-- Is `n' a prime number?
		local
			divisor: INTEGER_64
		do
			if n <= 1 then
				Result := False
			elseif n = Smallest_prime then
				Result := True
			elseif n \\ Smallest_prime /= 0 then
				from
					divisor := Smallest_odd_prime
				until
					(n \\ divisor = 0) or else (divisor * divisor >= n)
				loop
					divisor := divisor + Smallest_prime
				end
				if divisor * divisor > n then
					Result := True
				end
			end
		ensure then
			instance_free: class
		end


	higher_prime (n: INTEGER_64): INTEGER_64
			-- Lowest prime greater than or equal to `n'
		do
			if n <= Smallest_prime then
				Result := Smallest_prime
			else
					check
						n > Smallest_prime
					end
				from
					if n \\ Smallest_prime = 0 then
							-- Make sure that `Result' is odd
						Result := n + 1
					else
						Result := n
					end
				until
					is_prime (Result)
				loop
					Result := Result + Smallest_prime
				end
			end
		ensure
			instance_free: class
		end

	lower_prime (n: INTEGER_64): INTEGER_64
			-- Greatest prime lower than or equal to `n'
		require
			argument_big_enough: n >= Smallest_prime
		do
			if n = Smallest_prime then
				Result := Smallest_prime
			else
					-- `n' > Smallest_prime
				from
					if n \\ Smallest_prime = 0 then
							-- make sure that `Result' is odd
						Result := n - 1
					else
						Result := n
					end
				until
					is_prime (Result)
				loop
					Result := Result - Smallest_prime
				end
			end
		ensure
			instance_free: class
		end


feature -- Bit lenght

	bit_length_opt (n: INTEGER_64): INTEGER
			-- Return the bit size of a non-negative integer.
		require
			non_negative: n >= 0
		local
			l_bits: INTEGER
			m: INTEGER_64
			ln: INTEGER_64
		do
			if n = 0 then
				Result := 0
			else
				ln := n
				l_bits := 0
				from
				until
					ln = 0
				loop
					ln := ln |>> 1
					l_bits := l_bits + 1
 				end
 				Result := l_bits
 			end
 		ensure
 			instance_free: class
		end

	bit_length (n: INTEGER_64): INTEGER
			-- Return the bit size of a non-negative integer.
		require
			non_negative: n >= 0
		do
			if n = 0 then
				Result := 0
			else
				Result := {SINGLE_MATH}.log_2 (n).floor + 1
			end
			print ("Bitlength:" + Result.out + "%N")
		ensure
			instance_free: class
		end


feature {NONE} -- Implementation

	random_generator(a_bits: INTEGER): SALT_XOSHIRO_256_GENERATOR
		once
			create Result.make (a_bits)
			Result.set_seed (seed)
		end

	seed: INTEGER
			-- Seed of the random number generator.
		local
			l_seed: NATURAL_64
			l_date: C_DATE
		do
			create l_date
				-- Compute the seed as number of milliseconds since EPOC (January 1st 1970)
			l_seed := (l_date.year_now - 1970).to_natural_64 * 12 * 30 * 24 * 60 * 60 * 1000
			l_seed := l_seed + l_date.month_now.to_natural_64 * 30 * 24 * 60 * 60 * 1000
			l_seed := l_seed + l_date.day_now.to_natural_64 * 24 * 60 * 60 * 1000
			l_seed := l_seed + l_date.hour_now.to_natural_64 * 60 * 60 * 1000
			l_seed := l_seed + l_date.minute_now.to_natural_64 * 60 * 1000
			l_seed := l_seed + l_date.second_now.to_natural_64 * 1000
			l_seed := l_seed + l_date.millisecond_now.to_natural_64
				-- Use RFC 4122 trick to preserve as much meaning of `l_seed' onto an INTEGER_32.
			Result := (l_seed |>> 32).bit_xor (l_seed).as_integer_32 & 0x7FFFFFFF
		ensure
			instance_free: class
		end

end
