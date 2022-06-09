
if [[ "$OSTYPE" == "darwin"* ]]; then
    export BUILD_FILE_NAME=bin/darwin
elif [[ "$OSTYPE" == "linux"* ]]; then
    export BUILD_FILE_NAME=bin/linux
else
    echo "This snippet only handles Mac OS X and Linux."
fi

conan build . -bf ${BUILD_FILE_NAME}

cp "${BUILD_FILE_NAME}/FBX2glTF" "../WayveSimAssets/${BUILD_FILE_NAME}"
