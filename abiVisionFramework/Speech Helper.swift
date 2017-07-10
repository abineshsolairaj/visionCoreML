//
//  Speech Helper.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 28/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit
import AVFoundation

let speech = AVSpeechSynthesizer()

extension UIViewController{
    func speechAnalysis(textToSpeech: String){
        let speechUtter = AVSpeechUtterance(string: textToSpeech)
        speechUtter.rate = 0.52
        speechUtter.pitchMultiplier = 1.25
        speechUtter.volume = 0.90
        speech.speak(speechUtter)
    }
}
