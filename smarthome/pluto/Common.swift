//
//  Common.swift
//  smarthome
//
//  Created by lu on 2018/10/25.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final public class Common{
    
    private static var sseq:UInt16 = 0;
    
    public static let dev_type_invalide:Int = 0x00;
    public static let dev_type_gateway:Int = 0x01;
    public static let dev_type_router:Int = 0x02;
    public static let dev_type_device:Int = 0x03;
    public static let dev_type_lowenergy:Int = 0x04;

    public static let op_succeed:Int = 0x00;
    public static let op_faile:Int = 1;
    public static let op_error:Int = 2;
    public static let op_invalid:Int = 3;
    public static let op_permit_denied:Int = 4;
    public static let op_repeat:Int = 5;
    public static let op_no_port:Int = 6;
    public static let op_no_file:Int = 7;
    public static let op_read_error:Int = 8;
    public static let op_write_error:Int = 9;
    public static let op_vmInvalid:Int = 10;
    public static let op_vmRun:Int = 11;
    public static let op_vmPause:Int = 12;
    public static let op_vmStop:Int = 13;
    public static let op_vmFinished:Int = 14;
    public static let op_vmNoTask:Int = 15;
    public static let op_vmSysTick:Int = 16;
    public static let op_vmTest:Int = 17;
    public static let op_vmJoined:Int = 18;
    public static let op_vm_param:Int = 19;//19

    public static let op_upgrade_stop:Int  = 0x20;
    public static let op_upgrade_start:Int = 0x21;
    public static let op_upgrade_finished:Int = 0x22;
    
    public static let login_state_start:Int = 0;
    public static let login_state_stop:Int = 1;
    public static let login_state_online:Int = 2;
    public static let login_state_offline:Int = 3;
    public static let login_state_login_failed:Int = 4;
    public static let login_state_logout_failed:Int = 5;
    
    public static let osFalse:Int = 0x00;
    public static let osTrue:Int = 0x01;
    public static let osDisable:Int = 0x00;
    public static let osEnable:Int = 0x01;
    public static let osError:Int = 0xFF;
    public static let osSucceed:Int = 0x00;
    public static let osFailed:Int = 0x01;
    public static let osParam_error:Int = 0x02;
    public static let osPassword_error:Int = 0x04;
    public static let osVersion_error:Int = 0x06;
    
    public static let cmd_invalide:Int         =      0x00;
    public static let cmd_read:Int         =    0x01;
    public static let cmd_write :Int       =     0x02;
    public static let cmd_del:Int          =     0x03;
    public static let cmd_toggle:Int            =     0x04;
    public static let cmd_alarm :Int           =     0x05;
    public static let cmd_readname :Int           =     0x06;
    public static let cmd_rename :Int            =     0x07;
    public static let cmd_readstate:Int        =   0x08;
    public static let cmd_writestate :Int       =    0x09;
    public static let cmd_readCfg :Int           =     0x0A;
    public static let cmd_writeCfg :Int           =     0x0B;
    public static let cmd_beacon :Int           =     0x0C;
    public static let cmd_notify :Int           =    0x0D;
    public static let cmd_return :Int           =   0x80;
    
    public static let data_type_unkown:Int       = 0x00;
    public static let data_type_byte:Int          = 0x01;
    public static let data_type_let :Int         = 0x02;
    public static let data_type_float:Int       = 0x03;
    public static let data_type_string :Int       = 0x04;
    
    public static let attr_read :Int     = 0x01;
    public static let attr_write :Int   = 0x02;
    
    public static let keyID_none :Int        = 0x00;
    public static let keyID_sn :Int           = 0x01;
    public static let keyID_admin:Int        = 0x02;
    public static let keyID_common:Int        = 0x03;
    public static let keyID_guest :Int       = 0x04;
    
    public static let Application_ID_Key                            = 0x001000;
    public static let Application_ID_Switch                        = 0x001010;
    
    public static let Application_ID_Light                            = 0x001020;
    public static let Application_ID_DimmerLight                    = 0x001021;
    public static let Application_ID_LED_Light                    = 0x001022;
    public static let Application_ID_ColorLight                = 0x001023;
    
    public static let Application_ID_86Socket                        = 0x001030;
    public static let Application_ID_LineSocket                    = 0x001031;
    
    public static let Application_ID_WidowCovering                = 0x001041;
    public static let Application_ID_BlindWidowCovering            = 0x001043;
    public static let Application_ID_PercentWidowCovering        = 0x001045;
    
    public static let Application_ID_Locker                            = 0x001080;
    
    public static let Application_ID_IRBox                            = 0x001100;
    ////////////////////////////////////////////////////////
    public static let Application_ID_Fan                            = 0x002100;
    public static let Application_ID_WatterRefrigeration        = 0x002101;
    public static let Application_ID_Television                    = 0x002102;
    
    public static let Application_ID_TempController                = 0x002200;
    public static let Application_ID_AirConditioning                = 0x002201;
    public static let Application_ID_FanMachineController        = 0x002202;
    ///////////////////////////////////////////////////////////
    public static let Application_ID_FireAlarm                    = 0x004000;
    public static let Application_ID_SmokeAlarm                    = 0x004001;
    public static let Application_ID_PM25Alarm                    = 0x004002;
    
    public static let Application_ID_FloodAlarm                    = 0x004010;
    public static let Application_ID_WaterAlarm                    = 0x004011;
    
    public static let Application_ID_PoisonGasAlarm                = 0x004020;
    public static let Application_ID_CarbonMonoxideAlarm        = 0x004021;
    
    public static let Application_ID_CombustibelAlarm            = 0x004030;
    
    public static let Application_ID_DoorMagneticAlarm            = 0x004100;
    public static let Application_ID_BodyInfraredAlarm            = 0x004110;
    public static let Application_ID_BodyMicroWaveAlarm            = 0x004111;
    public static let Application_ID_EmergencyButtonAlarm        = 0x004120;
    public static let Application_ID_SecurityAlarm                = 0x004FFF;
    ///////////////////////////////////////////////////////////
    public static let Application_ID_HumidityAndTemSensor        = 0x005000;
    public static let Application_ID_TemperatureSensor            = 0x005001;
    public static let Application_ID_HumiditySensor                = 0x005002;
    
    public static let Application_ID_CarbonMonoxideSensor        = 0x005010;
    public static let Application_ID_CarbonDioxideSensor        = 0x005011;
    public static let Application_ID_OxygenSensor                    = 0x005012;
    public static let Application_ID_NitrogenSensor                = 0x005013;
    public static let Application_ID_OxygenAndNitrogenSensor    = 0x005014;
    public static let Application_ID_OzoneSensor                    = 0x005015;
    
    public static let Application_ID_NaturalGasSensor            = 0x005020;
    public static let Application_ID_MethaneSensor                = 0x005021;
    
    public static let Application_ID_FormaldehydeSensor            = 0x005030;
    
    public static let Application_ID_LocationSensor                = 0x005100;
    public static let Application_ID_DistanceSensor                = 0x005101;
    public static let Application_ID_HeightSensor                    = 0x005102;
    public static let Application_ID_AltitudeSensor                = 0x005104;
    
    public static let Application_ID_AirPressureSensor            = 0x005110;
    public static let Application_ID_WatterPressureSensor        = 0x005111;
    
    public static let Application_ID_GravitySensor                = 0x005120;
    
    public static let Application_ID_LightSensor                    = 0x005130;
    
    public static let Application_ID_SpeedSensor                    = 0x005140;
    public static let Application_ID_AccelerationSensor            = 0x005141;
    
    public static let Application_ID_WindSpeedSensor                = 0x005150;
    
    public static let Application_ID_FlowSensor                    = 0x005160;
    
    public static let Application_ID_KilowattHourSensor            = 0x005170;
    public static let Application_ID_WattHourSensor                = 0x005171;
    public static let Application_ID_VoltageSensor                = 0x005172;
    public static let Application_ID_AmmeterSensor                = 0x005173;
    
    ///////////////////////////////////////////////////////////
    public static let Application_ID_RFASKRemoteCtrl                = 0x007000;
    public static let Application_ID_UART                            = 0x007010;
    
    /*************通用数据属性*********************************/
    public static let aID_Common_Option                    = 0x00;
    public static let aID_PDO_Type_Factory                 = 0x000000; //
    public static let aID_PDO_Type_Device_Info             = 0x000001; //
    public static let aID_PDO_Type_Port_List                = 0x000002;
    public static let aID_PDO_Type_Port_Describe          = 0x000003;
    public static let aID_PDO_Type_Scene                   = 0x000004;
    public static let aID_PDO_Type_File                     = 0x000005;
    public static let aID_PDO_Type_White_Table              = 0x000006;
    public static let aID_PDO_Type_Alarm_Record             = 0x000007;
    public static let aID_PDO_Type_History_Record             = 0x000008;
    public static let aID_PDO_Type_Beacon                  = 0x00000F;
    public static let aID_PDO_Type_Device_Indication        = 0x000010;
    public static let aID_PDO_Type_Time                   = 0x000011;
    public static let aID_PDO_Type_Upgrade                  = 0x000012;
    public static let aID_PDO_Type_ManufactureID          = 0x0000FF;
    
    public static let aID_PDO_Type_Port_Indication      = 0x000100;
    public static let aID_PDO_Type_Permite_Join           = 0x000101;
    public static let aID_Gen_Type_LQI                    = 0x000102;
    ////////////////////////////////////////////////////////////
    public static let aID_Gen_Type_KeyValue                    = 0x009000;
    public static let aID_Gen_Type_KeyShift                    = 0x009001;
    
    public static let aID_Gen_Type_Switch                    = 0x009020;
    public static let aID_Gen_Type_SocketSwitch            = 0x009021;
    
    public static let aID_Gen_Type_CommonPersent            = 0x009030;
    public static let aID_Gen_Type_Red                        = 0x009031;
    public static let aID_Gen_Type_Green                    = 0x009032;
    public static let aID_Gen_Type_Blue                        = 0x009033;
    public static let aID_Gen_Type_Yellow                    = 0x009034;
    public static let aID_Gen_Type_White                    = 0x00903F;
    
    public static let aID_Gen_Type_WindowSwitch            = 0x009050;
    public static let aID_Gen_Type_WindowPercent            = 0x009051;
    public static let aID_Gen_Type_BlindsAngle                = 0x009052;
    
    public static let aID_Gen_Type_IRCode                    = 0x009055;
    public static let aID_Gen_Type_IRLearn                    = 0x009056;
    public static let aID_Gen_Type_RFCode                    = 0x00905A;
    public static let aID_Gen_Type_RFLearn                    = 0x00905B;
    
    public static let aID_Gen_Type_Locker                        = 0x009080;
    public static let aID_Gen_Type_Locker_RFID                    = 0x009081;
    public static let aID_Gen_Type_Locker_PSW                    = 0x009082;
    public static let aID_Gen_Type_Locker_Finger                = 0x009083;
    
    public static let aID_Gen_Type_FanSwitch                    = 0x009060;
    public static let aID_Gen_Type_FanSpeedPercent            = 0x009061;
    public static let aID_Gen_Type_FanForwardSwitch            = 0x009062;
    public static let aID_Gen_Type_FanWaterSwitch                = 0x009063;
    
    public static let aID_Gen_Type_FireAlarm                    = 0x00C000;
    public static let aID_Gen_Type_SmokeAlarm                    = 0x00C001;
    public static let aID_Gen_Type_PM25Alarm                     = 0x00C002;
    
    public static let aID_Gen_Type_FloodAlarm                    = 0x00C010;
    public static let aID_Gen_Type_WaterAlarm                    = 0x00C011;
    
    public static let aID_Gen_Type_PoisonGasAlarm                = 0x00C020;
    public static let aID_Gen_Type_CarbonMonoxideAlarm        = 0x00C021;
    
    public static let aID_Gen_Type_CombustibleAlarm            = 0x00C030;
    
    public static let aID_Gen_Type_MenciAlarm                    = 0x00C100;
    public static let aID_Gen_Type_HumenIRAlarm                = 0x00C110;
    public static let aID_Gen_Type_HumenWaveAlarm                = 0x00C111;
    public static let aID_Gen_Type_EmergencyButton            = 0x00C120;
    
    public static let aID_Gen_Type_DisassembleAlarm            = 0x00C400;
    public static let aID_Gen_Type_SecurityAlarm                = 0x00CFFF;
    
    public static let aID_Gen_Type_TemperatureSensor            = 0x00D000;
    public static let aID_Gen_Type_HumiditySensor                = 0x00D001;
    
    public static let aID_Gen_Type_WeightTSensor                = 0x00D120;
    public static let aID_Gen_Type_WeightKGSensor                = 0x00D121;
    public static let aID_Gen_Type_WeightGSensor                = 0x00D122;
    public static let aID_Gen_Type_WeightMGSensor                = 0x00D123;
    
    public static let aID_Gen_Type_PushPowerSensor            = 0x00D130;
    
    public static let aID_Gen_Type_KilowattHourSensor            = 0x00D170;
    public static let aID_Gen_Type_WattHourSensor                = 0x00D171;
    
    public static let aID_Gen_Type_KilowattSensor                = 0x00D174;
    public static let aID_Gen_Type_WattSensor                    = 0x00D175;
    public static let aID_Gen_Type_VoltageSensor                = 0x00D178;
    public static let aID_Gen_Type_AmpSensor                    = 0x00D17C;
    
    public static let aID_Gen_Type_Unkown                        = 0x00FFFF;
    
    public static func getSeq()->UInt16{
        sseq=sseq+1;
        return sseq.toU16;
    }
    
    public static func getDtypeByaID(aID:Int) ->Int {
        switch (aID) {
            case aID_Gen_Type_KeyValue:
                return data_type_byte;
            case aID_Gen_Type_KeyShift:
                return data_type_byte;
            case aID_Gen_Type_Switch:
                return data_type_byte;
            case aID_Gen_Type_SocketSwitch:
                return data_type_byte;
            case aID_Gen_Type_WindowSwitch:
                return data_type_byte;
            case aID_Gen_Type_IRCode:
                return data_type_byte;
            case aID_Gen_Type_RFCode:
                return data_type_byte;
            case aID_Gen_Type_Locker:
                return data_type_byte;
            case aID_Gen_Type_Locker_PSW:
                return data_type_byte;
            case aID_Gen_Type_Locker_RFID:
                return data_type_byte;
            case aID_Gen_Type_Locker_Finger:
                return data_type_byte;
            case aID_Gen_Type_FanSwitch:
                return data_type_byte;
            case aID_Gen_Type_FanForwardSwitch:
                return data_type_byte;
            case aID_Gen_Type_FanWaterSwitch:
                return data_type_byte;
            case aID_Gen_Type_FireAlarm:
                return data_type_byte;
            case aID_Gen_Type_SmokeAlarm:
                return data_type_byte;
            case aID_Gen_Type_PM25Alarm :
                return data_type_byte;
            case aID_Gen_Type_FloodAlarm:
                return data_type_byte;
            case aID_Gen_Type_WaterAlarm:
                return data_type_byte;
            case aID_Gen_Type_PoisonGasAlarm:
                return data_type_byte;
            case aID_Gen_Type_CarbonMonoxideAlarm:
                return data_type_byte;
            case aID_Gen_Type_CombustibleAlarm:
                return data_type_byte;
            case aID_Gen_Type_MenciAlarm:
                return data_type_byte;
            case aID_Gen_Type_DisassembleAlarm:
                return data_type_byte;
            case aID_Gen_Type_HumenIRAlarm:
                return data_type_byte;
            case aID_Gen_Type_HumenWaveAlarm:
                return data_type_byte;
            case aID_Gen_Type_EmergencyButton:
                return data_type_byte;
            case aID_Gen_Type_IRLearn:
                return data_type_byte;
            case aID_Gen_Type_RFLearn:
                return data_type_byte;
            case aID_Gen_Type_Red:
                return data_type_byte;
            case aID_Gen_Type_Green:
                return data_type_byte;
            case aID_Gen_Type_Blue:
                return data_type_byte;
            case aID_Gen_Type_Yellow:
                return data_type_byte;
            case aID_Gen_Type_White:
                return data_type_byte;
            case aID_Gen_Type_Unkown:
                return data_type_byte;
            return data_type_byte;
                return data_type_byte;
            case aID_Gen_Type_CommonPersent:
                return data_type_byte;
            case aID_Gen_Type_WindowPercent:
                return data_type_byte;
            case aID_Gen_Type_BlindsAngle:
                return data_type_byte;
            case aID_Gen_Type_FanSpeedPercent:
                return data_type_byte;
            case aID_Gen_Type_TemperatureSensor:
                return data_type_float
            case aID_Gen_Type_HumiditySensor:
                return data_type_float
            case aID_Gen_Type_WeightTSensor:
                return data_type_float
            case aID_Gen_Type_WeightKGSensor:
                return data_type_float
            case aID_Gen_Type_WeightGSensor:
                return data_type_float
            case aID_Gen_Type_WeightMGSensor:
                return data_type_float
            case aID_Gen_Type_PushPowerSensor:
                return data_type_float
            case aID_Gen_Type_KilowattHourSensor:
                return data_type_float
            case aID_Gen_Type_WattHourSensor:
                return data_type_float
            case aID_Gen_Type_KilowattSensor:
                return data_type_float
            case aID_Gen_Type_WattSensor:
                return data_type_float
            case aID_Gen_Type_VoltageSensor:
                return data_type_float
            case aID_Gen_Type_AmpSensor:
                return data_type_float
            default:
                return data_type_unkown;
        }
    }
}

