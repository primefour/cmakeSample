/*******************************************************************************
 **      Filename: sample_jni.cpp
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-27 15:38:20
 ** Last Modified: 2017-06-27 15:38:20
 ******************************************************************************/
#include <jni.h>
#include "utils.h"
#include "codec.h"

static void jni_display_yuv(JNIEnv *env,jobject thiz,jstring src_path,jbyteArray buff){
    const char *src = env->GetStringUTFChars(src_path, 0);
    jbyte* rgb32_buff = env->GetByteArrayElements(buff, NULL);
    jsize lengthOfArray = env->GetArrayLength(buff);

    int src_w = 176 ,src_h = 144;
    int size = src_w * src_h * 3 /2 ;
    uint8_t *yuv_data = (uint8_t *)malloc(size);
    int ret = YuvLoader("./one_frame_sample.yuv",yuv_data,size);
    Yuv2Rgb32Convertor cvt(src_w,src_h,src_w,src_h);
    if(ret < 0){
        fprintf(stderr,"error loader image file\n");
        goto check_fail;
    }
    if(src_w *src_h * 4 > lengthOfArray || rgb32_buff == NULL ){
        fprintf(stderr,"buffer size is too small \n");
        goto check_fail;
    }
    cvt.Convert(yuv_data,(uint8_t *)rgb32_buff);
check_fail:
    if(yuv_data != NULL){
        free(yuv_data);
        yuv_data = NULL;
    }
    env->ReleaseByteArrayElements(buff,rgb32_buff, 0);
    env->ReleaseStringUTFChars(src_path,src);
}
