#!/bin/bash

echo "- AutotoolsToolchain: The toolchain generator for Autotools -"

set -ex

# Remove cache
rm -rf conanbuild* conanrun* conanauto* deactivate* *.pc aclocal* auto* config.* Makefile.in depcomp install-sh missing Makefile configure string_formatter

# auto-gen the example
aclocal 
automake --add-missing 
autoconf

# Then generate conanbuild.sh
if [ ! -e .venv ]; then
  python3 -m pip install virtualenv --target .conan
  .conan/bin/virtualenv .venv
  . .venv/bin/activate
  pip install conan
  conan profile detect -f
  deactivate
fi
. .venv/bin/activate
conan install -r conancenter . --build=missing -of . -pr:b cpp11.profile -pr:h cpp11.profile
deactivate

# the configure script knows how to find all the 3rd parties libreries/tools we depend on
# this is a hack to add the conan's package install script to the 'configure' script
# if we could source it before we call 'configure', we will not need it here
sed -i '1 a\. ./conanbuild.sh' configure

echo 'AutotoolsToolchain example has been generated. SUCCESS!'
exit 0
