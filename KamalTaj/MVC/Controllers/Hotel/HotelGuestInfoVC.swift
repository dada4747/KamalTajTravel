//
//  HotelGuestInfoVC.swift
//  Hoetus
//
//  Created by Rahul on 16/07/23.
//

import UIKit
class HotelGuestInfoVC: UIViewController{
    
    @IBOutlet weak var lbl_grandFinalTotal: UILabel!
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var view_header: UIView!
    
    // passengers list elements...
    @IBOutlet weak var tbl_adultNames: UITableView!
    @IBOutlet weak var tbl_childNames: UITableView!
    @IBOutlet weak var view_childMain: UIView!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    @IBOutlet weak var txt_promo: UITextField!
    
    @IBOutlet weak var adultMenu_HContraint: NSLayoutConstraint!
    @IBOutlet weak var childMenu_HContraint: NSLayoutConstraint!

    // booking info...
    @IBOutlet weak var lbl_room_guest_count: UILabel!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var lbl_roomType: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_totalAmount: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    @IBOutlet weak var btn_applyPromo: CRButton!
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    @IBOutlet weak var img_hotel: CRImageView!
    @IBOutlet weak var rating_view: FloatRatingView!
    @IBOutlet weak var lbl_numberOfNights: UILabel!
    @IBOutlet weak var lbl_checkInDay: UILabel!
    @IBOutlet weak var lbl_checkInDate: UILabel!
    @IBOutlet weak var lbl_checkInMonth: UILabel!
    @IBOutlet weak var lbl_checkOutDay: UILabel!
    @IBOutlet weak var lbl_checkOutDate: UILabel!
    @IBOutlet weak var lbl_checkOutMonth: UILabel!
    @IBOutlet weak var btn_addChild: UIButton!
    @IBOutlet weak var lbl_roomAndNight: UILabel!
    
    
    //MARK: - Variables

    var view_PromoCodeView: ToursPackageView?
    var selectedPromo: DCommonTopOfferItems?
    var countryISO_Dict: [String: String] = [:]
    var countries_array: [[String: String]] = []
    var termsBool = false
    var adult_count = 0
    var child_count = 0
    var infant_count = 0

    // SSR Variables...
    var isSSR: Bool = false
    var isSSRSeatSelected: Bool = false
    var SSRPaymentDict = [String: Any]()
    var baseConvenienceFare: Float = FinalBreakupHotelModel.convenienceFare

    var isTerms = false
    //    var title_name = "Mr"
    var selectedRoomIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_mobileNo.delegate = self
        
