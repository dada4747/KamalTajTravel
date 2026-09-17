//
//  GuestFormVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// delegate...
protocol GuestFormDelegate: class {
    func addOrUpdate_PassengersSending(Reload: Bool)
}

class GuestFormVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var mainTitle_lbl: UILabel!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_international: UIView!
    @IBOutlet weak var hei_internationalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titlesMain_View: UIView!
    @IBOutlet weak var firstName_TF: UITextField!
    @IBOutlet weak var lastName_TF: UITextField!
    @IBOutlet weak var DOB_TF: UITextField!
    
    @IBOutlet weak var passportNo_TF: UITextField!
    @IBOutlet weak var issuedCountry_TF: UITextField!
    @IBOutlet weak var DOE_TF: UITextField!
    
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    // date pickers...
    @IBOutlet weak var datePicker_MainView: UIView!
    @IBOutlet weak var datePicker_View: UIDatePicker!
    
    let isDomestic = true
    var title_value = "1"
    var gender_value = "1"
    
    // MARK:- Variables
    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = [:]
    var defaultColor = UIColor.blue
    var delegate: GuestFormDelegate?
    var editIndex = -1
    var title_name = "Mr"
    var dateTags = 0
    
    // passing elements
    var passengerModel: DHPassengerItem?
    var formType = PFormType.Adult
    enum PFormType {
        case Adult
        case Child
        case Infant
    }
    var iso_code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bottom shadow...
        view_header.viewShadow()
        // initlazation...
        defaultColor = btn_save.backgroundColor!
        addTextFieldDelegate()
        addingMainTitle()
        
        // coming from edit...
        btn_delete.isHidden = true
        if editIndex != -1 {
            
            btn_delete.isHidden = false
            setTravellerEditingInfo()
        }
        
        // domestic...
        hei_internationalConstraint.constant = 0
        view_international.isHidden = true
        
        if !isDomestic {
            getISOCodeList()
            hei_internationalConstraint.constant = 150
            view_international.isHidden = false
        }
    }
    
    // MARK:- Helper
    func getISOCodeList() {
        
        // getting country codes...
        countryISO_Dict = VKDialCodes.shared.current_dialCode
        displayDialCode(dailCode: countryISO_Dict)
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    
    func getTitleGenderValue() {
        
        if title_name == "Mr" {
            title_value = "1"
            gender_value = "1"
        }
        else if title_name == "Ms" {
            title_value = "2"
            gender_value = "2"
        }
        else if title_name == "Miss" {
            title_value = "3"
            gender_value = "2"
        }
        else if title_name == " Master " {
            title_value = "4"
            gender_value = "1"
        }
        else if title_name == "Mrs" {
            title_value = "5"
            gender_value = "2"
        }
        else if title_name == "Mstr" {
            title_value = "6"
            gender_value = "1"
        }
        else {}
    }
    
    func displayDialCode(dailCode: [String: String]) {
        self.issuedCountry_TF.text = "\(String(describing: dailCode["Country"]!))"
    }
    
    func addTextFieldDelegate() {
        
        // delegate...
        firstName_TF.delegate = self
        lastName_TF.delegate = self
        passportNo_TF.delegate = self
        issuedCountry_TF.delegate = self
    }
    
    func addPassengerInfo() {
        
        getTitleGenderValue()
        var model = DHPassengerItem.init()
        model.title_value = title_value
        model.gender_value = gender_value
        model.title_name = title_name
        model.first_name = firstName_TF.text
        model.last_name = lastName_TF.text
        model.dateOf_birth = DOB_TF.text
        
        if !isDomestic {
            
            //            model.passport_no = passportNo_TF.text
            //            model.issued_country = issuedCountry_TF.text
            //            model.passport_expiry = DOE_TF.text
        }
        
        if formType == .Child {
            
            model.person_type = "Child"
            DHPassengerModel.childArray.append(model)
            
        } else {
            DHPassengerModel.adultArray.append(model)
        }
    }
    
    func updatePassengerForm(index: Int) {
        
        if formType == .Child {
            
            var model = DHPassengerModel.childArray[index]
            model.title_name = title_name
            model.first_name = firstName_TF.text
            model.last_name = lastName_TF.text
            model.dateOf_birth = DOB_TF.text
            model.person_type = "Child"
            if !isDomestic {
                
                //                model.passport_no = passportNo_TF.text
                //                model.issued_country = issuedCountry_TF.text
                //                model.passport_expiry = DOE_TF.text
            }
            
            DHPassengerModel.childArray[index] = model
        } else {
            
            var model = DHPassengerModel.adultArray[index]
            model.title_name = title_name
            model.first_name = firstName_TF.text
            model.last_name = lastName_TF.text
            model.dateOf_birth = DOB_TF.text
            model.person_type = "Adult"
            
            if !isDomestic {
                //                model.passport_no = passportNo_TF.text
                //                model.issued_country = issuedCountry_TF.text
                //                model.passport_expiry = DOE_TF.text
            }
            
            DHPassengerModel.adultArray[index] = model
        }
    }
    func deletePassengerInfo(index: Int) {
        
        if formType == .Child {
            DHPassengerModel.childArray.remove(at: index)
        } else {
            DHPassengerModel.adultArray.remove(at: index)
        }
        
        self.delegate?.addOrUpdate_PassengersSending(Reload: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTravellerEditingInfo()  {
        
        // main title...
        if formType == .Adult {
            passengerModel = DHPassengerModel.adultArray[editIndex]
        }
        else if formType == .Child {
            passengerModel = DHPassengerModel.childArray[editIndex]
        }
        else {}
        
        // display informations...
        firstName_TF.text = passengerModel?.first_name
        lastName_TF.text = passengerModel?.last_name
        DOB_TF.text = passengerModel?.dateOf_birth
        //        issuedCountry_TF.text = passengerModel?.issued_country
        //        passportNo_TF.text = passengerModel?.passport_no
        //        DOE_TF.text = passengerModel?.passport_expiry
        //
        //        // ios and title indexs...
        //        iso_code = passengerModel?.issued_country ?? ""
        title_name = passengerModel?.title_name ?? "Mr"
        title_value = passengerModel?.title_value ?? "1"
        gender_value = passengerModel?.gender_value ?? "1"
        titlesSelectionColor()
    }
    
    func passengerFormValidaiton() {
        
        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        if firstName_TF.text?.count == 0 || firstName_TF.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter first name"
        }
        else if (firstName_TF.text?.count)! == 0 {
            messageStr = "First name minimum 1 characters length"
        }
        else if lastName_TF.text?.count == 0 || lastName_TF.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter last name"
        }
        else if (lastName_TF.text?.count)! == 0  {
            messageStr = "Last name minimum 1 characters length"
        }
        else if DOB_TF.text?.count == 0 || DOB_TF.text?.trimmingCharacters(in: whitespace).count == 0   {
            messageStr = "Please select date of birth"
        }
        else{}
        
        if !isDomestic && messageStr.count == 0 {
            
            if (issuedCountry_TF.text?.count == 0 || issuedCountry_TF.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter nationality" //passport issued country/
            }
            else if (passportNo_TF.text?.count == 0 || passportNo_TF.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter passport number"
            }
            else if (DOE_TF.text?.count == 0 || DOE_TF.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please select date of expiry"
            }
            else {}
        }
        
        // validation...
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            
            if editIndex != -1  {
                updatePassengerForm(index: editIndex)
                self.delegate?.addOrUpdate_PassengersSending(Reload: true)
                self.navigationController?.popViewController(animated: true)
                
            } else {
                self.addPassengerInfo()
                self.delegate?.addOrUpdate_PassengersSending(Reload: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.view.isUserInteractionEnabled = true
    }
    
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        
        // delete alert...
        let deleteAlert = UIAlertController.init(title: "Alert!",
                                                 message: String.init(format: "Do you want delete %@", (passengerModel?.first_name)!),
                                                 preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Proceed", style: .default, handler: { (action:UIAlertAction) in
            
            // delete passenger...
            self.deletePassengerInfo(index: self.editIndex)
        })
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func titlesButtonsClicked(_ sender: UIButton) {
        title_name = sender.currentTitle!
        titlesSelectionColor()
    }
    
    @IBAction func issuingCountryButtonClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    @IBAction func dateOfBirthAndExpireDatesButtonsClicked(_ sender: UIButton) {
        
        dateTags = sender.tag
        if sender.tag == 10 {
            
            if formType == .Adult {
                datePicker_View.maximumDate = gettingMinMaxDates(maxBool: true)
                datePicker_View.minimumDate = gettingMinMaxDates(maxBool: false)
            }
            else if formType == .Child {
                datePicker_View.maximumDate = gettingMinMaxDates(maxBool: true)
                datePicker_View.minimumDate = gettingMinMaxDates(maxBool: false)
            }
            else  {
                datePicker_View.maximumDate = NSDate() as Date
                datePicker_View.minimumDate = gettingMinMaxDates(maxBool: false)
            }
        }
        else {
            datePicker_View.maximumDate = nil
            datePicker_View.minimumDate = NSDate() as Date
        }
        dismissKeyboardMethod()
        self.datePicker_MainView.isHidden = false
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        passengerFormValidaiton()
    }
    
    // MARK:- PickerButtons
    @IBAction func hiddenDatePicker_ButtonClicked(_ sender: UIButton) {
        self.datePicker_MainView.isHidden = true
    }
    
    @IBAction func pickerCancelAndDone_ButtonClicked(_ sender: UIButton) {
        
        // done button aciton
        if sender.tag == 11 {
            
            if dateTags == 10 {
                DOB_TF.text = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                          date: self.datePicker_View.date)
            } else {
                DOE_TF.text = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                          date: self.datePicker_View.date)
            }
        }
        self.datePicker_MainView.isHidden = true
    }
}

