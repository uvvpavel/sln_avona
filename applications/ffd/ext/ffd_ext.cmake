

file(GLOB_RECURSE APP_EXT_SOURCES ${CMAKE_CURRENT_LIST_DIR}/*.c )
set(APP_EXT_INCLUDES
    ${CMAKE_CURRENT_LIST_DIR}/src/usb
    ${CMAKE_CURRENT_LIST_DIR}/src/ssd1306
)

set(APP_EXT_COMPILER_FLAGS "")
set(APP_EXT_COMPILE_DEFINITIONS
    XUD_CORE_CLOCK=600
    CFG_TUSB_DEBUG_PRINTF=rtos_printf
    CFG_TUSB_DEBUG=0
)
set(APP_EXT_COMMON_LINK_LIBRARIES
    sdk::lib_src
)

include(${CMAKE_CURRENT_LIST_DIR}/ffd_i2c_output.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ffd_usb_output.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ffd_usb_audio_testing.cmake)