        addFrameAddView()
        view_header.viewShadow()
        // delegates...
        displayInformationAndDelegates()
        reloadTablesAndFrameAdjust()
        btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadTablesAndFrameAdjust()
    }
    
    @IBAction func cancellationPolicy(_ sender: UIButton) {
        var msg = ""
        
        if sender.tag == 11 {
            //            msg = DHClonePreBookingModel.canc_policy.first!
        } else {
//            msg = DHPreBookingModel.cancellationDate
            msg = DHotelDetailsModel.roomsArray[selectedRoomIndex!].cancel_policy!
        }
        guard let attributedString = try? NSAttributedString(data: (msg.data(using: .utf8)!),
                                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil) else {
            return
        }
        
        let alert = UIAlertController(title: "Cancellation Policy", message: nil, preferredStyle: .alert)
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        // Add "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the UIAlertController
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectPromoCodeAction(_ sender: Any) {
        let result = DCommonModel.topOffer_Array.filter{ $0.module == "hotel"}
        print(result)
        if result.count == 0 {
            self.view.makeToast(message: "Promo Code Not available")
        } else {
            let filterObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "ApplyPromoCodeVC") as! ApplyPromoCodeVC
            filterObj.modalPresentationStyle = .fullScreen
            filterObj.promoCodeArray = result
            filterObj.promoCodeDelegate = self
            self.present(filterObj, animated: true, completion: nil)
//            print("text field clicked")
//            print(DCommonModel.topOffer_Array)
//            self.view_PromoCodeView?.packageType = .PromoCodes
//            self.view_PromoCodeView?.promoCodeArray = result //DCommonModel.topOffer_Array.filter{ $0.module == "hotel"}
//            self.view_PromoCodeView?.displayInfo()
//            self.view_PromoCodeView?.promoCodeDelegate = self
//            self.view_PromoCodeView?.isHidden = false
//            UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_PromoCodeView!)
        }
    }
    
    @IBAction func btnCancelPromoAction(_ sender: Any) {
        baseConvenienceFare = FinalBreakupHotelModel.convenienceFare
        self.btn_selectPromo.isHidden = false
        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
//        btn_applyPromo.setTitle("APPLY", for: .normal)
        FinalBreakupHotelModel.discount = 0.0
        self.displayBookingPriceInfo()
        removePromo()
        
    }
    
    
    
    // MARK:- PassengerButtons
    @IBAction func addAdultButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 0, editIndex: -1)
    }
    
    @IBAction func addChildrenButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 1, editIndex: -1)
    }
    
    @IBAction func addInfantButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 2, editIndex: -1)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        FinalBreakupHotelModel.discount = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func promoBtnClicked(_ sender: Any) {
        aplyPromo()
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
    
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        /*print("***************")
        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        // select count based one category...
        var adult_maxCount = 0
        var child_maxCount = 0
        var pet_maxCount = 0
        
        adult_maxCount = DHTravelModel.adult_count
        child_maxCount = DHTravelModel.child_count
        
        
        // validations...
        if ((adult_count == 0 || child_count != 0)) {
            messageStr = "Please select only one adult"
        }
        else 
        
        if (adult_maxCount != adult_count ) {
            messageStr = "Please add all adults"
        }
        else if (child_maxCount != child_count) {
            messageStr = "Please add all children"
        }
        
        else if (tf_email.text?.count == 0 || tf_email.text?.trimmingCharacters(in: whitespace).count == 0) {
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
        }else if (!(tf_mobileNo.text?.isValidPhone())!){
            messageStr = "Please enter mobile number"
        }else if !isTerms {
            messageStr = "Please accept Terms & Conditions"
        }
        else {}
        
        // validation...
        if messageStr.count != 0 {
            
            self.view.makeToast(message: messageStr)
            
        }
        else {
            
            // mobile numbers...
            let mobileNo = String(format: "%@ %@", countryISO_Dict["DialCode"]!, tf_mobileNo.text!)
            DHPassengerModel.email_id = tf_email.text!
            DHPassengerModel.mobile_no = tf_mobileNo.text!
            
            hotelPreBooking_HTTPConnection()
            
        }
        self.view.isUserInteractionEnabled = true
        */
        FinalBreakupHotelModel.convenienceFare = baseConvenienceFare
        let hSearchObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelGuestListVC") as! HotelGuestListVC
        hSearchObj.promocode = txt_promo.text ?? ""
        self.navigationController?.pushViewController(hSearchObj, animated: true)
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
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Helper
    
    
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    
    func displayInformationAndDelegates() {
        
        lbl_room_guest_count.text = "\(AddRoomModel.addRooms_array.count) Rooms, \(DHTravelModel.adult_count + DHTravelModel.child_count) Guests - \(DHTravelModel.adult_count) Adults, \(DHTravelModel.child_count) Child"
        
        lbl_hotelName.text = DHPreBookingModel.hotelName
        lbl_hotelAddress.text = DHPreBookingModel.hotelAddress
        lbl_roomType.text = DHPreBookingModel.roomType
        img_hotel.sd_setImage(with: URL.init(string: DHPreBookingModel.hotelImage.replacingOccurrences(of: " ", with: "%20")))
        rating_view.rating = Double(5)
        let checkIn_date = DHTravelModel.checkin_date
        let checkOut_date = DHTravelModel.checkout_date
        // check-In date, month, year...
        lbl_checkInDay.text = DateFormatter.getDateString(formate: "EEEE", date: checkIn_date)
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "dd", date: checkIn_date)
        lbl_checkInMonth.text = DateFormatter.getDateString(formate: "MMM yy", date: checkIn_date)
        
        // check-Out date, month, year...
        lbl_checkOutDay.text = DateFormatter.getDateString(formate: "EEEE", date: checkOut_date)
        lbl_checkOutDate.text = DateFormatter.getDateString(formate: "dd", date: checkOut_date)
        lbl_checkOutMonth.text = DateFormatter.getDateString(formate: "MMM yy", date: checkOut_date)
        
        let night_no = DateFormatter.getDaysBetweenTwoDates(startDate: checkIn_date, endDate: checkOut_date)
        lbl_numberOfNights.text = "\(night_no) Nights"
        lbl_roomAndNight.text = "\(AddRoomModel.addRooms_array.count) Rooms, \(night_no) Nights"
        getISOCodeList()
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_adultNames.delegate = self
        tbl_adultNames.dataSource = self
        
        tbl_childNames.delegate = self
        tbl_childNames.dataSource = self
        
        // clear selection...
        clearAll_SelectedInfo()
        
        // check user login or not...
        
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                DHPassengerModel.email_id = email_id
                self.tf_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.tf_mobileNo.text = phone
                DHPassengerModel.mobile_no = phone
            }
