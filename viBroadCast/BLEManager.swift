//
//  BLEManager.swift
//  viBroadCast
//
//  Created by DatTran on 4/25/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//


import Foundation
import CoreBluetooth
import UIKit


class BLEManager: NSObject, CBPeripheralManagerDelegate {
    
    var centralManager:CBCentralManager?;
    var peripherals: [(CBPeripheral, String, NSNumber)]?;
    var lastBroadcastData: NSData?;
    var viewController = UIApplication.sharedApplication().keyWindow?.rootViewController
    var appDelegate : AppDelegate;
    var callbacks = CallbackList<(CBCentralManager, CBPeripheral, [String : AnyObject], NSNumber) -> Void>();
    var seen = 0;
    
    //---- BROADCAST
    
    var bluetoothServices:CBMutableService?
    var nameCharacteristic:CBMutableCharacteristic?
    var peripheralManager:CBPeripheralManager?
    var peripheralServiceUUID = CBUUID(string: "55557555-F4CB-4159-BD38-7375CD0DD777")
    
    
    init(delegate: AppDelegate) {
        peripherals = [];
        appDelegate = delegate;
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        bluetoothServices = CBMutableService(type: peripheralServiceUUID, primary: true)

    }
    
    // BROAD_CAST
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        switch (peripheral.state) {
            
        case .PoweredOn:
            print("Current Bluetooth State:  PoweredOn")
            publishServices(bluetoothServices)
            break;
        case .PoweredOff:
            print("Current Bluetooth State:  PoweredOff")
            break;
        case .Resetting:
            print("Current Bluetooth State:  Resetting")
            break;
        case .Unauthorized:
            print("Current Bluetooth State:  Unauthorized")
        case .Unknown:
            print("Current Bluetooth State:  Unknown")
            break;
        case .Unsupported:
            
            print("Current Bluetooth State:  Unsupported")
            break;

        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
        if (error != nil) {
            print("PerformerUtility.publishServices() returned error: \(error!.localizedDescription)")
            print("Providing the reason for failure: \(error!.localizedFailureReason)")
        }
        else {
//            let uuidServiceString: String = "4E41"
//            let UUIDService:NSUUID = NSUUID(UUIDString: uuidServiceString)!

//            var byteArray = [UInt8]()
//            byteArray.append(0b00000111)
//            let manufacturerData = NSData(bytes: byteArray,length: byteArray.count)


//            peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey : "SABCDEFGHIKLMNZz", CBAdvertisementDataServiceUUIDsKey : UUIDService, CBAdvertisementDataManufacturerDataKey : manufacturerData])
            peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey : "SpMZSkUVQ8qwcD6u"])

            
        }
    }
    
    func publishServices(newService:CBMutableService!) {
        peripheralManager?.addService(newService)
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager,
                                              error: NSError?) {
        if (error != nil) {
            print("peripheralManagerDidStartAdvertising encountered an error.")
            print(error!.localizedDescription)  // Error: One or more parameters were invalid
            print(error!.localizedFailureReason)  // Error: nil
        }
        print ("Debug: peripheralManagerDidStartAdvertising()")
    }
    
}
