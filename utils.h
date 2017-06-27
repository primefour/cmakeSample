/*******************************************************************************
 **      Filename: utils.h
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-27 15:41:17
 ** Last Modified: 2017-06-27 15:41:17
 ******************************************************************************/
#ifndef __UTILS_H__
#define __UTILS_H__
#include <stddef.h>
#include <stdint.h>
int YuvLoader(const char *img_path,uint8_t * yuv_data,int size);
void YuvCopy(uint8_t *data,int size ,const char *path);
#endif 

