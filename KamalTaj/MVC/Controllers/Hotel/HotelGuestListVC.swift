//
//  HotelGuestListVC.swift
//  Dreamora
//
//  Created by Rahul on 04/08/25.
//

import UIKit

class HotelGuestListVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    //GuestDetails
    @IBOutlet weak var tblGuests : UITableView!
    @IBOutlet weak var heiTblConstraint : NSLayoutConstraint!
    // Contact detail
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    //guest count
    
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    var isTerms = false

    
    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = ["DialCode": "+91",
                                             "Country": "India",
                                             "ISOCode": "IN"]
    var fieldTags = 0
    var selectedIndex = 0
    var sel_date = Date()
    var promocode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.viewShadow()
        showGuestCount()
        createPassenger_Form()

        addDelegates()
        displayUserProfile()
        // Do any additional setup after loading the view.
    }
    
    func showGuestCount (){
        // selected passenger counts...
        lbl_adultCount.text = "AD \(DHTravelModel.adult_count)"
        lbl_childCount.text = "CH \(DHTravelModel.child_count)"

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
    @IBAction func termsBtnClicked(_ sender: Any) {
        
        // move to about us....
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
        vc.isRegisterScreen = true
        vc.isFrom = .Terms
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func createPassenger_Form() {
        
        DHPassengerModel.allGuestsArray.removeAll()
        
        // adding passengers list
        for i in 0 ..< DHTravelModel.adult_count {
            
            var model = DHPassengerItem.init()
            model.title_form = String.init(format: "Adult %d", i + 1)
            model.title_name = "Mr"
            DHPassengerModel.allGuestsArray.append(model)
        }
        
        for j in 0 ..< DHTravelModel.child_count {
            
            var model = DHPassengerItem.init()
            model.title_form = String.init(format: "Child %d", j + 1)
            model.person_type = "Child"
            model.title_name = "Mstr"
            DHPassengerModel.allGuestsArray.append(model)
        }
        
        tblGuests.reloadData()
        // Wait for reload and calculate real height
        DispatchQueue.main.async {
            self.heiTblConstraint.constant = self.calculateTableHeight()
        }
    }
    func addDelegates(){
        tf_email.delegate = self
        tf_mobileNo.delegate = self
        
        tblGuests.delegate = self
        tblGuests.dataSource = self
        tblGuests.rowHeight = UITableView.automaticDimension;
        tblGuests.estimatedRowHeight = 610
    }
    func displayUserProfile(){
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                self.tf_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.tf_mobileNo.text = phone
            }
        }
        getISOCodeList()
        
    }
    //MARK: - Helper
    func getISOCodeList() {
        
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        
        if userProfile is [String: Any] {
            if let code = (userProfile as! [String: Any])["country_code"] as? String {
                
                let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "+", with: "")
                
                countryISO_Dict = VKDialCodes.shared.getDialCode(country_code: "\(trimmedCode)")
                
            } else {
                
            }
        } else {
            // countryISO_Dict = VKDialCodes.shared.current_dialCode
            // displayDialCode(dailCode: countryISO_Dict)
            
        }
        
        // getting country codes...
        displayDialCode(dailCode: countryISO_Dict)
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    func displayDialCode(dailCode: [String: String]) {
        print(dailCode)
        self.tf_isdCode.text = "\(String(describing: dailCode["Country"] ?? "India")) (\(String(describing: dailCode["DialCode"] ?? "")))"
    }
    func calculateTableHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        for section in 0..<tblGuests.numberOfSections {
            for row in 0..<tblGuests.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                
                if let cell = tblGuests.dataSource?.tableView(tblGuests, cellForRowAt: indexPath) {
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                    
                    // Calculate actual height
                    let height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                    totalHeight += height
                }
            }
        }
        
        return totalHeight
    }
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        
        let nextObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ISOCodeVC") as! ISOCodeVC
        nextObj.delegate = self
        nextObj.DCatType = .ISOCode
        nextObj.countries_array = countries_array
        self.present(nextObj, animated: true, completion: nil)
        
    }
    @IBAction func btnBookClicked(_ sender: UIButton) {
//        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        let valid = passengerFormValidation()
        if valid {
            if (tf_email.text?.count == 0 || tf_email.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter email id"
            }
            else if !(tf_email.text?.isValidEmailAddress())! {
                messageStr = "Please enter valid email"
            }
            else if (tf_isdCode.text?.count == 0 || tf_isdCode.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please select ISD code"
            }
            else if (tf_mobileNo.text?.count == 0 || tf_mobileNo.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter mobile number"
            }else if !((tf_mobileNo.text?.isValidPhone())!) {
                messageStr = "Please enter mobile number"
            }
            else if !isTerms {
                messageStr = "Please accept Terms & Conditions"
            }
            else {
            }
            
            // validation...
            if messageStr.count != 0 {
                //self.view.makeToast(message: messageStr)
                
                // alert...
                let alertContorller = UIAlertController.init(title: "Alert!", message: messageStr, preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
                })
                alertContorller.addAction(okAction)
                self.present(alertContorller, animated: true, completion: nil)
            }
            else {
                
                // mobile numbers...
                DHPassengerModel.email_id = tf_email.text!
                DHPassengerModel.mobile_no = tf_mobileNo.text!
                DHPassengerModel.country_code = countryISO_Dict
                hotelPreBooking_HTTPConnection()
            }
        }
        
    }
    func passengerFormValidation() -> Bool {
        
        // form validations...
        var message = ""
        for i in 0 ..< DHPassengerModel.allGuestsArray.count {
            if (DHPassengerModel.allGuestsArray[i].title_name)!.isEmpty && DHPassengerModel.allGuestsArray[i].person_type == "Adult" {
                message = "Please select title \(DHPassengerModel.allGuestsArray[i].title_form)" // - \(i + 1)
                break
            }
            else if (DHPassengerModel.allGuestsArray[i].first_name ?? "").isEmpty {
                message = "Please enter first name \(DHPassengerModel.allGuestsArray[i].title_form)"
                break
            }
            else if !((DHPassengerModel.allGuestsArray[i].first_name ?? "").isValidName()) {
                message = "Please enter valid first name \(DHPassengerModel.allGuestsArray[i].title_form)"
                break
            }
            else if (DHPassengerModel.allGuestsArray[i].last_name ?? "").isEmpty {
                message = "Please enter last name \(DHPassengerModel.allGuestsArray[i].title_form)"
                break
            }
            else if !((DHPassengerModel.allGuestsArray[i].last_name ?? "").isValidName()) {
                message = "Please enter valid Last name \(DHPassengerModel.allGuestsArray[i].title_form)"
                break
            }
           
//            else if (DHPassengerModel.allGuestsArray[i].dateOf_birth ?? "").isEmpty {
//                message = "Please select date of birth \(DHPassengerModel.allGuestsArray[i].title_form)"
//                break
//            }
           
            else {}
        }
        
        // alert if anyone not fileds...
        if message.count != 0 {
            self.view.makeToast(message: message)
            return false
        }
        else {
            return true
        }
    }
}
extension HotelGuestListVC: UITableViewDataSource, UITableViewDelegate, guestFormCellDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DHPassengerModel.allGuestsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HotelGuestTVCell") as? HotelGuestTVCell
        if cell == nil {
            tableView.register(UINib(nibName: "HotelGuestTVCell", bundle: nil), forCellReuseIdentifier: "HotelGuestTVCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HotelGuestTVCell") as? HotelGuestTVCell
        }
        
        // display information...
        cell?.txtFirstName.delegate = self
        cell?.txtLastName.delegate = self
