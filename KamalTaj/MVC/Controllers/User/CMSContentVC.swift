//
//  CMSContentVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class CMSContentVC: UIViewController {
    
    @IBOutlet weak var lbl_cmsCotent: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_header: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    var isRegisterScreen = false
    var isFrom = contentType.AboutUs
    enum contentType {
        
        case AboutUs
        case ContactUs
        case Terms
        case Privacy
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view_header.viewShadow()
        displayContentInfo()
    }
  
    // MARK:- Helpers
    func displayContentTitle(contentStr: String) {
        
        lbl_cmsCotent.attributedText = contentStr.htmlToAttributedString()
        print(lbl_cmsCotent.attributedText ?? "")
    }
    
    func displayContentInfo() {
        
        lbl_title.text = ""
        lbl_cmsCotent.numberOfLines = 0
        
        if isFrom == .AboutUs {
            lbl_title.text = "About Us"
            lbl_header.text = "About Us"
            getCMS_HTTPConnection(url_cms: CMS_AboutUs)
            
        } else if isFrom == .ContactUs {
            lbl_title.text = "Contact Us"
            lbl_header.text = "Contact Us"
            getCMS_HTTPConnection(url_cms: CMS_ContactUs)
            
        } else if isFrom == .Terms {
            lbl_title.text = "Terms & Conditions"
            lbl_header.text = "Terms & Conditions"
            
            getCMS_HTTPConnection(url_cms: CMS_TermsAndConditions)
            
        } else if isFrom == .Privacy {
            
            lbl_title.text = "Privacy Policy"
            lbl_header.text = "Privacy Policy"
            getCMS_HTTPConnection(url_cms: CMS_PrivacyPolicy)
            
        } else {}
    }
    
    // MARK:- ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        if isRegisterScreen {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension CMSContentVC {
    
    // MARK:- API's
    func getCMS_HTTPConnection(url_cms: String) -> Void {
        
        CommonLoader.shared.startLoader(in: view)
        // calling api...
        VKAPIs.shared.getRequest(file: url_cms, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("CMS Content success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response data...
                        if let dataContent = result["data"] as? String {
                            self.displayContentTitle(contentStr: dataContent)
                        }
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("CMS Content formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
        }
    }
}


