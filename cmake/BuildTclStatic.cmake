include(ExternalProject)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  ExternalProject_Add(tcl90b1-unix
    URL http://prdownloads.sourceforge.net/tcl/tcl90b1-src.zip
    URL_HASH MD5=0b1240690f483a85e60513d3312566bc
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/staging_dir
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )

  ExternalProject_Add_Step(tcl90b1-unix config-unix
    COMMAND ./configure --prefix=<INSTALL_DIR> --enable-shared=no $<$<CONFIG:Debug>:--enable-symbols>
    WORKING_DIRECTORY <SOURCE_DIR>/unix
    DEPENDEES download
  )

  ExternalProject_Add_Step(tcl90b1-unix build-unix
    COMMAND make
    WORKING_DIRECTORY <SOURCE_DIR>/unix
    DEPENDEES config-unix
  )

  ExternalProject_Add_Step(tcl90b1-unix install-unix
    COMMAND make install
    WORKING_DIRECTORY <SOURCE_DIR>/unix
    DEPENDEES build-unix
  )
  set(TCL_INCLUDE_PATH ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/include)
  set(TCL_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/lib/libtcl9.0.a m z)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  ExternalProject_Add(tcl90b1-win-debug
    URL http://prdownloads.sourceforge.net/tcl/tcl90b1-src.zip
    URL_HASH MD5=0b1240690f483a85e60513d3312566bc
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/debug
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )

  ExternalProject_Add_Step(tcl90b1-win-debug build-win-debug
    COMMAND nmake -f makefile.vc all OPTS=static,symbols,nomsvcrt
    WORKING_DIRECTORY <SOURCE_DIR>/win
    DEPENDEES configure
  )

  ExternalProject_Add_Step(tcl90b1-win-debug install-win-debug
    COMMAND nmake -f makefile.vc install INSTALLDIR=<INSTALL_DIR> OPTS=static,symbols,nomsvcrt
    WORKING_DIRECTORY <SOURCE_DIR>/win
    DEPENDEES build-win-debug
  )

  ExternalProject_Add(tcl90b1-win-release
    URL http://prdownloads.sourceforge.net/tcl/tcl90b1-src.zip
    URL_HASH MD5=0b1240690f483a85e60513d3312566bc
    DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/release
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )

  ExternalProject_Add_Step(tcl90b1-win-release build-win-release
    COMMAND nmake -f makefile.vc all OPTS=static,pdbs,nomsvcrt
    WORKING_DIRECTORY <SOURCE_DIR>/win
    DEPENDEES configure
  )

  ExternalProject_Add_Step(tcl90b1-win-release install-win-release
    COMMAND nmake -f makefile.vc install INSTALLDIR=<INSTALL_DIR> OPTS=static,pdbs,nomsvcrt
    WORKING_DIRECTORY <SOURCE_DIR>/win
    DEPENDEES build-win-release
  )

  set(TCL_INCLUDE_PATH ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/$<IF:$<CONFIG:Debug>,debug,release>/include)
  set(TCL_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/staging_dir/$<IF:$<CONFIG:Debug>,debug,release>/lib/tcl90s.lib netapi32.lib)
endif()
