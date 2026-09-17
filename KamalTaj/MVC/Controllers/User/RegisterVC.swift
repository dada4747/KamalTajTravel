//
//  RegisterVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_countryCode: UITextField!
    @IBOutlet weak var txt_mobileNumber: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmPass: UITextField!
    
    @IBOutlet weak var sv_scrollView: UIScrollView!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!
    
    @IBOutlet weak var haveLoginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK:- Variables
    var isFrom : String? = ""
    var countries_array: [[String: String]] = []
    var country_dialCode = ["DialCode": "+91",
                            "Country": "India",
                            "ISOCode": "IN"]
    var isTerms = false
    var isPasswordShown = true
    var isCPasswordShown = true
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        // Do any additional setup after loading the view.
        keyboardNotification()
        gettingCountyCodeList()
        addDelegate()
    }

    func keyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.sv_scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        sv_scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        sv_scrollView.contentInset = contentInset
    }

    // MARK: - Helpers
    func addDelegate() {
        
        // delegate...
        txt_firstName.delegate = self
        txt_lastName.delegate = self
        txt_email.delegate = self
        txt_mobileNumber.delegate = self
        txt_password.delegate = self
        txt_confirmPass.delegate = self
    }
    func gettingCountyCodeList() {
        
        // getting country codes...
        country_dialCode = VKDialCodes.shared.current_dialCode
        displayDialCode(dailCode: country_dialCode)
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
        
    }
    func displayDialCode(dailCode: [String: String]) {

        txt_countryCode.text = String.init(format: "%@ %@", dailCode["Country"] ?? "", dailCode["DialCode"] ?? "" )
        let img_iso = dailCode["ISOCode"] ?? ""
        //img_country.image = UIImage.init(named: String.init(format: "%@.png", img_iso.lowercased()))
    }

    // MARK: - ButtonAction
    @IBAction func loginAction(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController

//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func titleBtnClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_title = self
        tbl_popView.DType = .Title
        tbl_popView.title_array = ["Mr", "Ms", "Mrs" ]
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        
        let nextObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ISOCodeVC") as! ISOCodeVC
        nextObj.delegate = self
        nextObj.DCatType = .ISOCode
        nextObj.countries_array = countries_array
        self.present(nextObj, animated: true, completion: nil)
    }
    
    @IBAction func termsBtnClicked(_ sender: Any) {
        
        // move to about us...
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
        vc.isFrom = .Terms
        vc.isRegisterScreen = true
        self.present(vc, animated: true, completion: nil)
    
    }
    
    @IBAction func acceptTermsBtnClicked(_ sender: UIButton) {
        
        if isTerms {
            isTerms = false
            sender.isSelected = false
            sender.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        } else {
            isTerms = true
            sender.isSelected = true
            sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        if txt_firstName.text?.count == 0 || txt_firstName.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter first name"
        }
        else if txt_lastName.text?.count == 0 || txt_lastName.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter last name"
        }
        else if txt_email.text?.count == 0 || txt_email.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter email id"
        }
        else if txt_email.text?.isValidEmailAddress() == false {
            messageStr = "Please enter valid email address"
        }
        else if txt_mobileNumber.text?.count == 0 || txt_mobileNumber.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter mobile number"
        }
        else if txt_mobileNumber.text?.isValidPhone() == false {
            messageStr = "Please enter valid mobile number"
        }
        else if txt_password.text?.count == 0 || txt_password.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter password"
        }
        else if txt_confirmPass.text?.count == 0 || txt_confirmPass.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter confirm password"
        }
        else if txt_password.text != txt_confirmPass.text {
            messageStr = "Password and confirm password not matched"
        }
        else if !isTerms {
            messageStr = "Please accept Terms & Conditions"
        }
        else {}
        
        // validation message...
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            
            // calling register...
            self.dismiss_keyboard()
            register_APIConnection()
        }
        
    }
    @IBAction func visibilityPAction(sender: AnyObject) {
            if(isPasswordShown == true) {
                txt_password.isSecureTextEntry = false
                eyeButton1.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_password.isSecureTextEntry = true
                eyeButton1.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

            isPasswordShown = !isPasswordShown
        }
    
    @IBAction func visibilityCPAction(sender: AnyObject) {
            if(isCPasswordShown == true) {
                txt_confirmPass.isSecureTextEntry = false
                eyeButton2.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
                
            } else {
                txt_confirmPass.isSecureTextEntry = true
                eyeButton2.setImage(UIImage(named: "eye-pw"), for: .normal)
                
            }

        isCPasswordShown = !isCPasswordShown
        }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension RegisterVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
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
        txt_firstName.resignFirstResponder()
        txt_lastName.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_mobileNumber.resignFirstResponder()
        txt_password.resignFirstResponder()
        txt_confirmPass.resignFirstResponder()
    }
}

