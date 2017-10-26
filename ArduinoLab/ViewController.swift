//
//  ViewController.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/23/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEDelegate {

    // MARK: VC Properties
    var bleShield = BLE()
    var rssiTimer = Timer()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var buttonConnect: UIButton!
    @IBOutlet weak var rssiLabel: UILabel!
    
    @IBOutlet weak var heartRateButton: UIButton!
    
    @IBOutlet weak var ledLabel1: UILabel!
    @IBOutlet weak var ledLabel2: UILabel!
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bleShield.delegate = self
        self.spinner.isHidden = true
        prepareButtons()
    }
    
    func prepareButtons(){
        buttonConnect.tintColor = .newBlue
        buttonConnect.layer.borderColor = UIColor.newBlue.cgColor
        buttonConnect.layer.borderWidth = 1
        buttonConnect.layer.cornerRadius = 5
        
        heartRateButton.tintColor = .newRed
        heartRateButton.layer.borderColor = UIColor.newRed.cgColor
        heartRateButton.layer.borderWidth = 1
        heartRateButton.layer.cornerRadius = 5
    }
    
    func readRSSITimer(timer:Timer){
        bleShield.readRSSI { (number, error) in
            // when RSSI read is complete, display it
            self.rssiLabel.text = String(format: "%.1f",(number?.floatValue)!)
        }
    }
    
    // MARK: Delegate Methods
    func bleDidUpdateState() {
        
    }
    
    func bleDidConnectToPeripheral() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.buttonConnect.setTitle("Disconnect", for: .normal)
        
        // Schedule to read RSSI every 1 sec.
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                         repeats: true,
                                         block: self.readRSSITimer)
        
    }
    
    func bleDidDisconnectFromPeripheral() {
        self.buttonConnect.setTitle("Connect", for: .normal)
        rssiTimer.invalidate()
    }
    
    func bleDidReceiveData(data: Data?) {
        // this data could be anything, here we know its an encoded string
       // let s = String(bytes: data!, encoding: String.Encoding.utf8)
        
        
    }
    
    // MARK: User initiated Functions
    @IBAction func buttonScanForDevices(_ sender: UIButton) {
        
        // disconnect from any peripherals
        var didDisconnect = false
        for peripheral in bleShield.peripherals {
            if(peripheral.state == .connected){
                if(bleShield.disconnectFromPeripheral(peripheral: peripheral)){
                    didDisconnect = true
                }
            }
        }
        // if we disconnected anything, return from button
        if(didDisconnect){
            return
        }
        
        //start search for peripherals with a timeout of 3 seconds
        // this is an asynchronous call and will return before search is complete
        if(bleShield.startScanning(timeout: 3.0)){
            // after three seconds, try to connect to first peripheral
            Timer.scheduledTimer(withTimeInterval: 3.0,
                                 repeats: false,
                                 block: self.connectTimer)
        }
        
        // give connection feedback to the user
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    @IBAction func didSwitchLed1(_ sender: Any) {
        if switch1.isOn {
            ledLabel1.text = "LED 1: On"
        } else {
            ledLabel1.text = "LED 1: Off"
        }
    }
    
    @IBAction func didSwitchLed2(_ sender: Any) {
        if switch2.isOn {
            ledLabel2.text = "LED 2: On"
        } else {
            ledLabel2.text = "LED 2: Off"
        }
    }
    @IBAction func sendDataButton(_ sender: UIButton) {
        
//        let d = s.data(using: String.Encoding.utf8)!
//        bleShield.write(d)
        // if (self.textField.text.length > 16)
    }
    
    func connectTimer(timer:Timer){
        
        if(bleShield.peripherals.count > 0) {
            // connect to the first found peripheral
            bleShield.connectToPeripheral(peripheral: bleShield.peripherals[0])
        }
        else {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }


}

