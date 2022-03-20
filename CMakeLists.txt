cmake_minimum_required(VERSION 3.16)

project(shoppinglist VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick QuickControls2 REQUIRED)

qt_add_executable(appshoppinglist
    main.cpp
    singleton.h
    singleton.cpp
)

qt_add_qml_module(appshoppinglist
    URI shoppinglist
    VERSION 1.0
    QML_FILES main.qml 
)

qt_add_resources(RCC_SOURCES app.qrc)

set_target_properties(appshoppinglist PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER fr.xavi-b.shoppinglist
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)

target_compile_definitions(appshoppinglist
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appshoppinglist
    PRIVATE Qt6::Quick
    PRIVATE Qt6::QuickControls2)
