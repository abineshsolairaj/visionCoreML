//
//  CameraDetailViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 09/07/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML

class CameraDetailViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //UI Variables
    var detailText : UILabel? = nil
    var cameraView: UIView? = nil
    let session = AVCaptureSession()
    var previewLayer :AVCaptureVideoPreviewLayer? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        detailText = UILabel(frame: CGRect(x: 65, y: 74, width: 400, height: 30))
        self.view.addSubview(detailText!)
        detailText?.textColor = UIColor.orange
        detailText?.backgroundColor = UIColor.white
        cameraView = UIView(frame: CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 114))
        self.view.addSubview(cameraView!)
        setupCamera()

        // Do any additional setup after loading the view.
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera() {
        let availableCameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        var activeDevice: AVCaptureDevice?
        
        for device in availableCameraDevices.devices as [AVCaptureDevice]{
            if device.position == .back {
                activeDevice = device
                break
            }
        }
        
        do {
            let camInput = try AVCaptureDeviceInput(device: activeDevice!)
            
            if session.canAddInput(camInput) {
                session.addInput(camInput)
            }
        } catch {
            print("no camera")
        }
        
        guard cameraAuthentication() else {return}
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "buffer queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let bounds = cameraView!.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer!.bounds = bounds
        previewLayer!.position = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        self.cameraView!.layer.addSublayer(previewLayer!)
        
        session.startRunning()
    }
    
    private func cameraAuthentication() -> Bool{
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                DispatchQueue.main.async {
                                                    self.cameraView!.setNeedsDisplay()
                                                }
                                            }
            })
            return true
        case .authorized:
            return true
        case .denied, .restricted: return false
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
}

extension UIViewController{
    
    func showAlert(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertView, animated: true, completion: nil)
    }
    
}
