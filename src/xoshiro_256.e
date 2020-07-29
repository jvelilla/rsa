note
	description: "Summary description for {XOSHIRO_256}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XOSHIRO_256

create
	make

feature {NONE} -- Initialization

	make (a_seed: INTEGER_64)
			-- Create a new instance of XOSHIRO_256.
		do
			if a_seed = 0 then
				set_state (0xdeadbeef)
			else
				set_state (a_seed)
			end
		end

feature -- Random

	random: INTEGER_64
			-- New random
		local
			t: INTEGER_64
		do
			Result := rol_64 (s1 * 5, 7) * 9

		    t := s1 |<< 17
			s2 := s2 ⊕ s0
			s3 :=  s3 ⊕ s1
			s1 :=  s1 ⊕ s2
			s0 :=  s0 ⊕ s3

			s2 := s2 ⊕ t
			s3 := rol_64(s3, 45)
		end

feature {NONE} -- Implementation

	set_state (a_seed: INTEGER_64)
		local
			sms: INTEGER_64
		do
			sms := split_mix64_1(a_seed)
			s0 := split_mix64_2(sms)
			sms := split_mix64_1(sms)
			s1 := split_mix64_2(sms)
			sms := split_mix64_1(sms)
			s2 := split_mix64_2(sms)
			sms := split_mix64_1(sms)
			s3 := split_mix64_2(sms)
		end

	rol_64 (a_x: INTEGER_64; k: INTEGER): INTEGER_64
		local
			lx: NATURAL_64
		do
			lx := a_x.to_natural_64
			Result := ((lx |<< k) | (lx |>> (64 - k))).to_integer_64
		end

	s0: INTEGER_64
	s1: INTEGER_64
	s2: INTEGER_64
	S3: INTEGER_64
		-- internal bit shifted	


	split_mix64_1 (x: INTEGER_64): INTEGER_64
		do
			Result := x + SPLITMIX1_MAGIC
		end

	split_mix64_2(z: INTEGER_64): INTEGER_64
		local
			lz: INTEGER_64
		do
			lz := z
			lz := (lz ⊕ (lz |>> 30)) * 0xBF58476D1CE4E5B9
			lz := (lz ⊕ (lz |>> 27)) * 0x94D049BB133111EB
			Result := lz ⊕ (lz |>> 31)
		end

	SPLITMIX1_MAGIC: INTEGER_64 = 0x9E3779B97F4A7C15
;note
	copyright: "Copyright (c) 1984-2017, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
