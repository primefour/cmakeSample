/*******************************************************************************
 **      Filename: utils.cpp
 **        Author: crazyhorse                  
 **   Description: ---
 **        Create: 2017-06-27 15:41:07
 ** Last Modified: 2017-06-27 15:41:07
 ******************************************************************************/
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdio.h>
#include "utils.h"

int YuvLoader(const char *img_path,uint8_t * yuv_data,int size){
    int fd = open(img_path,O_RDONLY);
    if(fd < 0){
        fprintf(stderr,"error:%s file can't open \n",img_path);
        return -1;
    }
    int ret = read(fd,yuv_data,size);
    if(ret < 0){
        fprintf(stderr,"error:read image data failed \n");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

void YuvCopy(uint8_t *data,int size ,const char *path){
    if(data == NULL || path == NULL){
        fprintf(stderr,"error: data or path is NULL \n");
        return ;
    }
    int fd = open(path,O_CREAT|O_TRUNC|O_WRONLY,0644);
    if(fd < 0){
        fprintf(stderr,"error:create file %s fail",path);
        return ;
    }
    int ret = write(fd,data,size);
    close(fd);
}

