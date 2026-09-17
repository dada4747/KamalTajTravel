//
//  SuccessVC.swift
//  EzyAirline
//
//  Created by Rahul on 21/02/25.
//

import UIKit

class SuccessVC: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    var module =  ModuleType.Flight
    enum ModuleType: String {
        case Flight
        case Hotel
        case Car
        case Visa
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_title.text = "Thank you for booking a \(module.rawValue) with us"
        // Apply radial gradient
               // Dismiss after 3 seconds
               DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                   self.dismiss(animated: true, completion: nil)
               }
        // Do any additional setup after loading the view.
    }

}
