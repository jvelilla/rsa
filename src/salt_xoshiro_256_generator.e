note
	description: "Summary description for {SALT_XOSHIRO_256_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SALT_XOSHIRO_256_GENERATOR

inherit

	SALT_GENERATOR

create
	make

feature --{NONE} Implementation

	set_seed (a_seed: INTEGER)
			-- <Precursor>
		do
			create xoshiro.make (a_seed)
		end

	new_random: INTEGER_64
			-- <Precursor>
		do
			Result := xoshiro.random
		end

	xoshiro: XOSHIRO_256
		-- xoshiro random generator.

;note
	copyright: "Copyright (c) 1984-2013, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
