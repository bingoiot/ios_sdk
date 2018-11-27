import Foundation

/**
 * Created by lort on 2018/5/28.
 */

public final class Record{
    private static let alarmFileName = "alarm.rd";
    private static let historyFileName = "history.rd";
    
    public static func initialization()->Void {
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_Alarm_Record,listener:Record.mySection);
        _ = Aps.SetOnSectionListener(aID:Common.aID_PDO_Type_History_Record,listener:Record.mySection);
    }

    public static func setAlarmRecordSectionListener(listener:onSectionListener)->Int{
        var isHave = false;
        for subsec in myAlarmRecordListener {
            if (subsec === listener) {
                isHave = true;
            }
        }
        if (isHave == false) {
            myAlarmRecordListener.append(listener);
            return Common.op_succeed;
        }
        return Common.op_faile;
    }
    public static func removeAlarmSectionListener(listener:onSectionListener)->Int
    {
        var ret = Common.op_faile;
        var i = 0;
        for  subsec in myAlarmRecordListener{
            if subsec === listener {
                myAlarmRecordListener.remove(at: i);
                ret = Common.op_succeed;
                break;
            }
            i = i + 1;
        }
        return ret;
    }
    public static func resetAlarmRecordSectionListener()->Int{
        myAlarmRecordListener = [onSectionListener]();
        return Common.op_succeed;
    }
    public static func setHistroryRecordSectionListener(listener:onSectionListener)->Int{
        var isHave = false;
        for subsec in myHistoryRecordListener {
            if (subsec === listener) {
                isHave = true;
            }
        }
        if (isHave == false) {
            myHistoryRecordListener.append(listener);
            return Common.op_succeed;
        }
        return Common.op_faile;
    }
    public static func removeHistorySectionListener(listener:onSectionListener)->Int
    {
        var ret = Common.op_faile;
        var i:Int = 0;
        for subsec in myHistoryRecordListener{
            if subsec === listener{
                myHistoryRecordListener.remove(at: i);
                ret = Common.op_succeed;
                break;
            }
            i = i + 1;
        }
        return ret;
    }
    public static func resetHistoryRecordSectionListener()->Int{
        myHistoryRecordListener = [onSectionListener]();
        return Common.op_succeed;
    }
    public static func reqReadHistory( keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_History_Record,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func reqDeleteHistory( keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_History_Record,cmd:Common.cmd_del.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func reqReadHistoryEnableFlag( keyID:UInt8,  dst:[UInt8],  seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_History_Record,cmd:Common.cmd_readstate.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func reqWriteHistoryEnableFlag( keyID:UInt8,  dst:[UInt8],  seq:UInt16, enable:Bool)->Int
    {
        var buf:[UInt8] = [UInt8]();
        if enable==false{
            buf.append(0);
        }
        else{
            buf.append(1);
        }
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_History_Record,cmd:Common.cmd_readstate.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    public static func reqReadAlarm( keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Alarm_Record,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8);
    }
    public static func reqDeleteAlarm( keyID:UInt8, dst:[UInt8], seq:UInt16)->Int
    {
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Alarm_Record,cmd:Common.cmd_del.toU8, option:Common.aID_Common_Option.toU8);
    }
    private static  func ProcessCallBack(listenerList:[onSectionListener],  keyID:UInt8,  src:[UInt8],  seq:UInt16,  pdata:[UInt8])->Void
    {
        let state = pdata[0];
        if(state == Common.op_succeed) {
            let str = Convert.arrary_Uint8_to_string(arrary: pdata, start_index: 1, len: (pdata.count-1));
            let arrayList = JSON.init(parseJSON: str);
            if (arrayList != JSON.null){
                for  i in (0 ... arrayList.count - 1) {
                    let tagStr = arrayList[i]["tag"].stringValue; //getString("tag");
                    let unix_time = arrayList[i]["date"].int64Value;
                    let cmdStr = arrayList[i]["cmd"].stringValue;
                    let addStr = arrayList[i]["addr"].stringValue;
                    let dataStr = arrayList[i]["data"].stringValue;
                    let toaddr = Convert.hex_string_to_Uint8(str: addStr);
                    let todata = Convert.hex_string_to_Uint8(str: dataStr);
                    let tocmd = Convert.hex_string_to_Uint8(str: cmdStr);
                    let sport = get_port(data:toaddr);
                    //let skeyID = get_keyID(data:toaddr);
                    let dev_addr = get_addr(data:toaddr);
                    let saID = get_aID(data:tocmd);
                    let scmd = get_cmd(data:tocmd);
                    let soption = get_option(data:tocmd);
                    for  subsec in listenerList {//search every section listener to callback
                        subsec.ReadCB(keyID:keyID, src:src, seq:seq, state:state.toInt, tag:tagStr, unix_time:unix_time.toU32, dev_addr:dev_addr, port:sport, cmd:scmd, option:soption, aID:saID, pdata:todata);
                    }
                }
            }
        }
    }
    private static  func get_addr(data:[UInt8])->[UInt8]
    {
        let addr = Clib.cut_Uint8_arrary(arrary: data, start: 0, len: 8);
        return addr;
    }
    private static  func get_port(data:[UInt8])->UInt8
    {
        return data[8]&255;
    }
    private static  func get_keyID(data:[UInt8])->UInt8
    {
        return data[9]&255;
    }
    private static  func get_cmd(data:[UInt8])->UInt8
    {
        return data[0]&255;
    }
    private static  func get_option(data:[UInt8])->UInt8
    {
        return data[1]&255;
    }
    private static func get_aID(data:[UInt8])->Int
    {
        let aID = Clib.BtoU32(pdata: data, startIndex: 2, bytes: 4);
        return aID.toInt;
    }
    public class onSectionListener{
        public  func ReadCB( keyID:UInt8,  src:[UInt8],  seq:UInt16,  state:Int, tag:String, unix_time:UInt32,  dev_addr:[UInt8],  port:UInt8,  cmd:UInt8,  option:UInt8, aID:Int,  pdata:[UInt8])->Void{};
        public  func DeleteCB( keyID:UInt8,  src:[UInt8],  seq:UInt16,  state:Int)->Void{};
        public  func ReadStateCB( keyID:UInt8,  src:[UInt8],  seq:UInt16,  state:Int,  enable:UInt8)->Void{};
        public  func WriteStateCB( keyID:UInt8,  src:[UInt8],  seq:UInt16,   state:Int)->Void{};
        public  func SendState( src:[UInt8],  seq:UInt16,  state:Int)->Void{};
    }
    private static var myAlarmRecordListener:[onSectionListener]=[onSectionListener]();
    private static var myHistoryRecordListener:[onSectionListener]=[onSectionListener]();
    private static let mySection:Section = Section();
    private class Section:Aps.onSectionListener{
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            if(aID == Common.aID_PDO_Type_Alarm_Record) {
                switch(cmd&0x7F) {
                case Common.cmd_read.toU8://read scene respone]
                    ProcessCallBack(listenerList:myAlarmRecordListener,keyID:keyID,src:src,seq:seq,pdata:pdata);
                    break;
                case Common.cmd_del.toU8://delect scene respone
                    let state = FileSystem.getState(pdata:pdata);
                    //let fname = FileSystem.getName(pdata:[UInt8]());
                    for subsec in myAlarmRecordListener {//search every section listener to callback
                        subsec.DeleteCB(keyID:keyID,src:src,seq:seq,state:state.toInt);
                    }
                    break;
                default: break;
                }
            }
            else if(aID == Common.aID_PDO_Type_History_Record) {
                switch(cmd&0x7F) {
                case Common.cmd_read.toU8://read scene respone]
                    ProcessCallBack(listenerList:myHistoryRecordListener,keyID:keyID,src:src,seq:seq,pdata:pdata);
                    break;
                case Common.cmd_del.toU8://delect scene respone
                    let state = FileSystem.getState(pdata:pdata);
                    //let fname = FileSystem.getName(pdata:[UInt8]());
                    for subsec in myHistoryRecordListener {//search every section listener to callback
                        subsec.DeleteCB(keyID:keyID,src:src,seq:seq,state:state);
                    }
                    break;
                case Common.cmd_readstate.toU8:
                    for subsec in myHistoryRecordListener {//search every section listener to callback
                        subsec.ReadStateCB(keyID:keyID,src:src,seq:seq,state:pdata[0].toInt,enable:pdata[1]);
                    }
                    break;
                case Common.cmd_writestate.toU8:
                    for subsec in myHistoryRecordListener{//search every section listener to callback
                        subsec.WriteStateCB(keyID:keyID,src:src,seq:seq,state:pdata[0].toInt);
                    }
                    break;
                default :break;
                }
            }
        }
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            if(aID == Common.aID_PDO_Type_Alarm_Record) {
                for subsec in myAlarmRecordListener{//search every section listener to callback
                    subsec.SendState(src:src,seq:seq,state:state);
                }
            }
            else if(aID == Common.aID_PDO_Type_History_Record) {
                for subsec in myHistoryRecordListener {//search every section listener to callback
                    subsec.SendState(src:src,seq:seq,state:state);
                }
            }
        }
    }
}
