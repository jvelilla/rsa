note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	RSA_UTIL_TEST

inherit
	EQA_TEST_SET

feature -- Test routines

	test_modular_inverse
			-- New test routine
		local
			r: RSA_UTILS
		do
			assert ("expected value 1969", {RSA_UTILS}.modular_inverse (42, 2017) = 1969)
			assert ("expected value 0", {RSA_UTILS}.modular_inverse (40, 1) = 0)
			assert ("expected value 96", {RSA_UTILS}.modular_inverse (52, -217) = 96)
			assert ("expected value 121", {RSA_UTILS}.modular_inverse (-486, 217) = 121)
			if {RSA_UTILS}.comprime (40, 2018) then
				assert ("Unexpected", False)
			end
		end

	test_modular_inverse_2
		local
			r: RSA_EXTENDED_EUCLIDEAN
		do
			create r
			r.modular_inverse (42, 2017)
			assert ("expected inverse True", r.exist)
			assert ("expected inverse value 1969", r.last_inverse = 1969)

			r.modular_inverse (40, 1)
			assert ("expected value True", r.exist)
			assert ("expected value 0", r.last_inverse = 0)

			r.modular_inverse (52, -217)
			assert ("expected value True", r.exist)
			assert ("expected value 0", r.last_inverse = 96)


			r.modular_inverse (-486, 217)
			assert ("expected inverse True", r.exist)
			assert ("expected value 121", r.last_inverse = 121)

			r.modular_inverse (40, 2018)
			assert ("expected inverse False", not r.exist)
		end

	test_bits_integers
		do
			assert ("Expected 1", {RSA_UTILS}.bit_length (1) = 1)
			assert ("Expected 3", {RSA_UTILS}.bit_length (5) = 3)
			assert ("Expected 4", {RSA_UTILS}.bit_length (10) = 4)
		end


	test_generate_keys
		local
			rsa_gen: RSA_KEY_GENERATOR
			l_tuple: TUPLE [pub_key: detachable RSA_PUBLIC_KEY; priv_key: detachable RSA_PRIVATE_KEY; error: detachable STRING]
		do
			create rsa_gen
			l_tuple := rsa_gen.rsa_gen_keys (2048)
		end

end