extension RegisterVC: countryDailCodeDelegate, TravellerTitleDelegate {

    // MARK:- ISOCodeDelegate
    func countryDailCode(dial_code: [String : String], nationality: [String : Any]) {

        country_dialCode = dial_code
        displayDialCode(dailCode: country_dialCode)
    }
    
    func travellerTitle(title: String) {
        
        txt_title.text = title
        print(title)
    }
}


extension RegisterVC {
    
    // MARK:- API's
//    func register_APIConnection() -> Void {
//        
//        CommonLoader.shared.startLoader(in: view)
//
//        // params...
//        let params: [String: String] = [
////            "first_name": txt_firstName.text!,
////            "last_name": txt_lastName.text!,
//            "phone": txt_mobileNumber.text!,
//            "email": txt_email.text!,
//            "password": txt_password.text!,
//            "confirm_password": txt_confirmPass.text!,
////            "tc": "on",
////            "country_code": country_dialCode["DialCode"]!.replacingOccurrences(of: "+", with: "")
//        ]
//        
//        let paramString: [String: String] = ["register_param": VKAPIs.getJSONString(object: params)]
//        
//        // calling api...
//        VKAPIs.shared.getRequestFormdata(params: paramString, file: USER_Register, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Register user response: \(String(describing: resultObj))")
//                
//                if let result_dict = resultObj as? [String: Any] {
//                    if result_dict["status"] as? Bool == true  {
//                        appDel.moveToLoginScreen()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
//                                rootVC.view.makeToast(message: result_dict["data"] as? String ?? "", duration: 5)
//                            }
//                        }
//                    }
//                    else {
//                        // error message...
//                        if let message_str = result_dict["data"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Register user formate : \(String(describing: resultObj))")
//                }
//            } else {
//                print("Register user error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//            }
//            CommonLoader.shared.stopLoader()
//        }
//    }
    func getTitleGenderValue(for title: String) -> String {
        switch title.trimmingCharacters(in: .whitespaces) {
        case "Mr":     return "1"
        case "Ms":     return "2"
        case "Mrs":    return "5"
        default:       return ""
        }
    }
    func register_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["first_name": txt_firstName.text!,
                                        "last_name": txt_lastName.text!,
                                        "country_code": country_dialCode["DialCode"] ?? "+91",
                                        "phone": txt_mobileNumber.text!,
                                        "email": txt_email.text!,
                                        "password": txt_password.text!,
                                        "confirm_password": txt_confirmPass.text!,
                                        "title": self.getTitleGenderValue(for: txt_title.text!),
                                        "tc": "on"]
        
        let paramString: [String: String] = ["user_register": VKAPIs.getJSONString(object: params)]
        // calling api...
        VKAPIs.shared.getNewRequestXwwwform(params: paramString, file: USER_Register, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Register user response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {

                        appDel.moveToLoginScreen()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
                                rootVC.view.makeToast(message: result_dict["message"] as? String ?? "", duration: 5)
                            }
                        }
                    }
                    else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Register user formate : \(String(describing: resultObj))")
                }
            } else {
                print("Register user error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            SwiftLoader.hide()
        }
    }
    
}



