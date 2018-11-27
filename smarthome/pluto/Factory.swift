//
//  Factory.swift
//  smarthome
//
//  Created by lu on 2018/10/30.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final public class Factory {
    public static func initialization()->Void {
        _ = Aps.SetOnSectionListener(aID: Common.aID_PDO_Type_Factory, listener: Factory.mySection);
    }

    public static func setSectionListener(listenser:onSectionListener)->Int{
        var isHave = false;
        for sec in myListener {
            if sec === listenser {
                isHave = true;
            }
        }
        if isHave == false {
            myListener.append(listenser);
            return Common.op_succeed;
        }
        return Common.op_faile;
    }
    public static func removeSectionListener(listener:onSectionListener)->Int
    {
        var i = 0;
        for subsec in myListener {
            if subsec === listener{
                myListener.remove(at: i);
                return Common.op_succeed;
            }
            i = i + 1;
        }
        return Common.op_faile;
    }
    public static func resetSectionListener()->Int{
        myListener = [Factory.onSectionListener]();
        return Common.op_succeed;
    }
    public static func reqReadInfo(keyID:UInt8, addr:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID: keyID, dst: addr, seq: seq, port: 0, aID: Common.aID_PDO_Type_Factory, cmd: Common.cmd_write.toU8, option: Common.aID_Common_Option.toU8);
    }
    public static func reqSaveInfo(keyID:UInt8, addr:[UInt8], seq:UInt16, info:String)->Int
    {
        let buf = Convert.string_to_arrary(str: info);
        return Aps.ReqSend(keyID: keyID, dst: addr, seq: seq, port: 0, aID: Common.aID_PDO_Type_Factory, cmd: Common.cmd_write.toU8, option: Common.aID_Common_Option.toU8,pdata:buf,len:buf.count);
    }
    public static func output()->String
    {
        if let str = FactoryInfo.rawString(){
            return str;
        }
        else{
            return "";
        }
    }
    public static func creat(server_domain:String, server_ipv4:String, server_udp_port:Int, server_tcp_port:Int, local_udp_port:Int)->Int
    {
        var ret = Common.osFailed;
        FactoryInfo = JSON();
        FactoryInfo["server_url"].stringValue = server_domain;
        FactoryInfo["server_ipv4"].stringValue = server_ipv4;
        FactoryInfo["server_udp_port"].intValue = server_udp_port;
        FactoryInfo["server_tcp_port"].intValue = server_tcp_port;
        FactoryInfo["local_udp_port"].intValue = local_udp_port;
        ret = Common.osSucceed;
        return ret;
    }
    public static func putExtraNum(name:String, num:Int)->Int
    {
        var ret = Common.osFailed;
        if (FactoryInfo != JSON.null)
        {
            FactoryInfo[name].intValue = num;
            ret = Common.osSucceed;
        }
        return ret;
    }
    public static func putExtraString(name:String, str:String)->Int
    {
        var ret = Common.osFailed;
        if FactoryInfo != JSON.null{
            FactoryInfo[name].stringValue = str;
            ret = Common.osSucceed;
        }
        return ret;
    }
    final private class Section:Aps.onSectionListener{
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            switch  cmd&0x7F{
            case Common.cmd_read.toU8:
                if(pdata[0]==Common.op_succeed)
                {
                    let substr = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (len-1));////Clib.btostr(pdata,1,pdata.length-1);
                    let info = JSON.init(parseJSON: substr)//Clib.toJSON(substr);
                    for  subsec in Factory.myListener {
                        subsec.ReadCB(keyID:keyID,addr:src,state:pdata[0].toInt,info:info);
                    }
                }
                else
                {
                    for  subsec in Factory.myListener {
                        subsec.ReadCB(keyID:keyID,addr:src,state:Common.op_faile,info:JSON.null);
                    }
                }
            case Common.cmd_write.toU8:
                for  subsec in Factory.myListener {
                    subsec.WriteCB(keyID: keyID, addr: src, state: pdata[0].toInt);
                }
            default:
                break;
            }
        }
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            
        }
    }
    /*********** 出厂设置***********************/
    private static var myListener:[Factory.onSectionListener] = [Factory.onSectionListener]();
    private static var FactoryInfo:JSON = JSON();
    private static let mySection:Section = Section();
    
    public class onSectionListener{
        public func ReadCB(keyID:UInt8, addr:[UInt8], state:Int, info:JSON)->Void{};
        public func WriteCB(keyID:UInt8,addr:[UInt8], state:Int)->Void{};
    }
}
