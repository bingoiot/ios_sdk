/**
 * osType.h
 *
 *  Created on: Aug 20, 2016
 *      Author: lort
 */

#ifndef OS_TYPES_H_
#define OS_TYPES_H_
/*
#include "unistd.h"
#include "stdio.h"
#include "stdlib.h"
#include <netdb.h>
#include <sys/socket.h>
#include <sys/msg.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "time.h"
#include "sys/time.h"
#include "pthread.h"
#include "stdarg.h"
#include <string.h>
#include <stdlib.h>
#include <sys/vfs.h>
#include <stdio.h>
#include <signal.h>
#include <sys/stat.h>

#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include<sys/wait.h>
#include <string.h>
*/

#define FUC_ATTR

typedef enum
{
	osFalse = 0x00,
	osTrue = 0x01,

	osDisable = 0x00,
	osEnable = 0x01,

	osError = -1,

	osSucceed = 0x00,
	osFailed = 0x01,

	osParamError = 0x02,
	osPasswordError = 0x04,
	osVersionError = 0x06

}osState;

#ifndef NULL
#define NULL	((void*)0)
#endif

#ifndef uint8
#define uint8 unsigned char
#endif

#ifndef uint16
#define uint16 unsigned short
#endif

#ifndef uint32
#define uint32 unsigned int
#endif

#ifndef uint64
#define uint64 unsigned long
#endif

#ifndef int8
#define  int8 char
#endif

#ifndef int16
#define  int16 short
#endif

#ifndef int32
#define int32 unsigned int
#endif

#ifndef int64
#define int64 unsigned long
#endif


typedef void (*task_t)(int sig, void *param,int len);


#endif /* JF_OS_JF_TYPES_H_ */
