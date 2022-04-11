include(point.cmake)

set(is_game_running TRUE)


# Constants
set(HEIGHT 		10)
set(WIDTH 		20)
set(APPLE_CHAR 	"@")
set(WALL_CHAR	"#")
set(TAIL_CHAR 	"#")
set(HEAD_CHAR 	"/")
set(VOID_CHAR 	" ")


# Snake
point(CREATE head 	X 3)
point(CREATE t1 	X 2)
point(CREATE t2 	X 1)
set(snake head t1 t2)


# Apple
point(CREATE apple X 3 Y 4)


# Dir enum
set(dir_LEFT 	0)
set(dir_RIGHT 	1)
set(dir_UP 		2)
set(dir_DOWN 	3)
set(dir 		${dir_RIGHT})


# Keys
set(key_A 65)
set(key_D 68)
set(key_W 87)
set(key_S 83)




function(draw)
	# Clear
	set(OUTPUT "")
	foreach(i RANGE 50)
		set(OUTPUT "${OUTPUT}\n")
	endforeach()


	# WALL
	foreach(i RANGE ${WIDTH})
		set(OUTPUT "${OUTPUT}${WALL_CHAR}")
	endforeach()
	set(OUTPUT "${OUTPUT}${WALL_CHAR}${WALL_CHAR}\n")


	# Main paint
	foreach(y RANGE ${HEIGHT})

		# WALL
		set(OUTPUT "${OUTPUT}${WALL_CHAR}")
		
		foreach(x RANGE ${WIDTH})

			# Draw snake tail
			set(is_snake OFF)
			foreach(i IN LISTS snake)
				if( (${i}_X EQUAL x) AND (${i}_Y EQUAL y) )
					message(${i})
					if( "${i}" STREQUAL "head" )
						set(OUTPUT "${OUTPUT}${HEAD_CHAR}")
					else()
						set(OUTPUT "${OUTPUT}${TAIL_CHAR}")
					endif()
					set(is_snake ON)
					break()

				endif()

			endforeach()	


			# Apple and spaces
			if(is_snake)
			elseif( (apple_X EQUAL x) AND (apple_Y EQUAL y) )
				set(OUTPUT "${OUTPUT}${APPLE_CHAR}")
			else()
				set(OUTPUT "${OUTPUT}${VOID_CHAR}")
			endif()
	
		endforeach()

		# WALL, NEXT LINE
		set(OUTPUT "${OUTPUT}${WALL_CHAR}\n")
	endforeach()

	# WALL
	foreach(i RANGE ${WIDTH})
		set(OUTPUT "${OUTPUT}${WALL_CHAR}")
	endforeach()
	set(OUTPUT "${OUTPUT}${WALL_CHAR}${WALL_CHAR}")


	# Output
	message(${OUTPUT})
endfunction()


macro(key_update)
	exec_program(
		key_check.exe		"${CMAKE_CURRENT_SOURCE_DIR}"
		RETURN_VALUE 		RET	
	)


	if(		${RET} EQUAL ${key_A})
		set(dir ${dir_LEFT})
	
	elseif(	${RET} EQUAL ${key_D})
		set(dir ${dir_RIGHT})	
	
	elseif(	${RET} EQUAL ${key_W})
		set(dir ${dir_UP})	
	
	elseif(	${RET} EQUAL ${key_S})
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
		point(SET t${i} X ${t${next}_X} Y ${t${next}_Y})
	endforeach()
	unset(size)

	# Change of first tail point
	point(SET t1 X ${prev_head_X} Y ${prev_head_Y})

	unset(prev_head)
	unset(prev_head_Y)
	unset(prev_head_X)
endmacro()


macro(apple_check)
	if( ( head_X EQUAL apple_X) AND ( head_Y EQUAL apple_Y ) )
		list(LENGTH snake size)

		point(CREATE t${size} X 0 Y 0)
		list(APPEND snake t${size})

		while(TRUE)
			string(RANDOM LENGTH 2 ALPHABET "1234567890" ax)
			string(RANDOM LENGTH 2 ALPHABET "1234567890" ay)
			if( NOT((ax GREATER WIDTH) OR (ax LESS 0) OR (ay GREATER HEIGHT) OR (ay LESS 0)) )
				break()
			endif()
		endwhile()
		point(SET apple X ${ax} Y ${ay})	

		unset(ax)
		unset(ay)
		unset(size)
	endif()
endmacro()


macro(wall_tail_check)
	# Wall update
	if( (head_X GREATER WIDTH) OR (head_X LESS 0) OR (head_Y GREATER HEIGHT) OR (head_Y LESS 0) )
		set(is_game_running FALSE)
	endif()


	# Tail
	list(LENGTH snake size)
	math(EXPR size "${size} - 1")
	foreach(i RANGE 1 ${size})
		if( (${t${i}_X} EQUAL head_X) AND (${t${i}_Y} EQUAL head_Y) )
			set(is_game_running FALSE) 	
		endif()
	endforeach()
	unset(size)
endmacro()


function(main)
	while(${is_game_running})
		draw()
		wall_tail_check()
		apple_check()
		key_update()
		snake_update()
	endwhile()

	message("GAME OVER!!!")
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