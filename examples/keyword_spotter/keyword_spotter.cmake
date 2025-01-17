#**********************
# Gather Sources
#**********************
file(GLOB_RECURSE APP_SOURCES ${CMAKE_CURRENT_LIST_DIR}/src/*.c )
set(APP_INCLUDES
    ${CMAKE_CURRENT_LIST_DIR}/src
    ${CMAKE_CURRENT_LIST_DIR}/src/usb
    ${CMAKE_CURRENT_LIST_DIR}/src/ssd1306
)

include(${CMAKE_CURRENT_LIST_DIR}/bsp_config/bsp_config.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/inference_engines/inference_engines.cmake)

#**********************
# Flags
#**********************
set(APP_COMPILER_FLAGS
    -Os
    -g
    -report
    -fxscope
    -mcmodel=large
    -Wno-xcore-fptrgroup
    ${CMAKE_CURRENT_LIST_DIR}/src/config.xscope
)

set(APP_COMPILE_DEFINITIONS
    DEBUG_PRINT_ENABLE=1
    PLATFORM_USES_TILE_0=1
    PLATFORM_USES_TILE_1=1

    XUD_CORE_CLOCK=600

    CFG_TUSB_DEBUG_PRINTF=rtos_printf
    CFG_TUSB_DEBUG=0
)

set(APP_LINK_OPTIONS
    -report
    ${CMAKE_CURRENT_LIST_DIR}/src/config.xscope
)

set(APP_COMMON_LINK_LIBRARIES
    sln_avona::example::inference_engine::keyword
    rtos::freertos_usb
    sdk::lib_src
    avona::agc
    avona::ic
    avona::ns
    avona::vad
)

#**********************
# Tile Targets
#**********************
set(TARGET_NAME tile0_example_keyword_spotter)
add_executable(${TARGET_NAME} EXCLUDE_FROM_ALL)
target_sources(${TARGET_NAME} PUBLIC ${APP_SOURCES})
target_include_directories(${TARGET_NAME} PUBLIC ${APP_INCLUDES})
target_compile_definitions(${TARGET_NAME} PUBLIC ${APP_COMPILE_DEFINITIONS} THIS_XCORE_TILE=0)
target_compile_options(${TARGET_NAME} PRIVATE ${APP_COMPILER_FLAGS})
target_link_libraries(${TARGET_NAME} PUBLIC ${APP_COMMON_LINK_LIBRARIES} sln_avona::example::keyword_spotter::xk_voice_l71)
target_link_options(${TARGET_NAME} PRIVATE ${APP_LINK_OPTIONS})
unset(TARGET_NAME)

set(TARGET_NAME tile1_example_keyword_spotter)
add_executable(${TARGET_NAME} EXCLUDE_FROM_ALL)
target_sources(${TARGET_NAME} PUBLIC ${APP_SOURCES})
target_include_directories(${TARGET_NAME} PUBLIC ${APP_INCLUDES})
target_compile_definitions(${TARGET_NAME} PUBLIC ${APP_COMPILE_DEFINITIONS} THIS_XCORE_TILE=1)
target_compile_options(${TARGET_NAME} PRIVATE ${APP_COMPILER_FLAGS})
target_link_libraries(${TARGET_NAME} PUBLIC ${APP_COMMON_LINK_LIBRARIES} sln_avona::example::keyword_spotter::xk_voice_l71)
target_link_options(${TARGET_NAME} PRIVATE ${APP_LINK_OPTIONS} )
unset(TARGET_NAME)

set(TARGET_NAME tile0_example_keyword_spotter_dev)
add_executable(${TARGET_NAME} EXCLUDE_FROM_ALL)
target_sources(${TARGET_NAME} PUBLIC ${APP_SOURCES})
target_include_directories(${TARGET_NAME} PUBLIC ${APP_INCLUDES})
target_compile_definitions(${TARGET_NAME} PUBLIC ${APP_COMPILE_DEFINITIONS} THIS_XCORE_TILE=0)
target_compile_options(${TARGET_NAME} PRIVATE ${APP_COMPILER_FLAGS})
target_link_libraries(${TARGET_NAME} PUBLIC ${APP_COMMON_LINK_LIBRARIES} sln_avona::example::keyword_spotter::xcore_ai_explorer)
target_link_options(${TARGET_NAME} PRIVATE ${APP_LINK_OPTIONS})
unset(TARGET_NAME)

set(TARGET_NAME tile1_example_keyword_spotter_dev)
add_executable(${TARGET_NAME} EXCLUDE_FROM_ALL)
target_sources(${TARGET_NAME} PUBLIC ${APP_SOURCES})
target_include_directories(${TARGET_NAME} PUBLIC ${APP_INCLUDES})
target_compile_definitions(${TARGET_NAME} PUBLIC ${APP_COMPILE_DEFINITIONS} THIS_XCORE_TILE=1)
target_compile_options(${TARGET_NAME} PRIVATE ${APP_COMPILER_FLAGS})
target_link_libraries(${TARGET_NAME} PUBLIC ${APP_COMMON_LINK_LIBRARIES} sln_avona::example::keyword_spotter::xcore_ai_explorer)
target_link_options(${TARGET_NAME} PRIVATE ${APP_LINK_OPTIONS} )
unset(TARGET_NAME)

#**********************
# Merge binaries
#**********************
merge_binaries(example_keyword_spotter tile0_example_keyword_spotter tile1_example_keyword_spotter 1)
merge_binaries(example_keyword_spotter_dev tile0_example_keyword_spotter_dev tile1_example_keyword_spotter_dev 1)

#**********************
# Create run and debug targets
#**********************
create_run_target(example_keyword_spotter)
create_debug_target(example_keyword_spotter)
create_flash_app_target(example_keyword_spotter)

create_run_target(example_keyword_spotter_dev)
create_debug_target(example_keyword_spotter_dev)
create_flash_app_target(example_keyword_spotter_dev)
