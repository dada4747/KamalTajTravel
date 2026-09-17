//
//  LoginNavigationVC.swift
//  Internacia
//
//  Created by Admin on 03/11/22.
//

import UIKit

class LoginNavigationVC: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    
    }
    
    @IBAction func backButtonction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func navigateToLogin(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
    }
    @IBAction func naviagateToRegister(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
    }
    
}
