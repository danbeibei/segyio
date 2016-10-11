function(to_path_list var path1)
    if("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
        set(sep "\\;")
    else()
        set(sep ":")
    endif()
    set(result "${path1}") # First element doesn't require separator at all...
    foreach(path ${ARGN})
        set(result "${result}${sep}${path}") # .. but other elements do.
    endforeach()
    set(${var} "${result}" PARENT_SCOPE)
endfunction()

function(add_memcheck_test NAME BINARY)
    # Valgrind on MacOS is experimental
    if(LINUX AND (${CMAKE_BUILD_TYPE} MATCHES "DEBUG"))
        set(memcheck_command "valgrind --trace-children=yes --leak-check=full --error-exitcode=31415")
        separate_arguments(memcheck_command)
        add_test(memcheck_${NAME} ${memcheck_command} ./${BINARY})
    endif()
endfunction(add_memcheck_test)

function(add_segyio_test TESTNAME TEST_SOURCES)
    add_executable(test_${TESTNAME} unittest.h "${TEST_SOURCES}")
    target_link_libraries(test_${TESTNAME} segyio-static m)
    add_dependencies(test_${TESTNAME} segyio-static)
    add_test(NAME ${TESTNAME} COMMAND ${EXECUTABLE_OUTPUT_PATH}/test_${TESTNAME})
    add_memcheck_test(${TESTNAME} ${EXECUTABLE_OUTPUT_PATH}/test_${TESTNAME})
endfunction()
