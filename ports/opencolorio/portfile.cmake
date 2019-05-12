# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)


vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO imageworks/OpenColorIO
    REF v1.1.1
    SHA512 bed722f9ddce1887d28aacef2882debccd7c3f3c0c708d2723fea58a097de9f02721af9e85453e089ffda5406aef593ab6536c6886307823c132aa787e492e33
    HEAD_REF master
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(BUILD_SHARED_LIBS OFF)
else()
    set(BUILD_SHARED_LIBS ON)
endif()



vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Create folders
file (MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
file (MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/opencolorio)
file (MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/opencolorio)

# Copy cmake files
file (RENAME ${CURRENT_PACKAGES_DIR}/cmake/OpenColorIO.cmake ${CURRENT_PACKAGES_DIR}/share/opencolorio/OpenColorIO.cmake)
file (RENAME ${CURRENT_PACKAGES_DIR}/cmake/OpenColorIO-release.cmake ${CURRENT_PACKAGES_DIR}/share/opencolorio/OpenColorIO-release.cmake)
file (RENAME ${CURRENT_PACKAGES_DIR}/OpenColorIOConfig.cmake ${CURRENT_PACKAGES_DIR}/share/opencolorio/OpenColorIOConfig.cmake)

# Copy all RELEASE exes to tools
file (RENAME ${CURRENT_PACKAGES_DIR}/bin/ociobakelut.exe ${CURRENT_PACKAGES_DIR}/tools/opencolorio/ociobakelut.exe)
file (RENAME ${CURRENT_PACKAGES_DIR}/bin/ociocheck.exe ${CURRENT_PACKAGES_DIR}/tools/opencolorio/ociocheck.exe)
file (RENAME ${CURRENT_PACKAGES_DIR}/bin/ocioconvert.exe ${CURRENT_PACKAGES_DIR}/tools/opencolorio/ocioconvert.exe)
file (RENAME ${CURRENT_PACKAGES_DIR}/bin/ociodisplay.exe ${CURRENT_PACKAGES_DIR}/tools/opencolorio/ociodisplay.exe)
file (RENAME ${CURRENT_PACKAGES_DIR}/bin/ociolutimage.exe ${CURRENT_PACKAGES_DIR}/tools/opencolorio/ociolutimage.exe)

# Remove unecessary debug files
file (REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file (REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file (REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)
file (REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/cmake)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/ociobakelut.exe)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/ociocheck.exe)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/ocioconvert.exe)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/ociodisplay.exe)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/ociolutimage.exe)
file (REMOVE ${CURRENT_PACKAGES_DIR}/debug/OpenColorIOConfig.cmake)


# Handle copyright
file (COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/opencolorio)
file (RENAME ${CURRENT_PACKAGES_DIR}/share/opencolorio/LICENSE ${CURRENT_PACKAGES_DIR}/share/opencolorio/copyright)

