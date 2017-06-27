/*******************************************************************************
 **      Filename: codec.h
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-22 15:01:58
 ** Last Modified: 2017-06-22 15:01:58
 ******************************************************************************/
#ifndef __CODEC_H__
#define __CODEC_H__

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavdevice/avdevice.h"
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
}

class Yuv2Rgb32Convertor{
    public:
        Yuv2Rgb32Convertor(int src_w,int src_h,int dst_w,int dst_h);
        ~Yuv2Rgb32Convertor();
        int Convert(uint8_t *yuv_data,uint8_t *rgba_data);
    private:
        int mSrcWidth,mSrcHeight;
        int mDstWidth;
        SwsContext *mSwsCtx;
};

#endif//
