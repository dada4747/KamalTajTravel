//
//  ChangePasswordVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    // Outlets...
    @IBOutlet weak var txt_oldPassword: UITextField!
    @IBOutlet weak var txt_newPassword: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var btn_oldPassword: UIButton!
    @IBOutlet weak var btn_newPassword: UIButton!
    @IBOutlet weak var btn_ConfirmPassword: UIButton!
    var isOldPassVis = true
    var isNewPassVis = true
    var isConfirmPassVis = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txt_oldPassword.delegate = self
        txt_newPassword.delegate = self
        txt_ConfirmPassword.delegate = self
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
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtnClicked(_ sender: Any) {
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        if txt_oldPassword.text?.count == 0 || txt_oldPassword.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter old password"
        }
        else if txt_newPassword.text?.count == 0 || txt_newPassword.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter new password"
        }
        else if txt_ConfirmPassword.text?.count == 0 || txt_ConfirmPassword.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please re-enter new password"
        }
        else if txt_newPassword.text != txt_ConfirmPassword.text {
            messageStr = "Password and confirm password not matched"
        }
            
        else {}
        
        // validation message...
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            // call Api...
            self.dismiss_keyboard()
            changePassword_APIConnection()
        }
    }
    @IBAction func oldPasswordAction(sender: AnyObject) {
            if(isOldPassVis == true) {
                txt_oldPassword.isSecureTextEntry = false
                btn_oldPassword.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_oldPassword.isSecureTextEntry = true
                btn_oldPassword.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

        isOldPassVis = !isOldPassVis
        }
    @IBAction func newPassword(sender: AnyObject) {
            if(isNewPassVis == true) {
                txt_newPassword.isSecureTextEntry = false
                btn_newPassword.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_newPassword.isSecureTextEntry = true
                btn_newPassword.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

        isNewPassVis = !isNewPassVis
        }
    @IBAction func ConfirmPasswordAction(sender: AnyObject) {
            if(isConfirmPassVis == true) {
                txt_ConfirmPassword.isSecureTextEntry = false
                btn_ConfirmPassword.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_ConfirmPassword.isSecureTextEntry = true
                btn_ConfirmPassword.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

        isConfirmPassVis = !isConfirmPassVis
        }

}

extension ChangePasswordVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate & TablePopViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func dismiss_keyboard() -> Void {
        
        // resign key boards...
        txt_oldPassword.resignFirstResponder()
        txt_newPassword.resignFirstResponder()
        txt_ConfirmPassword.resignFirstResponder()
    }
    
    func clearTextFieldData() -> Void {
        
        // clear textfields..
        txt_oldPassword.text = ""
        txt_newPassword.text = ""
        txt_ConfirmPassword.text = ""
    }
}

extension ChangePasswordVC {
    
    // MARK:- API's
    func changePassword_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        
        let user_id = ""
        
        // params...
        let params: [String: String] = ["current_password": txt_oldPassword.text!,
                                        "new_password": txt_newPassword.text!,
                                        "user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: User_ChangePassword, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Change Password response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        
                        self.clearTextFieldData()
                        if let message_str = result_dict["message"] as? String {
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
                    }
                } else {
                    print("Change Password formate : \(String(describing: resultObj))")
                }
            } else {
                print("Change Password error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
        }
    }
}


