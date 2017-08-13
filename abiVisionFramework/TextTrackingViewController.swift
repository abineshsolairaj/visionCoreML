//
//  TextTrackingViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 25/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class TextTrackingViewController: CameraDetailViewController {
    
    private var requests = [VNRequest]()
    
    //@IBOutlet weak var foundLabel: UILabel!
    //@IBOutlet weak var cameraView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detectText()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    
    func detectText(){
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.textDetectionHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    func textDetectionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {print("no result"); return}
        
        let result = observations.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            self.cameraView?.layer.sublayers?.removeSubrange(1...)
            for region in result {
                guard let rg = region else {continue}
                self.drawRegionBox(box: rg)
                if let boxes = region?.characterBoxes {
                    for characterBox in boxes {
                        self.detailText?.text = "Found \(boxes.count * result.count) characters in \(result.count) words."
                        self.drawTextBox(box: characterBox)
                    }
                }
            }
        }
    }
    
    func drawRegionBox(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {return}
        var xMin: CGFloat = 9999.0
        var xMax: CGFloat = 0.0
        var yMin: CGFloat = 9999.0
        var yMax: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < xMin {xMin = char.bottomLeft.x}
            if char.bottomRight.x > xMax {xMax = char.bottomRight.x}
            if char.bottomRight.y < yMin {yMin = char.bottomRight.y}
            if char.topRight.y > yMax {yMax = char.topRight.y}
        }
        
        let xCoord = xMin * self.cameraView!.frame.size.width
        let yCoord = (1 - yMax) * self.cameraView!.frame.size.height
        let width = (xMax - xMin) * self.cameraView!.frame.size.width
        let height = (yMax - yMin) * self.cameraView!.frame.size.height
        
        let layer = CALayer()
        layer.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.green.cgColor
        
        self.cameraView!.layer.addSublayer(layer)
    }
    
    func drawTextBox(box: VNRectangleObservation) {
        let xCoord = box.topLeft.x * self.cameraView!.frame.size.width
        let yCoord = (1 - box.topLeft.y) * self.cameraView!.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * self.cameraView!.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * self.cameraView!.frame.size.height
        
        let layer = CALayer()
        layer.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.orange.cgColor
        
        self.cameraView!.layer.addSublayer(layer)
    }
    
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
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
