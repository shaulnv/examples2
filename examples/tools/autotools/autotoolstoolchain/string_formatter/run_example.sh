#!/bin/bash

echo "- AutotoolsToolchain: The toolchain generator for Autotools -"

set -ex

# Remove cache
rm -rf conanbuild* conanrun* conanauto* deactivate* *.pc aclocal* auto* config.* Makefile.in depcomp install-sh missing Makefile configure string_formatter

# Then generate conanbuild.sh
if [[ ! -e .venv ]]; then
  python3 -m pip install virtualenv --target .conan
  .conan/bin/virtualenv .venv
  source .venv/bin/activate
  pip install conan
  deactivate
fi
source .venv/bin/activate
conan install --requires cmake/3.28.1 -of . -pr:b centos7.profile -pr:h centos7.profile
source ./conanbuild.sh
source ./conanrun.sh
conan install -r conancenter . --build=missing -of . -pr:b centos7.profile -pr:h centos7.profile
deactivate
source ./conanbuild.sh
source ./conanrun.sh

# Build the example
aclocal 
automake --add-missing 
autoconf
./configure
make

source ./deactivate_conanbuild.sh

# Make dynamic library available on PATH
source ./conanrun.sh

output=$(./string_formatter)

if [[ "$output" != 'Conan - The C++ Package Manager!' ]]; then
    echo "ERROR: The String Formatter output does not match with the expected value: 'Conan - The C++ Package Manager!'"
    exit 1
fi

echo 'AutotoolsToolchain example has been executed with SUCCESS!'
exit 0