//        cell?.txtDob.delegate = self
        
        cell?.txtFirstName.tag = indexPath.row
        cell?.txtLastName.tag = indexPath.row
//        cell?.txtDob.tag = indexPath.row
        
        cell?.lblPaxType.text = String.init(format: "%@", DHPassengerModel.allGuestsArray[indexPath.row].title_form)
        cell?.displayGuest_information(model: DHPassengerModel.allGuestsArray[indexPath.row])
        
        cell?.delegate = self
        let passenger = DHPassengerModel.allGuestsArray[indexPath.row]
        let titles = passenger.person_type == "Adult" ? ["Mr", "Mrs", "Ms"] : ["Mstr","Miss"]

        cell?.configure(with: titles, selected: passenger.title_name)
        cell?.onTitleChanged = { [weak self] title_name in
            DHPassengerModel.allGuestsArray[indexPath.row].title_name = title_name
        }

        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - passengerFormCellDelegate
    
    
    
    
    
    
    func dobButton_Action(sender: UIButton, cell: UITableViewCell) {
        self.view.endEditing(true)
        
        let indexPath = tblGuests?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        
        let model = DHPassengerModel.allGuestsArray[selectedIndex]
        let passType = model.person_type
        
        fieldTags = 10
        
        // date pop view...
        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
        picker_popView.delegate = self
        picker_popView.setDate(_date: sel_date)
        
        picker_popView.setMinimumDate(_date: gettingMinMaxDates(maxBool: false, pass_type: passType))
        picker_popView.setMaximumDate(_date: gettingMinMaxDates(maxBool: true, pass_type: passType))
        
        self.view.addSubview(picker_popView)
    }
    
    
    
    
    func textFieldDidChange(textField: UITextField, cell: UITableViewCell) {
        
        // main actions...
        let loCell = cell as! HotelGuestTVCell
        let indexPath = tblGuests?.indexPath(for: cell)
        
        if textField == loCell.txtFirstName {
            DHPassengerModel.allGuestsArray[(indexPath?.row)!].first_name = textField.text
        }
        else if textField == loCell.txtLastName {
            DHPassengerModel.allGuestsArray[(indexPath?.row)!].last_name = textField.text
        }
        
        
        else {}
    }
    
    func didTapReturn(textField: UITextField, cell: UITableViewCell) {
        
        print("MoveToNext")
        let guestCell = cell as! HotelGuestTVCell

        if textField == guestCell.txtFirstName {
            guestCell.txtLastName.becomeFirstResponder()
        }
        else if textField == guestCell.txtLastName {
            guestCell.txtDob.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
    
    func gettingMinMaxDates(maxBool: Bool, pass_type: String) -> Date! {
        
        var dateComponent = DateComponents()
        if pass_type == "Adult" {
            
            if maxBool == true {
                dateComponent.year = -12
            } else {
                dateComponent.year = -100
            }
        }
        else if pass_type == "Child" {
            
            if maxBool == true {
                dateComponent.year = -2
            } else {
                dateComponent.year = -11
            }
        }
        
        else {
            dateComponent.year = -2
        }
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: DHTravelModel.checkin_date)
        return futureDate
    }
    
}
extension HotelGuestListVC :UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == (textField.superview as? HotelGuestTVCell)?.txtFirstName ||
//           textField == (textField.superview as? HotelGuestTVCell)?.txtLastName {
//
//            // Allow backspace
//            if string.isEmpty { return true }
//            if string.isValidName() == false {
//                return false
//            }
//            // Allow only alphabets and space
//            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
//            return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
//        }
//        
//                if textField == tf_mobileNo  {
//        
//                    if string.isValidIntergerSet() == false {
//                        return false
//                    }
//                    let currentCharacterCount = textField.text?.count ?? 0
//                    if range.length + range.location > currentCharacterCount {
//                        return false
//                    }
//                    let newLength = currentCharacterCount + string.count - range.length
//                    return newLength <= 15
//                }
//        
//        
//        return true
//    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow backspace
        if string.isEmpty { return true }

        // Get cell safely
        guard let cell = textField.findSuperview(ofType: HotelGuestTVCell.self) else {
            return true
        }

        // 👤 First & Last Name — Alphabets + Space ONLY
        if textField == cell.txtFirstName || textField == cell.txtLastName {

            let allowedSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedSet.inverted) == nil
        }

        // 📞 Mobile Number — Digits only
        if textField == tf_mobileNo {

            if string.isValidIntergerSet() == false {
                return false
            }

            let currentCount = textField.text?.count ?? 0
            let newLength = currentCount + string.count - range.length
            return newLength <= 15
        }

        return true
    }
    func dismissKeyboardMethod() {
        // resigns...
//                tf_email.resignFirstResponder()
//                tf_mobileNo.resignFirstResponder()
//                tf_isdCode.resignFirstResponder()
    }
}

