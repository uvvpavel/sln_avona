// Copyright (c) 2022 XMOS LIMITED. This Software is subject to the terms of the
// XMOS Public License: Version 1

/* STD headers */
#include <platform.h>
#include <xs1.h>
#include <xcore/hwtimer.h>

/* FreeRTOS headers */
#include "FreeRTOS.h"
#include "task.h"
#include "stream_buffer.h"

/* App headers */
#include "app_conf.h"
#include "platform/driver_instances.h"
#include "inference_engine.h"
#include "wanson_inf_eng.h"
#include "ssd1306_rtos_support.h"

__attribute__((weak))
void wanson_engine_proc_keyword_result(const char **text, int id)
{
    rtos_printf("%s %d\n", (char*)*text, id);
#if appconfSSD1306_DISPLAY_ENABLED
    // some temporary fixes to the strings returned
    switch (id) {
        case 200:
            // fix capital "On"
            ssd1306_display_ascii_to_bitmap("Switch on the TV\0");
            break;
        case 420:
            // fix lower case "speed"
            // fix word wrapping
            ssd1306_display_ascii_to_bitmap("Speed up the   fan\0");
            break;
        case 430:
            // fix lower case "slow"
            ssd1306_display_ascii_to_bitmap("Slow down the fan\0");
            break;
        case 440:
            // fix lower case "set"
            // fix word wrapping
            ssd1306_display_ascii_to_bitmap("Set higher    temperature\0");
            break;
        case 450:
            // fix lower case "set"
            // fix word wrapping
            ssd1306_display_ascii_to_bitmap("Set lower     temperature\0");
            break;
        default:
            ssd1306_display_ascii_to_bitmap((char *)*text);
    }
#endif
#if appconfINFERENCE_I2C_OUTPUT_ENABLED
    i2c_res_t ret;
    uint32_t buf = id;
    size_t sent = 0;

    ret = rtos_i2c_master_write(
        i2c_master_ctx,
        appconfINFERENCE_I2C_OUTPUT_DEVICE_ADDR,
        (uint8_t*)&buf,
        sizeof(uint32_t),
        &sent,
        1
    );

    if (ret != I2C_ACK) {
        rtos_printf("I2C inference output was not acknowledged\n\tSent %d bytes\n", sent);
    }
#endif
}

int32_t inference_engine_create(uint32_t priority, void *args)
{
    (void) args;
#if appconfINFERENCE_ENABLED
#if INFERENCE_TILE_NO == AUDIO_PIPELINE_TILE_NO
    wanson_engine_task_create(priority);
#else
    wanson_engine_intertile_task_create(priority);
#endif
#endif
    return 0;
}

int32_t inference_engine_sample_push(int32_t *buf, size_t frames)
{
#if appconfINFERENCE_ENABLED
#if INFERENCE_TILE_NO == AUDIO_PIPELINE_TILE_NO
    wanson_engine_samples_send_local(
            frames,
            buf);
#else
    wanson_engine_samples_send_remote(
            intertile_ctx,
            frames,
            buf);
#endif
#endif
    return 0;
}
