cmake_policy(SET CMP0007 NEW) # ignore empty list elements

file(READ ${NAME}.spv SPV_CONTENT HEX)
string(REGEX REPLACE "([0-9a-fA-F][0-9a-fA-F])" "0x\\1;" SPV_HEXBYTES "${SPV_CONTENT}")
# message(STATUS "${SPV_HEXBYTES}")

make_directory("${BUILD}")

list(LENGTH SPV_HEXBYTES NUM_BYTES)
math(EXPR NUM_BYTES "${NUM_BYTES} - 1")

file(WRITE ${BUILD}/${NAME}.cpp "extern const unsigned char ${NAME}[${NUM_BYTES}]{")
foreach(BYTE ${SPV_HEXBYTES})
	file(APPEND ${BUILD}/${NAME}.cpp "${BYTE}, ")
endforeach()
file(APPEND ${BUILD}/${NAME}.cpp "};")

file(WRITE ${BUILD}/${NAME}.hpp "\
#ifndef ${NAME}_HPP\n\
#define ${NAME}_HPP\n\
extern const unsigned char ${NAME}[${NUM_BYTES}];
#endif\n")