extension HotelGuestListVC: DPickerPopViewDelegate , countryDailCodeDelegate{
    func countryDailCode(dial_code: [String : String], nationality: [String : Any]) {
        print(dial_code)
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
    func datePickerPopView(_picker: DatePickerPopView, _date: Date) {
        sel_date = _date
        
        var dateStr = ""
        if fieldTags == 10 {
            dateStr = DateFormatter.getDateString(formate: "yyyy-MM-dd",
                                                  date: _date)
            DHPassengerModel.allGuestsArray[selectedIndex].dateOf_birth = dateStr
        }
        
        tblGuests.reloadData()
    }
}
extension HotelGuestListVC {
    func hotelPreBooking_HTTPConnection() {
        
        let user_id = ""
        // params...
        let params:[String: Any] = ["ProvabAuthKey": DHPreBookingModel.preBookingItem?.token_key ?? "",
                                    "Email": DHPassengerModel.email_id ,
                                    "ContactNo": DHPassengerModel.mobile_no ,
                                    "Booking_source": DHPreBookingModel.preBookingItem?.booking_source ?? "",
                                    "AddressLine1": "E-City",
                                    "City": "Bengaluru",
                                    "PinCode": "560100",
                                    "CountryCode": "IN",
                                    "CountryName": "India",
                                    "search_id": String.init(format: "%@", DHotelSearchModel.search_id),
                                    "promo_code": promocode ?? "",
                                    "promo_code_discount_val": String.init(format: "% .2f", FinalBreakupHotelModel.discount),
                                    "final_fare": String.init(format: "% .2f", FinalBreakupHotelModel.totalFare ),
                                    "tax": String.init(format: "% .2f", FinalBreakupHotelModel.gst),
                                    "convenience_fee": String.init(format: "% .2f", FinalBreakupHotelModel.convenienceFare),
                                    "customer_id": user_id.getUserId(),
                                    "payment_method": "PNHB1" /*DHPreBookingModel.preBookingItem?.payment_method ?? ""*/,
                                    "Passengers": getPassengers()]
        
        var paramString:[String: String] = [:]
        
        paramString["hotel_params"] = VKAPIs.getJSONString(object: params)
        paramString["Token"] = DHPreBookingModel.preBookingItem?.token ?? ""
        paramString["Token_key"] = DHPreBookingModel.preBookingItem?.token_key ?? ""
        paramString["wallet_bal"] = "off"
        
        moveToReviewPage(params: paramString)
        
    }
    func getPassengers() -> [Any] {
        
        // adding passenger information...
        var passenger_array: [[String: Any]] = []
        
        for model in DHPassengerModel.allGuestsArray {
            
            var passenger: [String: Any] = [
                "Gender": model.gender_value ?? "1",
                "Pax_Type": "1",
                "Title": model.title_name ?? "Mr",
                "FirstName": model.first_name!,
                "LastName": model.last_name!,
                "DateOfBirth": model.dateOf_birth ?? "",
                "PassportNumber": "",
                "PassportExpiry": "",
                "PassportIssueCountry": "91",
                "selection": "1"
            ]
            
            
            if model.person_type == "Child" {
                passenger["PaxType"] = "2"
            }
            
            if model.person_type == "Infant" {
            }
            passenger_array.append(passenger)
        }
        
        passenger_array[0]["lead_passenger"] = "1"
        
        return passenger_array
    }
    func moveToReviewPage(params: [String: String]) {
        
        // move to next screen...
        let hReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "HotelReviewVC") as! HotelReviewVC
        hReviewVC.paramString = params
        self.navigationController?.pushViewController(hReviewVC, animated: false)

    }
}
