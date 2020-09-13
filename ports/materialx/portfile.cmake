include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO materialx/MaterialX
    REF 1f4aa75a610fe9dfa1cf62958ac04fdf7220631a #1.37.2
    SHA512 d1cdebcbefc065ea558dafff0a6cf3d434f3dda3d7272b504c77f38714586a395394e307a7357e44a1ed6f959b40cd3694cbe5ead69582db675ff2ace7bc023a
    HEAD_REF master
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    viewer MATERIALX_BUILD_VIEWER
    openimageio MATERIALX_BUILD_OIIO
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH cmake)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/resources)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/libraries)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/MaterialXRender/External)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
