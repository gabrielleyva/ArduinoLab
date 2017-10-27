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
    lazy var bleShield = (UIApplication.shared.delegate as! AppDelegate).bleShield
    var rssiTimer = Timer()
    var bpmResetTimer = Timer()

    
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
  
    @IBOutlet weak var rssiLabel: UILabel!
    
    @IBOutlet weak var heartRateButton: UIButton!
    @IBOutlet weak var ldrButton: UIButton!
    
    @IBOutlet weak var ledLabel1: UILabel!
    @IBOutlet weak var ledLabel2: UILabel!
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareButtons()
        
        
        // BLE Connect Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onBLEDidConnectNotification),
                                               name: NSNotification.Name(rawValue: kBleConnectNotification),
                                               object: nil)
        
        // BLE Disconnect Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onBLEDidDisconnectNotification),
                                               name: NSNotification.Name(rawValue: kBleDisconnectNotification),
                                               object: nil)
        
        // BLE Recieve Data Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onBLEDidRecieveDataNotification),
                                               name: NSNotification.Name(rawValue: kBleReceivedDataNotification),
                                               object: nil)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func prepareButtons(){
        
        heartRateButton.tintColor = .newRed
        heartRateButton.layer.borderColor = UIColor.newRed.cgColor
        heartRateButton.layer.borderWidth = 1
        heartRateButton.layer.cornerRadius = 5
        
        ldrButton.tintColor = .newBlue
        ldrButton.layer.borderColor = UIColor.newBlue.cgColor
        ldrButton.layer.borderWidth = 1
        ldrButton.layer.cornerRadius = 5
        
    }
    
    func readRSSITimer(timer:Timer){
        bleShield.readRSSI { (number, error) in
            // when RSSI read is complete, display it
            self.rssiLabel.text = String(format: "RSSI: %.1f",(number?.floatValue)!)
        }
    }
    
    // MARK: Delegate Methods
    func bleDidUpdateState() {
        
    }
    
    func bleDidConnectToPeripheral() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        
        
        // Schedule to read RSSI every 1 sec.
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                         repeats: true,
                                         block: self.readRSSITimer)
        
    }
    
    func bleDidDisconnectFromPeripheral() {
        
        rssiTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func bleDidReceiveData(data: Data?) {
        // this data could be anything, here we know its an encoded string
//        let s = String(bytes: data!, encoding: String.Encoding.utf8)
//        signal = s!
        
        
    }
    
    
    
    @IBAction func didSwitchLed1(_ sender: Any) {
        if switch1.isOn {
            ledLabel1.text = "Heart Rate Monitoring: On"
            self.startHeartRateMonitor()
            monitoringHr = true
        } else {
            ledLabel1.text = "Heart Rate Monitoring: Off"
            self.stopHeartRateMonitor()
            monitoringHr = false
        }
    }
    
    @IBAction func didSwitchLed2(_ sender: Any) {
        if switch2.isOn {
            ledLabel2.text = "LDR: On"
            self.startLDRMonitor()
        } else {
            ledLabel2.text = "LDR: Off"
            self.stopLDRMonitor()
        }
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

    @objc func onBLEDidRecieveDataNotification(notification:Notification){
        let d = notification.userInfo?["data"] as! Data?
        let s = String(bytes: d!, encoding: String.Encoding.ascii)
        if let value = Float(s!){
            //self.dataBuffer.add(point: value)
            signal = value
        }
    }
    
    // NEW  DISCONNECT FUNCTION
    @objc func onBLEDidDisconnectNotification(notification:Notification){
        print("Notification arrived that BLE Disconnected a Peripheral")
        rssiTimer.invalidate()
    }
    
    @objc func onBLEDidConnectNotification(notification:Notification){
        print("Notification arrived that BLE Connected")
        let deviceName = notification.userInfo?["name"] as! String?
        self.deviceLabel.text = deviceName
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                         repeats: true,
                                         block: self.readRSSITimer)
    }

    func startHeartRateMonitor() {
        //
        let command = "A"
        let d = command.data(using: String.Encoding.ascii)!
        bleShield.write(d)
    }
    func stopHeartRateMonitor()  {
        //
        let command = "B"
        let d = command.data(using: String.Encoding.ascii)!
        bleShield.write(d)
        
    }
    func startLDRMonitor() {
        //
        let command = "C"
        let d = command.data(using: String.Encoding.ascii)!
        bleShield.write(d)
        
    }
    func stopLDRMonitor()  {
        //
        let command = "D"
        let d = command.data(using: String.Encoding.ascii)!
        bleShield.write(d)
    }
    
    @IBAction func sliderDidSlide(_ sender: Any) {
        print(Int(slider.value))
        let command = "E" + String(describing: Int(slider.value))
        print(command)
        bleShield.write(command.data(using: String.Encoding.ascii)!)
    }
    
    
}

