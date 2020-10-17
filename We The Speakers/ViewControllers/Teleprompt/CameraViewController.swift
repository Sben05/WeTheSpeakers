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

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    //MARK:- IB Outlets
    @IBOutlet weak var componentView: UIView!
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cameraSwitch: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollSpeedSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    //MARK:- IB Actions
    @IBAction func flipIsTapped(_ sender: Any) {
        field+=1
        orient()
    }
    
    @IBAction func scrollSpeedValueChanged(_ sender: UISlider) {
        speed = CGFloat(sender.value)
        count = 0
        
    }
    
    @IBAction func doneButton(_ sender: Any){
        performSegue(withIdentifier: "toMainC", sender: self)
        
        if (outputURL != nil){
            
            let URLPath = "\(outputURL!)"
            
            try? FileManager.default.removeItem(at: outputURL!)
            print("Works!")
            
            if ((!(FileManager.default.fileExists(atPath: URLPath)))){
                
                print(outputURL!)
                print ("Deleted File")
                
            }
        }
        else {
            print("No Video Recorded")
        }
    }
    
    // MARK:- Variable Setup
    var content = ""
    
    public var superCont = "Hello!"
    
    let captureSession = AVCaptureSession()
    
    var field = 0
    var numIn = 0
    var count = 0
    
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    var startFalse = true
    var noStart = false
    
    var recordCounter = 0
    var temp = CGFloat(1.0)
    
    var camAuth = false
    var audioAuth = false
    
    //Scroll Indiactors
    private var speed: CGFloat = 0.0
    
    private var displayLink: CADisplayLink?
    
    var timer:Timer?
    
    
    
    //MARK:- ViewDid functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        movieOutput.movieFragmentInterval = CMTime.invalid
        speedLabel.text = " "
        
        //MARK: Auth for cam and audio
        
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioAuthStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        componentView.addSubview(errorLabel)
            switch cameraAuthStatus{
                case .authorized:
                    camAuth = true
                    errorLabel.isHidden = true
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            print("Granted access for vido")
                            self.camAuth = true
                            self.errorLabel.isHidden = true
                        } else {
                            print("Denied access to video")
                            self.camAuth = false
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "It looks like you have denied access to the camera. In order to take videos, we need access to your camera roll. Please follow the following steps to grant access: Settings > Privacy > Camera > CHANGE THIS > On. You may have to restart the app afterwards."
                        }
                    }
                case .restricted:
                    print("Restricted access to video")
                    self.camAuth = false
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "It looks like you have restricted access to video. The teleprompter cannot be used at this time."
                case .denied:
                    print("Denied access to video")
                    self.camAuth = false
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "It looks like you have denied access to the camera. In order to take videos, we need access to your camera. Please follow the following steps to grant access: Settings > Privacy > Camera > CHANGE THIS > On. You may have to restart the app afterwards."
                @unknown default:
                    return
            }
            
            switch audioAuthStatus {
                case .authorized:
                    audioAuth = true
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            print("Granted access for audio")
                            self.audioAuth = true
                            self.errorLabel.isHidden = true
                        } else {
                            print("Denied access to audio")
                            self.audioAuth = false
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "It looks like you have denied access to the microphone. In order to have audio in your video, we need access to your microphone. Please do the following steps to grant access: Settings > Privacy > Microphone > CHANGE THIS > On. You may have to restart the app afterwards."
                        }
                    }
                case .restricted:
                    print("Restricted access to audio")
                    self.audioAuth = false
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "It looks like you have restricted access to audio. The teleprompter cannot be used at this time."
                case .denied:
                    print("Denied access to audio")
                    self.audioAuth = false
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "It looks like you have denied access to the microphone. In order to have audio in your video, we need access to your microphone. Please do the following steps to grant access: Settings > Privacy > Microphone > CHANGE THIS > On. You may have to restart the app afterwards."
                @unknown default:
                    return
            }
        
        
        if (audioAuth && camAuth){
            if setupSession() {
                setupTextview()
                setupPreview()
                startSession()
            }
        }
        
        //Camera setups
        cameraButton.isUserInteractionEnabled = true
        let cameraButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.startCapture))
        cameraButton.addGestureRecognizer(cameraButtonRecognizer)
        
        //Others
        
        speed = CGFloat(scrollSpeedSlider.value)
        temp = speed
        
        
    }
    
    //MARK:- Setup Textview and Preview
    func setupTextview() {
        textView.text = content
        textView.font = UIFont(name: textView.font!.fontName, size: 50)
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.addSubview(camPreview)
        view.addSubview(componentView)
        camPreview.layer.addSublayer(previewLayer)
        componentView.addSubview(cameraButton)
        componentView.addSubview(cameraSwitch)
        componentView.addSubview(doneButton)
        componentView.addSubview(scrollSpeedSlider)
        if (numIn != 0){
            scrollSpeedSlider.isHidden = true
            noStart = true
        }
        
    }
    
    
    
    
    //MARK:- Setup Camera and Related Features
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        
        
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        // Setup Camera
        
        let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)!
        
        
        do {
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        
        
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    func orient(){
        if(field%2 == 0 ){
            captureSession.removeInput(activeInput)
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)!
            do {
                
                let input = try AVCaptureDeviceInput(device: camera)
                
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                }
            } catch {
                captureSession.addInput(activeInput)
            }
            
            
        }
        if(field%2 == 1 ){
            captureSession.removeInput(activeInput)
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)!
            do {
                
                let input = try AVCaptureDeviceInput(device: camera)
                
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                }
            } catch {
                captureSession.addInput(activeInput)
            }
            
        }
    }
    
    func setupCaptureMode(_ mode: Int) {
    }
    
    //MARK:- Camera Session
    func startSession() {
        
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    //Orient export
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case.portrait:
            orientation = AVCaptureVideoOrientation.portrait
        default:
            orientation = AVCaptureVideoOrientation.portrait
        }
        
        return orientation
    }
    
    //MARK: - Objective-C funcs/Selectors
    //Start recording
    @objc func startCapture() {
        startRecording()
    }
    //Text view scroll
    @objc func step(displaylink: CADisplayLink) {
        
        
        let seconds = displaylink.targetTimestamp - displaylink.timestamp
        if (startFalse||noStart){ speed = 0}
        else {speed = CGFloat(scrollSpeedSlider.value)
            var labelString = String(format: "%.2f", speed)
            let labelRound: Double = Double(labelString)!*100.0
            labelString = String(labelRound)
            speedLabel.text = "Speed: \(labelString)"}
        
        
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentOffset.y + speed * CGFloat(seconds) * 100 ), animated: false)
        
        
    }
    
    // MARK:- URL Setup
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    // MARK:- Photo Library Export
    
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
        else if PHPhotoLibrary.authorizationStatus() == .denied{
            errorLabel.isHidden = false
            errorLabel.text = "It looks like you have denied access to the photo library. In order to save your recorded videos, we need access to your camera roll. Please follow the following steps to grant access: Settings > Privacy > Photos > CHANGE THIS > Write. You may have to restart the app afterwards."
        }
        
    }
    
    
    
    func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved successfully")
                    }
                    completion?(error)
                }
            }
        }
    }
    
    //MARK:- Recording Functions
    func startRecording() {
        
        if movieOutput.isRecording == false {
            count += 1
            
            
            
            startFalse = false
            speed = CGFloat(scrollSpeedSlider.value)
            print(speed)
            displayLink = CADisplayLink(target: self, selector: #selector(step(displaylink:)))
            displayLink?.add(to: .current, forMode: .common)
            
            let connection = movieOutput.connection(with: AVMediaType.video)
            let image = UIImage(systemName: "stop.circle.fill")
            
            cameraButton.tintColor = .white
            cameraButton.setBackgroundImage(image, for: .normal)
            
            
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            
            if (device.isSmoothAutoFocusSupported) {
                
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                    
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            
            if (recordCounter>0){
                try? FileManager.default.removeItem(at: outputURL)
                let URLPath = "\(outputURL!)"
                
                if (!(FileManager.default.fileExists(atPath: URLPath))){
                    
                    print(outputURL!)
                    print ("Deleted File")
                }
            }
            
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
            
            
        }
        else {
            
            stopRecording()
        }
        
    }
    
    func stopRecording() {
        
        if movieOutput.isRecording == true {
            displayLink?.invalidate()
            speedLabel.text = " "
            startFalse = true
            textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            let image = UIImage(systemName: "largecircle.fill.circle")
            cameraButton.tintColor = .systemRed
            cameraButton.setBackgroundImage(image, for: .normal)
            movieOutput.stopRecording()
            recordCounter+=1
        }
    }
    
    
    // MARK:- Video Outputs
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if (error != nil) {
            
            print("Error recording movie: \(error!.localizedDescription)")
            
        } else {
            
            let videoRecorded = outputURL! as URL
            
            self.saveVideoToAlbum(videoRecorded) { (error) in
                
            }
            
        }
    }
    
    
}
