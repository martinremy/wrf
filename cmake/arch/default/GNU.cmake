# WRF-CMake (https://github.com/WRF-CMake/wrf).
# Copyright 2018 M. Riechert and D. Meyer. Licensed under the MIT License.

set(debug "-g")
set(optimized "-O3")
set(temps "-save-temps")

if (CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
    set(other "-fallow-argument-mismatch -fallow-invalid-boz")
endif()
