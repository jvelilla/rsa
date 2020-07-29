note
	description: "test application root class"
	date: "$Date: 2019-09-11 18:27:54 +0000 (Wed, 11 Sep 2019) $"
	revision: "$Revision: 103504 $"

class
	APPLICATION

create
	make

feature  -- Initialization

	make
			-- Run application.
		do
--			print ({RSA_UTILS}.prime (1024))
--			print ("%N")
			test_generate_keys
----			test_primes
--			io.read_line
			test_xhosiro
		end

	test_shortshift
		do

		end

	test_generate_keys
		local
			key_gen: RSA_KEY_GENERATOR
			message: INTEGER_X
			cipher: INTEGER_X
			plain: INTEGER_X
			signature: INTEGER_X
			correct: BOOLEAN
			l_tuple: TUPLE [pub_key: detachable RSA_PUBLIC_KEY; priv_key: detachable RSA_PRIVATE_KEY; error: detachable STRING]
			a_message: STRING_8
			bytes_array: SPECIAL [NATURAL_8]
			i: INTEGER
		do
			a_message:="Message to encrypt"
			create bytes_array.make_filled (0, a_message.count)
			from
				i := 1
			until
				i > a_message.count
			loop
				bytes_array.force (a_message.at (i).code.to_natural_8, i - 1)
				i := i + 1
			end
			print ("%NInput bytes" + bytes_array.out)

			l_tuple := {RSA_KEY_GENERATOR}.rsa_gen_keys (2048)
			print ("%NTest")
			io.read_line
			if attached l_tuple.pub_key as pub_key and then attached l_tuple.priv_key as priv_key then
				create message.make_from_bytes (bytes_array, 0, bytes_array.count)
				cipher := pub_key.encrypt (message)
				print ("%NCyper")
				io.read_line
				plain :=  priv_key.decrypt (cipher)
				print ("%Nplain")
				io.read_line

				check
					same_value: plain ~ message
				end
				print ("%Nplain as bytes:" + plain.as_bytes.out)
				io.read_line
				signature := priv_key.sign (message)
				correct := pub_key.verify (message, signature)
				check
					value_true: correct = True
				end
			end

		end

	test_xhosiro
		local
			r:SALT_XOSHIRO_256_GENERATOR
		do
			create r.make (1024)
			across 1 |..| 100 as ic loop
				print (r.new_random)
				print ("%N")
			end

		end
note
	copyright: "Copyright (c) 1984-2019, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