extension GuestFormVC: searchCitiesDelegate {
    
    // MARK:- Utilities
    func addingMainTitle() {
        
        // Main Titles...
        if formType == .Adult {
            
            mainTitle_lbl.text = "Add Adult"
            if editIndex != -1 {
                mainTitle_lbl.text = "Update Adult"
            }
        }
        else if formType == .Child {
            
            mainTitle_lbl.text = "Add Child"
            if editIndex != -1 {
                mainTitle_lbl.text = "Update Child"
            }
        }
        else if formType == .Infant {
            
            mainTitle_lbl.text = "Add Infant"
            if editIndex != -1 {
                mainTitle_lbl.text = "Update Infant"
            }
        }
        else {}
        
        
        // replace titels for child and infant...
        if formType != .Adult {
            for childView in titlesMain_View.subviews {
                if childView is UIButton {
                    
                    let btn = childView as! UIButton
                    if btn.tag == 10 {
                        btn.setTitle("Miss", for: .normal)
                    }
                    else if btn.tag == 11 {
                        btn.setTitle("Mstr", for: .normal)
                    }
                    else {
                        btn.isHidden = true
                    }
                }
            }
        }
    }
    
    func titlesSelectionColor() {
        
        // selection color changing...
        for childView in titlesMain_View.subviews {
            if childView is UIButton {
                
                let btn = childView as! UIButton
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(defaultColor, for: .normal)
                
                if btn.currentTitle == title_name {
                    btn.backgroundColor = defaultColor
                    btn.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    }
    
    func gettingMinMaxDates(maxBool: Bool) -> Date! {
        
        var dateComponent = DateComponents()
        if formType == .Adult {
            
            if maxBool == true {
                dateComponent.year = -12
            } else {
                dateComponent.year = -100
            }
        }
        else if formType == .Child {
            
            if maxBool == true {
                dateComponent.year = -2
            } else {
                dateComponent.year = -12
            }
        }
        else {
            dateComponent.year = -2
        }
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        return futureDate
    }
    
    // MARK:- searchCitiesDelegate
    func searchCountry_info(countryInfo: [String : String]) {
        
        iso_code = countryInfo["iso"]!
        self.issuedCountry_TF.text = countryInfo["name"]
    }
}

extension GuestFormVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboardMethod() {
        
        // resigns...
        firstName_TF.resignFirstResponder()
        lastName_TF.resignFirstResponder()
        issuedCountry_TF.resignFirstResponder()
        passportNo_TF.resignFirstResponder()
    }
}

extension GuestFormVC: ISOCodeDelegate {
    
    // MARK:- ISOCodeDelegate
    func countryISOCode(dial_code: [String : String]) {
        
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
}
