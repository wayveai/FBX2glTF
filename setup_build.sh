# Set up environment to be able to build

if [[ "$OSTYPE" == "darwin"* ]]; then
    export CONAN_CONFIG="-s compiler=apple-clang -s compiler.version=10.0 -s compiler.libcxx=libc++"
    export FBXSDK_TARBALL="https://github.com/zellski/FBXSDK-Darwin/archive/2019.2.tar.gz"
    export BUILD_FILE_NAME=bin/darwin
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
pip install conan # or sometimes just "pip"; you may need to install Python/PIP
conan remote add --force bincrafters https://bincrafters.jfrog.io/artifactory/api/conan/public-conan
conan config set general.revisions_enabled=1

# Initialize and run build
conan install . -i ${BUILD_FILE_NAME} -s build_type=Release ${CONAN_CONFIG} --build missing
conan build . -bf ${BUILD_FILE_NAME}