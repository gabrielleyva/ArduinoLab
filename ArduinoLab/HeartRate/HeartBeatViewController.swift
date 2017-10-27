//
//  HeartBeatViewController.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/26/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class HeartBeatViewController: UIViewController {
    
    @IBOutlet weak var graphView: SKView!
    @IBOutlet weak var bpmLabel: UILabel!
    
    static let buffersize = 2048
    static let samplingRate = Float(100.0*60)
    static let fftSize = 2048
    let fft = FFTHelper(fftSize: 2048, andWindow: WindowTypeHamming)
    let finder = PeakFinder(frequencyResolution: samplingRate / Float(fftSize))
    var arrayMag = Array(repeating: Float(0), count: Int(buffersize/2))
    var dataBuffer = Buffer(with: 2048)
    var bpmTimer = Timer()
    var bpmResetTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareScene()
        bpmLabel.textColor = .newRed
        // BLE Recieve Data Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onBLEDidRecieveDataNotification),
                                               name: NSNotification.Name(rawValue: kBleReceivedDataNotification),
                                               object: nil)
        
        bpmTimer = Timer.scheduledTimer(withTimeInterval: 2.0,
                                        repeats: true, block: self.getBpm)
        dataBuffer.reset()

    }
    
    @objc func onBLEDidRecieveDataNotification(notification:Notification){
        let d = notification.userInfo?["data"] as! Data?
        let s = String(bytes: d!, encoding: String.Encoding.ascii)
        if (s?.index(of: "A") != nil){
            
            let startIndex = s?.index((s?.startIndex)!, offsetBy: 1)
            let endIndex = s?.index((s?.startIndex)!, offsetBy: 4)
            
            let hrData = s![startIndex!...endIndex!]
            if let value = Float(hrData){
                self.dataBuffer.add(point: value)
                //self.labelText.text = String(hrData)
                signal = value

            }
        }
        
    }
    
    func prepareScene() {
        if let scene = MyScene(fileNamed:"MyScene") {
            //setup your scene here
            scene.size = graphView.bounds.size
            scene.scaleMode = .aspectFill
            
            graphView.presentScene(scene)
        }
        
    }
    func getBpm(timer:Timer) {
        print("Called")
        let data = self.dataBuffer.getData()
        print(data.count)
        print(monitoringHr)
        if (data.count != 0 && monitoringHr){

            let pad_size = HeartBeatViewController.buffersize - data.count
            var zeroPaddedData = data + Array(repeating: Float(0), count: pad_size)
            
            fft!.performForwardFFT(withData: &zeroPaddedData, andCopydBMagnitudeToBuffer: &arrayMag)
            
            var peaks = finder!.getFundamentalPeaks(fromBuffer: &arrayMag, withLength: UInt(Int(HeartBeatViewController.buffersize/2)),
                                                    usingWindowSize: 15, andPeakMagnitudeMinimum: 20, aboveFrequency: 60.0)
            
            if (peaks != nil){
                
                if peaks!.count > 0 {
                    let peak1: Peak = peaks![0] as! Peak
                    let res = Float(HeartBeatViewController.samplingRate) / Float(HeartBeatViewController.fftSize)
                    if peak1.frequency < 200{
                        self.bpmLabel.text = "BPM: "+String(peak1.frequency)
                    }else{
                        
                    }
                    
                    // print(arrayMag.max())
                    print("Freq resolution",res)
                    print("Heart rate is ",peak1.frequency)
                    
                }
            }
        }
    }
    
}
