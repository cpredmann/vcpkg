## # vcpkg_common_definitions
##
## File contains helpful variabls for portfiles which are commonly needed or used.
##
## ## The following variables are available:
## ```cmake
## VCPKG_TARGET_IS_<target>                 with <target> being one of the following: WINDOWS, UWP, LINUX, OSX, ANDROID, FREEBSD. only defined if <target>
## VCPKG_HOST_PATH_SEPARATOR                Host specific path separator (USAGE: "<something>${VCPKG_HOST_PATH_SEPARATOR}<something>"; only use and pass variables with VCPKG_HOST_PATH_SEPARATOR within "")
## VCPKG_HOST_EXECUTABLE_SUFFIX             executable suffix of the host
## VCPKG_TARGET_EXECUTABLE_SUFFIX           executable suffix of the target
## VCPKG_TARGET_STATIC_LIBRARY_PREFIX       static library prefix for target (same as CMAKE_STATIC_LIBRARY_PREFIX)
## VCPKG_TARGET_STATIC_LIBRARY_SUFFIX       static library suffix for target (same as CMAKE_STATIC_LIBRARY_SUFFIX)
## VCPKG_TARGET_SHARED_LIBRARY_PREFIX       shared library prefix for target (same as CMAKE_SHARED_LIBRARY_PREFIX)
## VCPKG_TARGET_SHARED_LIBRARY_SUFFIX       shared library suffix for target (same as CMAKE_SHARED_LIBRARY_SUFFIX)
## VCPKG_TARGET_IMPORT_LIBRARY_PREFIX       import library prefix for target (same as CMAKE_IMPORT_LIBRARY_PREFIX)
## VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX       import library suffix for target (same as CMAKE_IMPORT_LIBRARY_SUFFIX)
## VCPKG_FIND_LIBRARY_PREFIXES              target dependent prefixes used for find_library calls in portfiles
## VCPKG_FIND_LIBRARY_SUFFIXES              target dependent suffixes used for find_library calls in portfiles
## VCPKG_SYSTEM_LIBRARIES                   list of libraries are provide by the toolchain and are not managed by vcpkg
## ```
##
## CMAKE_STATIC_LIBRARY_(PREFIX|SUFFIX), CMAKE_SHARED_LIBRARY_(PREFIX|SUFFIX) and CMAKE_IMPORT_LIBRARY_(PREFIX|SUFFIX) are defined for the target
## Furthermore the variables CMAKE_FIND_LIBRARY_(PREFIXES|SUFFIXES) are also defined for the target so that
## portfiles are able to use find_library calls to discover dependent libraries within the current triplet for ports.
##

#Helper variable to identify the Target system. VCPKG_TARGET_IS_<targetname>
if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    set(VCPKG_TARGET_IS_WINDOWS 1)
    if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
        set(VCPKG_TARGET_IS_UWP 1)
    endif()
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(VCPKG_TARGET_IS_OSX 1)
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(VCPKG_TARGET_IS_IOS 1)
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(VCPKG_TARGET_IS_LINUX 1)
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Android")
    set(VCPKG_TARGET_IS_ANDROID 1)
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    set(VCPKG_TARGET_IS_FREEBSD 1)
elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "MinGW")
    set(VCPKG_TARGET_IS_WINDOWS 1)
    set(VCPKG_TARGET_IS_MINGW 1)
endif()

#Helper variable to identify the host path separator.
if(CMAKE_HOST_WIN32)
    set(VCPKG_HOST_PATH_SEPARATOR ";")
elseif(CMAKE_HOST_UNIX)
    set(VCPKG_HOST_PATH_SEPARATOR ":")
endif()

#Helper variables to identify executables on host/target
if(CMAKE_HOST_WIN32)
    set(VCPKG_HOST_EXECUTABLE_SUFFIX ".exe")
else()
    set(VCPKG_HOST_EXECUTABLE_SUFFIX "")
endif()
#set(CMAKE_EXECUTABLE_SUFFIX ${VCPKG_HOST_EXECUTABLE_SUFFIX}) not required by find_program

if(VCPKG_TARGET_IS_WINDOWS)
    set(VCPKG_TARGET_EXECUTABLE_SUFFIX ".exe")
else()
    set(VCPKG_TARGET_EXECUTABLE_SUFFIX "")
endif()

