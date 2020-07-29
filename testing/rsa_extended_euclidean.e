note
	description: "Summary description for {RSA_EXTENDED_EUCLIDEAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RSA_EXTENDED_EUCLIDEAN

feature -- Access


	modular_inverse (a, n: INTEGER_64)
			-- Sets `last_inverse` to the multiplicative inverse of a in the ring ℤ/nℤ and exist in `True`.
			-- If a and n are not relatively prime, a has no multiplicative inverse in the ring ℤ/nℤ.
			-- In this case, exist in set to `False`.
		note
			eis: "Modular multiplicative inverse", "src=https://en.wikipedia.org/wiki/Modular_multiplicative_inverse" ,"protocol=uri"
			eis: "Modular Inverse", "src=https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm", "protocol=uri"
		local
			la, ln: INTEGER_64
			t, nt, r, nr, q, tmp: INTEGER_64
		do
				-- reset
			last_inverse := 0
			exist := True

			ln := if n < 0 then  - n else n end
			la := if a < 0 then  ln - (- a \\ ln) else a end
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
				exist := False
			else
				if t < 0 then
					t := t + ln
				end
				last_inverse := t
			end
		end


	last_inverse: INTEGER_64
			-- result of the last modular_inverse


feature -- Status Report

	exist: BOOLEAN
			-- Does modular inverse exist?


end
