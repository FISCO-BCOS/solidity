include(ExternalProject)
include(GNUInstallDirs)

set(BOOST_CXXFLAGS "")
if (WIN32)
    set(BOOST_BOOTSTRAP_COMMAND bootstrap.bat)
    set(BOOST_BUILD_TOOL b2.exe)
    set(BOOST_LIBRARY_SUFFIX -vc141-mt-x64-1_68.lib)
else()
    set(BOOST_BOOTSTRAP_COMMAND ./bootstrap.sh)
    set(BOOST_BUILD_TOOL ./b2)
    set(BOOST_LIBRARY_SUFFIX .a)
    if (${BUILD_SHARED_LIBS})
        set(BOOST_CXXFLAGS "cxxflags=-fPIC")
    endif()
endif()

#set(BOOST_CXXFLAGS "cxxflags=-Wa,-march=generic64")
if(APPLE)
    set(BOOST_CXXFLAGS "cxxflags=-fPIC -std=c++14")
else()
    set(BOOST_CXXFLAGS "cxxflags=-fPIC")
endif()

ExternalProject_Add(boost
    PREFIX ${CMAKE_SOURCE_DIR}/deps
    DOWNLOAD_NO_PROGRESS 1
    URL https://nchc.dl.sourceforge.net/project/boost/boost/1.68.0/boost_1_68_0.tar.bz2
        http://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2
        https://raw.githubusercontent.com/FISCO-BCOS/LargeFiles/master/libs/boost_1_68_0.tar.bz2
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
set(BOOST_INCLUDE_DIR ${SOURCE_DIR})
set(BOOST_LIB_DIR ${SOURCE_DIR}/stage/lib)

add_library(Boost::system STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::system PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_system${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::system PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
add_dependencies(Boost::system boost)

add_library(Boost::Chrono STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Chrono PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_chrono${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Chrono boost)

add_library(Boost::DataTime STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::DataTime PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_date_time${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::DataTime PROPERTY INTERFACE_LINK_LIBRARIES Boost::system)
add_dependencies(Boost::DataTime boost)

add_library(Boost::Regex STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Regex PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_regex${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Regex PROPERTY INTERFACE_LINK_LIBRARIES Boost::system)
add_dependencies(Boost::Regex boost)

add_library(Boost::filesystem STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::filesystem PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_filesystem${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::filesystem PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
set_property(TARGET Boost::filesystem PROPERTY INTERFACE_LINK_LIBRARIES Boost::system)
add_dependencies(Boost::filesystem boost)

add_library(Boost::Random STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Random PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_random${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Random boost)

add_library(Boost::unit_test_framework STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::unit_test_framework PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_unit_test_framework${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::unit_test_framework PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
add_dependencies(Boost::unit_test_framework boost)

add_library(Boost::Thread STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Thread PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_thread${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Thread PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
set_property(TARGET Boost::Thread PROPERTY INTERFACE_LINK_LIBRARIES Boost::Chrono Boost::DataTime Boost::Regex)
add_dependencies(Boost::Thread boost)

add_library(Boost::program_options STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::program_options PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_program_options${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::program_options PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
add_dependencies(Boost::program_options boost)

add_library(Boost::Log STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Log PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_log${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Log PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
set_property(TARGET Boost::Log PROPERTY INTERFACE_LINK_LIBRARIES Boost::Filesystem Boost::Thread)
add_dependencies(Boost::Log boost)

add_library(Boost::Serialization STATIC IMPORTED GLOBAL)
set_property(TARGET Boost::Serialization PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_serialization${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Serialization PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${BOOST_INCLUDE_DIR})
add_dependencies(Boost::Serialization boost)

unset(SOURCE_DIR)