#Helper variables for libraries
if(VCPKG_TARGET_IS_MINGW)
    set(VCPKG_TARGET_STATIC_LIBRARY_SUFFIX ".a")
    set(VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX ".dll.a")
    set(VCPKG_TARGET_SHARED_LIBRARY_SUFFIX ".dll")
    set(VCPKG_TARGET_STATIC_LIBRARY_PREFIX "lib")
    set(VCPKG_TARGET_SHARED_LIBRARY_PREFIX "lib")
    set(VCPKG_TARGET_IMPORT_LIBRARY_PREFIX "lib")
    set(VCPKG_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")
    set(VCPKG_FIND_LIBRARY_PREFIXES "lib" "")
elseif(VCPKG_TARGET_IS_WINDOWS)
    set(VCPKG_TARGET_STATIC_LIBRARY_SUFFIX ".lib")
    set(VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX ".lib")
    set(VCPKG_TARGET_SHARED_LIBRARY_SUFFIX ".dll")
    set(VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX ".lib")
    set(VCPKG_TARGET_STATIC_LIBRARY_PREFIX "")
    set(VCPKG_TARGET_SHARED_LIBRARY_PREFIX "")
    set(VCPKG_TARGET_IMPORT_LIBRARY_PREFIX "")
    set(VCPKG_FIND_LIBRARY_SUFFIXES ".lib" ".dll") #This is a slight modification to CMakes value which does not include ".dll".
    set(VCPKG_FIND_LIBRARY_PREFIXES "" "lib") #This is a slight modification to CMakes value which does not include "lib".
elseif(VCPKG_TARGET_IS_OSX)
    set(VCPKG_TARGET_STATIC_LIBRARY_SUFFIX ".a")
    set(VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX "")
    set(VCPKG_TARGET_SHARED_LIBRARY_SUFFIX ".dylib")
    set(VCPKG_TARGET_STATIC_LIBRARY_PREFIX "lib")
    set(VCPKG_TARGET_SHARED_LIBRARY_PREFIX "lib")
    set(VCPKG_FIND_LIBRARY_SUFFIXES ".tbd" ".dylib" ".so" ".a")
    set(VCPKG_FIND_LIBRARY_PREFIXES "lib" "")
else()
    set(VCPKG_TARGET_STATIC_LIBRARY_SUFFIX ".a")
    set(VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX "")
    set(VCPKG_TARGET_SHARED_LIBRARY_SUFFIX ".so")
    set(VCPKG_TARGET_STATIC_LIBRARY_PREFIX "lib")
    set(VCPKG_TARGET_SHARED_LIBRARY_PREFIX "lib")
    set(VCPKG_FIND_LIBRARY_SUFFIXES ".so" ".a")
    set(VCPKG_FIND_LIBRARY_PREFIXES "lib" "")
endif()
#Setting these variables allows find_library to work in script mode and thus in portfiles!
#This allows us scale down on hardcoded target dependent paths in portfiles
set(CMAKE_STATIC_LIBRARY_SUFFIX "${VCPKG_TARGET_STATIC_LIBRARY_SUFFIX}")
set(CMAKE_SHARED_LIBRARY_SUFFIX "${VCPKG_TARGET_SHARED_LIBRARY_SUFFIX}")
set(CMAKE_IMPORT_LIBRARY_SUFFIX "${VCPKG_TARGET_IMPORT_LIBRARY_PREFIX}")
set(CMAKE_STATIC_LIBRARY_PREFIX "${VCPKG_TARGET_STATIC_LIBRARY_PREFIX}")
set(CMAKE_SHARED_LIBRARY_PREFIX "${VCPKG_TARGET_SHARED_LIBRARY_PREFIX}")
set(CMAKE_IMPORT_LIBRARY_PREFIX "${VCPKG_TARGET_IMPORT_LIBRARY_SUFFIX}")

set(CMAKE_FIND_LIBRARY_SUFFIXES "${VCPKG_FIND_LIBRARY_SUFFIXES}" CACHE INTERNAL "") # Required by find_library
set(CMAKE_FIND_LIBRARY_PREFIXES "${VCPKG_FIND_LIBRARY_PREFIXES}" CACHE INTERNAL "") # Required by find_library

# Append platform libraries to VCPKG_SYSTEM_LIBRARIES
# The variable are just appended to permit to custom triplets define the variable

# Platforms with libdl
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_OSX)
    list(APPEND VCPKG_SYSTEM_LIBRARIES dl)
endif()

# Platforms with libm
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_FREEBSD OR VCPKG_TARGET_IS_OSX)
    list(APPEND VCPKG_SYSTEM_LIBRARIES m)
endif()

# Platforms with pthread
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_FREEBSD OR VCPKG_TARGET_IS_MINGW)
    list(APPEND VCPKG_SYSTEM_LIBRARIES pthread)
endif()

# Platforms with libstdc++
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_FREEBSD OR VCPKG_TARGET_IS_MINGW)
    list(APPEND VCPKG_SYSTEM_LIBRARIES [=[stdc\+\+]=])
endif()

# Platforms with libc++
if(VCPKG_TARGET_IS_OSX)
    list(APPEND VCPKG_SYSTEM_LIBRARIES [=[c\+\+]=])
endif()

# Platforms with librt
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_FREEBSD OR VCPKG_TARGET_IS_MINGW)
    list(APPEND VCPKG_SYSTEM_LIBRARIES rt)
endif()

# Platforms with GCC libs
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID OR VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_FREEBSD OR VCPKG_TARGET_IS_MINGW)
    list(APPEND VCPKG_SYSTEM_LIBRARIES gcc)
    list(APPEND VCPKG_SYSTEM_LIBRARIES gcc_s)
endif()

# Platforms with system iconv
if(VCPKG_TARGET_IS_OSX)
    list(APPEND VCPKG_SYSTEM_LIBRARIES iconv)
endif()

# Windows system libs
if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND VCPKG_SYSTEM_LIBRARIES advapi32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES bcrypt)
    list(APPEND VCPKG_SYSTEM_LIBRARIES dinput8)
    list(APPEND VCPKG_SYSTEM_LIBRARIES gdi32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES imm32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES oleaut32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES ole32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES psapi)
    list(APPEND VCPKG_SYSTEM_LIBRARIES secur32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES setupapi)
    list(APPEND VCPKG_SYSTEM_LIBRARIES shell32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES shlwapi)
    list(APPEND VCPKG_SYSTEM_LIBRARIES strmiids)
    list(APPEND VCPKG_SYSTEM_LIBRARIES user32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES uuid)
    list(APPEND VCPKG_SYSTEM_LIBRARIES version)
    list(APPEND VCPKG_SYSTEM_LIBRARIES vfw32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES winmm)
    list(APPEND VCPKG_SYSTEM_LIBRARIES wsock32)
    list(APPEND VCPKG_SYSTEM_LIBRARIES Ws2_32)
endif()
