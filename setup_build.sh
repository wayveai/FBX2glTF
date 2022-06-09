#!/bin/bash

# Set up environment to be able to build

if [[ "$OSTYPE" == "darwin"* ]]; then
    export CONAN_CONFIG="-s compiler=apple-clang -s compiler.version=13.1 -s compiler.libcxx=libc++ -s arch=x86_64 -s arch_target=x86_64 -s arch_build=x86_64"
    export FBXSDK_TARBALL="https://github.com/zellski/FBXSDK-Darwin/archive/2019.2.tar.gz"
    export BUILD_FILE_NAME=bin/darwin
    export CFLAGS="$CFLAGS -DHAVE_UNISTD_H"
    export BUILD_FOLDER=build
elif [[ "$OSTYPE" == "linux"* ]]; then
    export CONAN_CONFIG="-s compiler.libcxx=libstdc++11"
    export FBXSDK_TARBALL="https://github.com/zellski/FBXSDK-Linux/archive/2019.2.tar.gz"
    export BUILD_FILE_NAME=bin/linux
else
    echo "This snippet only handles Mac OS X and Linux."
fi

# Fetch and unpack FBX SDK
curl -sL "${FBXSDK_TARBALL}" | tar xz --strip-components=1 --include */sdk/
# Then decompress the contents
zstd -d -r --rm sdk

# Install and configure Conan, if needed
pip install conan # or sometimes "pip3"; you may need to install Python/PIP
conan remote add --force bincrafters https://bincrafters.jfrog.io/artifactory/api/conan/public-conan
conan config set general.revisions_enabled=1

# Initialize and run build
mkdir -p ${BUILD_FILE_NAME}
mkdir -p ${BUILD_FOLDER}
conan install . -if ${BUILD_FILE_NAME} -of ${BUILD_FOLDER} -s build_type=Release ${CONAN_CONFIG} --build=missing
conan build . -bf ${BUILD_FILE_NAME}

cp "${BUILD_FILE_NAME}/FBX2glTF" "../WayveSimAssets/${BUILD_FILE_NAME}"
