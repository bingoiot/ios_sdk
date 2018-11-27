import Foundation

/**
 * Created by lort on 2017/11/2.
 */

/**
 * pdata structure as floww:
 * char 	crc[2];
 * byte	nlen[2];
 * byte	dlen[4];
 * byte	pdata[0];
 */
public final class Scene {
    
    public static func initialization()->Void {
        _ = Aps.SetOnSectionListener(aID: Common.aID_PDO_Type_Scene, listener: mySection);
    }
    public static func setSectionListener(listener:onSectionListener)->Int {
        var isHave = false;
        for subsec in myListener {
            if  subsec === listener {
                isHave = true;
            }
        }
        if isHave == false {
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
    public static func resetSectionListener()->Int {
        myListener = [onSectionListener]();
        return Common.op_succeed;
    }
    public static func reqRead(keyID:UInt8,dst:[UInt8],seq:UInt16, fname:String)->Int  {
        let buf = FileSystem.genPackage(fname:fname);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_read.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqWrite(keyID:UInt8, dst:[UInt8], seq:UInt16, fname:String, text:String)->Int  {
        let buf = FileSystem.genPackage(fname:fname, str:text);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_write.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqDel(keyID:UInt8, dst:[UInt8],seq:UInt16, fname:String)->Int  {
        let buf = FileSystem.genPackage(fname:fname);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_del.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqReadAllName(keyID:UInt8, dst:[UInt8],seq:UInt16)->Int //read all scence name
    {
        let buf = FileSystem.genPackage(fname:"*.vm");
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_readname.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqRenameScene(keyID:UInt8, dst:[UInt8], seq:UInt16, oldname:String, newname:String)->Int //rename scence
    {
        let buf = FileSystem.genPackage(fname:oldname,str:newname);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_rename.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqJoin(keyID:UInt8, dst:[UInt8], seq:UInt16, tsk0:String, tsk1:String)->Int //join another scene and set the scene run util other's run finished
    {
        let buf = FileSystem.genPackage(fname:tsk0,str:tsk1);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_writestate.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    public static func reqRun(keyID:UInt8, dst:[UInt8], seq:UInt16, name:String, arg:String?)->Int //run a scene in device by name, if no argument pls set null
    {
        var buf:[UInt8] = [UInt8]();
        if (arg != "") && (arg != nil) {
            buf = FileSystem.genPackage(fname:name, str:arg!);

        } else {
            buf = FileSystem.genPackage(fname:name,state: Common.op_vmTest);
        }
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_writestate.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    /**
     * read scene current state as flow:
     * 1 op_invalid = 9;
     * 2 op_vmRun = 10;
     * 3 op_vmPause = 11;
     * 4 op_vmStop = 12;
     * 5 op_vmFinished = 13;
     * 6 op_vmNoTask = 14;
     * 7 op_vmSysTick = 15;
     * 8 op_vmTest = 16;
     *
     * @param addr
     * @param keyID
     * @param name
     * @return
     */
    public static func reqReadState(keyID:UInt8, dst:[UInt8],seq:UInt16, name:String)->Int {
        let buf = FileSystem.genPackage(fname:name);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_readstate.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }

    /**
     * set scene state as flow:
     * 2 op_vmRun = 10;
     * 3 op_vmPause = 11;
     * 4 op_vmStop = 12;
     *
     * @param addr
     * @param keyID
     * @param name
     * @param state
     * @return
     */
    public static func reqSetState(keyID:UInt8, dst:[UInt8], seq:UInt16, name:String, state:Int)->Int  {
        let buf = FileSystem.genPackage(fname:name, state:state);
        return Aps.ReqSend(keyID:keyID,dst:dst,seq:Common.getSeq(),port:0,aID:Common.aID_PDO_Type_Scene,cmd:Common.cmd_writestate.toU8, option:Common.aID_Common_Option.toU8,pdata:buf, len:buf.count);
    }
    
    public static func creatBody()->Int{
        return scence_create_body().toInt;
    }
    public static func addAction(root:Int,what:String, param:String)->Int{
        let wptr = Convert.string_to_unsafe_cstring(str: what);
        let pptr = Convert.string_to_unsafe_cstring(str: param);
        let ret = scence_create_action(root.to32, wptr, pptr).toInt;
        wptr.deallocate();
        pptr.deallocate();
        return ret;
    }
    public static func addWhileBlock(root:Int,reason:String)->Int{
        let rptr = Convert.string_to_unsafe_cstring(str: reason);
        let ret = scence_create_while_block(root.to32, rptr).toInt;
        rptr.deallocate();
        return ret;
    }
    public static func addIfBlock(root:Int,what:String, reason:String)->Int{
        let ifptr = Convert.string_to_unsafe_cstring(str: what);
        let rptr = Convert.string_to_unsafe_cstring(str: reason);
        let ret = scence_create_if_block(root.to32, ifptr, rptr).toInt;
        ifptr.deallocate();
        rptr.deallocate();
        return ret;
    }
    public static func addElseBlock(root:Int)->Int{
        return scence_create_else_block(root.to32).toInt;
    }
    public static func output(root:Int)->String{
        let str = scence_print(root.to32);
        var out:String = "";
        if str != nil{
             out = Convert.unsafe_cstring_to_string(cstr: str!);
        }
        return out;
    }
    
    public static  func isSceneState(state:Int)->Bool
    {
        switch(state)
        {
            case Common.op_succeed:
                return true;
            case Common.op_faile:
                return true;
            case Common.op_vmInvalid:
                return true;
            case Common.op_vmRun:
                return true;
            case Common.op_vmPause:
                return true;
            case Common.op_vmStop:
                return true;
            case Common.op_vmFinished:
                return true;
            case Common.op_vmNoTask:
                return true;
            case Common.op_vmSysTick:
                return true;
            case Common.op_vmTest:
                return true;
            case Common.op_vmJoined:
                return true;
            case Common.op_vm_param:
                return true;
            default:
                return false;
        }
    }
    private static func readCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        /**pdata structure as floww:
         char 	crc[2];
         byte	nlen[2];
         byte	dlen[4];
         byte	pdata[0];*/
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            let pbuf = FileSystem.getData(pdata:[UInt8]());
            let text = Convert.arrary_Uint8_to_string(arrary: pbuf, start_index: 0, len: pbuf.count);
            for subsec in myListener{
                subsec.ReadCB(keyID:keyID, addr:addr,name: fname,text:text);
            }
        }
    }

    private static func writeCB (keyID:UInt8, addr:[UInt8], pdata:[UInt8] )->Void {
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.WriteCB(keyID:keyID, addr:addr,name: fname,state: state);
            }
        }
    }

    private static func deleteCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.DeleteCB(keyID:keyID,addr: addr,name: fname,state: state);
            }
        }
    }

    private static func renameCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.RenameCB(keyID:keyID,addr: addr,name: fname,state: state);
            }
        }
    }

    private static func readNameCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        let state = FileSystem.getState(pdata:pdata);
        if isSceneState(state:state) == true {
            if let fname = FileSystem.getName(pdata:[UInt8]()){
                for subsec in myListener {
                    subsec.ReadNameCB(keyID:keyID, addr:addr,name: fname,state: state);
                }
            }
        }
    }

    private static func readStateCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.ReadStateCB(keyID:keyID, addr:addr, name:fname,state:state);
            }
        }
    }

    private static func writeStateCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void {
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.WriteStateCB(keyID:keyID, addr:addr, name:fname,state: state);
            }
        }
    }

    private static func alarmCB(keyID:UInt8, addr:[UInt8], pdata:[UInt8])->Void{
        let state = FileSystem.getState(pdata:pdata);
        if let fname = FileSystem.getName(pdata:[UInt8]()){
            for subsec in myListener{
                subsec.Alarm(keyID:keyID, addr:addr,name:fname,state:state);
            }
        }
    }

    public static func test(addr:[UInt8], keyID:UInt8)->Void {
        let jbody = creatBody();
        //addAction(jbody,"state","auto");
        _ = addAction(root:jbody,what:"do",param:"x=0");
        let jwhile = addWhileBlock(root:jbody,reason:"x < 10");
        let jif = addIfBlock(root:jwhile,what:"if",reason: "wait(point=04,cmd=08,dtype=01,aID=008010)");
        _ = addAction(root:jif,what: "do",param: "k=0");
        let jwhile1 = addWhileBlock(root:jif,reason:"k < 5");
        _ = addAction(root:jwhile1, what:"send", param: "addr:0100010100000019,keyID:00,point:01,cmd:02,dtype:01,aID:008010,dlen:0001,data:01");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"send", param:"addr:0100010100000019,keyID:00,point:02,cmd:02,dtype:01,aID:008010,dlen:0001,data:01");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"send", param:"addr:0100010100000019,keyID:00,point:03,cmd:02,dtype:01,aID:008010,dlen:0001,data:01");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"send", param:"addr:0100010100000019,keyID:00,point:03,cmd:02,dtype:01,aID:008010,dlen:0001,data:00");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"send", param:"addr:0100010100000019,keyID:00,point:02,cmd:02,dtype:01,aID:008010,dlen:0001,data:00");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"send", param:"addr:0100010100000019,keyID:00,point:01,cmd:02,dtype:01,aID:008010,dlen:0001,data:00");
        _ = addAction(root:jwhile1, what:"delay", param:"200");
        _ = addAction(root:jwhile1, what:"do", param:"k++");
        _ = addAction(root:jif, what: "do", param:"x++");
        let out = output(root:jbody);
        _ = Scene.reqWrite(keyID:keyID, dst:addr, seq:Common.getSeq(),fname: "Test1.vm",text: out);
    }
    private class Section:Aps.onSectionListener{
        override
        public func Recieve(keyID:UInt8,src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,pdata:[UInt8],len:Int) -> Void{
            switch (cmd & 0x7F) {
            case Common.cmd_read.toU8://read scene respone]
                readCB(keyID:keyID,addr:src, pdata:pdata);
                break;
            case Common.cmd_write.toU8://write scene respone
                writeCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_del.toU8://delect scene respone
                deleteCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_toggle.toU8://no Commonine
                break;
            case Common.cmd_alarm.toU8://scene alarm
                alarmCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_readname.toU8:
                readNameCB(keyID:keyID,addr: src, pdata:pdata);
                break;
            case Common.cmd_rename.toU8:
                renameCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_readstate.toU8:
                readStateCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_writestate.toU8:
                writeStateCB(keyID:keyID, addr:src, pdata:pdata);
                break;
            case Common.cmd_readCfg.toU8://no Commonine
                break;
            case Common.cmd_writeCfg.toU8://no Commonine
                break;
            default: break;
            }
        }
        override
        public func SendState(src:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int) -> Void{
            
        }
    }
    public class onSectionListener{
        public func ReadStateCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func WriteStateCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func ReadNameCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func RenameCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func ReadCB(keyID:UInt8, addr:[UInt8], name:String, text:String)->Void{};
        public func WriteCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func DeleteCB(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
        public func Alarm(keyID:UInt8, addr:[UInt8], name:String, state:Int)->Void{};
    }
    private static var myListener:[onSectionListener] = [onSectionListener]();
    private static let mySection:Section = Section();
}
