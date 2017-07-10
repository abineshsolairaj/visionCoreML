//
//  RectangleTrackingViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 10/07/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class RectangleTrackingViewController: CameraDetailViewController, AVCapturePhotoCaptureDelegate {
    
    private var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectRectangles()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    
    func detectRectangles(){
        let rectangleRequest = VNDetectRectanglesRequest(completionHandler: self.textDetectionHandler)
        self.requests = [rectangleRequest]
    }
    
    func textDetectionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRectangleObservation] else {print("no result"); return}
        
        let result = observations.map({$0 as? VNRectangleObservation})
        
        DispatchQueue.main.async() {
            self.detailText?.text = "Found \(observations.count) rectangles."
            self.cameraView?.layer.sublayers?.removeSubrange(1...)
            for rectangle in observations{
                let layer = CALayer()
                layer.frame = self.transformRect(fromRect: rectangle.boundingBox, toViewRect: self.cameraView!)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