//             = tf_email.text!
//             tf_mobileNo.text!
            
        }
    }
    
    func getISOCodeList() {
        
        // getting country codes...
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        
        if userProfile is [String: Any] {
            if let code = (userProfile as! [String: Any])["country_code"] as? String {
                countryISO_Dict = VKDialCodes.shared.getDialCode(country_code: "\(code.replacingOccurrences(of: "+", with: ""))")
                displayDialCode(dailCode: countryISO_Dict)
            }
        } else {
            countryISO_Dict = VKDialCodes.shared.current_dialCode
            
            displayDialCode(dailCode: countryISO_Dict)
            
        }
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    
    func displayDialCode(dailCode: [String: String]) {
        
        self.tf_isdCode.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"
    }
    
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_convenienceFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", baseConvenienceFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        // currency and total price...
        lbl_total.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.baseFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_taxFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ((FinalBreakupHotelModel.gst)  *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_totalAmount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ((FinalBreakupHotelModel.totalFare - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_totalFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.gst + baseConvenienceFare) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_discount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.discount  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        
        
        lbl_grandFinalTotal.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare  + baseConvenienceFare ) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_totalFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare  + baseConvenienceFare ) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
    }
    
    func clearAll_SelectedInfo() {
        
        // adult count...
        for i in 0 ..< DHPassengerModel.adultArray.count {
            DHPassengerModel.adultArray[i].isSelected = false
        }
        
        // child count...
        for i in 0 ..< DHPassengerModel.childArray.count {
            DHPassengerModel.childArray[i].isSelected = false
        }
    }
    
    func reloadTablesAndFrameAdjust() {
        
        // reload tables...
        tbl_adultNames.reloadData()
        tbl_childNames.reloadData()
        
        // frames adjust...
        adultMenu_HContraint.constant = CGFloat((DHPassengerModel.adultArray.count * 40) + 80)
        
        childMenu_HContraint.constant = 0
//        childMenu_YConstraint.constant = 0
        btn_addChild.isHidden = true
        
        if DHTravelModel.child_count >= 1 {
            childMenu_HContraint.constant = CGFloat((DHPassengerModel.childArray.count * 40) + 80)
            btn_addChild.isHidden = false
//            childMenu_YConstraint.constant = 16
        }
        displayMaxPassengersCounts()
    }
    
    func displayMaxPassengersCounts() {
        
        // adult count...
        adult_count = 0
        for model in DHPassengerModel.adultArray {
            if model.isSelected == true {
                adult_count = adult_count + 1
            }
        }
        
        // child count...
        child_count = 0
        for model in DHPassengerModel.childArray {
            if model.isSelected == true {
                child_count = child_count + 1
            }
        }
        
        // selected passenger counts...
        lbl_adultCount.text = "AD \(adult_count)/\(DHTravelModel.adult_count)"
        lbl_childCount.text = "CH \(child_count)/\(DHTravelModel.child_count)"
        
    }
    
    func moveToAddPassengerFrom(indexS: Int, editIndex: Int) {
        
        // move to add passenger form...
        let formObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "GuestFormVC") as! GuestFormVC
        formObj.delegate = self
        if indexS == 0 {
            formObj.formType = .Adult
        }
        else if indexS == 1  {
            formObj.formType = .Child
        }
        else {}
        
        // editing...
        if editIndex != -1 {
            formObj.editIndex = editIndex
        }
        self.navigationController?.pushViewController(formObj, animated: true)
    }
    func removePromo() {
        FinalBreakupHotelModel.discount  = 0.0
        baseConvenienceFare = FinalBreakupHotelModel.convenienceFare
        self.btn_applyPromo.setTitle("APPLY", for: .normal)

        self.btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        self.txt_promo.text = nil
        self.displayBookingPriceInfo()
    }
    func appliedPromo() {
        self.btn_applyPromo.setTitle("APPLIED", for: .normal)

        self.btn_cancelPromo.isHidden = false
        self.btn_selectPromo.isHidden = true
        self.view.makeToast(message: "Promo Code Applied Successfully")
        self.displayBookingPriceInfo()
    }
    
    func aplyPromo() {
        if (txt_promo.text?.isEmpty == true) {
            self.view.makeToast(message: "Please select promo code")
        } else {
            SwiftLoader.show(animated: true)

            let userId = ""
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"hotel","total_amount_val": FinalBreakupHotelModel.totalFare,"user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee":FinalBreakupHotelModel.convenienceFare,"currency": "INR","search_id": DHotelSearchModel.search_id ]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            print(result["discount_value"] as! String)
                            let value = Float(result["discount_value"] as! String)
                            
                            if  FinalBreakupHotelModel.totalFare <= (self.selectedPromo?.minimum_amount)! || (value! > FinalBreakupHotelModel.totalFare) {
                                FinalBreakupHotelModel.total_amount_val = 0.0//FinalBreakupHotelModel.totalFare
                                self.removePromo()
                                
                            }else {
                                FinalBreakupHotelModel.discount  = Float(result["discount_value"] as! String)!
                                if let value = result["total_amount_val"] as? Double {
                                    FinalBreakupHotelModel.total_amount_val = Float(value)
                                } else if let value = result["total_amount_val"] as? Int {
                                    FinalBreakupHotelModel.total_amount_val = Float(value)
                                } else if let value = result["total_amount_val"] as? String {
                                    FinalBreakupHotelModel.total_amount_val = Float(value) ?? 0.0
                                }
                                self.baseConvenienceFare = parseAmount(result["convenience_fee"])// Float(String.init(describing: result["convenience_fee"]!))!//Float(result["discount_value"] as! String)!

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
}

extension HotelGuestInfoVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tf_mobileNo {
            // Ensure the input is numeric and within the length limit
            if !string.isValidIntergerSet() {
                return false
            }
            
            // Calculate the updated text length
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Check if the updated text is within the 10-digit limit
            return updatedText.count <= 10
        } else {
            // Allow changes for other text fields
            return true
        }
    }
    
    func dismissKeyboardMethod() {
        // resigns...
        tf_email.resignFirstResponder()
        tf_mobileNo.resignFirstResponder()
    }
}
extension HotelGuestInfoVC: PromoCodeDelegate /*,searchHotelCitiesDelegate*/ {
    
    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
        selectedPromo = promoCode
        txt_promo.text = promoCode.promoCode
    }
}

