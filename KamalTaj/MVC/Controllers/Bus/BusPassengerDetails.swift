//
//  BusPassengerDetails.swift
//  EasiTripBooking
//
//  Created by Admin on 18/11/25.
//

import UIKit


struct PassengerInfo {
    static var passenger_type :[Int : String] = [:]
    static var nameTitle :[Int : String] = [:]
    static var firstName :[Int : String] = [:]
    static var lastName : [Int : String] = [:]
    static var age : [Int : String] = [:]
    static var email: String = ""
    static var mobileNumber : String = ""
//    var w : [String] = []
    static func removeAllDetails(){
        PassengerInfo.passenger_type.removeAll()
        PassengerInfo.nameTitle.removeAll()
        PassengerInfo.firstName.removeAll()
        PassengerInfo.age.removeAll()
        PassengerInfo.lastName.removeAll()
        PassengerInfo.email.removeAll()
        PassengerInfo.mobileNumber.removeAll()
    }
}

class BusPassengerDetails: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isoCode: UITextField!
    @IBOutlet weak var tf_mobileNumber: UITextField!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var btn_applyPromo: UIButton!
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    @IBOutlet weak var txt_promo: UITextField!

    @IBOutlet weak var lbl_seatsNo: UILabel!
    @IBOutlet weak var lbl_boardingPoint: UILabel!
    @IBOutlet weak var lbl_dropingPoint: UILabel!

    @IBOutlet weak var tbl_traveller: UITableView!
    @IBOutlet weak var tbl_travHight: NSLayoutConstraint!

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_totalSeats: UILabel!
    
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var lbl_convenience_fee: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_finalFare : UILabel!
    

    var view_PromoCodeView: ToursPackageView?
    var selectedPromo: DCommonTopOfferItems?
    var countryISO_Dict: [String: String] = ["DialCode": "+61",
                                             "Country": "Australia",
                                             "ISOCode": "AU"]
    var countries_array: [[String: String]] = []
    var selectedIndexPath : IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bottom shadow...
        view_header.viewShadow()
        
        apiBooking()
        addFrameAddView()
        displayInfo()
        addDelegate()
        getISOCodeList()
        showUserDefaults()
        DBusResultModel.bus_discount = 0.0
        PassengerInfo.removeAllDetails()
        
        for i in 0..<DBusResultModel.bus_Selected_Seats_list.count {
            PassengerInfo.nameTitle[i] = "Mr"
            PassengerInfo.passenger_type[i] = "Male"
        }  

        // Do any additional setup after loading the view.
    }
    
    func displayInfo() {
        
        let seatNumbers = DBusResultModel.bus_Selected_Seats_list.map{String($0!.seatIndex) + "(\($0!.seatName ))"}
        lbl_seatsNo.text = seatNumbers.joined(separator: ", ")

        lbl_boardingPoint.text = DBusResultModel.selected_boarding.name
        lbl_dropingPoint.text = DBusResultModel.selected_dropOff.name
        
        lbl_totalSeats.text =  "Total Seats \(DBusResultModel.bus_Selected_Seats_list.count)"
        
        displayBookingPriceInfo()
    }
    
    func displayBookingPriceInfo() {
        
        let curreny_symbol = DCurrencyModel.currency_saved?.currency_symbol ?? "AUD"
        
        self.lbl_baseFare.text = String(format: "%@ %.2f", curreny_symbol, DBusResultModel.bus_final_total_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        self.lbl_discount.text = String(format: "%@ %.2f", curreny_symbol, DBusResultModel.bus_discount) // * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)
        
        self.lbl_finalFare.text = String(format: "%@ %.2f", curreny_symbol, ((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) - DBusResultModel.bus_discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        self.lbl_taxFare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.gst * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        self.lbl_convenience_fee.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.convenienceFee * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        
        self.lbl_price.text = String(format: "%@ %.2f", curreny_symbol, (((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) - DBusResultModel.bus_discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)) )
    }
    
    
    func showUserDefaults(){
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                self.tf_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.tf_mobileNumber.text = phone
            }
        }

    }
    func addDelegate(){
        tbl_traveller.delegate = self
        tbl_traveller.dataSource = self
        tbl_traveller.rowHeight = UITableView.automaticDimension
        tbl_traveller.estimatedRowHeight = 100
        setTableHeight()
    }
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    func setTableHeight(){
//        tbl_travHight.constant =  CGFloat((DBusResultModel.bus_Selected_Seats_list.count) * 100)//CGFloat((DBlockTripsModel.pre_booking_params?.bookingQuestionsList.count)! * 200)//
//        self.view.isUserInteractionEnabled = false
//        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
        DispatchQueue.main.async {
            self.tbl_travHight.constant = self.calculateTableHeight()
        }
        
    }
   func calculateTableHeight() -> CGFloat  {
        var totalHeight: CGFloat = 0
        
       for section in 0..<tbl_traveller.numberOfSections {
            for row in 0..<tbl_traveller.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                
                if let cell = tbl_traveller.dataSource?.tableView(tbl_traveller, cellForRowAt: indexPath) {
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
//    @objc func tableHeightCalculation() {
//        tbl_travHight.constant = tbl_traveller.contentSize.height
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//            self.view.isUserInteractionEnabled = true
//        }
//        tbl_traveller.reloadData()
//    }
    func getISOCodeList() {
        
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)

        if userProfile is [String: Any] {
            if let code = (userProfile as! [String: Any])["country_code"] as? String {
                
                let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
                countryISO_Dict = VKDialCodes.shared.getDialCode(country_code: "\(trimmedCode.replacingOccurrences(of: "+", with: ""))")
                displayDialCode(dailCode: countryISO_Dict)
            } else {
                displayDialCode(dailCode: countryISO_Dict)
            }
        } else {
            
            displayDialCode(dailCode: countryISO_Dict)
            
        }
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    
    func displayDialCode(dailCode: [String: String]) {
        
//        self.tf_isoCode.text = "\(String(describing: dailCode["Country"] as? String ?? "")) (\(String(describing: dailCode["DialCode"] ?? "")))"
        self.tf_isoCode.text = "\(dailCode["Country"] ?? "") (\(dailCode["DialCode"] ?? ""))"
    }
    @IBAction func selectCountryCode(_ sender: Any) {
        
    }
    @IBAction func selectPromoCodeAction(_ sender: Any) {
        let result = DCommonModel.topOffer_Array.filter{ $0.module == "bus"}
        if result.count == 0 {
            self.view.makeToast(message: "Promo Code Not available")
        } else {
            let filterObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "ApplyPromoCodeVC") as! ApplyPromoCodeVC
            filterObj.modalPresentationStyle = .fullScreen
            filterObj.promoCodeArray = result
            filterObj.promoCodeDelegate = self
            self.present(filterObj, animated: true, completion: nil)
        }
    
    }
    @IBAction func btnCancelPromoAction(_ sender: Any) {
        
        self.btn_selectPromo.isHidden = false
        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
        btn_applyPromo.setTitle("APPLY", for: .normal)
        removePromo()
        self.displayBookingPriceInfo()

    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        DBusResultModel.bus_discount = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func promoBtnClicked(_ sender: Any) {
        aplyPromo()
    }
    func removePromo() {
        DBusResultModel.bus_discount  = 0.0
        self.btn_applyPromo.setTitle("APPLY", for: .normal)
        self.btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        self.txt_promo.text = nil
        self.view.makeToast(message: "Promo Code Not Valid")
        
        self.displayBookingPriceInfo()
    }
    func appliedPromo() {
        
        self.btn_applyPromo.setTitle("APPLIED", for: .normal)
        self.btn_cancelPromo.isHidden = false
        self.btn_selectPromo.isHidden = true
        self.view.makeToast(message: "Promo Code Applied Successfully")
        
        self.displayBookingPriceInfo()
    }
    
    func aplyPromo(){
        if (txt_promo.text?.isEmpty == true) {
            self.view.makeToast(message: "Please select promo code")
        } else {
            SwiftLoader.show(animated: true)

            let userId = ""
            
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"bus","total_amount_val": DBusResultModel.bus_final_total_price,"user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee": DBusResultModel.convenienceFee ,"currency": DCurrencyModel.currency_saved?.currency_country ?? "AUD"]
            
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]

            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")

                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {

                            // response data...
                            let value = Float(result["discount_value"] as! String)
                            if  DBusResultModel.bus_final_total_price <= (self.selectedPromo?.minimum_amount)! || (value! > DBusResultModel.bus_final_total_price) {
                                self.removePromo()

                            }else {
                                DBusResultModel.bus_discount  = Float(result["discount_value"] as! String)!
                                self.appliedPromo()
                            }

                        } else {

                            // error message...
                            if let message_str = result["message"] as? String {
                                self.view.makeToast(message: message_str)
                            }
                        }
                    } else {
                        print("Promo code formate : \(String(describing: resultObj))")
                    }
                }
                SwiftLoader.hide()

            }

        }
    }
    
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview?.superview
        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        fieldRect.size.width = fieldRect.size.width - fieldRect.size.width/2 + 50
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    // MARK: - _MulitTrip validations
    func passengerFormValidation() -> Bool {
        
        // form validations...
        var message = ""
        for i in 0 ..< PassengerInfo.firstName.count {
            
            if PassengerInfo.firstName[i]?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                message = "Please enter first name - \(i + 1)"
                break
            }
            else if !(PassengerInfo.firstName[i]?.range(of: "^[A-Za-z ]+$", options: .regularExpression) != nil) {
                message = "First name should contain only alphabets - \(i + 1)"
                break
            }
            else if PassengerInfo.lastName[i]?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                message = "Please enter last name - \(i + 1)"
                break
            }
            else if !(PassengerInfo.lastName[i]?.range(of: "^[A-Za-z ]+$", options: .regularExpression) != nil) {
                message = "Last name should contain only alphabets - \(i + 1)"
                break
            }
            else if PassengerInfo.age[i]?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                message = "Please enter age - \(i + 1)"
                break
            }
            else if !(PassengerInfo.age[i]?.range(of: "^[0-9]+$", options: .regularExpression) != nil) {
                message = "Age should contain numbers only - \(i + 1)"
                break
            }

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
    
    @IBAction func continueActionButton() {
        
        self.view.isUserInteractionEnabled = false
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        // form validation
        let valid = passengerFormValidation()
        
        if valid == false {
            self.view.isUserInteractionEnabled = true
            return
        }
        
        if PassengerInfo.firstName.count < DBusResultModel.bus_Selected_Seats_list.count {
            messageStr = "Please select name of all traveller"
        } else if PassengerInfo.age.count < DBusResultModel.bus_Selected_Seats_list.count{
            messageStr = "Please select age of all traveller"
        } else if (tf_email.text?.count == 0 || tf_email.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter email id"
        }
        else if !(tf_email.text?.isValidEmailAddress())! {
            messageStr = "Please enter valid email"
        }
        else if (tf_isoCode.text?.count == 0 || tf_isoCode.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please select ISD code"
        }
        else if (tf_mobileNumber.text?.count == 0 || tf_mobileNumber.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter mobile number"
        } else if (!(tf_mobileNumber.text?.isValidPhone())!){
            messageStr = "Please enter valid mobile number"
        }else{}
        if messageStr.count != 0 {
            
            self.view.makeToast(message: messageStr)
        }
        else {
            PassengerInfo.email = tf_email.text!
            // mobile numbers...
//            let mobileNo = String(format: "%@ %@", countryISO_Dict["DialCode"]!, tf_mobileNumber.text!)
//            PassengerInfo.mobileNumber = mobileNo
            let dialCode = countryISO_Dict["DialCode"] ?? "+91"
            PassengerInfo.mobileNumber = "\(dialCode) \(tf_mobileNumber.text ?? "")"
            preApiParams()
        }
        
        self.view.isUserInteractionEnabled = true


    }
    func preApiParams(){


        let user_id = ""
        let params: [String : Any] = [
            "ResultToken" : DBTravelModel.selectdBus.ResultToken ?? "",
            "alternate_contact" : "",
            "billing_email" : PassengerInfo.email,
            "booking_source" : DBusSearchModel.booking_source,
//            "contact_name" : PassengerInfo.firstName.map{$0.1},
            "contact_name": PassengerInfo.firstName.map {
                let index = $0.key
                let first = PassengerInfo.firstName[index] ?? ""
                let last = PassengerInfo.lastName[index] ?? ""
                return "\(first) \(last)".trimmingCharacters(in: .whitespaces)
            },
            "age": PassengerInfo.age.map{$0.1},
            "gender" : PassengerInfo.passenger_type.map{$0.1},
            "op" : "book_bus",//
            "passenger_contact" : tf_mobileNumber.text ?? "",//
            "pax_title" : PassengerInfo.nameTitle.map{$0.1},//
            "payment_method" : "PNHB1",//
            "search_id" : DBusSearchModel.search_id ?? "",//
            "tc" : "on",//
            "token" : VKAPIs.getJSONString(object: createToken()),
            "payment_type" : "EBS",//
            "customer_id" : user_id.getUserId(),
            "promo_code" : selectedPromo?.promoCode ?? "",
            "promo_code_discount_val" : String(DBusResultModel.bus_discount),
        ]
        
        navigateToReview(params: params)
        
 
    }
    func createToken() -> [String: Any] {
                let dict : [String: Any] = [
            "RouteScheduleId" : DBusResultModel.selectedBus?.RouteScheduleId! ?? "",//
            "JourneyDate" : DBusResultModel.selectedBus?.DeptTime ?? "",//
            "PickUpID" : DBusResultModel.selected_boarding.code,//
            "RouteCode": DBusResultModel.selectedBus?.RouteCode ?? "",//
            "CompanyId": DBusResultModel.selectedBus?.CompanyId ?? "",//
            "DropID" : DBusResultModel.selected_dropOff.code ,//
            "DepartureTime" : DBusResultModel.selectedBus?.DeptTime ?? "",//
            "ArrivalTime" : DBusResultModel.selectedBus?.ArrTime ?? "",//
            "departure_from" : DBusResultModel.selectedBus?.From ?? "",//
            "arrival_to" : DBusResultModel.selectedBus?.To ?? "",//
            "Form_id" : DBTravelModel.sourceCity["id"] ?? "",//
            "To_id" : DBTravelModel.destinationCity["id"] ?? "",//
            "boarding_from" : "\(DBusResultModel.selected_boarding.name ?? ""), Address : \(DBusResultModel.selected_boarding.address ?? ""), Landmark : \(DBusResultModel.selected_boarding.landmark ?? ""), Phone : \(DBusResultModel.selected_boarding.contact ?? "")",//
            "dropping_to" : DBusResultModel.selected_dropOff.name ?? "",//
            "bus_type" : DBusResultModel.selectedBus?.BusTypeName ?? "",//
            "operator" : DBusResultModel.selectedBus?.CompanyName ?? "",//
            "CommAmount" : String(DBusResultModel.selectedBus?.CommAmount ?? 0.0) as CVarArg,//
            //"CancPolicy" : DBusResultModel.selectedBus?.canc as Any,
            "seat_attr" : DBusResultModel.busSeatAttributDetails//
        ]
            return dict
    }
    func navigateToReview(params: [String : Any]){
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusReviewVC") as! BusReviewVC
        vc.params = params
        navigationController?.pushViewController(vc, animated: true)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension BusPassengerDetails : PromoCodeDelegate, ISOCodeDelegate, AddTravellerCellDelegate /*TravellerTitleCellDelegate*/ {
    func textFieldDidChange(textField: UITextField, cell: UITableViewCell) {
        // main actions...
        let loCell = cell as! AddTravellerCell
        let indexPath = tbl_traveller?.indexPath(for: cell)
        
        if textField == loCell.tf_firstName {
            PassengerInfo.firstName[(indexPath?.row)!] = textField.text
        }
        else if textField == loCell.tf_lastName {
            PassengerInfo.lastName[(indexPath?.row)!] = textField.text
        } else if textField == loCell.tf_age {
            PassengerInfo.age[(indexPath?.row)!] = textField.text
        }
        
        else {}
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
        let ageCharacterSet = CharacterSet.decimalDigits

        if textField.tag == 0 || textField.tag >= 0 {

            // First Name & Last Name
            if textField == (textField.superview?.superview?.superview as? AddTravellerCell)?.tf_firstName ||
                textField == (textField.superview?.superview?.superview as? AddTravellerCell)?.tf_lastName {

                return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
            }

            // Age
            if textField == (textField.superview?.superview?.superview as? AddTravellerCell)?.tf_age {

                return string.rangeOfCharacter(from: ageCharacterSet.inverted) == nil
            }
        }

        return true
    }
    func didTapReturn(textField: UITextField, cell: UITableViewCell) {
        
    }
        
        func firstNameTextField(sender: UITextField, cell: UITableViewCell) {
            
            let indexPath =  tbl_traveller.indexPath(for: cell)
            PassengerInfo.firstName[indexPath!.row] = sender.text!
        }
        
        func lastNameTextField(sender: UITextField, cell: UITableViewCell) {
            let indexPath = tbl_traveller.indexPath(for: cell)
            PassengerInfo.lastName[indexPath!.row] = sender.text
        }
        
        func countryISOCode(dial_code: [String : String]) {
            tf_isoCode.text = "\(String(describing: dial_code["Country"]!)) (\(String(describing: dial_code["DialCode"]!)))"
            countryISO_Dict = dial_code
            displayDialCode(dailCode: dial_code)
        }
        
        func selectedPromoCode(promoCode: DCommonTopOfferItems) {
            selectedPromo = promoCode
            txt_promo.text = selectedPromo?.promoCode
        }
}

extension BusPassengerDetails : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return DBusResultModel.bus_Selected_Seats_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddTravellerCell") as? AddTravellerCell
            if cell == nil {
                tableView.register(UINib.init(nibName: "AddTravellerCell", bundle: nil), forCellReuseIdentifier: "AddTravellerCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "AddTravellerCell") as? AddTravellerCell
            }
        cell?.tf_firstName.delegate = self
        cell?.tf_lastName.delegate = self
        cell?.tf_age.delegate = self
        
        cell?.tf_firstName.keyboardType = .default
        cell?.tf_lastName.keyboardType = .default
        cell?.tf_age.keyboardType = .numberPad
        
        cell?.tf_firstName.tag = indexPath.row
        cell?.tf_lastName.tag = indexPath.row
        cell?.tf_age.tag = indexPath.row
        cell?.lbl_travellerSeat.text = "Seat \(DBusResultModel.bus_Selected_Seats_list[indexPath.row]?.seatName ?? "" )"
        cell?.delegate = self
        let titles = ["Mr", "Mrs", "Ms"]
        

        cell?.configure(with: titles, selected: PassengerInfo.nameTitle[indexPath.row])
        cell?.onTitleChanged = { [weak self] title_name in
            
            PassengerInfo.nameTitle[indexPath.row] = title_name
            if title_name == "Mr" || title_name == "Master" || title_name == "" {
                PassengerInfo.passenger_type[indexPath.row] = "Male"
            } else {
                PassengerInfo.passenger_type[indexPath.row] = "Female"
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
extension BusPassengerDetails {
    
    func apiBooking(){

        let seats = DBusResultModel.bus_Selected_Seats_list.map{"\($0!.seatIndex)"} //seatName
            SwiftLoader.show(animated: true)

        let params : [String : Any] = [
            "route_schedule_id": DBTravelModel.selectdBus.RouteScheduleId ?? "",
            "journey_date": DBTravelModel.selectdBus.DeptTime ?? "",
            "pickup_id": "1",
            "ResultToken": DBTravelModel.selectdBus.ResultToken ?? "",
            "drop_id":"1" ,
            "seat": seats ,
            "booking_source": DBusSearchModel.booking_source,
            "token": DBusSeatModel.token  ?? ""]

            var paramString: [String: String] = ["booking": VKAPIs.getJSONString(object: params)]
            paramString["search_id"] = DBusSearchModel.search_id ?? ""
            VKAPIs.shared.getNewRequestXwwwform(params: paramString, file: "bus/booking", httpMethod: .POST)
            { (resultObj, success, error) in

                // success status...
                if success == true {
                    print("Booking booking success: \(String(describing: resultObj))")

                    if let result = resultObj as? [String: Any] {
                        if let total_fare = result["total_fare"] as? Double {
                            DBusResultModel.bus_final_total_price = Float(total_fare)
                        }
                        if let conv = result["convenience_fees"] as? Double {
                            DBusResultModel.convenienceFee = Float(conv)
                        }
                        
                        if let conv = result["convenience_fees"] as? String {
                            DBusResultModel.convenienceFee = Float(Double(conv) ?? 0.0)
                        }
                        
                        if let gst = result["gst_value"] as? Float {
                            DBusResultModel.gst = gst
                        }
                        
//                        if let paymentOptions = result["active_payment_options"] as? [String] {
//                            DBusResultModel.activePaymentOptions = paymentOptions
//                        } else if let paymentOptions = result["active_payment_options"] as? NSArray {
//                            DBusResultModel.activePaymentOptions = paymentOptions as? [String] ?? ["PNHB1"]
//                        } else {
//                            DBusResultModel.activePaymentOptions = ["PNHB1"]
//                        }
                        if let paymentOptions = result["active_payment_options"] as? [[String: Any]] {
                            
                            DBusResultModel.activePaymentOptions = paymentOptions.map {
                                PaymentOption(
                                    name: $0["name"] as? String ?? "",
                                    method: $0["method"] as? String ?? "",
                                    imgurl: $0["imgurl"] as? String ?? ""
                                )
                            }
                            
                        } else {
                            
                            DBusResultModel.activePaymentOptions = [
                                PaymentOption(
                                    name: "Razorpay",
                                    method: "PNHB1",
                                    imgurl: ""
                                )
                            ]
                        }
                    } else {
                        print("Booking booking formate : \(String(describing: resultObj))")
                    }
                } else {
                    print("Booking booking error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                    self.navigationController?.popViewController(animated: true)
                }

                // getting rooms list...

                self.displayInfo()
                SwiftLoader.hide()
            }
    }
}
