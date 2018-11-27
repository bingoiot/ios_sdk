//
//  FileSystem.swift
//  smarthome
//
//  Created by lu on 2018/10/27.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

/**pdata structure as floww:
 char     crc[2];
 byte    nlen[2];
 byte    dlen[4];
 byte    pdata[0];*/

final public class FileSystem {
    
    /**pdata structure as floww:
     char     crc[2];
     byte    nlen[2];
     byte    dlen[4];
     byte    pdata[0];*/
    static var dbuf:[UInt8] = [UInt8]();
    public static func  getState(pdata:[UInt8])->Int{
        let state = pdata[0];
        dbuf = Clib.cut_Uint8_arrary(arrary: pdata, start:1, len:(pdata.count-1));
        return state.toInt;
    }
    public static func getName(pdata:[UInt8])->String?
    {
        var pbuf:[UInt8];
        var name:String? = nil;
        if(pdata.count==0){
            pbuf = dbuf;
        }
        else{
            pbuf = pdata;
        }
        let nlen = getNameLenth(pdata:pbuf);
        if(nlen <= pbuf.count) {
            name = Convert.arrary_Uint8_to_string(arrary: pbuf, start_index: 8, len: nlen);
        }
        return name;
    }
    public static func getNameLenth(pdata:[UInt8])->Int
    {
        var pbuf:[UInt8] = [UInt8]();
        if(pdata.count==0){
            pbuf = dbuf;
        }
        else{
            pbuf = pdata;
        }
        var nlen:UInt32 = 0;
        if(pbuf.count >= 4){
            nlen = Clib.BtoU32(pdata: pbuf, startIndex: 2, bytes: 2);
        }
        return nlen.toInt;
    }
    public static func getDataLenth(pdata:[UInt8])->Int
    {
        var pbuf:[UInt8] = [UInt8]();
        if(pdata.count==0){
            pbuf = dbuf;
        }
        else{
            pbuf = pdata;
        }
        var nlen:UInt32 = 0;
        if(pbuf.count >= 8){
            nlen = Clib.BtoU32(pdata: pbuf, startIndex: 4, bytes: 4);
        }
        return nlen.toInt;
    }
    public static func getData(pdata:[UInt8])->[UInt8]
    {
        var buf:[UInt8]=[UInt8]();
        var pbuf:[UInt8] = [UInt8]();
        if(pdata.count==0){
            pbuf = dbuf;
        }
        else{
            pbuf = pdata;
        }
        let nlen = getNameLenth(pdata:pbuf);
        let dlen = getDataLenth(pdata:pbuf);
        if((dlen != 0)&&(dlen <= (pbuf.count-nlen))) {
            buf = Clib.cut_Uint8_arrary(arrary: pbuf, start: (8+nlen), len: dlen);
        }
        return buf;
    }
    /**pdata structure as floww:
     char     crc[2];
     byte    nlen[2];
     byte    dlen[4];
     byte    pdata[0];*/
    public static func genPackage(fname:String, pdata:[UInt8])->[UInt8]
    {
        let arrary_name = Convert.string_to_arrary(str: fname);
        let nlen:UInt16 = arrary_name.count.toU16;
        let dlen:UInt32 = pdata.count.toU32;
        var buf:[UInt8] = [UInt8]();
        
        buf = arrary_name + pdata;
        let crc:UInt16 = Clib.CRC16(crc: 0, pdata: buf, pos: 0, len: buf.count);
        buf = Clib.U16toB(value: crc) + buf;
        buf = Clib.U16toB(value: nlen) + buf;
        buf = Clib.U32toB(value: dlen) + buf;
        return buf;
    }
    public static func genPackage(fname:String, str:String)->[UInt8]
    {
        let pdata = Convert.string_to_arrary(str: str);
        let buf = genPackage(fname: fname, pdata: pdata);
        return buf;
    }
    public static func genPackage(fname:String, state:Int, str:String)->[UInt8]
    {
        var buf:[UInt8] = [UInt8]();
        buf.append(state.toU8);
        buf = buf + Convert.string_to_arrary(str: str);
        buf = genPackage(fname: fname, pdata: buf);
        return buf;
    }
    public static func genPackage(fname:String)->[UInt8]
    {
        let arrary_name = Convert.string_to_arrary(str: fname);
        let nlen:UInt16 = arrary_name.count.toU16;
        let dlen:UInt32 = 0;
        var buf:[UInt8] = [UInt8]();
        
        buf = arrary_name;
        let crc:UInt16 = Clib.CRC16(crc: 0, pdata: buf, pos: 0, len: buf.count);
        buf = Clib.U16toB(value: crc) + buf;
        buf = Clib.U16toB(value: nlen) + buf;
        buf = Clib.U32toB(value: dlen) + buf;
        return buf;
    }
    public static func genPackage(fname:String, state:Int)->[UInt8]
    {
        var buf:[UInt8]=[UInt8]();
        buf.append(state.toU8);
        buf = genPackage(fname: fname, pdata: buf);
        return buf;
    }
}

