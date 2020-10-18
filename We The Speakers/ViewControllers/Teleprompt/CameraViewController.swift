//
//  TeleCamViewController.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var scrollSpeedSlider: UISlider!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var speedLabel: UILabel!
    
    var camCount = 0
    var flashCount = 0
    var content = ""
    var startFalse = false
    
    private var speed: CGFloat = 0.0
    
    private var displayLink: CADisplayLink?
    
    var timer:Timer?
    
    
    
    
    override func viewDidLoad() {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            print("Eyy")
        }
        super.viewDidLoad()
        //recordButton.delegate = self
        //maximumVideoDuration = 0.0
        
        view.addSubview(recordButton)
        defaultCamera = .rear
        cameraDelegate = self
        
        speed = CGFloat(scrollSpeedSlider.value)
        //temp = speed
        textView.text = content
        textView.font = UIFont(name: textView.font!.fontName, size: 50)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapRecord(sender: Any){
        if camCount%2 == 0{
            startFalse = false
            speed = CGFloat(scrollSpeedSlider.value)
            print(speed)
            displayLink = CADisplayLink(target: self, selector: #selector(step(displaylink:)))
            displayLink?.add(to: .current, forMode: .common)
            
            let image = UIImage(systemName: "stop.circle.fill")
            recordButton.tintColor = .systemRed
            recordButton.setBackgroundImage(image, for: .normal)
            
            startVideoRecording()
            
            camCount+=1
            
        }
        else{
            displayLink?.invalidate()
            //speedLabel.text = " "
            startFalse = true
            textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
            let image = UIImage(systemName: "largecircle.fill.circle")
            recordButton.tintColor = .systemRed
            recordButton.setBackgroundImage(image, for: .normal)
            
            stopVideoRecording()
            startFalse = false
            camCount-=1
        }
    }
    @IBAction func didTapFlash(sender: Any){
        if flashCount%2 == 0{
            flashMode = .on
        }
        else{
            flashMode = .off
        }
    }
    
    @IBAction func didTapSwitch(sender: Any){
        switchCamera()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
        print("done")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        print(url)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    @objc func step(displaylink: CADisplayLink) {
        
        
        let seconds = displaylink.targetTimestamp - displaylink.timestamp
        if (startFalse){ speed = 0}
        else {speed = CGFloat(scrollSpeedSlider.value)
            var labelString = String(format: "%.2f", speed)
            let labelRound: Double = Double(labelString)!*100.0
            labelString = String(labelRound)
            speedLabel.text = "Speed: \(labelString)"}
        
        
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentOffset.y + speed * CGFloat(seconds) * 100 ), animated: false)
        
        
    }
    
    
    
}
