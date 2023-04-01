cmake_minimum_required(VERSION 3.15)
project(embedspv)

set(SHADER_EMBED_SOURCES)
make_directory(${CMAKE_BINARY_DIR}/shader)
function(compile_embed_shader NAME)
	add_custom_command(
		OUTPUT ${CMAKE_BINARY_DIR}/shader/${NAME}.cpp
		       ${CMAKE_BINARY_DIR}/shader/${NAME}.hpp
		COMMAND ${CMAKE_COMMAND} -DNAME=${NAME} -DBUILD=${CMAKE_BINARY_DIR}/shader -P ${CMAKE_SOURCE_DIR}/incbin.cmake
		DEPENDS ${CMAKE_SOURCE_DIR}/${NAME}.spv
		        ${CMAKE_SOURCE_DIR}/incbin.cmake
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		COMMENT "Generating shader/${NAME}.cpp"
	)
	list(
		APPEND SHADER_EMBED_SOURCES
		${CMAKE_BINARY_DIR}/shader/${NAME}.cpp
		${CMAKE_BINARY_DIR}/shader/${NAME}.hpp
	)
	set(SHADER_EMBED_SOURCES ${SHADER_EMBED_SOURCES} PARENT_SCOPE)
endfunction()

compile_embed_shader(shader_a)
compile_embed_shader(shader_b)

add_executable(embedspv embedspv.cpp ${SHADER_EMBED_SOURCES})
target_include_directories(embedspv PRIVATE ${CMAKE_BINARY_DIR})
