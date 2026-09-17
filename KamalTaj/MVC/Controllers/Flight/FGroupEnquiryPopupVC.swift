//
//  FGroupEnquiryPopupVC.swift
//  EasiTripBooking
//
//  Created by Rahul on 30/06/25.
//

import UIKit

class FGroupEnquiryPopupVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lbl_adult: UILabel!
    @IBOutlet weak var lbl_child: UILabel!
    @IBOutlet weak var lbl_infant: UILabel!

    @IBOutlet var classButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_adult.text =  "\(DTravelModel.adultCount) AD"//String.init(format: "Adult %02d", DTravelModel.adultCount)
        lbl_child.text =  "\(DTravelModel.childCount) CH"//String.init(format: "Child %02d", DTravelModel.childCount)
        lbl_infant.text =  "\(DTravelModel.infantCount) IN"//String.init(format: "Infant %02d", DTravelModel.infantCount)
        DTravelModel.flight_class = "Economy"
        mobileTextField.keyboardType = .numberPad

        let defaultIndex = 0
        classButtonTapped(classButtons[defaultIndex])

    }
    
    @IBAction func classButtonTapped(_ sender: UIButton) {
        for button in classButtons {
                guard let parent = button.superview else { continue }

                if button == sender {
                    // 🔵 SELECTED
                    parent.layer.borderWidth  = 1
                    parent.layer.borderColor  = UIColor(hexString: "#FF8A37").cgColor
                    parent.backgroundColor    = UIColor(hexString: "#F4F5F9")
                } else {
                    // ⚪️ DESELECTED
                    parent.layer.borderWidth  = 1
                    parent.layer.borderColor  = UIColor(hexString: "#CACACA").cgColor
                    parent.backgroundColor    = .white
                }
            }

        print("Selected class index: \(sender.tag)")
        if sender.tag == 0 {
            DTravelModel.flight_class = "Economy"
        }
        else if sender.tag == 1 {
            DTravelModel.flight_class = "Business Class"
        }
        else if sender.tag == 2 {
            DTravelModel.flight_class = "First Class"
        }
    }
    
    @IBAction func hideMainPopup(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if nameTextField.text?.isEmpty == true {
            self.view.makeToast(message: "Please enter your first name.")
        } else if nameTextField.text?.isEmpty == true {
            self.view.makeToast(message: "Please enter your last name.")
        }else if mobileTextField.text?.isEmpty == true {
            self.view.makeToast(message: "Please enter your mobile number.")
        } else if emailTextField.text?.isEmpty == true {
            self.view.makeToast(message: "Please enter your email.")
        } else {
            // ✅ All fields are filled → Go to booking API
            submitEnquiry_APIConnection()
        }
        
    }
    
}
extension FGroupEnquiryPopupVC {
    func submitEnquiry_APIConnection() -> Void {
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["first_name": nameTextField.text!,
                                        "last_name": lastNameTextField.text!,
                                        "email": emailTextField.text!,
                                        "phone_no": mobileTextField.text!,
                                        "adult_count": "\(DTravelModel.adultCount)",
                                        "child_count": "\(DTravelModel.childCount)",
                                        "infant_count": "\(DTravelModel.infantCount)",
                                        "selected_class": DTravelModel.flight_class]
        
        let paramString: [String: String] = ["post_params": VKAPIs.getJSONString(object: params)]
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: "menu/flight_group_enquiry", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("flight_group_enquiry response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        
                        self.dismiss(animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let rootVC = UIApplication.shared.currentWindow?.rootViewController {
                                rootVC.view.makeToast(message: result_dict["message"] as? String ?? "", duration: 3)
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
                    print("flight_group_enquiry  formate : \(String(describing: resultObj))")
                }
            } else {
                print("flight_group_enquiry error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            SwiftLoader.hide()
        }
    }
}