extension HotelGuestInfoVC: UITableViewDataSource, UITableViewDelegate, hPassengerCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_adultNames {
            return DHPassengerModel.adultArray.count
        }
        else if tableView == tbl_childNames {
            return DHPassengerModel.childArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        if cell == nil {
            tableView.register(UINib(nibName: "HPassengerCell", bundle: nil), forCellReuseIdentifier: "HPassengerCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        }
        cell?.delegate = self
        
        
        // display information...
        if tableView == tbl_adultNames {
            cell?.displayPassenger_information(model: DHPassengerModel.adultArray[indexPath.row])
        }
        else if tableView == tbl_childNames {
            cell?.displayPassenger_information(model: DHPassengerModel.childArray[indexPath.row])
        }
        else {}
        
        
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK:- CellButtonActions
    func selectionButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // getting table...
        var tableView: UITableView?
        if let superView = cell.superview as? UITableView {
            tableView = superView
        }
        print("Table : \(String(describing: tableView))")
        
        
        // main actions...
        let indexPath = tableView? .indexPath(for: cell)
        if tableView == tbl_adultNames {
            
            // getting selection count...
            var adultCount = 0
            for model in DHPassengerModel.adultArray {
                if model.isSelected == true {
                    adultCount = adultCount + 1
                }
            }
            
            // max count...
            var adult_MaxCount = 1
            
            adult_MaxCount = DHTravelModel.adult_count
            
            // adult max count
            if (adultCount >= adult_MaxCount) && DHPassengerModel.adultArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum adult selection \(adult_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DHPassengerModel.adultArray[(indexPath?.row)!].isSelected == true {
                DHPassengerModel.adultArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DHPassengerModel.adultArray[(indexPath?.row)!].isSelected = true
            }
        }
        else if tableView == tbl_childNames {
            
            // getting selection count...
            var childCount = 0
            for model in DHPassengerModel.childArray {
                if model.isSelected == true {
                    childCount = childCount + 1
                }
            }
            
            // max count...
            var child_MaxCount = 1
            
            child_MaxCount = DHTravelModel.child_count
            
            // child max count
            if (childCount >= child_MaxCount) && DHPassengerModel.childArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum child selection \(child_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DHPassengerModel.childArray[(indexPath?.row)!].isSelected == true {
                DHPassengerModel.childArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DHPassengerModel.childArray[(indexPath?.row)!].isSelected = true
            }
        }
        
        else {}
        
        // display selection informations...
        displayMaxPassengersCounts()
        tableView?.reloadData()
    }
    
    func editButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // getting table...
        var tableView: UITableView?
        if let superView = cell.superview as? UITableView {
            tableView = superView
        }
        print("Table : \(String(describing: tableView))")
        
        
        // main actions...
        let indexPath = tableView? .indexPath(for: cell)
        if tableView == tbl_adultNames {
            moveToAddPassengerFrom(indexS: 0, editIndex: (indexPath?.row)!)
        }
        else if tableView == tbl_childNames {
            moveToAddPassengerFrom(indexS: 1, editIndex: (indexPath?.row)!)
        }
        else {}
    }
}

extension HotelGuestInfoVC: GuestFormDelegate, ISOCodeDelegate {
    
    // MARK:- GuestFormDelegate
    func addOrUpdate_PassengersSending(Reload: Bool) {
        DispatchQueue.main.async {
            self.reloadTablesAndFrameAdjust()
        }
    }
    
    // MARK:- ISOCodeDelegate
    func countryISOCode(dial_code: [String : String]) {
        
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
    
}

extension HotelGuestInfoVC {
    
    // MARK:- API's
    func hotelPreBooking_HTTPConnection() {
        
        var firstname : [String] = []
        var middlename : [String] = []
        var lastname: [String] = []
        var titles : [String] = []
        var dateofbirth: [String] = []
        var genders: [String] = []
        var passenger_nationality : [String] = []
        var passenger_passport_number : [String] = []
        var passenger_passport_issuing_country : [String] = []
        var passenger_passport_expiry_day : [String] = []
        var passenger_passport_expiry_month : [String] = []
        var passenger_passport_expiry_year : [String] = []
        var passengerType: [String] = []
        var isLead: [String] = []
        
        for i in 0..<DHTravelModel.adult_count {
            firstname.append("")
            lastname.append("")
            titles.append("")
            dateofbirth.append("")
            genders.append("")
            passenger_nationality.append("")
            passenger_passport_number.append("")
            passenger_passport_issuing_country.append("")
            passenger_passport_expiry_day.append("")
            passenger_passport_expiry_month.append("")
            passenger_passport_expiry_year.append("")
            if i == 0 {
                isLead.append("1")
            }else{
                isLead.append("0")
            }
            passengerType.append("1")
            middlename.append("")
        }
        
        for i in 0..<DHTravelModel.child_count {
            firstname.append("")
            lastname.append( "")
            titles.append( "")
            dateofbirth.append( "")
            genders.append( "")
            passenger_nationality.append("")
            passenger_passport_number.append("")
            passenger_passport_issuing_country.append("")
            passenger_passport_expiry_day.append("")
            passenger_passport_expiry_month.append("")
            passenger_passport_expiry_year.append("")
            passengerType.append("2")
            isLead.append("0")
            middlename.append("")
        }
        
        var model = DHPassengerItem.init()
        
        let user_id = ""
        // params...
        var params:[String: Any] = [
            "currency": "INR",
            "currency_symbol": "Rs",
            "search_id": String.init(format: "%@", DHotelSearchModel.search_id),
            "promo_code": txt_promo.text ?? "",
            "promo_code_discount_val": String.init(format: "%.2f", FinalBreakupHotelModel.discount),
            "total_amount_val": String.init(format: "%.2f", FinalBreakupHotelModel.totalFare ),
            "convenience_fee": String.init(format: "%.2f", FinalBreakupHotelModel.convenienceFare),
            "payment_method": "PNHB1",
            "token": DHPreBookingModel.preBookingItem?.token ?? "",
            "token_key": DHPreBookingModel.preBookingItem?.token_key ?? "",
            "op": "book_flight",
            "booking_source": DHPreBookingModel.preBookingItem?.booking_source ?? "",
            "promo_actual_value": FinalBreakupHotelModel.discount,
            "code": "",
            "billing_country": "92",
            "billing_city": "test",
            "billing_zipcode": "test",
            "billing_address_1": "test",
            "phone_country_code": "\(String(describing: countryISO_Dict["DialCode"]!))",//"+91",
            "passenger_contact": DHPassengerModel.mobile_no,
            "billing_email": DHPassengerModel.email_id,
            "alternate_hotel_room": "" ?? "", //"YToyOntpOjA7czo0OiIxN18wIjtpOjE7czo0OiIxN18xIjt9",
            "tc": "on",
            "passenger_type": passengerType,
            "lead_passenger": isLead,
            "date_of_birth": dateofbirth,
            "gender": genders,
            "passenger_nationality": passenger_nationality,
            "passenger_passport_number": passenger_passport_number,
            "passenger_passport_issuing_country": passenger_passport_issuing_country,
            "passenger_passport_expiry_day": passenger_passport_expiry_day,
            "passenger_passport_expiry_month": passenger_passport_expiry_month,
            "passenger_passport_expiry_year": passenger_passport_expiry_year,
            "name_title": titles,
            "first_name": firstname,
            "middle_name": middlename,
            "last_name": lastname,
        ]
        
        var paramString:[String: String] = [:]
        
        paramString["hotel_params"] = VKAPIs.getJSONString(object: params)
        paramString["Token"] = DHPreBookingModel.preBookingItem?.token ?? ""
        paramString["Token_key"] = DHPreBookingModel.preBookingItem?.token_key ?? ""
        paramString["wallet_bal"] = "off"
        
        moveToReviewPage(params: params)
        
        
        
        
    }
    
    func moveToReviewPage(params: [String: Any]) {
        
        // move to next screen...
        let hReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "HotelReviewVC") as! HotelReviewVC
        hReviewVC.paramString = [:]
        self.navigationController?.pushViewController(hReviewVC, animated: false)

    }
    
    func getPassengers() -> [Any] {
        
        // adding passenger information...
        var passenger_array: [[String: String]] = []
        for model in DHPassengerModel.adultArray {
            if model.isSelected == true {
                
                let passenger: [String: String] = ["Gender": model.gender_value ?? "1","Pax_Type": "1", "Title": model.title_value ?? "1", "FirstName": model.first_name!, "LastName": model.last_name!, "DateOfBirth": model.dateOf_birth ?? "", "PassportNumber": "", "PassportExpiry": "", "PassportIssueCountry": ""]
                passenger_array.append(passenger)
            }
        }
        
        for model in DHPassengerModel.childArray {
            if model.isSelected == true {
                
                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
                                                   "Pax_Type": "2",
                                                   "Title": model.title_value ?? "1",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth ?? "",
                                                   "PassportNumber": "",
                                                   "PassportExpiry": "",
                                                   "PassportIssueCountry": ""]
                passenger_array.append(passenger)
            }
        }
        
        //        passenger_array[0]["lead_passenger"] = "1"
        return passenger_array
    }
    
    
    func prebookingApiConnection(paramString: [String: Any]){
        print(paramString)
        
        SwiftLoader.show(animated: true)
        // calling apis...
        VKAPIs.shared.getRequestRaw(params: [:], file: HOTEL_Pre_Booking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel Pre Book success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            
                            // move to payment...
                            let pay_vc = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelPaymentVC") as! HotelPaymentVC
                            pay_vc.payment_url = data_dict["return_url"] as? String
                            self.navigationController?.pushViewController(pay_vc, animated: true)
                        }
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel Pre Book formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Pre Book error : \(String(describing: error?.localizedDescription))")
            }
            SwiftLoader.hide()
        }
    }
}
