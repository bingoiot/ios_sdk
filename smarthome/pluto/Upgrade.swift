import Foundation
/**
 * Created by lort on 2017/11/10.
 */

public class Upgrade {

    public static func initialization()->Void{
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Upgrade,listener: mySection);
    }
    public static func setSectionListener(listener:onSectionListener)->Int{
        var isHave = false;
        for subsec in myListener {
            if subsec === listener {
                isHave = true;
            }
        }
        if isHave==false {
            myListener.append(listener);
            return Common.op_succeed;
        }
        return Common.op_faile;
    }
    public static func removeSectionListener(listener:onSectionListener)->Int
    {
        var ret = Common.op_faile;
        var i = 0;
        for subsec in myListener {
            if subsec === listener{
                myListener.remove(at: i);
                ret = Common.op_succeed;
                break;
            }
            i = i + 1;
        }
        return ret;
    }
    public static func resetSectionListener()->Int{
        myListener = [onSectionListener]();
        return Common.op_succeed;
    }
    public static func reqUpdate(keyID:UInt8,dst:[UInt8], server_ip:String, server_port:Int, server_url:String, stry:Int)->Int
    {
        var root = JSON();
        root["server_ip"].stringValue = server_ip;
        root["server_port"].intValue = server_port;
        root["server_url"].stringValue = server_url;
        root["try"].intValue = stry;
        root["state"].intValue = Common.op_upgrade_start;
        if let out = root.rawString(){
            let buf = Convert.string_to_arrary(str: out);
            return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Upgrade,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
        }
        return Common.op_faile;
    }
    public static func reqReadInfo(keyID:UInt8,dst:[UInt8])->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Upgrade,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    private static func readCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void
    {
        if pdata.count == 0{
            return ;
        }
        let state = pdata[0];
        if state == Common.op_succeed {
            let str = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (pdata.count-1));
            for subsec in myListener {
                subsec.ReadInfoCB(keyID:keyID, addr:addr, state:state.toInt, info:str);
            }
        }
    }
    private static func updateCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])
    {
        if pdata.count == 0{
            return ;
        }
        let state = pdata[0];
        var percent = 0;
        if(pdata.count==2){
            percent = pdata[1].toInt;
        }
        for subsec in myListener {
            subsec.UpdateStateCB(keyID: keyID, addr: addr, state: state.toInt, percent: percent);
        }
    }
    private static var myListener:[onSectionListener]=[onSectionListener]();
    private static let mySection:Section = Section();
    
    private class Section:Aps.onSectionListener{
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            switch(cmd&0x7F) {
            case Common.cmd_read.toU8://read scene respone]
                readCB(keyID:keyID, addr:src,pdata:pdata);
                break;
            case Common.cmd_write.toU8:
                for subsec in myListener {
                    subsec.UpdateStateCB(keyID:keyID,addr:src,state:pdata[0].toInt,percent:0);
                }
                break;
            case Common.cmd_notify.toU8:
                for subsec in myListener {
                    subsec.UpdateStateCB(keyID:keyID, addr:src, state:pdata[0].toInt,percent:pdata[1].toInt);
                }
                break;
            default:break;
            }
        }
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            
        }
    }
    public class onSectionListener{
        public func ReadInfoCB(keyID:UInt8, addr:[UInt8], state:Int, info:String)->Void{};
        public func UpdateStateCB(keyID:UInt8, addr:[UInt8], state:Int, percent:Int)->Void{};
    }
}
