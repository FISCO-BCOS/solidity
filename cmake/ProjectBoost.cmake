include(ExternalProject)
include(GNUInstallDirs)

set(BOOST_CXXFLAGS "")
if (WIN32)
    set(BOOST_BOOTSTRAP_COMMAND bootstrap.bat)
    set(BOOST_BUILD_TOOL b2.exe)
    set(BOOST_LIBRARY_SUFFIX -vc140-mt-1_63.lib)
else()
    set(BOOST_BOOTSTRAP_COMMAND ./bootstrap.sh)
    set(BOOST_BUILD_TOOL ./b2)
    set(BOOST_LIBRARY_SUFFIX .a)
    if (${BUILD_SHARED_LIBS})
        set(BOOST_CXXFLAGS "cxxflags=-fPIC")
    endif()
endif()

#set(BOOST_CXXFLAGS "cxxflags=-Wa,-march=generic64")
set(BOOST_CXXFLAGS "cxxflags=-fPIC")

ExternalProject_Add(boost
    PREFIX ${CMAKE_SOURCE_DIR}/deps
    DOWNLOAD_NO_PROGRESS 1
    URL http://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2
    URL_HASH SHA256=7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${BOOST_BOOTSTRAP_COMMAND}
    LOG_CONFIGURE 1
    BUILD_COMMAND ${BOOST_BUILD_TOOL} stage
        ${BOOST_CXXFLAGS}
        threading=multi
        link=static
        variant=release
        address-model=64
        --with-thread
        --with-date_time
        --with-system
        --with-regex
        --with-chrono 
        --with-filesystem 
        --with-program_options 
        --with-random
    LOG_BUILD 1
    INSTALL_COMMAND ""
)

ExternalProject_Get_Property(boost SOURCE_DIR)
set(Boost_INCLUDE_DIRS ${SOURCE_DIR})
set(Boost_LIBRARIES ${SOURCE_DIR}/stage/lib)
unset(BUILD_DIR)

add_library(Boost::Chrono STATIC IMPORTED)
set_property(TARGET Boost::Chrono PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_chrono${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Chrono boost)

add_library(Boost::DataTime STATIC IMPORTED)
set_property(TARGET Boost::DataTime PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_date_time${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::DataTime boost)

add_library(Boost::Regex STATIC IMPORTED)
set_property(TARGET Boost::Regex PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_regex${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Regex boost)

add_library(Boost::System STATIC IMPORTED)
set_property(TARGET Boost::System PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_system${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::System boost)

add_library(Boost::Filesystem STATIC IMPORTED)
set_property(TARGET Boost::Filesystem PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_filesystem${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Filesystem PROPERTY INTERFACE_LINK_LIBRARIES Boost::System)
add_dependencies(Boost::Filesystem boost)

add_library(Boost::Random STATIC IMPORTED)
set_property(TARGET Boost::Random PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_random${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Random boost)

add_library(Boost::ProgramOptions STATIC IMPORTED)
set_property(TARGET Boost::ProgramOptions PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_program_options${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::ProgramOptions boost)

add_library(Boost::UnitTestFramework STATIC IMPORTED)
set_property(TARGET Boost::UnitTestFramework PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_unit_test_framework${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::UnitTestFramework boost)

add_library(Boost::Thread STATIC IMPORTED)
set_property(TARGET Boost::Thread PROPERTY IMPORTED_LOCATION ${Boost_LIBRARIES}/libboost_thread${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Thread PROPERTY INTERFACE_LINK_LIBRARIES Boost::Chrono Boost::DataTime Boost::Regex)
add_dependencies(Boost::Thread boost)

set(Boost_FILESYSTEM_LIBRARIES Boost::Filesystem)
set(Boost_REGEX_LIBRARIES Boost::Regex)
set(Boost_SYSTEM_LIBRARIES Boost::System)
set(CMAKE_THREAD_LIBS_INIT Boost::Thread)
set(Boost_PROGRAM_OPTIONS_LIBRARIES Boost::ProgramOptions)