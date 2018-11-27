//
//  DeviceHelper.swift
//  smarthome
//
//  Created by lu on 2018/10/24.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final public class DeviceHelper {
    
    public static func StartWifiSmartConfig(ssid:String, psw:String, hide_ssid:Bool)->Int{
        let pssid = Convert.string_to_unsafe_cstring(str: ssid);
        let ppsw = Convert.string_to_unsafe_cstring(str: psw);
        var hide = 0;
        if hide_ssid == true{
            hide = 1;
        }
        let ret = smartconfig_start(pssid, ppsw, hide.to32, (5*60*1000));
        pssid.deallocate();
        ppsw.deallocate();
        return ret.toInt;
    }
    public static func StopWifiSmartConfig()->Int{
        let ret = smartconfig_stop();
        return ret.toInt;
    }
    public static func AttachDevice(addr:[UInt8], adminKey:[UInt8]?, comKey:[UInt8]?, guestKey:[UInt8]?)->Void {
        var dev:DeviceInfo_t?;
        var keyID:UInt8 = Common.keyID_none.toU8;
        if (guestKey != nil) {
            keyID = Common.keyID_guest.toU8;
            _ = Aps.AddDeviceKey(addr: addr, keyID: keyID, key: guestKey!);
        }
        if (comKey != nil) {
            keyID = Common.keyID_common.toU8;
            _ = Aps.AddDeviceKey(addr: addr, keyID: keyID, key: comKey!);
        }
        if (adminKey != nil) {
            keyID = Common.keyID_admin.toU8;
            _ = Aps.AddDeviceKey(addr: addr, keyID: keyID, key: adminKey!);
        }
        locker.lock();
        dev = getDeviceByAddr(addr:addr);
        if (dev == nil) {
            _ = addDevice(addr:addr, keyID:keyID);
            dev = getDeviceByAddr(addr:addr);
        }
        if dev != nil{
            dev?.keyID = keyID
            dev?.state = state_invalid
        }
        locker.unlock();
    }
    public static func SetOnSectionListener(listener:onSectionListener)->Int{
        var ishave = false;
        var ret  = 1;
        for sec in myListenerList{
            if(sec === listener)
            {
                ishave = true;
            }
        }
        if(ishave == false){
            myListenerList.append(listener);
            ret  = 0;
        }
        return ret;
    }
    public static func RemoveOnSectionListener(listener:onSectionListener)->Int{
        var i : Int = 0;
        var ret = Common.op_faile;
        for sec in myListenerList{
            if(sec === listener)
            {
                myListenerList.remove(at: i);
                ret = Common.op_succeed;
                break;
            }
            i = i + 1;
        }
        return ret;
    }
    public static func ResetOnSectionListener()->Int{
        myListenerList = [onSectionListener]();
        return 0;
    }
    public static func RemoveDevice(addr:[UInt8])->Int {
        var ret = Common.osFailed;
        locker.lock()
        let index = getDeviceIndexByAddr(addr:addr);
        if index >= 0 {
            myDeviceList.remove(at: index);
            ret = Common.osSucceed;
        }
        locker.unlock();
        return ret;
    }
    
    public static func RemoveAllDevice()->Int {
        myDeviceList.removeAll()
        return Common.osSucceed;
    }
    
    public static func ReqDevEnableJoin(keyID:UInt8, dst:[UInt8], seq:UInt16, duration:Int)->Int {
        var  buf:[UInt8]=[UInt8]();
        buf.append(Common.osTrue.toU8);
        buf = buf + Clib.U32toB(value:duration.toU32);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Permite_Join,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    
    public static func ReqDevDisableJoin(keyID:UInt8, dst:[UInt8], seq:UInt16) ->Int{
        var  buf:[UInt8]=[UInt8]();
        buf.append(Common.osFalse.toU8);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Permite_Join,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    
    public static func ReqReadPorts(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Port_List,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    
    public static func ReqReadDeviceInfo(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Device_Info,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    
    public static func ReqReadPortDescribe(keyID:UInt8, dst:[UInt8], seq:UInt16, port:UInt8)->Int {
        var  buf:[UInt8]=[UInt8]();
        buf.append(port);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Port_Describe,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    
    public static func ReqWriteDevInfo(keyID:UInt8, dst:[UInt8], seq:UInt16, info:JSON)->Int {
        if let str = info.rawString(){
            let char_list = str.cString(using: String.Encoding.ascii)!
            let buf = Convert.arrary_character_to_UInt8(arrary: char_list);
            return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Device_Info,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
        }
        else{
             return -1;
        }
    }
    public static func ReqWritePortDescribe(keyID:UInt8, dst:[UInt8], seq:UInt16, describe:JSON)->Int{
        if let str = describe.rawString(){
            let char_list = str.cString(using: String.Encoding.ascii)!
            let buf = Convert.arrary_character_to_UInt8(arrary: char_list);
            return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Port_Describe,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
        }
        else{
            return -1;
        }
    }
    
    public static func ReqSendBeacon(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int {
        var temp:UInt64;
        var  buf:[UInt8]=[UInt8]();
        temp = (Clib.getUnixTime() / 60000);
        buf.append(temp.toU8);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Beacon,cmd:Common.cmd_beacon.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    
    public static func ReqGetLqi(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_Gen_Type_LQI,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    
    public static func ReqGetLqi(keyID:UInt8, dst:[UInt8], seq:UInt16, port:UInt8)->Int {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:port,aID:Common.aID_Gen_Type_LQI,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    
    private class Section: Aps.onSectionListener {
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            var dev:DeviceInfo_t?;
            locker.lock();
            switch (aID) {
            case Common.aID_PDO_Type_Beacon:
                dev = getDeviceByAddr(addr:src);
                if (dev == nil) {
                    _ = addDevice(addr:src);
                    dev = getDeviceByAddr(addr:src);
                    if (dev != nil) {
                        _ = ReqReadDeviceInfo(keyID:dev!.keyID, dst:dev!.addr, seq:Common.getSeq());
                        dev!.runtime = Clib.getUnixTime();
                        dev!.state = state_reading_device_info;
                    }
                }
                break;
            case Common.aID_PDO_Type_Device_Indication://new device joined
                dev = getDeviceByAddr(addr:src);
                if((dev != nil)&&(dev!.key_word != pdata[0])) {
                    _ = RemoveDevice(addr:src);
                    dev = nil;
                }
                if(dev==nil)
                {
                    _ = addDevice(addr:src);
                    dev = getDeviceByAddr(addr:src);
                    if (dev != nil) {
                        _ = ReqReadDeviceInfo(keyID:dev!.keyID, dst:dev!.addr, seq:Common.getSeq());
                        dev!.runtime = Clib.getUnixTime();
                        dev!.state = state_reading_device_info;
                        dev!.key_word = pdata[0];
                    }
                }
                break;
            case Common.aID_PDO_Type_Device_Info://got device info
                if (cmd == (Common.cmd_return | Common.cmd_read)) {
                    if (pdata[0] == Common.osSucceed) {
                        let str_device_info = Convert.arrary_Uint8_to_string(arrary:pdata, start_index: 1, len:(len-1));
                        dev = getDeviceByAddr(addr:src);
                        if (dev == nil) {
                            _ = addDevice(addr:src);
                            dev = getDeviceByAddr(addr:src);
                        }
                        if ((dev != nil) && (str_device_info.count != 0)) {
                            _ = addDeviceInfo(addr:src,devInfo:str_device_info);
                            let devtype:Int = dev!.device_info["dev_type"].intValue;
                            if (devtype == Common.dev_type_gateway) {
                                dev?.runtime = Clib.getUnixTime();
                            }
                        }
                        if ((dev != nil) && (dev?.port_list.count==0)) {
                            dev!.state = state_reading_port_list;
                            _ = ReqReadPorts(keyID:dev!.keyID,dst:dev!.addr,seq:Common.getSeq());
                        }
                    }
                }
                break;
            case Common.aID_PDO_Type_Port_List://got port list
                if (cmd == (Common.cmd_return | Common.cmd_read)) {
                    if (pdata[0] == Common.osSucceed) {
                        let buf = Clib.cut_Uint8_arrary(arrary: pdata, start: 1, len: (len-1));
                        dev = getDeviceByAddr(addr:src);
                        if (dev == nil) {
                            _ = addDevice(addr:src);
                            dev = getDeviceByAddr(addr:src);
                        }
                        if ((dev != nil) && (buf.count>0)) {
                            _ = addDevciePortList(addr:src,ports:buf);
                        }
                        if (dev!.port_list.count != dev!.port_describe.count) {
                            for i in 0...(dev!.port_list.count-1){
                                _ = ReqReadPortDescribe(keyID:dev!.keyID,dst:dev!.addr,seq: Common.getSeq(), port:dev!.port_list[i]);
                            }
                            dev!.state = state_reading_port_describe;
                        }
                    }
                }
                break;
            case Common.aID_PDO_Type_Port_Describe://got port Info
                if (cmd == (Common.cmd_return | Common.cmd_read)) {
                    if (pdata[0] == Common.osSucceed) {
                        let desc = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (len-1));
                        dev = getDeviceByAddr(addr:src);
                        if (dev == nil) {
                            _ = addDevice(addr:src);
                            dev = getDeviceByAddr(addr:src);
                        }
                        if ((dev != nil) && (desc.count != 0)) {
                            _ = addDevicePortDescribe(addr:src, desc:desc);
                            if ((dev!.state == state_reading_port_describe) && (checkDeviceInfoComplete(device:dev!) == true)) {
                                for  subsec in DeviceHelper.myListenerList {//search every section listener to callback
                                    subsec.CompleteDevice(addr:dev!.addr,devInfo: dev!.device_info,ports: dev!.port_list,descList: dev!.port_describe);
                                }
                                dev!.state = state_device_ready;
                            }
                        }
                    }
                }
                break;
            default:
                break;
            }
            locker.unlock();
            for  subsec in  DeviceHelper.myListenerList {//search every section listener to callback
                switch (aID) {
                case Common.aID_PDO_Type_Beacon:
                    if cmd == Common.cmd_beacon{
                        subsec.ReceiveBeacon(addr:src, state:Common.osSucceed);
                    }
                    break;
                case Common.aID_PDO_Type_Device_Indication://new device joined
                    if cmd == Common.cmd_return{
                        subsec.DeviceJoinIndicates(addr:src);
                    }
                    break;
                case Common.aID_PDO_Type_Device_Info://got device info
                    if (cmd == (Common.cmd_return | Common.cmd_read)) {
                        if (pdata[0] == Common.osSucceed) {
                            let devInfo = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: Int(len-1));
                            let info = JSON.init(parseJSON: devInfo);
                            subsec.ReceiveDeviceInfo(addr:src,devInfo: info,state: pdata[0].toInt);
                        } else {
                            subsec.ReceiveDeviceInfo(addr:src,devInfo: JSON.null,state: pdata[0].toInt);
                        }
                    }
                    break;
                case Common.aID_PDO_Type_Port_List://got port list
                    if (cmd == (Common.cmd_return | Common.cmd_read)) {
                        if (pdata[0] == Common.osSucceed) {
                            let portList = Clib.cut_Uint8_arrary(arrary: pdata, start: 1, len: (len-1));
                            subsec.ReceivePortList(addr:src,ports: portList,state: pdata[0].toInt);
                        } else {
                            subsec.ReceivePortList(addr:src,ports: [UInt8](),state: pdata[0].toInt);
                        }
                    }
                    break;
                case Common.aID_PDO_Type_Port_Describe://got port Info
                    if (cmd == (Common.cmd_return | Common.cmd_read)) {
                        if (pdata[0] == Common.osSucceed) {
                            let describe = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (len-1));
                            if(describe.count != 0){
                                let desc = JSON.init(parseJSON: describe);
                                subsec.ReceivePortDescribe(addr:src,describe: desc,state: pdata[0].toInt);
                            }
                        } else {
                            subsec.ReceivePortDescribe(addr:src,describe: JSON.null,state: pdata[0].toInt);
                        }
                    }
                    break;
                case Common.aID_PDO_Type_Port_Indication://new port joined
                    if (cmd == Common.cmd_notify) {
                        let str = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 0, len: len);
                        if(str.count != 0){
                            let desc = JSON.init(parseJSON: str);
                            subsec.NewPortIndicates(addr:src,describe: desc);
                        }
                    }
                    break;
                case Common.aID_Gen_Type_LQI:
                    if (cmd == (Common.cmd_return | Common.cmd_read)) {
                        let lqi = (pdata[0] & 0xff);
                        subsec.ReceiveLqi(addr:src,port: port,lqi: lqi,state: Common.op_succeed);
                    }
                    break;
                default:
                    break;
                }//switch
            }//for
        }//func
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            
        }
    }
    
    public static func poll() -> Void {
        var device_num:Int = 0;
        var temp64:UInt64 = 0;
        var dev:DeviceInfo_t;
        while true
        {
            Thread.sleep(forTimeInterval: 0.1);
            device_num = myDeviceList.count;
            if(device_num>0)
            {
                for i in 0...(device_num-1) {
                    dev = myDeviceList[i];
                    temp64 = Clib.getUnixTime();
                    temp64 = Clib.loopSub(left:temp64, right:dev.runtime);
                    if (temp64 > pollDevcieTimeout) {
                        locker.lock();
                        dev.runtime = Clib.getUnixTime();
                        if ((dev.stry < 5) && (dev.state != state_device_ready)) {
                            dev.stry = dev.stry+1;
                            if (dev.device_info == JSON.null) {
                                _ = ReqReadDeviceInfo(keyID:dev.keyID,dst:dev.addr, seq:Common.getSeq());
                            }
                            else {
                                if (dev.keyID == Common.keyID_admin) {
                                    let enflag = dev.device_info["encrypt"].intValue;
                                    if (enflag == 0) {
                                        dev.device_info["encrypt"].intValue = 1;
                                        _ = ReqWriteDevInfo(keyID: dev.keyID, dst: dev.addr, seq:Common.getSeq(), info:dev.device_info);
                                    }
                                }
                                if (dev.port_list.count == 0) {
                                    dev.state = state_reading_port_list;
                                    _ = ReqReadPorts(keyID:dev.keyID, dst:dev.addr, seq:Common.getSeq());
                                } else if (dev.port_list.count != dev.port_describe.count) {
                                    for i in 0 ... (dev.port_list.count-1) {
                                        _ = ReqReadPortDescribe(keyID:dev.keyID, dst:dev.addr, seq:Common.getSeq(), port:dev.port_list[i]);
                                    }
                                    dev.state = state_reading_port_describe;
                                }
                                //reqReadPorts(dev.keyID, dev.addr, Common.osDisable);
                            }
                            if (checkDeviceInfoComplete(device:dev) == true) {//device info incomplete
                                for  subsec in myListenerList {//search every section listener to callback
                                    subsec.CompleteDevice(addr:dev.addr,devInfo: dev.device_info,ports: dev.port_list,descList: dev.port_describe);
                                }
                                dev.state = state_device_ready;
                            }
                        }
                        locker.unlock();
                    }
                }
            }//if num
        }//while true
    }
    private static func checkDeviceInfoComplete(device:DeviceInfo_t)->Bool {
        var flag = false;
        if (device.device_info != JSON.null) {
            if (device.port_list.count != 0) {
                if (device.port_describe.count != 0) {
                    if (device.port_describe.count == device.port_list.count){
                        flag = true;
                    }
                }
            }
        }
        return flag;
    }
    private static func getDeviceIndexByAddr(addr:[UInt8])->Int {
        let num = myDeviceList.count;
        var dev:DeviceInfo_t;
        if num>0{
            for i in 0...(num-1){
                dev = myDeviceList[i];
                if dev.addr == addr//找到对应设备
                {
                    return i;
                }
            }
        }
        return -1;
    }
    private static func getDeviceByAddr(addr:[UInt8])-> DeviceInfo_t? {
        var dev:DeviceInfo_t? = nil;
        let num = myDeviceList.count;
        if num>0{
            for i in 0...(num-1){
                dev = myDeviceList[i];
                if dev?.addr == addr//找到对应设备
                {
                    return dev;
                }
            }
        }
        return nil;
    }
    private static func addDevice(addr:[UInt8])->Int {
        var dev:DeviceInfo_t?;
        dev = getDeviceByAddr(addr:addr);
        if (dev == nil) {
            dev = DeviceInfo_t()
            if dev != nil{
                dev?.runtime = Clib.getUnixTime();
                dev?.stry = 0;
                dev?.keyID = Common.keyID_none.toU8;
                dev?.state = state_invalid;
                dev?.device_info = JSON.null;
                dev?.port_list = [UInt8]();
                dev?.addr = addr;
                dev?.port_describe = [JSON]();
                dev?.addr = addr;
                myDeviceList.append(dev!);
                return Common.osSucceed;
            }
        }
        return Common.osFailed;
    }
    
    private static func addDevice(addr:[UInt8], keyID:UInt8)->Int {
        var dev:DeviceInfo_t?;
        dev = getDeviceByAddr(addr:addr);
        if (dev == nil) {
            dev = DeviceInfo_t()
            if dev != nil{
                dev?.runtime = Clib.getUnixTime();
                dev?.stry = 0;
                dev?.keyID = keyID;
                dev?.state = state_invalid;
                dev?.device_info = JSON.null;
                dev?.port_list = [UInt8]();
                dev?.addr = addr;
                dev?.port_describe = [JSON]();
                myDeviceList.append(dev!);
                return Common.osSucceed;
            }
        }
        return Common.osFailed;
    }
    private static func addDeviceInfo(addr:[UInt8], devInfo:String)->Int {
        var info = JSON.init(parseJSON: devInfo);
        print(devInfo);
        if (info != JSON.null) {
            let dev:DeviceInfo_t? = getDeviceByAddr(addr:addr);
            if (dev != nil) {
                var str:String? = nil;
                dev?.device_info = info;
                str = info["guest_key"].stringValue;
                if (str != nil) && (str != "")  {
                    dev?.keyID = Common.keyID_guest.toU8;
                    let key:[UInt8] = Convert.hex_string_to_Uint8(str:str!);
                    if key.count>0 {
                        _ = Aps.AddDeviceKey(addr: dev!.addr, keyID: dev!.keyID, key: key)
                    }
                }
                
                str = info["com_key"].stringValue;
                if (str != nil) && (str != "") {
                    dev?.keyID = Common.keyID_common.toU8;
                    let key:[UInt8] = Convert.hex_string_to_Uint8(str:str!);
                    if key.count>0 {
                        _ = Aps.AddDeviceKey(addr: dev!.addr, keyID: dev!.keyID, key: key)
                    }
                }
                
                str = info["admin_key"].stringValue;
                if (str != nil) && (str != "") {
                    dev?.keyID = Common.keyID_admin.toU8;
                    let key:[UInt8] = Convert.hex_string_to_Uint8(str:str!);
                    if key.count>0 {
                        _ = Aps.AddDeviceKey(addr: dev!.addr, keyID: dev!.keyID, key: key)
                    }
                }
                return Common.osSucceed;
            }
        }
        return Common.osFailed;
    }
    private static func addDevciePortList(addr:[UInt8], ports:[UInt8])->Int {
        let dev:DeviceInfo_t? = getDeviceByAddr(addr:addr);
        if (dev != nil) {
            dev!.port_list = ports;
            return Common.osSucceed;
        }
    return Common.osFailed;
    }
    private static func addDevicePortDescribe(addr:[UInt8], desc:String)->Int {
        var have = false;
        var json:JSON;
        let dev = getDeviceByAddr(addr:addr);
        if (dev != nil) {
            print(desc);
            json = JSON.init(parseJSON: desc);
            if (json != JSON.null) {
                let port = json["port"].intValue;
                let plist = dev!.port_describe
                for js in  plist{
                    let sp = js["port"].intValue;
                    if (sp == port){
                        have = true;
                        break;
                    }
                }
                if (!have) {
                    dev!.port_describe.append(json);
                    return Common.osSucceed;
                }
            }
        }
        return Common.osFailed;
    }
    private class DeviceInfo_t {
        var stry:Int;
        var state:Int;
        var runtime:UInt64;
        var keyID:UInt8;
        var key_word:UInt8;
        var addr:[UInt8];
        var device_info:JSON;
        var port_list:[UInt8];
        var port_describe:[JSON];
        init() {
            stry = 0;
            state = 0;
            runtime = 0;
            keyID = 0;
            key_word = 0;
            addr = [UInt8]();
            device_info = JSON.null;
            port_list = [UInt8]();
            port_describe = [JSON]();
        }
    }
    public class onSectionListener {
        func DeviceJoinIndicates(addr:[UInt8])->Void{};
        func NewPortIndicates(addr:[UInt8],describe:JSON)->Void{};
        func ReceiveDeviceInfo(addr:[UInt8],devInfo:JSON,state:Int)->Void{};
        func ReceivePortList(addr:[UInt8],ports:[UInt8],state:Int)->Void{};
        func ReceivePortDescribe(addr:[UInt8],describe:JSON,state:Int)->Void{};
        func CompleteDevice(addr:[UInt8],devInfo:JSON,ports:[UInt8],descList:[JSON])->Void{};
        func ReceiveLqi(addr:[UInt8],port:UInt8,lqi:UInt8,state:Int)->Void{};
        func ReceiveBeacon(addr:[UInt8],state:Int)->Void{};
        func SendStatusCB(addr:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int)->Void{};
    }
    
    private static var mySection:Section = Section();
    private static var myDeviceList:[DeviceInfo_t] = [DeviceInfo_t]();
    private static var myListenerList:[onSectionListener] = [onSectionListener]();
    private static var runFlag = false;
    private static var locker = NSLock();
    
    private static let pollDevcieTimeout:UInt64 = 5000;
    
    private static let state_invalid:Int = 0;
    private static let state_reading_device_info:Int = 1;
    private static let state_got_device_info:Int = 2;
    private static let state_reading_port_list:Int = 3;
    private static let state_got_port_list:Int = 4;
    private static let state_reading_port_describe:Int = 5;
    private static let state_got_port_describe:Int = 6;
    private static let state_device_ready:Int = 7;
    
    public static func initialization()->Void {
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Beacon, listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Device_Indication,listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Device_Info, listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Port_List,listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Port_Describe,listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Port_Indication,listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Permite_Join,listener: DeviceHelper.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_Gen_Type_LQI,listener: DeviceHelper.mySection);
        print("initialation device helper \r\n");
        if DeviceHelper.runFlag==false{
            let queue = DispatchQueue(label:"test thread")  //SERIAL 代表串行
            queue.async(execute: DeviceHelper.poll);
            DeviceHelper.runFlag = true;
            print("initialation device task finished \r\n");
        }
    }
}
