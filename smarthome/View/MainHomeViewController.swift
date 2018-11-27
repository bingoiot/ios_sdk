 //
//  MainHomeViewController.swift
//  smarthome
//
//  Created by lu on 2018/11/7.
//  Copyright © 2018年 jifan. All rights reserved.
//

import UIKit

class MainHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        _ = DeviceHelper.SetOnSectionListener(listener: myDeviceHelpSection);        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BtnSmartconfigClick(_ sender: Any) {
        let ssid = TvWifiSsid.text;
        let psw = TvWifiPsw.text;
        if(ssid != nil)&&(psw != nil){
        _ = DeviceHelper.StartWifiSmartConfig(ssid: ssid!, psw: psw!, hide_ssid: false);
        }
    }
    @IBAction func BtnStopSmartconfigClick(_ sender: Any) {
        _ = DeviceHelper.StopWifiSmartConfig();
    }
    @IBAction func BtnScanDevClick(_ sender: Any) {
        let addr:[UInt8] = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF];
        _ = DeviceHelper.ReqSendBeacon(keyID:Common.keyID_none.toU8, dst: addr, seq: Common.getSeq());
    }
    @IBAction func BtnOnClick(_ sender: Any) {
        if(DeviceDB.Count() > 0){
            let dev_num = DeviceDB.Count();
            if(dev_num > 0){
                for i in (0 ... (dev_num - 1)){
                    let addr = DeviceDB.GetAddrById(index: i);
                    if(addr.count > 0){
                        let port_num = DeviceDB.CountPort(addr: addr);
                        if(port_num > 0 ){
                            for j in 0...(port_num - 1){
                                let keyID = DeviceDB.GetGoodKeyId(addr: addr).toU8;
                                let port = DeviceDB.GetPortById(addr: addr, index: j).toU8;
                                let aID = Common.aID_Gen_Type_Switch;
                                let pdata:[UInt8] = [1];
                                _ = Aps.ReqSend(keyID: keyID, dst: addr, seq: Common.getSeq(), port: port, aID: aID, cmd: Common.cmd_write.toU8, option: Common.aID_Common_Option.toU8, pdata: pdata, len: pdata.count);
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func BtnOffClick(_ sender: Any) {
        if(DeviceDB.Count() > 0){
            let dev_num = DeviceDB.Count();
            if(dev_num > 0){
                for i in (0 ... (dev_num - 1)){
                    let addr = DeviceDB.GetAddrById(index: i);
                    if(addr.count > 0){
                        let port_num = DeviceDB.CountPort(addr: addr);
                        if(port_num > 0 ){
                            for j in 0...(port_num - 1){
                                let keyID = DeviceDB.GetGoodKeyId(addr: addr).toU8;
                                let port = DeviceDB.GetPortById(addr: addr, index: j).toU8;
                                let aID = Common.aID_Gen_Type_Switch;
                                let pdata:[UInt8] = [0];
                                _ = Aps.ReqSend(keyID: keyID, dst: addr, seq: Common.getSeq(), port: port, aID: aID, cmd: Common.cmd_write.toU8, option: Common.aID_Common_Option.toU8, pdata: pdata, len: pdata.count);
                            }
                        }
                    }
                }
            }
        }
    }
    
    class DeviceHelpSection:DeviceHelper.onSectionListener {
        override
        func DeviceJoinIndicates(addr:[UInt8])->Void{
            
        };
        override
        func NewPortIndicates(addr:[UInt8],describe:JSON)->Void{
            
        }
        override
        func ReceiveDeviceInfo(addr:[UInt8],devInfo:JSON,state:Int)->Void{
            
        }
        override
        func ReceivePortList(addr:[UInt8],ports:[UInt8],state:Int)->Void{
            
        }
        override
        func ReceivePortDescribe(addr:[UInt8],describe:JSON,state:Int)->Void{
            
        }
        override
        func CompleteDevice(addr:[UInt8],devInfo:JSON,ports:[UInt8],descList:[JSON])->Void{
            _ = DeviceDB.AddDevice(addr: addr, force: true);
            _ = DeviceDB.AddDeviceInfo(addr: addr, info: devInfo);
            let num = descList.count;
            if(num > 0){
                for i in (0 ... (num-1)){
                    _ = DeviceDB.AddPort(addr: addr, port_info: descList[i]);
                }
            }
        }
        override
        func ReceiveLqi(addr:[UInt8],port:UInt8,lqi:UInt8,state:Int)->Void{
            
        }
        override
        func ReceiveBeacon(addr:[UInt8],state:Int)->Void{
            
        }
        override
        func SendStatusCB(addr:[UInt8],seq:UInt16,port:UInt8,aID:Int,cmd:UInt8,option:UInt8,state:Int)->Void{
            
        }
    }
    
    @IBOutlet weak var TvShowLog: UITextField!
    @IBOutlet weak var TvWifiSsid: UITextField!
    @IBOutlet weak var TvWifiPsw: UITextField!
    @IBOutlet weak var BtnSmartconfig: UIButton!
    @IBOutlet weak var BtnStopSmartconfig: UIButton!
    @IBOutlet weak var BtnScanDev: UIButton!
    @IBOutlet weak var BtnON: UIButton!
    @IBOutlet weak var BtnOFF: UIButton!
    
    let myDeviceHelpSection = DeviceHelpSection();
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
