//
//  ImageHelper.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 29/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import Vision

open class FaceDetector{
    
    open func highlightFaces(for source: UIImage, complete: @escaping (UIImage) -> Void) {
        var resultImage = source
        let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error == nil {
                if let results = request.results as? [VNFaceObservation] {
                    print("Found \(results.count) faces")
                    
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        let boundingRect = faceObservation.boundingBox
                        //let uuid = faceObservation.uuid
                        //let conf = faceObservation.confidence
                        var landmarkRegions: [VNFaceLandmarkRegion2D] = []
                        if let faceContour = landmarks.faceContour {
                            landmarkRegions.append(faceContour)
                        }
                        if let leftEye = landmarks.leftEye {
                            landmarkRegions.append(leftEye)
                        }
                        if let rightEye = landmarks.rightEye {
                            landmarkRegions.append(rightEye)
                        }
                        if let nose = landmarks.nose {
                            landmarkRegions.append(nose)
                        }
                        if let noseCrest = landmarks.noseCrest {
                            landmarkRegions.append(noseCrest)
                        }
                        if let medianLine = landmarks.medianLine {
                            landmarkRegions.append(medianLine)
                        }
                        if let outerLips = landmarks.outerLips {
                            landmarkRegions.append(outerLips)
                        }
                        /*
                         if let leftEyebrow = landmarks.leftEyebrow {
                         landmarkRegions.append(leftEyebrow)
                         }
                         if let rightEyebrow = landmarks.rightEyebrow {
                         landmarkRegions.append(rightEyebrow)
                         }
                         
                         if let innerLips = landmarks.innerLips {
                         landmarkRegions.append(innerLips)
                         }
                         if let leftPupil = landmarks.leftPupil {
                         landmarkRegions.append(leftPupil)
                         }
                         if let rightPupil = landmarks.rightPupil {
                         landmarkRegions.append(rightPupil)
                         }
                         */
                        resultImage = self.drawOnImage(source: resultImage,
                                                       boundingRect: boundingRect,
                                                       faceLandmarkRegions: landmarkRegions)
                        
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
            complete(resultImage)
        }
        
        let vnImage = VNImageRequestHandler(cgImage: source.cgImage!, options: [:])
        try? vnImage.perform([detectFaceRequest])
    }
    
    fileprivate func drawOnImage(source: UIImage,
                                 boundingRect: CGRect,
                                 faceLandmarkRegions: [VNFaceLandmarkRegion2D]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(source.size, false, 1)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: source.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.colorBurn)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        
        let rectWidth = source.size.width * boundingRect.size.width
        let rectHeight = source.size.height * boundingRect.size.height
        
        //draw image
        let rect = CGRect(x: 0, y:0, width: source.size.width, height: source.size.height)
        context.draw(source.cgImage!, in: rect)
        
        
        //draw bound rect
        var fillColor = UIColor.green
        fillColor.setFill()
        context.addRect(CGRect(x: boundingRect.origin.x * source.size.width, y:boundingRect.origin.y * source.size.height, width: rectWidth, height: rectHeight))
        context.drawPath(using: CGPathDrawingMode.stroke)
        
        //draw overlay
        fillColor = UIColor.red
        fillColor.setStroke()
        context.setLineWidth(2.0)
        for faceLandmarkRegion in faceLandmarkRegions {
            var points: [CGPoint] = []
            for i in 0..<faceLandmarkRegion.pointCount {
                let point = faceLandmarkRegion.point(at: i)
                let p = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
                points.append(p)
            }
            let mappedPoints = points.map { CGPoint(x: boundingRect.origin.x * source.size.width + $0.x * rectWidth, y: boundingRect.origin.y * source.size.height + $0.y * rectHeight) }
            context.addLines(between: mappedPoints)
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return coloredImg
    }
}

//func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer {
//
//    //let newImage = ImageUtilities.resize(image: image, newSize: CGSize(width: 224/3.0, height: 224/3.0))
//
//    let ciimage = CIImage(image: image)
//    let tmpcontext = CIContext(options: nil)
//    let cgimage =  tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
//
//    let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
//    let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
//    let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
//    let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
//    let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
//    let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
//    keysPointer.initialize(to: keys)
//    valuesPointer.initialize(to: values)
//
//    let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
//
//    let width = cgimage!.width
//    let height = cgimage!.height
//
//    var pxbuffer: CVPixelBuffer?
//    var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
//                                     kCVPixelFormatType_32BGRA, options, &pxbuffer)
//    status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//
//    let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!)
//
//
//    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//    let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
//    let context = CGContext(data: bufferAddress,
//                            width: width,
//                            height: height,
//                            bitsPerComponent: 8,
//                            bytesPerRow: bytesperrow,
//                            space: rgbColorSpace,
//                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
//    context?.concatenate(CGAffineTransform(rotationAngle: 0))
//    context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
//
//    context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)))
//    status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//    return pxbuffer!
//
//}



