//
//  Convert.swift
//  smarthome
//
//  Created by lu on 2018/10/22.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final class Convert {
    public static func unsafe_Int8_to_arrary(ptr:UnsafeMutablePointer<Int8>, len:Int)->[UInt8]{
        var buf:[UInt8] = [UInt8]();
        for i in 0...(len-1){
            buf.append(ptr[i].toU8);
        }
        return buf;
    }
    public static func unsafe_UInt8_to_arrary(ptr:UnsafeMutablePointer<UInt8>, len:Int)->[UInt8]{
        var buf:[UInt8] = [UInt8]();
        for i in 0...(len-1){
            buf.append(ptr[i]);
        }
        return buf;
    }
    public static func arrary_to_unsafe_Int8(arrary:[UInt8]) -> UnsafeMutablePointer<Int8> {
        let ptr = UnsafeMutablePointer<Int8>.allocate(capacity: arrary.count);
        for i in 0...(arrary.count-1)
        {
            ptr[i] = arrary[i].to8;
        }
        return ptr;
    }
    public static func arrary_to_unsafe_UInt8(arrary:[UInt8]) -> UnsafeMutablePointer<UInt8> {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: arrary.count);
        for i in 0...(arrary.count-1)
        {
            ptr[i] = arrary[i].toU8;
        }
        return ptr;
    }
    public static func arrary_character_to_unsafe_UInt8(arrary:[CChar]) -> UnsafeMutablePointer<UInt8> {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: arrary.count);
        for i in 0...(arrary.count-1)
        {
            ptr[i] = arrary[i].toU8;
        }
        return ptr;
    }
    public static func arrary_character_to_UInt8(arrary:[CChar]) -> [UInt8] {
        var buf = [UInt8]();
        for i in 0...(arrary.count-1)
        {
            buf.append(arrary[i].toU8);
        }
        return buf;
    }
    public static func arrary_Uint8_to_string(arrary:[UInt8], start_index:Int, len:Int)->String{
        if arrary.count<(start_index+len){
            return "";
        }
        let buf = UnsafeMutablePointer<CChar>.allocate(capacity: (len+1));
        for i in 0...(len-1)
        {
            buf[i] = arrary[i+start_index].to8;
        }
        buf[len] = 0x00;
        let str = unsafe_cstring_to_string(cstr: buf);
        buf.deallocate();
        return str;
    }
    public static func string_to_arrary(str:String)->[UInt8]{
        var char_list: [CChar] = str.cString(using: String.Encoding.ascii)!
        var cstr:[UInt8]=[UInt8]();
        for i in 0...(char_list.count-1)
        {
            cstr[i] = char_list[i].toU8;
        }
        return cstr ;
    }
    public static func string_to_unsafe_cstring(str:String) -> UnsafeMutablePointer<CChar>{
        var char_list: [CChar] = str.cString(using: String.Encoding.ascii)!
        let cstr = UnsafeMutablePointer<CChar>.allocate(capacity: char_list.count);
        for i in 0...(char_list.count-1)
        {
            cstr[i] = char_list[i];
        }
        return cstr ;
    }
    public static func unsafe_cstring_to_string(cstr:UnsafeMutablePointer<CChar>)->String {
        let str:String = String(cString: cstr, encoding: String.Encoding.utf8)!;
        return str;
    }
    public static func hex_string_to_Uint8(str:String)->[UInt8]{
        var buf:[UInt8] = [UInt8]();
        var temp:UInt8;
        let num = str.count;
        for i in 0...((num/2)-1){
            let idH = str.index(str.startIndex,offsetBy:(i*2));
            temp = Clib.hex_to_byte(ch: str[idH]);
            temp <<= 4;
            let idL = str.index(str.startIndex,offsetBy:((i*2)+1));
            temp |= Clib.hex_to_byte(ch: str[idL]);
            buf.append(temp);
        }
        return buf;
    }
    public static func arrary_Uint8_to_hex_string(arrary:[UInt8])->String{
        var str:String="";
        for i in 0...(arrary.count-1){
            str = str + String().appendingFormat("%02x",arrary[i].toInt);
        }
        return str;
    }
}
extension Int64 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}} //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}}  //No difference if the platform is 32 or 64
}
extension UInt64 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return Int32(self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}}
    //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}} //No difference if the platform is 32 or 64
}
extension Int32 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}} //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}}  //No difference if the platform is 32 or 64
}
extension UInt32 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return Int32(self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}}
    //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}} //No difference if the platform is 32 or 64
}
extension Int {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}} //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}}  //No difference if the platform is 32 or 64
}
extension UInt {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return Int32(self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}}
    //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}} //No difference if the platform is 32 or 64
}
extension Int16 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}} //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}}  //No difference if the platform is 32 or 64
}
extension UInt16 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return Int32(self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}}
    //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}} //No difference if the platform is 32 or 64
}
extension UInt8 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}} //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}}  //No difference if the platform is 32 or 64
}
extension Int8 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return Int32(self)}}
    public var toUInt: UInt{get{return UInt(truncatingIfNeeded:self)}}
    public var toInt: Int{get{return Int(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{ return UInt64(self)}}
    //No difference if the platform is 32 or 64
    public var to64: Int64{get{ return Int64(self)}} //No difference if the platform is 32 or 64
}
