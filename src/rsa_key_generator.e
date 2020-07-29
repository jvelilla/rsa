note
	description: "Summary description for {RSA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RSA_KEY_GENERATOR

feature -- Access

	rsa_gen_keys (a_bits: NATURAL): TUPLE [pub_key: detachable RSA_PUBLIC_KEY; priv_key: detachable RSA_PRIVATE_KEY; error: detachable STRING]
			-- generates a public/private key pair for RSA encryption/decryption with the given bitlen `a_bits`. See RFC 2313 section 6.
		note
			eis: "name=Key generation","src=https://tools.ietf.org/html/rfc2313#section-6", "protocol=uri"
		require
			valid_bits: a_bits >= 1024
		local
            current_retries: INTEGER
            n: INTEGER_X
            p: INTEGER_X
            q: INTEGER_x
            e: INTEGER_X
            d: INTEGER_X
            totient: INTEGER_X
            error: STRING
            pub: RSA_PUBLIC_KEY
            priv: RSA_PRIVATE_KEY
            exit: BOOLEAN
            rsa: RSA_UTILS
            integerx_gcd: INTEGER_X
            one: INTEGER_X
        do
        	Result := [Void, Void, Void]
        	if not exit then
	        	create rsa
	        	Result := [Void, Void, Void]
	        	from
	        		create one
	        		create totient
	        		create integerx_gcd
	        		create e.make_from_integer (65537)
	        	until
					e.coprime (totient)  or else exit
				loop
	      			-- We need a result pq with a_bits bits, so we generate p and q with a_bits/2 bits each.
					-- If the top bit of p and q are set, the result will have b bits.
					-- Otherwise, we'll retry. rand.Prime should return primes with their top
					-- bit set, so in practice there will be no retries.
					create p.default_create
					create q.default_create
					if a_bits // 2 >= 2 then
						from
								-- add a secure random generator.
							create p.make_random_prime (((a_bits + 1) // 2).to_integer_32)
						until
							(p \\ e) /= one
						loop
							create p.make_random_prime (((a_bits + 1) // 2).to_integer_32)
							debug
								print ("p:" + p.out + "%N")
							end
						end
						print ("p:" + p.out + "%N")
					else
						exit := True
						error := "Not engouh bits"
						Result := [Void, Void, error]
					end
					if a_bits // 2 >= 2 then
						from
							create q.make_random_prime ((a_bits + 1 - a_bits // 2).to_integer_32)
						until
							(q \\ e) /= one
						loop
							create q.make_random_prime ((a_bits + 1 - a_bits // 2).to_integer_32)
						end
						print ("q:" + q.out + "%N")
					else
						exit := True
						error := "Not engouh bits"
						Result := [Void, Void, error]
					end
					n := p * q
					print ("Value of n: " + n.out + "%N")
					if not exit then
						-- theta(n) = (p-1)(q-1)
						p := p - 1
						q := q - 1
						totient := p * q
						print ("totient:" + p.out + "%N")

							-- https://tools.ietf.org/html/rfc2313#section-6
							-- The public exponent may be standardized in
	          				-- specific applications. The values 3 and F4 (65537) may have
	             			-- some practical advantages, as noted in X.509 Annex C.

							-- Calculate the modular multiplicative inverse of e such that:
							-- de = 1 (mod totient)
						if  e.coprime (totient) then
							print ("gcd is 1%N")
							d :=e.inverse_value (totient)
							print ("Modular inverse:" + d.out + "%N")
							create pub.make (n, e)
							create priv.make (p, q, n, e)
							Result := [pub, priv, Void]
							exit := True
						end
					end
				end
			end
		ensure
			instance_free: class
			rescue
				if not exit then
					retry
				end
	    end



	rsa_gen_keys2 (a_bits: INTEGER): TUPLE [pub_key: detachable RSA_PUBLIC_KEY; priv_key: detachable RSA_PRIVATE_KEY; error: detachable STRING]
			-- generates a public/private key pair for RSA encryption/decryption with the given bitlen `a_bits`. See RFC 2313 section 6.
		note
			eis: "name=Key generation","src=https://tools.ietf.org/html/rfc2313#section-6", "protocol=uri"
		require
			valid_bits: a_bits >= 4
		local
            current_retries: INTEGER
            n: INTEGER_64
            p: INTEGER_64
            q: INTEGER_64
            e: INTEGER_64
            d: INTEGER_64
            totient: INTEGER_64
            error: STRING
            pub: RSA_PUBLIC_KEY
            priv: RSA_PRIVATE_KEY
            exit: BOOLEAN
            rsa: RSA_UTILS
        do
        	create rsa
        	Result := [Void, Void, Void]
        	from
        		e := 65537
			until
				{RSA_UTILS}.gcd (e, totient) = 1 or else exit
			loop
      			-- We need a result pq with a_bits bits, so we generate p and q with a_bits/2 bits each.
				-- If the top bit of p and q are set, the result will have b bits.
				-- Otherwise, we'll retry. rand.Prime should return primes with their top
				-- bit set, so in practice there will be no retries.
				if a_bits // 2 >= 2 then
					from
						p := rsa.prime (a_bits // 2)
						debug
--							print ("p:" + p.out + "%N")
						end
					until
						(p \\ e) /=1
					loop
						p := rsa.prime (a_bits // 2)
						debug
							print ("p:" + p.out + "%N")
						end
					end
					print ("p:" + p.out + "%N")
				else
					exit := True
					error := "Not engouh bits"
					Result := [Void, Void, error]
				end
				if a_bits // 2 >= 2 then
					from
						q := rsa.prime (a_bits - a_bits // 2)
					until
						(q \\ e) /= 1
					loop
						q := rsa.prime (a_bits - a_bits // 2)
					end
					print ("q:" + q.out + "%N")
				else
					exit := True
					error := "Not engouh bits"
					Result := [Void, Void, error]
				end
				n := p*q
				print ("Value of n: " + n.out + "%N")
--				if {RSA_UTILS}.bit_length (n) = a_bits and not exit then
				if not exit then
					-- theta(n) = (p-1)(q-1)
					p := p - 1
					q := q - 1
					totient := p * q
					print ("totient:" + p.out + "%N")

						-- https://tools.ietf.org/html/rfc2313#section-6
						-- The public exponent may be standardized in
          				-- specific applications. The values 3 and F4 (65537) may have
             			-- some practical advantages, as noted in X.509 Annex C.

						-- Calculate the modular multiplicative inverse of e such that:
						-- de = 1 (mod totient)
					if {RSA_UTILS}.gcd (e, totient) = 1 then
						print ("gcd is 1%N")
						d :={RSA_UTILS}.modular_inverse (e, totient)
						print ("Modular inverse:" + d.out + "%N")
						create pub.make (n, e)
						create priv.make (p, q, n, e)
						Result := [pub, priv, Void]
					end
				end
			end
        end


end

