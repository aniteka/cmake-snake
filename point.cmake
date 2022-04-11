
macro(point)
	cmake_parse_arguments(_ 
		"CREATE;SET" 
		"X;Y" 
		"___" 
		${ARGN}
	)

	if(__CREATE)
		if(NOT(DEFINED __X))
			set(__X 0)
		endif()
		if(NOT(DEFINED __Y))
			set(__Y 0)
		endif()

		set(${ARGV1} ${__X};${__Y})
		
		set("${ARGV1}_X" ${__X})
		set("${ARGV1}_Y" ${__Y})

	elseif(__SET)
		if(DEFINED __X)
			set(${ARGV1} ${__X};${${ARGV1}_Y})
			set("${ARGV1}_X" ${__X})
		endif()

		if(DEFINED __Y)
			set(${ARGV1} ${${ARGV1}_X};${${__Y}})
			set("${ARGV1}_Y" ${__Y})
		endif()

	endif()

	unset(__CREATE)
	unset(__SET)
	unset(__Y)
	unset(__X)
	unset(____)
endmacro()
