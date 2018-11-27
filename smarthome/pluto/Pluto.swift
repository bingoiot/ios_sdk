//
//  Pluto.swift
//  smarthome
//
//  Created by lu on 2018/10/17.

//  Copyright © 2018年 jifan. All rights reserved.
//
import AppleTextureEncoder

import Foundation
public class Pluto{
    
    public static func ReqSend(keyID:UInt8, dst:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int)->Int{
        let dst_ptr = Convert.arrary_to_unsafe_UInt8(arrary: dst);
        let data_ptr = Convert.arrary_to_unsafe_UInt8(arrary: pdata);
        let ret = pluto_req_send(keyID, dst_ptr, seq.to32, port, aID.to32, cmd, option,data_ptr,len.to32);
        dst_ptr.deallocate();
        data_ptr.deallocate();
        return ret.toInt;
    }
    public static func ReqSend(keyID:UInt8, dst:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8)->Int{
        let dst_ptr = Convert.arrary_to_unsafe_UInt8(arrary: dst);
        let ret = pluto_req_send_command(keyID, dst_ptr, seq.to32, port, aID.to32, cmd, option);
        dst_ptr.deallocate();
        return ret.toInt
    }
    
    let server_ipv4 = "119.23.8.181";
    let local_ipv4 = "192.168.8.54";
    let password:[UInt8] = [0x14,0xF7,0x90,0x5E,0x85,0x98,0xE5,0x39,0x90,0xDA,0xD1,0x9C,0x0E,0x57,0x95,0xE4];
    let user:[UInt8]=[0x01,0x56,0x05,0x00,0x01,0x00,0x00,0x02];
    init() {
        pluto_init();
        init_callbacks();
        var cstr:UnsafeMutablePointer<CChar>;
        cstr = Convert.string_to_unsafe_cstring(str:server_ipv4);
        pluto_set_server_ipv4(cstr);
        cstr.deallocate();
        cstr = Convert.string_to_unsafe_cstring(str:local_ipv4);
        pluto_set_local_ipv4(cstr);
        cstr.deallocate();
        
        let usr = Convert.arrary_to_unsafe_Int8(arrary:user);
        let psw = Convert.arrary_to_unsafe_Int8(arrary:password);
        pluto_set_user(usr, psw);
        usr.deallocate();
        psw.deallocate();
        pluto_start_login();
        
        Scene.initialization();
        Upgrade.initialization();
        UserTable.initialization();
        Record.initialization();
        DeviceHelper.initialization();
        Factory.initialization();
    }
    deinit {
        
    }
    private func init_callbacks()->Void{
        sw_login_change_cb = Pluto.login_chage_state;
        sw_recieve_message_cb = Pluto.recieve_message;
        sw_send_state_cb = Pluto.send_state;
    }
   // void (^sw_recieve_message_cb)(uint8 keyID,uint8 *src,int seq,uint8 port,int aID, uint8 cmd, uint8 option, uint8 *pdata, int len);
   // void (^sw_send_state_cb)(uint8 *src,int seq,uint8 port,int aID, uint8 cmd, uint8 option,  int state);
    
    private static func login_chage_state(state:Int32) -> Void {
        print("call login state change "+String(state) + "\r\n");
       
    }
    private static func recieve_message(keyID:UInt8,src:UnsafeMutablePointer<UInt8>?,seq:Int32,port:UInt8,aID:Int32,cmd:UInt8,option:UInt8,pdata:UnsafeMutablePointer<UInt8>?,len:Int32) -> Void{
        print("call receive message \r\n");
        let addr = Convert.unsafe_UInt8_to_arrary(ptr: src!, len: 8);
        let buf = Convert.unsafe_UInt8_to_arrary(ptr: pdata!, len: len.toInt);
        Aps.Receive_Message_CB(keyID: keyID, src:addr, seq: seq.toU16, port:port, aID: aID.toInt, cmd: cmd, option: option, pdata: buf, len: len.toInt);
    }
    private static func send_state(src:UnsafeMutablePointer<UInt8>?,seq:Int32,port:UInt8,aID:Int32,cmd:UInt8,option:UInt8,state:Int32) -> Void{
        print("call send state \r\n");
        let addr = Convert.unsafe_UInt8_to_arrary(ptr: src!, len: 8);
        Aps.Send_State_CB(src:addr, seq: seq.toU16, port:port, aID: aID.toInt, cmd: cmd, option: option,state:state.toInt);
    }
    
}

