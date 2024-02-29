vcpkg_download_distfile(
    ARCHIVE
    URLS https://www.freetds.org/files/stable/freetds-1.4.10.tar.gz
    FILENAME freetds-1.4.10.tar.gz
    SHA512 9787c81d6c978f93840e1742592bfd74d00f3ebc4ee66c7bf93464b8ef74f5d94d438907cee3daf1759b753c30c8d938bb67cb9edf7174a1e9117f2bf3ec49a8
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        --disable-sspi
        --disable-odbc
        --disable-apps
        --disable-server
        --disable-pool
        --disable-msdblib
        --enable-sybase-compat
        --disable-mars
        --disable-odbc-wide
        --without-openssl
)

vcpkg_build_make()
vcpkg_execute_required_process(
    COMMAND make V=1 install prefix=${CURRENT_PACKAGES_DIR}
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
    LOGNAME "install-${TARGET_TRIPLET}-rel"
)

vcpkg_execute_required_process(
    COMMAND make V=1 install "prefix=${CURRENT_PACKAGES_DIR}/debug"
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
    LOGNAME "install-${TARGET_TRIPLET}-dbg"
)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/etc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/etc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING_LIB.txt")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# Generate cmake CONFIG file
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    set(FREETDS_WITH_DEBUG ON)
else()
    set(FREETDS_WITH_DEBUG OFF)
endif()
configure_file("${CMAKE_CURRENT_LIST_DIR}/degaart-freetdsConfig.cmake.in" "${CURRENT_PACKAGES_DIR}/share/${PORT}/degaart-freetdsConfig.cmake" @ONLY)

