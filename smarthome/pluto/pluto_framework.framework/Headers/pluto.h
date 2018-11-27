//
//  pluto.h
//  pluto
//
//  Created by lu on 2018/10/17.
//  Copyright © 2018年 jifan. All rights reserved.

#ifndef PLUTO_H__
#define PLUTO_H__

#include "osType.h"

void (^sw_login_change_cb)(int state) = NULL;
void (^sw_recieve_message_cb)(uint8 keyID,uint8 *src,int seq,uint8 port,int aID, uint8 cmd, uint8 option, uint8 *pdata, int len);
void (^sw_send_state_cb)(uint8 *src,int seq,uint8 port,int aID, uint8 cmd, uint8 option,  int state);

/****************message input output API***********************/
extern int      pluto_req_send(uint8 keyID, uint8 *dst, int seq, uint8 port, int aID, uint8 cmd, uint8 option, uint8 *pdata, int len);
extern int      pluto_req_send_command(uint8 keyID, uint8 *dst, int seq, uint8 port, int aID, uint8 cmd, uint8 option);
/****************login server opteration funtion******************/
extern int      pluto_init(void);
extern int      pluto_set_server_url(char *url);
extern int      pluto_set_server_ipv4(char *ipv4);
extern int      pluto_set_local_ipv4(char *ipv4);
extern int      pluto_set_user(char *user, char* password);
extern int      pluto_start_login(void);
extern int      pluto_stop_login(void);
extern int      pluto_get_login_state(void);
extern int      pluto_set_route(int enable);

/***************local key operation funtion of current device ***************/
extern uint8*   pluto_get_local_key(uint8 keyID);
extern uint8*   pluto_get_adminkey(void);
extern uint8*   pluto_get_comkey(void);
extern uint8*   pluto_get_guestkey(void);
extern void     pluto_set_adminkey(uint8* key);
extern void     pluto_set_comkey(uint8* key);
extern void     pluto_set_guestkey(uint8* key);

/*************remote device key funtion *********************/
extern int      pluto_device_add_key(uint8 *addr, uint8 keyID, uint8 *key);
extern int      pluto_device_remove_key(uint8 *addr, uint8 keyID);
extern int      pluto_device_remove_all_keys(void);

/*************scence creator funtion*********************/
extern int      scence_create_body(void);
extern int      scence_create_while_block(int root, char *reason);
extern int      scence_create_if_block(int root, char *if_type, char *reason);
extern int      scence_create_action(int root, char *what, char *param);
extern int      scence_create_else_block(int root);
extern char     *scence_print(int root);
extern int      scence_release(void);

/**************smartconfig funtion**********************/
extern int      smartconfig_start(char *ssid, char *psw, int hide_ssid, int timeout);
extern int      smartconfig_stop(void);

extern void     osPrint2b(char *s,uint8 *pdata, int len);

#endif

