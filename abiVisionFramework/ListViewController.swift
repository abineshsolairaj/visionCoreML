//
//  ListViewController.swift
//  abiVisionFramework
//
//  Created by Abinesh Solairaj on 28/06/17.
//  Copyright © 2017 Abinesh Solairaj. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    //Properties
    let features = ["Rectangles Detection", "Face Detection", "Object Tracking", "Text Detection", "Object Recognition", "Number Recognition", "Text Recognition", "Face Recognition"]
    
    //Outlets
    @IBOutlet weak var visionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = visionTableView.dequeueReusableCell(withIdentifier: "visionCell")! as UITableViewCell
        cell.textLabel?.text = features[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let controller = RectangleTrackingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 1{
            let controller = FaceTrackingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 2{
            let controller = ObjectTrackingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 3{
            let controller = TextTrackingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 4{
            let controller = ObjectRecognitionViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 5{
            let controller = NumberRecognitionViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 6{
            showAlert(title: "In Progress", message: "Will be implemented soon.")
        }
        else if indexPath.row == 7{
            showAlert(title: "In Progress", message: "Will be implemented soon.")
            
        }
    }
}
