note
	description: "Represents the public part of an RSA key. "
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Public Key", "src=https://tools.ietf.org/html/rfc2313#section-7.1", "protocol=uri"

class
	RSA_PUBLIC_KEY

inherit
	DEBUG_OUTPUT

create
	make

feature

	make (modulus_a: INTEGER_X exponent_a: INTEGER_X)
		do
			modulus := modulus_a
			exponent := exponent_a
		end

	verify (message: INTEGER_X signature: INTEGER_X): BOOLEAN
		do
			result := encrypt (signature) ~ message
		end

	encrypt (message: INTEGER_X): INTEGER_X
		do
			result := message.powm_value (exponent, modulus)
		end

feature

	modulus: INTEGER_X
	exponent: INTEGER_X

feature --{RSA_KEY_PAIR}--{DEBUG_OUTPUT}

	debug_output: STRING
		do
			result := "Modulus: 0x" + modulus.out_hex
		end

end
