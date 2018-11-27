//
//  Device.swift
//  smarthome
//
//  Created by lo r t on 2018/11/8.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation
/**** json device list example
 [
    {"addr":"xxxx",
    "port_list":[
        {"port":1,"app_id":xx,"attr_id":[xx,xx,xx],"name":"xx"},
        {"port":2,"app_id":xx,"attr_id":[xx,xx,xx],"name":"xx"}],
    "name":"xxx";
    },
    {"addr":"xxxx",
    "port_list":[
        {"port":1,"app_id":xx,"attr_id":[xx,xx,xx],"name":"xx"},
        {"port":2,"app_id":xx,"attr_id":[xx,xx,xx],"name":"xx"}],
    "name":"xxx";
    }
 ]
 *******/
final public class DeviceDB{
    public static func PrintDevice()->Void{
        if let str = myDeviceList.rawString(){
            print(str);
        }
    }
    public static func RemoveAllDevice()->Int{
        let num = myDeviceList.count - 1;
        var ret = -1;
        for i in (0 ... num).reversed() {
            _ = myDeviceList.dropFirst(i);
            ret = 0;
        }
        myDeviceList = JSON();
        return ret;
    }
    public static func RemoveDevice(addr:[UInt8])->Int{
        let str_addr = Convert.arrary_Uint8_to_hex_string(arrary: addr);
        let num = myDeviceList.count - 1;
        var ret = -1;
        if(num>0){
            for i in (0 ... num).reversed(){
                if myDeviceList[i]["addr"].stringValue == str_addr{
                    _ = myDeviceList.dropFirst(i);
                    ret = 0;
                }
            }
        }
        return ret;
    }
    public static func RemovePort(addr:[UInt8],port:UInt8)->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        var ret = -1;
        if dev_id >= 0{
            let port_list = myDeviceList[dev_id]["port_list"];
            let port_num = port_list.count - 1;
            if port_num >= 0{
                for j in (0 ... port_num).reversed() {
                    if port_list[j]["port"].intValue == port.toInt{
                        _ = port_list.dropFirst(j);
                        ret = 0;
                    }
                }
            }
        }
        return ret;
    }
    public static func AddDevice(addr:[UInt8],force:Bool)->Int{
        let str_addr = Convert.arrary_Uint8_to_hex_string(arrary: addr);
        var dev:JSON = JSON();
        dev["addr"].stringValue = str_addr;
        if(myDeviceList.arrayObject == nil){
            myDeviceList.arrayObject = [Any]();
        }
        myDeviceList.arrayObject!.append(dev);
        return 0;
    }
    
    public static func AddDevice(addr:[UInt8],name:String,force:Bool)->Int{
        var ret:Int;
        ret = AddDevice(addr: addr, force: force);
        ret = SetDeviceName(addr: addr, name: name);
        return ret;
    }
    public static func AddDeviceInfo(addr:[UInt8],info:JSON)->Int{
        var ret = -1;
        let dev_id = GetIndexByAddr(addr: addr);
        if dev_id >= 0 {
            myDeviceList[dev_id]["admin_key"].stringValue = info["admin_key"].stringValue;
            myDeviceList[dev_id]["com_key"].stringValue = info["com_key"].stringValue;
            myDeviceList[dev_id]["guest_key"].stringValue = info["guest_key"].stringValue;
            myDeviceList[dev_id]["name"].stringValue = info["name"].stringValue;
            myDeviceList[dev_id]["dev_type"].intValue = info["dev_type"].intValue;
            myDeviceList[dev_id]["zone"].intValue = info["zone"].intValue;
            myDeviceList[dev_id]["encrypt"].intValue = info["encrypt"].intValue;
            myDeviceList[dev_id]["remote_lock"].intValue = info["remote_lock"].intValue;
            myDeviceList[dev_id]["guest_lock"].intValue = info["guest_lock"].intValue;
            myDeviceList[dev_id]["share_lock"].intValue = info["share_lock"].intValue;
            myDeviceList[dev_id]["history_record"].intValue = info["history_record"].intValue;
            myDeviceList[dev_id]["version"].intValue = info["version"].intValue;
            myDeviceList[dev_id]["attr_id"] = info["attr_id"];
            ret = 0;
        }
        return ret;
    }
    
    public static func AddPort(addr:[UInt8],port_info:JSON)->Int{
        let port_name = port_info["name"].stringValue;
        let port = port_info["port"].intValue.toU8;
        let appID:UInt32 = port_info["app_id"].intValue.toU32;
        var attrID = [UInt32]();
        var temp:UInt32;
        let num = port_info["attr_id"].count;
        if(num > 0){
            for i in (0 ... (num-1)){
                temp = port_info["attr_id"][i].intValue.toU32;
                attrID.append(temp);
            }
        }
        var ret:Int;
        ret = AddPort(addr: addr,port:port, appID: appID, attrID: attrID,force:true);
        ret = SetPortName(addr: addr, port: port, name: port_name);
        return ret;
    }
    public static func AddPort(addr:[UInt8], port:UInt8, appID:UInt32, attrID:[UInt32],force:Bool)->Int{
        var ret:Int;
        if(force == true){
            ret = RemovePort(addr: addr, port: port);
        }
        var dev = JSON();
        dev["port"].intValue = port.toInt;
        dev["app_id"].intValue = appID.toInt;
        dev["attr_id"].arrayObject = attrID;
        let dev_id = GetIndexByAddr(addr: addr);
        if(dev_id >= 0){
            if(myDeviceList[dev_id]["port_list"].arrayObject == nil){
                myDeviceList[dev_id]["port_list"].arrayObject = [Any]();
            }
            myDeviceList[dev_id]["port_list"].arrayObject!.append(dev);
            ret = 0;
        }
        else
        {
            ret = -1;
        }
        return ret;
    }
    public static func SetDeviceName(addr:[UInt8],name:String)->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        if dev_id >= 0{
            myDeviceList[dev_id]["name"].stringValue = name;
            return 0;
        }
        return -1;
    }
    public static func SetPortName(addr:[UInt8],port:UInt8,name:String)->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        let port_id = GetIndexByPort(addr: addr, port: port);
        if dev_id >= 0 && port_id >= 0 {
            myDeviceList[dev_id]["port_list"][port_id]["name"].stringValue = name;
            return 0;
        }
        return -1;
    }
    public static func Count()->Int{
        return myDeviceList.count;
    }
    public static func GetAddrById(index:Int)->[UInt8]{
        var addr:[UInt8] = [UInt8]();
        let dev = myDeviceList[index];
        if(dev != JSON.null){
            let addr_str = dev["addr"].stringValue;
            addr  = Convert.hex_string_to_Uint8(str: addr_str);
        }
        return addr;
    }
    public static func GetGoodKeyId(addr:[UInt8])->Int{
        let dev_id = GetIndexByAddr(addr:addr);
        if dev_id >= 0{
            let dev = myDeviceList[dev_id];
            if(dev["admin_key"].stringValue != ""){
                return Common.keyID_admin;
            }
            else if(dev["admin_key"].stringValue != ""){
                return Common.keyID_common;
            }
            else if(dev["admin_key"].stringValue != ""){
                return Common.keyID_guest;
            }
        }
        return Common.keyID_none;
    }
    public static func CountPort(addr:[UInt8])->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        if(dev_id >= 0){
            let port_list = myDeviceList[dev_id]["port_list"];
            return port_list.count;
        }
        return -1;
    }
    public static func GetPortById(addr:[UInt8], index:Int)->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        if(dev_id >= 0){
            let port_list = myDeviceList[dev_id]["port_list"];
            if(port_list.count > 0)&&(port_list.count > index){
                return port_list[index]["port"].intValue;
            }
        }
        return -1;
    }
    public static func GetApplicationID(addr:[UInt8], port:Int)->Int32{
        let dev_id = GetIndexByAddr(addr: addr);
        if(dev_id >= 0){
            let port_list = myDeviceList[dev_id]["port_list"];
            if(port_list.count > 0){
                let num = port_list.count - 1;
                for i in 0 ... num{
                    let p = port_list[i]["port"].intValue;
                    if (p == port){
                        return p.to32;
                    }
                }
            }
        }
        return -1;
    }
    public static func GetAttributeIDList(addr:[UInt8], port:Int)->[Int32]{
        let dev_id = GetIndexByAddr(addr: addr);
        var attr_list = [Int32]();
        if(dev_id >= 0){
            let port_list = myDeviceList[dev_id]["port_list"];
            if(port_list.count > 0){
                let num = port_list.count - 1;
                for i in 0 ... num{
                    let p = port_list[i]["port"].intValue;
                    if (p == port){
                        attr_list = port_list[i]["attr_id"].arrayObject as! [Int32];
                    }
                }
            }
        }
        return attr_list;
    }
    private static func GetIndexByAddr(addr:[UInt8])->Int{
        let str_addr = Convert.arrary_Uint8_to_hex_string(arrary: addr);
        var num = 0;
        if(myDeviceList.count>0){
            num = myDeviceList.count - 1;
            for i in (0 ... num).reversed(){
                let str = myDeviceList[i]["addr"].stringValue;
                if(str == str_addr){
                    return i;
                }
            }
        }
        return -1;
    }
    private static func GetIndexByPort(addr:[UInt8], port:UInt8)->Int{
        let dev_id = GetIndexByAddr(addr: addr);
        if( dev_id >= 0 ){
            var port_list = myDeviceList[dev_id]["port_list"];
            if(port_list.count>0){
                let num = port_list.count - 1 ;
                for i in (0...num).reversed(){
                    if port_list[i]["port"].intValue == port{
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    static var myDeviceList:JSON = JSON();
}
