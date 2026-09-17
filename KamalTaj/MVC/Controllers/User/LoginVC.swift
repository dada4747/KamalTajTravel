//
//  LoginVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txt_emailId: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var isPasswordShown = true
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        // Do any additional setup after loading the view.
        txt_emailId.text = "rahulad4747@gmail.com"
        txt_password.text = "Rahul@123"
        // delegate...
        txt_emailId.delegate = self
        txt_password.delegate = self
        
 
    }
    
    // MARK: - ButtonAction
    @IBAction func skipBtnClicked(_ sender: Any) {
        
        appDel.moveToHomeTabBarScreen()
    }
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        if txt_emailId.text?.count == 0 || txt_emailId.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter email id"
        }
        else if txt_emailId.text?.isValidEmailAddress() == false {
            messageStr = "Please enter valid email address"
        }
        else if txt_password.text?.count == 0 || txt_password.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter password"
        }
        else {}
        
        // validation message...
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            
            // call Api...
            self.dismiss_keyboard()
            loginUser_APIConnection()
        }
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        
        let nextVC = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        let regObj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        let navigationController = UINavigationController(rootViewController: regObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
//
//        let nextVC = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func visibilityAction(sender: AnyObject) {
            if(isPasswordShown == true) {
                txt_password.isSecureTextEntry = false
                eyeButton.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_password.isSecureTextEntry = true
                eyeButton.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

            isPasswordShown = !isPasswordShown
        }
}

extension LoginVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func dismiss_keyboard() -> Void {
        
        // resign key boards...
        txt_emailId.resignFirstResponder()
        txt_password.resignFirstResponder()
    }
}


extension LoginVC {
    
    // MARK:- API's
//    func loginUser_APIConnection() -> Void {
//        
//        CommonLoader.shared.startLoader(in: view)
//        // params...
//        let params: [String: String] = ["username": txt_emailId.text!,
//                                        "password": txt_password.text!]
//        
//        let paramString: [String: String] = ["user_login": VKAPIs.getJSONString(object: params)]
//        
//        // calling api...
//        VKAPIs.shared.getRequestXwwwform(params: paramString, file: USER_Login, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Login response: \(String(describing: resultObj))")
//                
//                if let result_dict = resultObj as? [String: Any] {
//                    if result_dict["status"] as? Bool == true {
//                        if let data_dict = result_dict["data"] as? [String: Any] {
//                            
//                            // store user profiles...
//                            let profile_dict = VKRemoveNull.shared.filterNulls_inDictionary(dictionary: data_dict, empty: true)
//                            UserDefaults.standard.set(profile_dict, forKey: TMXUser_Profile)
//                            appDel.window?.makeToast(message: result_dict["message"] as! String)
//                            
//                            // move to home sreen...
//                            appDel.moveToHomeTabBarScreen()
//                        }
//                    } else {
//                        // error message...
//                        if let message_str = result_dict["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Login response formate : \(String(describing: resultObj))")
//                }
//            } else {
//                print("Login response error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//            }
//            
//            CommonLoader.shared.stopLoader()
//        }
//    }
    func loginUser_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["username": txt_emailId.text!,
                                        "password": txt_password.text!]
        
        let paramString: [String: String] = ["user_login": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: USER_Login, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Login response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let data_dict = result_dict["data"] as? [String: Any] {
                            
                            // store user profiles...
                            let profile_dict = VKRemoveNull.shared.filterNulls_inDictionary(dictionary: data_dict, empty: true)
                            UserDefaults.standard.set(profile_dict, forKey: TMXUser_Profile)
                            appDel.window?.makeToast(message: result_dict["message"] as? String ?? "", duration: 5)
                            
                            // move to home sreen...
                            appDel.moveToHomeScreen()
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Login response formate : \(String(describing: resultObj))")
                }
            } else {
                print("Login response error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
        }
    }
}

extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
