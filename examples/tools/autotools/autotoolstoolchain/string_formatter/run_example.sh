#!/bin/bash

echo "- AutotoolsToolchain: The toolchain generator for Autotools -"

set -ex

# Remove cache
rm -rf conanbuild* conanrun* conanauto* deactivate* *.pc aclocal* auto* config.* Makefile.in depcomp install-sh missing Makefile configure string_formatter

# Then generate conanbuild.sh
if [[ ! -e .conan/bin/conan ]]; then
  pip install conan --target .conan
  .conan/bin/conan profile detect -f
  .conan/bin/conan install --requires cmake/3.28.1 -of build
  source ./build/conanbuild.sh
fi
.conan/bin/conan install -r conancenter . --build=missing -of build
source build/conanbuild.sh

# Build the example
aclocal 
automake --add-missing 
autoconf
./configure
make

source build/deactivate_conanbuild.sh

# Make dynamic library available on PATH
source build/conanrun.sh

output=$(./string_formatter)

if [[ "$output" != 'Conan - The C++ Package Manager!' ]]; then
    echo "ERROR: The String Formatter output does not match with the expected value: 'Conan - The C++ Package Manager!'"
    exit 1
fi

echo 'AutotoolsToolchain example has been executed with SUCCESS!'
exit 0
