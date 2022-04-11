include(point.cmake)

point(CREATE apple X 3 Y 4)

set(HEIGHT 	10)
set(WIDTH 	20)

point(CREATE head 	X 3)
point(CREATE t1 	X 2)
point(CREATE t2 	X 1)
set(snake head t1 t2)

set(dir_LEFT 	0)
set(dir_RIGHT 	1)
set(dir_UP 		2)
set(dir_DOWN 	3)
set(dir 		${dir_RIGHT})

function(draw)
	# Clear
	set(OUTPUT "")
	foreach(i RANGE 50)
		set(OUTPUT "${OUTPUT}\n")
	endforeach()

	# Main paint
	foreach(y RANGE ${HEIGHT})
		foreach(x RANGE ${WIDTH})

			# Draw snake tail
			set(is_snake OFF)
			foreach(i IN LISTS snake)
				if( (${i}_X EQUAL x) AND (${i}_Y EQUAL y) )
					set(OUTPUT "${OUTPUT}#")
					set(is_snake ON)
					break()

				endif()

			endforeach()	


			# Apple and spaces
			if(is_snake)
			elseif( (apple_X EQUAL x) AND (apple_Y EQUAL y) )
				set(OUTPUT "${OUTPUT}@")
			else()
				set(OUTPUT "${OUTPUT} ")
			endif()
	
		endforeach()

		# Output
		set(OUTPUT "${OUTPUT}\n")
	endforeach()

	message(${OUTPUT})
endfunction()


macro(key_update)
	exec_program(
		key_check.exe		"${CMAKE_CURRENT_SOURCE_DIR}"
		RETURN_VALUE 		RET	
	)


	if(${RET} EQUAL 65)#A
		set(dir ${dir_LEFT})
	elseif(${RET} EQUAL 68)#D
		set(dir ${dir_RIGHT})	
	elseif(${RET} EQUAL 87)#W
		set(dir ${dir_UP})	
	elseif(${RET} EQUAL 83)#S
		set(dir ${dir_DOWN})	
	endif()




	unset(RET)
endmacro()


macro(snake_update)
	# Head
	point(CREATE prev_head X ${head_X} Y ${head_Y})
	if(		dir EQUAL dir_RIGHT)
		math(EXPR new_X "${head_X} + 1")
		point(SET head X ${new_X})
		unset(new_X)
	elseif( dir EQUAL dir_LEFT)
		math(EXPR new_X "${head_X} - 1")
		point(SET head X ${new_X})
		unset(new_X)
	elseif( dir EQUAL dir_UP)
		math(EXPR new_Y "${head_Y} - 1")
		point(SET head Y ${new_Y})
		unset(new_Y)
	elseif( dir EQUAL dir_DOWN)
		math(EXPR new_Y "${head_Y} + 1")
		point(SET head Y ${new_Y})
		unset(new_Y)
	endif()

	# Tail change
	list(LENGTH snake size)
	math(EXPR size "${size} - 1")
	foreach(i RANGE ${size} 2 -1)
		math(EXPR next "${i} - 1")
		set(next "t${next}")
		point(SET t${i} X ${${next}_X} Y ${${next}_Y})
		unset(next)
	endforeach()
	unset(size)

	# Change of first tail point
	point(SET t1 X ${prev_head_X} Y ${prev_head_Y})

	unset(prev_head)
	unset(prev_head_Y)
	unset(prev_head_X)
endmacro()


function(main)
	while(ON)
		draw()
		key_update()
		snake_update()
	endwhile()




endfunction()







function(test)
	point(CREATE p X 6 Y 20)
	message("p = {${p_X}, ${p_Y}}")
	message("p = {${p}}")

	point(SET p X 100)
	message("p = {${p_X}, ${p_Y}}")
	message("p = {${p}}")

	point(SET p Y 200)
	message("p = {${p_X}, ${p_Y}}")
	message("p = {${p}}")

	point(SET p X 1000 Y 2000)
	message("p = {${p_X}, ${p_Y}}")
	message("p = {${p}}")
endfunction()

function(key_test)
while(ON)
	unset(OUT)

	exec_program(
		key_check.exe		"${CMAKE_CURRENT_SOURCE_DIR}"
		RETURN_VALUE 		RET	
	)

	#if(NOT(${RET} EQUAL 0))
		message(${RET})
	#endif()

endwhile()
endfunction()