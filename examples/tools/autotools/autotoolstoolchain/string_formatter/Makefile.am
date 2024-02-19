
cmake_version: 
	@source ./conanbuild.sh && cmake --version

# Ensure targets are not treated as a files
.PHONY: cmake_version

AUTOMAKE_OPTIONS = subdir-objects
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS}

bin_PROGRAMS = string_formatter
string_formatter_SOURCES = src/main.cpp
string_formatter_CPPFLAGS = $(fmt_CFLAGS)
string_formatter_LDADD = $(fmt_LIBS)
