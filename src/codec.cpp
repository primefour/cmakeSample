/*******************************************************************************
 **      Filename: codec.cpp
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-22 11:06:35
 ** Last Modified: 2017-06-22 11:06:35
 ******************************************************************************/
extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavdevice/avdevice.h"
#include <libavutil/imgutils.h>
#include <libavutil/parseutils.h>
#include <stdio.h>
#include "codec.h"
}

Yuv2Rgb32Convertor::Yuv2Rgb32Convertor(int src_w,int src_h,int dst_w,int dst_h){
    mSrcWidth = src_w;
    mSrcHeight = src_h;
    mDstWidth = dst_w;

    /* create scaling context */
    mSwsCtx = sws_getContext(src_w, src_h, AV_PIX_FMT_YUV420P,
            dst_w, dst_h,AV_PIX_FMT_RGB32,
            SWS_BILINEAR, NULL, NULL, NULL);

    if (!mSwsCtx) {
        fprintf(stderr,
                "Impossible to create scale context for the conversion "
                "fmt:%s s:%dx%d -> fmt:%s s:%dx%d\n",
                av_get_pix_fmt_name(AV_PIX_FMT_YUV420P), src_w, src_h,
                av_get_pix_fmt_name(AV_PIX_FMT_RGB32), dst_w, dst_h);
    }
}

Yuv2Rgb32Convertor::~Yuv2Rgb32Convertor(){
    if(mSwsCtx != NULL){
        sws_freeContext(mSwsCtx);
        mSwsCtx = NULL;
    }
}

int Yuv2Rgb32Convertor::Convert(uint8_t *yuv_data,uint8_t *rgba_data){
    if(mSwsCtx == NULL){
        return -1;
    }

    uint8_t *src_data[4], *dst_data[4];
    int src_linesize[4], dst_linesize[4];
    //yuv420p 
    src_data[0] = yuv_data;//y channel 
    src_data[1] = src_data[0] + mSrcWidth * mSrcHeight; //u channel
    src_data[2] = src_data[1] + mSrcWidth * mSrcHeight/4; //v channel

    src_linesize[0] = mSrcWidth;
    src_linesize[1] = mSrcWidth/2;
    src_linesize[2] = mSrcWidth/2;

    //rgb
    dst_data[0] = rgba_data;
    dst_linesize[0] = 4 * mDstWidth;

    /* convert to destination format */
    int ret = sws_scale(mSwsCtx, (const uint8_t * const*)src_data,
            src_linesize, 0,mSrcHeight, dst_data, dst_linesize);

    return ret;
}

