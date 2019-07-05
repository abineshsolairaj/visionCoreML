//
//  NumberRecognitionViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 10/07/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class NumberRecognitionViewController: CameraDetailViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Request permisions to AVCaptureDevice
        session.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    /// Update orientation for AVCaptureConnection so that CVImageBuffer pixels
    /// are rotated correctly in captureOutput(_:didOutput:from:)
    /// - Note: Even though rotation of pixel buffer is hardware accelerated,
    /// this is not the most effecient way of handling it. I was not able to test
    /// getting exif rotation based on device rotation, hence rotating the buffer
    /// I will update it in a near future
    @objc private func deviceOrientationDidChange(_ notification: Notification) {
        session.outputs.forEach {
            $0.connections.forEach {_ in
                //$0.videoOrientation = UIDevice.current.videoOrientation
            }
        }
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Note: Pixel buffer is already correctly rotated based on device rotation
        // See: deviceOrientationDidChange(_:) comment
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        var requestOptions: [VNImageOption: Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        // Run the Core ML classifier - results in handleClassification method
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: requestOptions)
        do {
            try handler.perform([classificationRequest])
        } catch {
            print(error)
        }
    }
    
    // MARK: ML
    
    lazy var classificationRequest: VNCoreMLRequest = {
        // Load the ML model through its generated class and create a Vision request for it.
        do {
            let model = try VNCoreMLModel(for: mnistCNN().model)
            let request = VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
            request.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
            return request
        } catch {
            fatalError("can't load Vision ML model: \(error)")
        }
    }()
    
    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation] else {
            fatalError("unexpected result type from VNCoreMLRequest")
        }
        // Filter observation
        let filteredOservations = observations[0...9].filter({ $0.confidence > 0.5 })
        // Update UI
        DispatchQueue.main.async { [weak self] in
            self?.detailText?.text = "The number is \(filteredOservations.first?.identifier)"
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
