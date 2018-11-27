//
//  Aps.swift
//  smarthome
//
//  Created by lu on 2018/10/23.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final public class Aps{
    static var myListener:[Listener_t] = [Listener_t]();
    public static func ReqSend(keyID:UInt8, dst:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int)->Int{
        return Pluto.ReqSend(keyID: keyID, dst: dst, seq: seq, port: port, aID: aID, cmd: cmd, option: option, pdata:pdata,len:len);
    }
    public static func ReqSend(keyID:UInt8, dst:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8)->Int{
        return Pluto.ReqSend(keyID: keyID, dst: dst, seq: seq, port: port, aID: aID, cmd: cmd, option: option);
    }
    public static func SetOnSectionListener(aID:Int, listener:onSectionListener)->Int{
        RemoveSameSection(aID: aID, listener: listener);
        var sec:Listener_t = Listener_t(listen:listener);
        sec.aID = aID;
        myListener.append(sec);
        return 0;
    }
    public static func SetOnSectionListener(minaID:Int, maxaID:Int, listener:onSectionListener)->Int{
        RemoveSameSection(minaID:minaID,maxaID:maxaID,listener:listener);
        var sec:Listener_t = Listener_t(listen:listener);
        sec.maxID = maxaID;
        sec.minID = minaID;
        myListener.append(sec);
        return 0;
    }
    public static func AddDeviceKey(addr:[UInt8],keyID:UInt8,key:[UInt8])->Int{
        let ptr_addr = Convert.arrary_to_unsafe_UInt8(arrary: addr);
        let ptr_key = Convert.arrary_to_unsafe_UInt8(arrary: key);
        let ret = pluto_device_add_key(ptr_addr, keyID, ptr_key).toInt;
        ptr_key.deallocate();
        ptr_addr.deallocate();
        return ret;
    }
    
    public static func RemoveSameSection(aID:Int, listener: onSectionListener)
    {
        var sec:Listener_t;
        let num = myListener.count;
        if num>0
        {
            for i in 0 ... (num-1)
            {
                sec = myListener[i];
                if  sec.aID == aID && sec.listener === listener
                {
                    myListener.remove(at: i);
                    break;
                }
            }
        }
    }
    public static func RemoveSameSection(minaID:Int, maxaID:Int, listener: onSectionListener)
    {
        var sec:Listener_t;
        let num = myListener.count;
        if num>0
        {
            for i in 0 ... (num-1)
            {
                sec = myListener[i];
                if  sec.maxID == maxaID && sec.minID == minaID && sec.listener === listener
                {
                    myListener.remove(at: i);
                    break;
                }
            }
        }
    }
    public static func Receive_Message_CB (keyID:UInt8,src:[UInt8],seq:UInt16, port:UInt8,aID:Int, cmd:UInt8, option:UInt8, pdata:[UInt8], len:Int)
    {
        for sec in myListener{
            if((sec.maxID != 0)&&(sec.minID != 0)){
                if ((sec.maxID >= aID)&&(sec.minID <= aID)){
                    sec.listener.Recieve(keyID: keyID, src: src, seq: seq, port: port, aID: aID, cmd: cmd, option: option, pdata: pdata, len: len);
                }
            }else if (sec.aID == aID){
                sec.listener.Recieve(keyID: keyID, src: src, seq: seq, port: port, aID: aID, cmd: cmd, option: option, pdata: pdata, len: len);
            }
        }
    }
    public static func Send_State_CB(src:[UInt8],seq:UInt16,port:UInt8,aID:Int, cmd:UInt8, option:UInt8, state:Int)
    {
        for sec in myListener{
            if((sec.maxID != 0)&&(sec.minID != 0)){
                if ((sec.maxID >= aID)&&(sec.minID <= aID)){
                    sec.listener.SendState(src: src, seq: seq, port: port, aID: aID, cmd: cmd, option: option, state: state);
                }
            }else if (sec.aID == aID){
                sec.listener.SendState(src: src, seq: seq, port: port, aID: aID, cmd: cmd, option: option, state: state);
            }
        }
    }
    struct Listener_t {
        var maxID:Int;
        var minID:Int;
        var aID:Int;
        var listener:onSectionListener;
        init(listen:onSectionListener) {
            maxID = 0;
            minID = 0;
            aID = 0;
            listener = listen;
        }
    }
    public class onSectionListener {
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{}
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{}
    }
    
}


