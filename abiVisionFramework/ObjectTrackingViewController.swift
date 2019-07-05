//
//  ObjectTrackingViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 25/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ObjectTrackingViewController: CameraDetailViewController {
    
    var highlightView : UIView?{
        didSet {
            self.highlightView?.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
            self.highlightView?.layer.borderColor = UIColor.orange.cgColor
            self.highlightView?.layer.borderWidth = 4
            self.highlightView?.backgroundColor = .clear
        }
    }
    
    var gesture:UITapGestureRecognizer?
    
    private var lastObservation: VNDetectedObjectObservation?
    
    private let visionSequenceHandler = VNSequenceRequestHandler()
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailText?.text = "Tap on the screen to track."
        // hide the red focus area on load
        self.highlightView?.frame = .zero
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.session.startRunning()
        gesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        self.cameraView?.isUserInteractionEnabled = true
        self.cameraView?.addGestureRecognizer(gesture!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard
            // make sure the pixel buffer can be converted
            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            // make sure that there is a previous observation we can feed into the request
            let lastObservation = self.lastObservation
            else { return }
        
        // create the request
        let request = VNTrackObjectRequest(detectedObjectObservation: lastObservation, completionHandler: self.handleVisionRequestUpdate)
        // set the accuracy to high
        // this is slower, but it works a lot better
        request.trackingLevel = .accurate
        
        // perform the request
        do {
            try self.visionSequenceHandler.perform([request], on: pixelBuffer)
        } catch {
            print("Throws: \(error)")
        }
    }
    
    private func handleVisionRequestUpdate(_ request: VNRequest, error: Error?) {
        // Dispatch to the main queue because we are touching non-atomic, non-thread safe properties of the view controller
        DispatchQueue.main.async {
            // make sure we have an actual result
            guard let newObservation = request.results?.first as? VNDetectedObjectObservation else { return }
            
            // prepare for next loop
            self.lastObservation = newObservation
            
            // check the confidence level before updating the UI
            guard newObservation.confidence >= 0.3 else {
                // hide the rectangle when we lose accuracy so the user knows something is wrong
                self.highlightView?.frame = .zero
                return
            }
            
            // calculate view rect
            var transformedRect = newObservation.boundingBox
            transformedRect.origin.y = 1 - transformedRect.origin.y
            let convertedRect = self.previewLayer!.layerRectConverted(fromMetadataOutputRect: transformedRect)
            
            // move the highlight view
            self.highlightView?.frame = convertedRect
            
        }
    }
    
    @objc func didTap(sender:UITapGestureRecognizer){
        if self.highlightView == nil{
            self.highlightView = UIView()
            self.cameraView?.addSubview(self.highlightView!)
        }
        
        // get the center of the tap
        self.highlightView?.frame.size = CGSize(width: 120, height: 120)
        self.highlightView?.center = sender.location(in: self.view)
        
        // convert the rect for the initial observation
        let originalRect = self.highlightView?.frame ?? .zero
        var convertedRect = self.previewLayer!.metadataOutputRectConverted(fromLayerRect: originalRect)
        convertedRect.origin.y = 1 - convertedRect.origin.y
        
        // set the observation
        let newObservation = VNDetectedObjectObservation(boundingBox: convertedRect)
        self.lastObservation = newObservation
        
    }

}
