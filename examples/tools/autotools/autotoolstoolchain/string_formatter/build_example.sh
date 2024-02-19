#!/bin/bash

echo "Configure & Make part of the build"

./configure
make

# you can ignore conan's libs & tools env vars now, as we finished building
source ./deactivate_conanbuild.sh

# Make dynamic library available on PATH
source ./conanrun.sh

output=$(./string_formatter)

if [[ "$output" != 'Conan - The C++ Package Manager!' ]]; then
    echo "ERROR: The String Formatter output does not match with the expected value: 'Conan - The C++ Package Manager!'"
    exit 1
fi
