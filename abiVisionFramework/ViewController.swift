//
//  ViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 24/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var exploreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.orange, NSAttributedStringKey.font.rawValue: UIFont(name: "Arial-Regular", size: 25)!]
        //speechAnalysis(textToSpeech: "Hi, Welcome to Vision and CoreML Exploration. This app shows a demo of all the Vision Framework features along with the CoreML introduced in WWDC17. The Following are the features you will go through in the app like Face Tracking, Object Tracking, Text Tracking, Object Recognition, Text Recognition and Face Recognition. You can start exploring by clicking the button below. Happy Learning.")
        exploreButton.layer.borderColor = UIColor.orange.cgColor
        exploreButton.layer.borderWidth = 1.0
        exploreButton.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

