/*******************************************************************************
 **      Filename: main.cpp
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-22 10:33:08
 ** Last Modified: 2017-06-22 10:33:08
 ******************************************************************************/
#include "QtCore/QCoreApplication"
#include "QtCore/QDebug"
#include <QtGui/QApplication>
#include <QtGui/QLabel>
#include <QtGui/QFrame>
#include <QtGui/QPainter>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdio.h>
#include "codec.h"
#include "utils.h"

int main(int argc,char **argv){
    QApplication app(argc, argv);
    int src_w = 176 ,src_h = 144;
    int size = src_w * src_h * 3 /2 ;
    uint8_t *yuv_data = (uint8_t *)malloc(size);
    int ret = YuvLoader("./one_frame_sample.yuv",yuv_data,size);
    //YuvCopy(yuv_data,size,"./one_frame_sample.yuv");
    if(ret < 0){
        fprintf(stderr,"error loader image file\n");
        free(yuv_data);
        return -1;
    }
    Yuv2Rgb32Convertor cvt(src_w,src_h,src_w,src_h);
    uint8_t *rgb32_data = (uint8_t *)malloc(src_w *src_h * 4);
    if(rgb32_data == NULL){
        free(yuv_data);
        return -1;
    }
    cvt.Convert(yuv_data,rgb32_data);
    QLabel *label = new QLabel();
    label->setFrameStyle(QFrame::Panel | QFrame::Sunken);
    QImage tmpImg((uchar *)rgb32_data,src_w,src_h,QImage::Format_RGB32);
    QImage image = tmpImg.copy(); 
    label->setPixmap(QPixmap::fromImage(image));
    label->show();
    return app.exec();
}
