//
//  CameraView.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 04/07/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    // Property
    private weak var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Insert layer at index 0
    func addCaptureVideoPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer?.removeFromSuperlayer()
        self.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer
        self.previewLayer?.videoGravity = .resizeAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
}
