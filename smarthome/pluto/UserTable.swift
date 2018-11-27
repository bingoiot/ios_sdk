import Foundation

/**
 * Created by lort on 2017/11/7.
 *          file name: "usrtable.tb"
 *         [
 *      	{
 *      	user:xxxxx
 *      	port:xxxxx
 *      	},
 *      	{
 *      	user:xxxxx
 *      	port:xxxxx
 *      	}
 *      ]
 */

public class UserTable {
    public static func initialization()->Void{
        _ = Aps.SetOnSectionListener(aID: Common.aID_PDO_Type_White_Table,listener:mySection);
    }
    public static func setSectionListener(listener:onSectionListener)->Int{
        var isHave = false;
        for subsec in myListener {
            if (subsec === listener) {
                isHave = true;
            }
        }
        if (isHave == false) {
            myListener.append(listener);
            return Common.op_succeed;
        }
        return Common.op_faile;
    }
    public static func removeSectionListener(listener:onSectionListener)->Int
    {
        var ret = Common.op_faile;
        for subsec in myListener {
            if subsec === listener{
                myListener.append(listener);
                ret = Common.op_succeed;
            }
        }
        return ret;
    }
    public static func resetSectionListener()->Int{
        myListener = [onSectionListener]();
        return Common.op_succeed;
    }

    public static func reqRead(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_White_Table,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func reqDelete(keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_White_Table,cmd:Common.cmd_del.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func create(white_list:Bool)->Int
    {
        jUserTable = JSON();
        if white_list == false{
            jUserTable["list_flag"] = 0;
        }else{
            jUserTable["list_flag"] = 1;
        }
        return Common.op_succeed;
    }
    public static func put(addr:[UInt8],port_list:[UInt8])->Int
    {
        if(jUserTable.count == 0) {
            return Common.op_faile;
        }
        let suser = Convert.arrary_Uint8_to_hex_string(arrary: addr);
        let port_map = convertBitmapFromPort(port_list: port_list);
        let ports = Convert.arrary_Uint8_to_hex_string(arrary: port_map);
        
        var node = JSON();
        node["user"].stringValue = suser;
        node["port"].stringValue = ports;
        if jUserTable["user_list"].exists() == false{
            jUserTable["user_list"][0] = node;
        }else{
            let index = jUserTable["user_list"].count - 1;
            jUserTable["user_list"][index] = node;
        }
        return Common.op_succeed;
    }
    public static func reqSave(keyID:UInt8, dst:[UInt8], seq:UInt16, table:String)->Int
    {
        let buf = Convert.string_to_arrary(str: table);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_White_Table,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    public static func output()->String
    {
        if let str = jUserTable.rawString(){
            return str;
        }else{
            return "";
        }
    }

    private static func readCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void
    {
        /**pdata structure as floww:
         char 	crc[2];
         byte	nlen[2];
         byte	dlen[4];
         byte	pdata[0];*/
        let state = FileSystem.getState(pdata:pdata);
        var white_list = false;
        if(state == Common.op_succeed) {
            let str = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (pdata.count-1))
            let root = JSON.init(parseJSON:str);
            if root != JSON.null {
                let flag = root["list_flag"].intValue;
                if flag == 0{
                    white_list = false
                }
                else {
                    white_list = true;
                }
                for i in 0 ... (root["user_list"].count - 1) {
                    let user = root[i]["user"].stringValue;
                    let ports = root[i]["port"].stringValue;
                    let saddr = Convert.hex_string_to_Uint8(str: user);
                    let port_map = Convert.hex_string_to_Uint8(str: ports);
                    let port_list = convertPortFromBitmap(bitmap: port_map);
                    for sec in myListener{
                        sec.ReadCB(keyID: keyID, addr: addr, state: state, white_list: white_list, userAddr: saddr, portlist:port_list);
                    }
                }
            }
        }
    }
    private static func writeCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void
    {
        let state = FileSystem.getState(pdata:pdata);
        for subsec in myListener {
            subsec.WriteCB(keyID:keyID,addr: addr,state: state);
        }
    }
    private static func deleteCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void
    {
        let state = FileSystem.getState(pdata:pdata);
        for subsec in myListener {
            subsec.DeleteCB(keyID:keyID,addr: addr,state: state);
        }
    }
    private static func convertPortFromBitmap(bitmap:[UInt8])->[UInt8]
    {
        var port_list = [UInt8]();
        var port_number:UInt8 = 255;
        for i in 0 ... (bitmap.count - 1){
            var temp = bitmap[i] & 0xFF;
            var j = 0;
            while (j < 8){
                if (temp & 0x80) > 0 {
                    port_list.append(port_number);
                }
                temp = temp << 1;
                port_number  = port_number - 1;
                j = j + 1;
            }
        }
        return port_list;
    }
    private static func convertBitmapFromPort(port_list:[UInt8])->[UInt8]
    {
        var bitmap = [UInt8](repeating: 0, count: 32);
        for i in 0 ... (port_list.count - 1){
            
            let temp = port_list[i] & 0xFF;
            let offset = 31 - (temp/8);
            let bit = temp % 8;
            bitmap[offset.toInt] |= (1 << bit);
        }
        return bitmap;
    }
    private static var myListener:[onSectionListener] = [onSectionListener]();
    private static var mySection:Section = Section();
    private static var jUserTable:JSON = JSON();
    
    private class Section:Aps.onSectionListener{
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            switch(cmd&0x7F) {
            case Common.cmd_read.toU8://read scene respone]
                readCB(keyID:keyID,addr: src,pdata: pdata);
            case Common.cmd_write.toU8://write scene respone
                writeCB(keyID:keyID,addr: src,pdata: pdata);
            case Common.cmd_del.toU8://delect scene respone
                deleteCB(keyID:keyID,addr: src,pdata: pdata);
            default:break;
            }
        };
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            for subsec in myListener{
                subsec.SendStatusCB(addr:src,state:state);
            }
        }
    }
    public class onSectionListener{
        public func ReadCB(keyID:UInt8, addr:[UInt8], state:Int, white_list:Bool, userAddr:[UInt8], portlist:[UInt8])->Void{};
        public func WriteCB(keyID:UInt8, addr:[UInt8], state:Int)->Void{};
        public func DeleteCB(keyID:UInt8, addr:[UInt8], state:Int)->Void{};
        public func SendStatusCB(addr:[UInt8], state:Int)->Void{};
    }

}
