//
//  ForgotPasswordVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_mobileNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


        txt_email.delegate = self
        txt_mobileNumber.delegate = self
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ButtonAction
    @IBAction func sendEmailBtnClicked(_ sender: Any) {
        
        // form validations...
       let whitespace = CharacterSet.whitespacesAndNewlines
       var messageStr = ""
       
       if txt_email.text?.count == 0 || txt_email.text?.trimmingCharacters(in: whitespace).count == 0 {
           messageStr = "Please enter email id"
       }
       else if txt_email.text?.isValidEmailAddress() == false {
           messageStr = "Please enter valid email address"
       }
       else if txt_mobileNumber.text?.count == 0 || txt_mobileNumber.text?.trimmingCharacters(in: whitespace).count == 0 {
           messageStr = "Please enter mobile number"
       }else if txt_mobileNumber.text?.isValidPhone() == false {
           messageStr = "Please enter valid mobile number"
       }
       else {}
       
       // validation message...
       if messageStr.count != 0 {
           self.view.makeToast(message: messageStr)
       }
       else {
           
           // call Api...
           self.dismiss_keyboard()
           forgotPassword_APIConnection()
       }
    }
    
    @IBAction func existingUserClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ForgotPasswordVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate & TablePopViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txt_mobileNumber {

            if string.isValidIntergerSet() == false {
                return false
            }
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 15
        }
        return true
    }
    
    func dismiss_keyboard() -> Void {
        
        // resign key boards...
        txt_email.resignFirstResponder()
        txt_mobileNumber.resignFirstResponder()
    }
    
    func clearTextFieldData() -> Void {
        
        // clear textfields..
        txt_email.text = ""
        txt_mobileNumber.text = ""
    }
}


extension ForgotPasswordVC {
    
    // MARK:- API's
    func forgotPassword_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["email_id": txt_email.text!, "phone": txt_mobileNumber.text!]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: User_ForgotPassword, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Forgot response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        
                        self.clearTextFieldData()
                        if let message_str = result_dict["data"] as? String {
//                            appDel.window?.makeToast(message: message_str)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
                                    rootVC.view.makeToast(message: message_str, duration: 5)
                                }
                            }

                            
                        }

                        self.navigationController?.popViewController(animated: true)
                       
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
                                    rootVC.view.makeToast(message: message_str, duration: 5)
                                }
                            }
                        }
                        if let message_str = result_dict["data"] as? String {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
                                    rootVC.view.makeToast(message: message_str, duration: 5)
                                }
                            }
                        }
                    }
                } else {
                    print("Forgot search formate : \(String(describing: resultObj))")
                }
            } else {
                print("Forgot error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
        }
    }
}

