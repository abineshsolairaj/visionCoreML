//
//  FaceTrackingViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 25/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import CoreImage
import CoreVideo
import Vision
import AVFoundation

class FaceTrackingViewController: CameraDetailViewController, AVCapturePhotoCaptureDelegate {
    
private var requests = [VNRequest]()
    
func detectFace(){
    let faceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.faceDetectionHandler)
    self.requests = [faceRequest]
}
    
func faceDetectionHandler(request: VNRequest, error: Error?) {
    guard let observations = request.results as? [VNFaceObservation] else {print("no result"); return}
    print(observations)
    let result = observations.map({$0 as? VNFaceObservation})
    DispatchQueue.main.async() {
        self.detailText?.text = "Found \(observations.count) faces."
        self.cameraView?.layer.sublayers?.removeSubrange(1...)
        for face in observations{
            let layer = CALayer()
            layer.frame = self.transformRect(fromRect: face.boundingBox, toViewRect: self.cameraView!)
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.orange.cgColor
            self.cameraView?.layer.addSublayer(layer)
        }
    }
    
}
    
//Convert Vision Frame to UIKit Frame
func transformRect(fromRect: CGRect , toViewRect :UIView) -> CGRect {
    
    var toRect = CGRect()
    toRect.size.width = fromRect.size.width * toViewRect.frame.size.width
    toRect.size.height = fromRect.size.height * toViewRect.frame.size.height
    toRect.origin.y =  (toViewRect.frame.height) - (toViewRect.frame.height * fromRect.origin.y )
    toRect.origin.y  = toRect.origin.y -  toRect.size.height
    toRect.origin.x =  fromRect.origin.x * toViewRect.frame.size.width
    
    return toRect
}
    
override func viewDidLoad() {
    super.viewDidLoad()
    detectFace()
    // Do any additional setup after loading the view.
}
    
override func viewDidDisappear(_ animated: Bool) {
    session.stopRunning()
}
    
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    
override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
    
    var requestOptions:[VNImageOption : Any] = [:]
    
    if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
        requestOptions = [.cameraIntrinsics:camData]
    }
    
    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: 6, options: requestOptions)
    
    do {
        try imageRequestHandler.perform(self.requests)
    } catch {
        print(error)
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
