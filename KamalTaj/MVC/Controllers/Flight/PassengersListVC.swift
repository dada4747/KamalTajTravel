//
//  PassengersListVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import WebKit

class PassengersListVC: UIViewController, ISOCodeDelegate, DPickerPopViewDelegate {
    func datePickerPopView(_picker: DatePickerPopView, _date: Date) {
        sel_date = _date
        
        var dateStr = ""
        if fieldTags == 10 {
            dateStr = DateFormatter.getDateString(formate: "yyyy-MM-dd",
                                                      date: _date)
            DPassengerModel.allPassengerArray[selectedIndex].dateOf_birth = dateStr
        } else if fieldTags == 11 {
            dateStr = DateFormatter.getDateString(formate: "yyyy-MM-dd",
                                                  date: _date)
            DPassengerModel.allPassengerArray[selectedIndex].passport_expiry = dateStr
        }
        
        tblPassenger.reloadData()
    }
    
    func countryISOCode(dial_code: [String : String]) {
        
        if fieldTags == 14 {
            
            // nationality...
            if let country_name = dial_code["Country"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country = country_name
            }
            if let country_code = dial_code["ISOCode"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country_code = country_code
            }
            tblPassenger.reloadData()
            // ✅ Delay needed because table reload happens asynchronously
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        if let cell = self.tblPassenger.cellForRow(at: IndexPath(row: self.selectedIndex, section: 0)) as? FlightPaxCell {
//                            self.dobButton_Action(sender: cell.btnDOB, cell: cell)
//                        }
//                    }
        }
        else if fieldTags == 15 {
            
            if let country_name = dial_code["cn"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country = country_name
            }
            if let country_id = dial_code["id"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country_code = country_id
            }
            
            tblPassenger.reloadData()
            // ✅ Delay needed because table reload happens asynchronously
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        if let cell = self.tblPassenger.cellForRow(at: IndexPath(row: self.selectedIndex, section: 0)) as? FlightPaxCell {
//                            self.dobButton_Action(sender: cell.btnPPE, cell: cell)
//                        }
//                    }
        }
        else {
            countryISO_Dict = dial_code
            displayDialCode(dailCode: countryISO_Dict)
        }

        print(dial_code)
    }
    
    
    
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var lbl_infantCount: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    
    // passengers list elements...
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    @IBOutlet weak var txt_promo: UITextField!
    
    var view_PromoCodeView: ToursPackageView?
    
    // booking info...
    @IBOutlet weak var lbl_handBaggage: UILabel!
    @IBOutlet weak var lbl_checkInBaggage: UILabel!
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_gstFare: UILabel!
    @IBOutlet weak var lbl_extraService: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    @IBOutlet weak var lbl_rewardDiscount: UILabel!
    
    @IBOutlet weak var tblPassenger: UITableView!
    @IBOutlet weak var heiTblConstraint: NSLayoutConstraint!
    
    // SSR Outlets...
    @IBOutlet weak var btnSSR: UIButton!
    @IBOutlet var view_SSR: UIView!
    @IBOutlet weak var web_view_SSR: WKWebView!
    @IBOutlet weak var btn_applyPromo: CRButton!
    
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    
    @IBOutlet weak var gst_credit_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gst_credit_view: UIView!
    @IBOutlet weak var scrolle_view: UIScrollView!
    
    @IBOutlet weak var tf_gst_number: UITextField!
    @IBOutlet weak var tf_gst_name: UITextField!
    @IBOutlet weak var tf_gst_email: UITextField!
    @IBOutlet weak var tf_gst_phone: UITextField!
    @IBOutlet weak var tf_gst_address: UITextField!
    
    @IBOutlet weak var img_addgst: UIImageView!
    @IBOutlet weak var lbl_gst_state: UILabel!
    @IBOutlet weak var view_discount: UIView!
    @IBOutlet weak var view_discount_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_rewardDiscount: UIView!
    @IBOutlet weak var view_rewardDiscount_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_redeem: CardView!
    @IBOutlet weak var view_redeemHConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_rewardusable: UILabel!
    
    @IBOutlet weak var lbl_rewardEarning: UILabel!
    @IBOutlet weak var tf_rewardPoints: UITextField!
    @IBOutlet weak var btn_cancelReward: UIButton!
    
    @IBOutlet weak var lbl_totalAmount: CustomFontLabel!
    var isRewardSelected = false
    
    var isExpandedGst = false
    var paramString: [String: String] = [:]
    var countryISO_Dict: [String: String] = ["DialCode": "+91",
                                             "Country": "India",
                                             "ISOCode": "IN"]
    var countries_array: [[String: String]] = []
    var termsBool = false
    var adult_count = 0
    var child_count = 0
    var infant_count = 0
    var fieldTags = 0
    var selectedIndex = 0
    var sel_date = Date()
    var baseConvenienceFare: Float = FinalBreakupModel.convenienceFare

    // SSR Variables...
    var isSSR: Bool = false
    var isSSRSeatSelected: Bool = false
    var SSRPaymentDict = [String: Any]()
    
    var selectedPromo: DCommonTopOfferItems?
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile) as? [String: Any] ?? [:]
    var isDomestic : Bool = DFlightSearchModel.is_domestic

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.layer.frame.size.height -= 255
        tf_mobileNo.delegate = self
        tf_gst_email.delegate = self
        tf_gst_phone.delegate = self
        tf_email.delegate = self
        
        gst_credit_view.isHidden = true
        gst_credit_HConstraint.constant = 0
        //        lbl_gst_state.text = DStorageModel.states.first!["name"]
        btn_cancelReward.isHidden = true
        if profile_dict.isEmpty {
            view_redeem.isHidden = false//true
            view_redeemHConstraint.constant = 0
            view_discount_HConstraint.constant = 0
            btn_cancelReward.isHidden = true
        }else{
            view_redeemHConstraint.constant = 0
            view_discount_HConstraint.constant = 0

            lbl_rewardusable.text = "\(DFlightStopsModel.availableTripPoints) Points"
            lbl_rewardEarning.text = "\(DFlightStopsModel.availableTripPoints) Points"
            
        }
        createPassenger_Form()
        
        // delegates...
        addFrameAddView()
        
        displayInformationAndDelegates()
        reloadTablesAndFrameAdjust()
        btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        
        // getting passengers list from server...
        if (DPassengerModel.adultArray.count == 0) && (DPassengerModel.childArray.count == 0) && (DPassengerModel.infantArray.count == 0) {
            //self.getAllPassengersList()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTablesAndFrameAdjust()
//        FinalBreakupModel.convenienceFare = baseConvenienceFare
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true) // force resign
    }
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    
    func createPassenger_Form() {
        
        DPassengerModel.allPassengerArray.removeAll()
        
        // adding passengers list
        for i in 0 ..< DTravelModel.adultCount {
            
            var model = DPassengerItem.init()
            model.title_form = String.init(format: "Adult %d", i + 1)
            model.title_name = "Mr"
            DPassengerModel.allPassengerArray.append(model)
        }
        
        for j in 0 ..< DTravelModel.childCount {
            
            var model = DPassengerItem.init()
            model.title_form = String.init(format: "Child %d", j + 1)
            model.person_type = "Child"
            model.title_name = "Mstr" //"Mstr"
            DPassengerModel.allPassengerArray.append(model)
        }
        
        for k in 0 ..< DTravelModel.infantCount {
            
            var model = DPassengerItem.init()
            model.title_form = String.init(format: "Infant %d", k + 1)
            model.person_type = "Infant"
            model.title_name = "Mstr"
            DPassengerModel.allPassengerArray.append(model)
        }
        
        tblPassenger.reloadData()
        // Wait for reload and calculate real height
        DispatchQueue.main.async {
            self.heiTblConstraint.constant = self.calculateTableHeight()
        }
    }
    func calculateTableHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        for section in 0..<tblPassenger.numberOfSections {
            for row in 0..<tblPassenger.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                
                if let cell = tblPassenger.dataSource?.tableView(tblPassenger, cellForRowAt: indexPath) {
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
    // MARK:- Helper
    func displayInformationAndDelegates() {
        
        self.view_SSR.isHidden = true
        self.view_SSR.frame = self.view.frame
        self.view.addSubview(self.view_SSR)
        //        view.backgroundColor = .appColor
        getISOCodeList()
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tblPassenger.delegate = self
        tblPassenger.dataSource = self
        tblPassenger.rowHeight = UITableView.automaticDimension;
        tblPassenger.estimatedRowHeight = 610
        
        tf_mobileNo.delegate = self
        
        // clear selection...
        clearAll_SelectedInfo()
        
        // check user login or not...
        //        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        //        if userProfile is [String: Any] {
        //
        //            // after login...
        //            if let email_id = (userProfile as! [String: Any])["email"] as? String {
        //                self.tf_email.text = email_id
        //            }
        //        }
        //
        
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
        
        
        // counrty code display...
        //        let mobileISO_Dict = UserDefaults.standard.object(forKey: CTGMobile_IOS)
        //        if let final_mobileISO = mobileISO_Dict as? [String: String] {
        //            countryISO_Dict = final_mobileISO
        //            self.tf_isdCode.text = "\(String(describing: countryISO_Dict["iso"]!)) \(String(describing: countryISO_Dict["isd"]!))"
        //        }
        
        // mobile number...
        //        let mobile_no = UserDefaults.standard.object(forKey: CTGMobileNo)
        //        if let final_no = mobile_no as? String  {
        //            self.tf_mobileNo?.text = final_no
        //        }
    }
    
    func displayUserProfile() {
        
        //          if profile_dict != nil {
        //
        //              if let email_id = profile_dict["email_id"] as? String {
        //                  self.tf_email.text = email_id
        //              }
        //              if let iso_code = (profile_dict as! [String: Any])["country_code"] as? String {
        //
        //                  //phone_code
        //                  self.tf_isdCode.text = String.init(format: "+%@",iso_code)
        //                  countryISO_Dict =  getDialCode(country_code: iso_code)
        //                  let img_iso = selected_code["ISOCode"] ?? ""
        //                  img_country.image = UIImage.init(named: String.init(format: "%@.png", img_iso.lowercased()))
        //              }
        //              if let phone_number = (profile_dict as! [String: Any])["phone"] as? String {
        //                  self.txt_phoneNumber.text = phone_number
        //              }
        //           }
        //          else {
        //               selected_code = ["DailCode": "+91",
        //                                "Country": "India",
        //                                 "ISOCode": "IN"]
        //              displayDialCode(dailCode: selected_code)
        //          }
    }
    
    func getISOCodeList() {
        
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        
        if userProfile is [String: Any] {
            if let code = (userProfile as! [String: Any])["country_code"] as? String {
                
                let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "+", with: "")
                
                countryISO_Dict = VKDialCodes.shared.getDialCode(country_code: "\(trimmedCode)")
                
                //displayDialCode(dailCode: countryISO_Dict)
            } else {
                //countryISO_Dict = VKDialCodes.shared.current_dialCode
                //displayDialCode(dailCode: countryISO_Dict)
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
        
        self.tf_isdCode.text = "\(String(describing: dailCode["Country"] ?? "India")) (\(String(describing: dailCode["DialCode"] ?? "")))"
    }
    
    func displayBookingPriceInfo() {
        
        let currency_symbol = DCurrencyModel.currency_saved?.currency_symbol ?? "AUD"
        
        // currency and total price...
        lbl_baseFare.text = String(format: "%@ %.0f", currency_symbol, FinalBreakupModel.baseFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_taxFare.text = String(format: "%@ %.0f", currency_symbol, FinalBreakupModel.totalTax * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        let totalfare = ((FinalBreakupModel.totalFare + baseConvenienceFare) -  FinalBreakupModel.discount - FinalBreakupModel.rewardDiscount ) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)
        
        lbl_totalAmount.text = String(format: "%@ %.0f", currency_symbol,(FinalBreakupModel.totalFare - FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_totalFare.text = String(format: "%@ %.0f", currency_symbol,(totalfare )) //FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)
        
        lbl_gstFare.text = String(format: "%@ %.0f", currency_symbol, FinalBreakupModel.gstFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_grandTotal.text = String(format: "%@ %.0f", currency_symbol, (totalfare)) //FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)
        
        lbl_convenienceFare.text = String(format: "%@ %.0f", currency_symbol, baseConvenienceFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_extraService.text = String(format: "%@ %.0f", currency_symbol, 0.0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        if selectedPromo == nil || FinalBreakupModel.discount == 0.0 {
            view_discount.isHidden = true
            view_discount_HConstraint.constant = 0
        }else{
            view_discount.isHidden = false
            view_discount_HConstraint.constant = 40
            lbl_discount.text = String(format: "%@ %.0f", currency_symbol, (FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        }
        if isRewardSelected == false || FinalBreakupModel.rewardDiscount == 0.0 {
            view_rewardDiscount.isHidden = true
            view_rewardDiscount_HConstraint.constant = 0
        }else{
            view_rewardDiscount.isHidden = false
            view_rewardDiscount_HConstraint.constant = 40
            lbl_rewardDiscount.text = String(format: "%@ %.0f", currency_symbol, (FinalBreakupModel.rewardDiscount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        }
        
        
        if DFlightStopsModel.flightTrip_array.count != 0 {
            lbl_checkInBaggage.text = DFlightStopsModel.flightTrip_array[0].baggage
            lbl_handBaggage.text = DFlightStopsModel.flightTrip_array[0].cabin_baggage
        }
        
    }
    
    
    func clearAll_SelectedInfo() {
        
        // adult count...
        for i in 0 ..< DPassengerModel.adultArray.count {
            DPassengerModel.adultArray[i].isSelected = false
        }
        
        // child count...
        for i in 0 ..< DPassengerModel.childArray.count {
            DPassengerModel.childArray[i].isSelected = false
        }
        
        // infant count...
        for i in 0 ..< DPassengerModel.infantArray.count {
            DPassengerModel.infantArray[i].isSelected = false
        }
    }
    
    func reloadTablesAndFrameAdjust() {
        
        displayMaxPassengersCounts()
    }
    
    func displayMaxPassengersCounts() {
        
        // adult count...
        adult_count = 0
        for model in DPassengerModel.adultArray {
            if model.isSelected == true {
                adult_count = adult_count + 1
            }
        }
        
        // child count...
        child_count = 0
        for model in DPassengerModel.childArray {
            if model.isSelected == true {
                child_count = child_count + 1
            }
        }
        
        // infant count...
        infant_count = 0
        for model in DPassengerModel.infantArray {
            if model.isSelected == true {
                infant_count = infant_count + 1
            }
        }
        
        
        //        // selected passenger counts...
        //        lbl_adultCount.text = "AD \(adult_count)/\(DTravelModel.adultCount)"
        //        lbl_childCount.text = "CH \(child_count)/\(DTravelModel.childCount)"
        //        lbl_infantCount.text = "IN \(infant_count)/\(DTravelModel.infantCount)"
        
        //passenger counts...
        lbl_adultCount.text = "\(DTravelModel.adultCount)"
        lbl_childCount.text = "\(DTravelModel.childCount)"
        lbl_infantCount.text = "\(DTravelModel.infantCount)"
        
    }
    
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        removePromo()
//        removeReward()
        FinalBreakupModel.discount = 0.0
        FinalBreakupModel.rewardDiscount = 0.0
        FinalBreakupModel.reward_promo_code = ""
        FinalBreakupModel.reward_total_fare = 0.0
        FinalBreakupModel.total_used_points = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideSSRBtnClicked(_ sender: Any) {
        
        self.view_SSR.isHidden = true
    }
    
    @IBAction func SSRSeatSelection(_ sender: UIButton) {
        
        if isSSR {
            isSSR = false
            btnSSR.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        }
        else {
            isSSR = true
            btnSSR.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    
    @IBAction func selectPromoAction(_ sender: Any) {
        
        let flightPromo = DCommonModel.topOffer_Array.filter{ $0.module == "flight"}
        if flightPromo.count == 0 {
            self.view.makeToast(message: "No Promocode available ")
        }else {
            let filterObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "ApplyPromoCodeVC") as! ApplyPromoCodeVC
            filterObj.modalPresentationStyle = .fullScreen
            filterObj.promoCodeArray = flightPromo
            filterObj.promoCodeDelegate = self
            self.present(filterObj, animated: true, completion: nil)
        }
        //        if DCommonModel.topOffer_Array.filter(T##(Self.Element) -> Bool)
        
    }
    @IBAction func cancelPRomoAction(_ sender: Any) {
        baseConvenienceFare = FinalBreakupModel.convenienceFare
        selectedPromo = nil
        self.btn_selectPromo.isHidden = false
        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
        btn_applyPromo.setTitle("APPLY", for: .normal)
        FinalBreakupModel.discount = 0.0
        self.displayBookingPriceInfo()
        FinalBreakupModel.promoCode = ""
        
    }
    @IBAction func promoBtnClicked(_ sender: Any) {
        aplyPromo()
        
    }
    func removePromo() {
        FinalBreakupModel.discount  = 0.0
        baseConvenienceFare = FinalBreakupModel.convenienceFare
        selectedPromo = nil
        self.btn_applyPromo.setTitle("APPLY", for: .normal)
        self.btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        self.txt_promo.text = nil
        self.view.makeToast(message: "Promo Code Not Valid for this booking")
        self.displayBookingPriceInfo()
        FinalBreakupModel.promoCode = ""
    }
    func appliedPromo() {
        print(FinalBreakupModel.convenienceFare)
        self.btn_applyPromo.setTitle("APPLIED", for: .normal)
        self.btn_cancelPromo.isHidden = false
        self.btn_selectPromo.isHidden = true
        self.view.makeToast(message: "Promo Code Applied Successfully")
        self.displayBookingPriceInfo()
        FinalBreakupModel.promoCode = txt_promo.text ?? ""
    }
    func aplyPromo(){
        print(txt_promo.text?.isEmpty)
        if (txt_promo.text?.isEmpty == true) {
            self.view.makeToast(message: "Please select promo code")
        } else {
            SwiftLoader.show(animated: true)
            
            let userId = ""
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"flight","total_amount_val":FinalBreakupModel.totalFare,"user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee": FinalBreakupModel.convenienceFare,"currency":"INR","search_id": DFlightSearchModel.search_id ]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            // print(result["discount_value"] as! String)
                            
                            var value: Float = 0.0
                            value = Float(String.init(describing: result["discount_value"]!))!
                            
                            
                            //let value = Float(result["discount_value"] as? String ?? "0.0")
                            
                            if  FinalBreakupModel.totalFare <= (self.selectedPromo?.minimum_amount ?? 0.0)! || (value > FinalBreakupModel.totalFare) {
                                self.removePromo()
                                
                            }else {
                                FinalBreakupModel.discount  = value
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
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        
        //        // getting current position...
        //        let parent_view = sender.superview?.superview
        //        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        //
        //        // table pop view...
        //        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        //        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //        tbl_popView.delegate = self
        //        tbl_popView.DType = .CountryISO
        //        tbl_popView.countries_array = countries_array
        //        tbl_popView.changeMainView_Frame(rect: fieldRect)
        //        self.view.addSubview(tbl_popView)
        
        
        let nextObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ISOCodeVC") as! ISOCodeVC
        nextObj.delegate = self
        nextObj.DCatType = .ISOCode
        nextObj.countries_array = countries_array
        self.present(nextObj, animated: true, completion: nil)

    }
    func isValidGST(testStr:String) -> Bool {
        
        return testStr.range(of: "[ !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+", options: .regularExpression) != nil
    }
    func passengerFormValidation() -> Bool {
        
        // form validations...
        var message = ""
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            if (DPassengerModel.allPassengerArray[i].title_name)!.isEmpty && DPassengerModel.allPassengerArray[i].person_type == "Adult" {
                message = "Please select title \(DPassengerModel.allPassengerArray[i].title_form)" // - \(i + 1)
                break
            }
            else if (DPassengerModel.allPassengerArray[i].first_name ?? "").isEmpty {
                message = "Please enter first name \(DPassengerModel.allPassengerArray[i].title_form)"
                break
            }
            else if !((DPassengerModel.allPassengerArray[i].first_name ?? "").isValidName()) {
                message = "Please enter valid first name \(DPassengerModel.allPassengerArray[i].title_form)"
                break
            }
            else if (DPassengerModel.allPassengerArray[i].last_name ?? "").isEmpty {
                message = "Please enter last name \(DPassengerModel.allPassengerArray[i].title_form)"
                break
            }
            else if !((DPassengerModel.allPassengerArray[i].last_name ?? "").isValidName()) {
                message = "Please enter valid last name \(DPassengerModel.allPassengerArray[i].title_form)"
                break
            }
            if !isDomestic {
                if (DPassengerModel.allPassengerArray[i].issued_country ?? "").isEmpty {
                    message = "Please select Nationality \(DPassengerModel.allPassengerArray[i].title_form)"
                    break
                }
                else if (DPassengerModel.allPassengerArray[i].dateOf_birth ?? "").isEmpty {
                    message = "Please select date of birth \(DPassengerModel.allPassengerArray[i].title_form)"
                    break
                }
                else if (DPassengerModel.allPassengerArray[i].passport_no ?? "").isEmpty  {
                    message = "Please enter passport number \(DPassengerModel.allPassengerArray[i].title_form)"
                    break
                }
                else if (DPassengerModel.allPassengerArray[i].issued_country)!.isEmpty {
                    message = "Please select passport issuing country \(DPassengerModel.allPassengerArray[i].title_form)"
                    break
                }
                else if (DPassengerModel.allPassengerArray[i].passport_expiry ?? "").isEmpty  {
                    message = "Please select passport expiry date \(DPassengerModel.allPassengerArray[i].title_form)"
                    break
                }
                else {}
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
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        
        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        // select count based one category...
        
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
            //        else if termsBool == false {
            //            messageStr = "Please acccept terms and conditions"
            //        }
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
                DPassengerModel.email_id = tf_email.text!
                DPassengerModel.mobile_no = tf_mobileNo.text!
                DPassengerModel.country_code = countryISO_Dict
                FinalBreakupModel.convenienceFare = baseConvenienceFare
                flightPreBooking_HTTPConnection()
            }
        }
        self.view.isUserInteractionEnabled = true
        
    }
    @IBAction func expand_gst_option(_ sender: Any) {
        if isExpandedGst == false {
            img_addgst.image = UIImage(named: "ic_minus1")
            isExpandedGst = true
            gst_credit_view.isHidden = false
            gst_credit_HConstraint.constant = 286
            var contentInset:UIEdgeInsets = self.scrolle_view.contentInset
            //            contentInset.bottom = 270
            scrolle_view.contentInset = contentInset
        }else {
            img_addgst.image = UIImage(named: "ic_plus1")
            isExpandedGst = false
            gst_credit_HConstraint.constant = 0
            gst_credit_view.isHidden = true
            var contentInset:UIEdgeInsets = self.scrolle_view.contentInset
            //            contentInset.bottom -= 270
            scrolle_view.contentInset = contentInset
        }
        
    }
    
    @IBAction func selectGSTStateAction(_ sender: UIButton) {
        let parent_view = sender.superview
        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        fieldRect.size.width = fieldRect.size.width
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_stateArray = self
        tbl_popView.DType = .State
        tbl_popView.state_array = DStorageModel.states
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
//    func appliedReward(){
//        tf_rewardPoints.resignFirstResponder()
//        self.btn_cancelReward.isHidden = false
//        self.view.makeToast(message: "reeward points applied Successfully")
//        isRewardSelected = true
//        self.displayBookingPriceInfo()
//        print("FinalBreakupModel.rewardDiscount : \(FinalBreakupModel.rewardDiscount)")
//        print("FinalBreakupModel.reward_promo_code : \(FinalBreakupModel.reward_promo_code)")
//        print("FinalBreakupModel.reward_total_fare : \(FinalBreakupModel.reward_total_fare)")
//        print("FinalBreakupModel.total_used_points : \(FinalBreakupModel.total_used_points)")
//    }
//    func removeReward(){
//        isRewardSelected = false
//        
//        tf_rewardPoints.text = nil
//        tf_rewardPoints.resignFirstResponder()
//        btn_cancelReward.isHidden = true
//        lbl_rewardusable.text = "\(DFlightStopsModel.availableTripPoints) Points"
//        
//        FinalBreakupModel.rewardDiscount = 0.0
//        FinalBreakupModel.reward_promo_code = ""
//        FinalBreakupModel.reward_total_fare = 0.0
//        FinalBreakupModel.total_used_points = 0.0
//        self.displayBookingPriceInfo()
//        
//    }
    @IBAction func applyRewardPointApi(_ sender: Any) {
//        self.dismissKeyboardMethod()
//        if (tf_rewardPoints.text?.isEmpty == true) {
//            self.view.makeToast(message: "Please Enter reedem points")
//        }else if let availablePoints = Int(DFlightStopsModel.availableTripPoints),
//                 let enteredPoints = Int(tf_rewardPoints.text ?? ""),
//                 availablePoints < enteredPoints {
//            self.view.makeToast(message: "Please redeem points should less than \(DFlightStopsModel.availableTripPoints)")
//        }else {
////            redeemRewardPoints()
//        }
    }
    @IBAction func cancelReward(_ sender: Any) {
//        removeReward()
    }
}
extension PassengersListVC  {
//    func redeemRewardPoints(){
//        SwiftLoader.show(animated: true)
//        
//        _ = ""
//        let params: [String: String] = ["user_id": "".getUserId(), "enter_reward_point": tf_rewardPoints.text ?? "",
//                                        "available_rewards":DFlightStopsModel.availableTripPoints,"total_amt": "\(FinalBreakupModel.totalFare)"]
//        
//        
//        VKAPIs.shared.getRequestXwwwform(params: params, file: "user/reward_booking_discount", httpMethod: .POST) { (resultObj, success, error) in
//            if success == true {
//                print("Reward Point success responce: \(String(describing: resultObj))")
//                
//                if let result = resultObj as? [String: Any] {
//                    if result["status"] as? Bool == true {
//                        var reducingAmount: Float = 0.0
//                        reducingAmount = Float(String.init(describing: result["discount_reward_amt"]!))!
//                        
//                        if reducingAmount <= FinalBreakupModel.totalFare {
//                            
//                            self.lbl_rewardusable.text =  "\(String.init(describing: result["remaining_points"]!)) Points"
//                            
//                            FinalBreakupModel.rewardDiscount = reducingAmount
//                            FinalBreakupModel.reward_promo_code = String.init(describing: result["reward_promo_code"]!)
//                            FinalBreakupModel.reward_total_fare = Float(String.init(describing: result["grand_total"]!))!
//                            FinalBreakupModel.total_used_points = Float(String.init(describing: result["total_used_points"]!))!
//                            self.appliedReward()
//                        }else{
//                            appDel.window?.makeToast(message:"Reward point should less than total fare")
//                            //                            appDel.window?.makeToast(message:"You can use only \(result["remaining_points"]!)")
//                        }
//                    }else{
//                        self.view.makeToast(message: result["message"] as! String)
//                    }
//                    //                    {"grand_total":267.68000000000000682121026329696178436279296875,"trip_points":"10","total_reward_amt":10,"discount_reward_amt":10,"used_points":"10","total_used_points":"10","reward_promo_code":"ETB-05MAYRWD4572","remaining_points":0,"message":"Success","status":1}
//                    
//                } else {
//                    print("Reward Point formate : \(String(describing: resultObj))")
//                    appDel.window?.makeToast(message:"\(resultObj ?? "")")
//                }
//            }
//            SwiftLoader.hide()
//        }
//    }
}
extension PassengersListVC : PromoCodeDelegate , StateDelegates, UITextFieldDelegate {
    func selectedState(state: [String : String]) {
        print(state)
        lbl_gst_state.text = state["name"]
    }
    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
        
        selectedPromo = promoCode
        txt_promo.text = promoCode.promoCode
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow backspace
        if string.isEmpty { return true }

        // 🔐 Passport Number — ALPHANUMERIC ONLY (NO SPECIAL CHAR, NO SPACE)
        if textField is UITextField,
           let cell = textField.findSuperview(ofType: FlightPaxCell.self),
           textField == cell.txtPassportNo {

            let allowedCharacters = CharacterSet.alphanumerics
            return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
        }

        // 👤 First & Last Name
        if let cell = textField.findSuperview(ofType: FlightPaxCell.self),
           (textField == cell.txtFirstName || textField == cell.txtLastName) {

            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
        }

        // 📞 Mobile
        if textField == tf_mobileNo || textField == tf_gst_phone {
            if string.isValidIntergerSet() == false {
                return false
            }
            let currentCount = textField.text?.count ?? 0
            let newLength = currentCount + string.count - range.length
            return newLength <= 10
        }

        return true
    }
    func dismissKeyboardMethod() {
        // resigns...
        tf_email.resignFirstResponder()
        tf_mobileNo.resignFirstResponder()
        tf_isdCode.resignFirstResponder()
        txt_promo.resignFirstResponder()
        tf_gst_number.resignFirstResponder()
        tf_gst_name.resignFirstResponder()
        tf_gst_email.resignFirstResponder()
        tf_gst_phone.resignFirstResponder()
        tf_gst_address.resignFirstResponder()
        tf_rewardPoints.resignFirstResponder()
    }
}


extension PassengersListVC: PassengerFormDelegate, countryDailCodeDelegate { //ISOCodeDelegate,
    
    // MARK: - PassengerFormDelegate
    func addOrUpdate_PassengersSending(Reload: Bool) {
        DispatchQueue.main.async {
            self.reloadTablesAndFrameAdjust()
        }
    }
    
    //    // MARK: - ISOCodeDelegate
    //    func countryISOCode(dial_code: [String : String]) {
    //
    //        countryISO_Dict = dial_code
    //        displayDialCode(dailCode: countryISO_Dict)
    //    }
    
    // MARK: - countryDailCodeDelegate
    func countryDailCode(dial_code: [String : String], nationality: [String : Any]) {
        if fieldTags == 14 {
            
            // nationality...
            if let country_name = dial_code["Country"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country = country_name
            }
            if let country_code = dial_code["ISOCode"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country_code = country_code
            }
            tblPassenger.reloadData()
            // ✅ Delay needed because table reload happens asynchronously
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        if let cell = self.tblPassenger.cellForRow(at: IndexPath(row: self.selectedIndex, section: 0)) as? FlightPaxCell {
//                            self.dobButton_Action(sender: cell.btnDOB, cell: cell)
//                        }
//                    }
        }
        else if fieldTags == 15 {
            
            if let country_name = dial_code["Country"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country = country_name
            }
            if let country_id = dial_code["ISOCode"] {
                DPassengerModel.allPassengerArray[selectedIndex].issued_country_code = country_id
            }
            
            tblPassenger.reloadData()
            // ✅ Delay needed because table reload happens asynchronously
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        if let cell = self.tblPassenger.cellForRow(at: IndexPath(row: self.selectedIndex, section: 0)) as? FlightPaxCell {
//                            self.dobButton_Action(sender: cell.btnPPE, cell: cell)
//                        }
//                    }
        }
        else {
            countryISO_Dict = dial_code
            displayDialCode(dailCode: countryISO_Dict)
        }

    }
}

extension PassengersListVC {
    
    // MARK: - API's
    func flightPreBooking_HTTPConnection() {
        
        let user_id = ""
        
        // params...
        var params:[String: Any] =
        [ "token_key": DFlightStopsModel.preBookingItem?.token_key! ?? "",// "bd34e11898f8ce4fc82a5fab60ddbf32",
          "Email": DPassengerModel.email_id,
          "ContactNo": tf_mobileNo.text ?? "",//"9960077482",// DPassengerModel.mobile_no,//"7795889630",
          "AddressLine1":"E-city",
          "City":"banglore",
          "PinCode":"4456666",
          "CountryCode":"IN",
          "CountryName":"India",
          "search_id": Int(DFlightSearchModel.search_id) ?? 0,//"2510",
          "total_amount_val": String.init(format: "%.0f", FinalBreakupModel.totalFare),//"72.00",
          "currency": DCurrencyModel.currency_saved?.currency_country ?? "INR",
          "currency_symbol":  DCurrencyModel.currency_saved?.currency_symbol ?? "$",//"$"
          "convenience_fee": String.init(format: "%.0f", baseConvenienceFare),//"0.00",
          "tax": String.init(format: "% .2f", FinalBreakupModel.gstFare),
          "promo_code_discount_val": String.init(format: "%.0f", FinalBreakupModel.discount),//"0.00",
          "promo_code": txt_promo.text ?? "",
          "customer_id": user_id.getUserId(),//"1297",
          "payment_method":"PNHB1",
          "Passengers": getPassengersNew(),
          "reward_discount_amt": String.init(format: "%.0f", FinalBreakupModel.rewardDiscount),
          "total_reward_amt": String.init(format: "%.0f", FinalBreakupModel.reward_total_fare),// "276.68",
          "total_used_points": String.init(format: "%.0f", FinalBreakupModel.total_used_points) ,//"10",
          "reward_promo_code": FinalBreakupModel.reward_promo_code,
          
        ]
        
        if isExpandedGst {
            params["gst_number"] = tf_gst_number.text ?? ""
            params["gst_company_name"] = tf_gst_name.text ?? ""
            params["gst_email"] = tf_gst_email.text ?? ""
            params["gst_phone"] = tf_gst_phone.text ?? ""
            params["gst_address"] = tf_gst_address.text ?? ""
            params["gst_state"] = lbl_gst_state.text ?? ""
            
            FinalBreakupModel.gstDetails.gst_address = tf_gst_address.text ?? ""
            FinalBreakupModel.gstDetails.gst_company_name = tf_gst_name.text ?? ""
            FinalBreakupModel.gstDetails.gst_email = tf_gst_email.text ?? ""
            FinalBreakupModel.gstDetails.gst_phone = tf_gst_phone.text ?? ""
            FinalBreakupModel.gstDetails.gst_address = tf_gst_address.text ?? ""
            FinalBreakupModel.gstDetails.gst_state = lbl_gst_state.text ?? ""
        }
        
        
        let param_tokens:[String: Any] = ["flight_token_table_id": DFlightStopsModel.preBookingItem?.flight_token_table_id ?? ""]
        
        //var paramString:[String: String] = [:]
        
        paramString["token"] = VKAPIs.getJSONString(object: param_tokens)
        paramString["flight_book"] = VKAPIs.getJSONString(object: params)
        paramString["search_ssr_hash"] =  DFlightStopsModel.preBookingItem?.search_hash ?? ""
        paramString["wallet_bal"] = VKAPIs.getJSONString(object: "off")
        
        if isSSR && !isSSRSeatSelected {
            paramString["booking_step"] = VKAPIs.getJSONString(object: "book")

            
            //            getExtraServices()
            //            DFlightAddOnsModel.createFightAddOnsModel(response_dict: data_dict)
            let destVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightAddOnsVC") as! FlightAddOnsVC
            destVC.gstSelected = isExpandedGst
            destVC.skipParam = paramString
            self.navigationController?.pushViewController(destVC, animated: true)
            //
            //            paramString["booking_step"] = "additional_ssr"
            //
            //            //DTravelModel.isPaymemt = true
            //
            //            // seat selection webview load here...
            //            let data = VKAPIs.shared.getDatafrom(params: paramString)
            //            let urlStr = String.init(format: "%@/%@",TMX_Base_URL, FLIGHT_PreBooking)
            //            print("Url: \(urlStr)")
            //            let url = URL(string: urlStr)!
            //            let request = VKAPIsClient().getRequestFormdata(url: url, httpMethod: .POST, httpBody: data)//.getRequestXwwwform(url: url!, httpMethod: .POST, httpBody: data)
            //
            //            // load url request...
            //            self.view_SSR.isHidden = false
            //            self.web_view_SSR.navigationDelegate = self
            //            web_view_SSR.load(request)
            //            return
        }
        else {
            
            paramString["booking_step"] = VKAPIs.getJSONString(object: "book")
            moveToReviewPage(params: paramString)
        }
    }
    
    // MARK: - Utilities
    func successMovements(info: [String: Any]) {
        
        self.SSRPaymentDict = info
        
        if let ssrDict = info["data"] as? [String: Any] {
            
            FinalBreakupModel.extraServicecharge = Float(String.init(describing: ssrDict["extra_services_total_price"]!))!
        }
        //        moveToReviewPage(params: params)
    }
    
    func moveToReviewPage(params: [String: String]) {
        
        // move to next screen...
        let fReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "FlightReviewVC") as! FlightReviewVC
        fReviewVC.paramString = params
        //fReviewVC.SSRPaymentDict = SSRPaymentDict
        //fReviewVC.isSSR = isSSR
        self.navigationController?.pushViewController(fReviewVC, animated: false)
    }
    func getPassengersNew() -> [Any] {
        
        // adding passenger information...
        var passenger_array: [[String: Any]] = []
        
        for model in DPassengerModel.allPassengerArray {
            
            var passenger: [String: Any] = ["Gender": model.gender_value ?? "1",
                                            "lead_passenger": "0",
                                            "passenger_type": model.person_type,
                                            "Title": model.title_value ?? "1",
                                            "FirstName": model.first_name!,
                                            "LastName": model.last_name!,
                                            "DateOfBirth": model.dateOf_birth ?? "",
                                            "PassportNumber": model.passport_no ?? "",
                                            "PassportExpiry": model.passport_expiry ?? "",
                                            "PassportIssueCountry": model.issued_country ?? "",
                                            //                     "selection": "1"
            ]
            
            if model.person_type == "Child" {
            }
            
            if model.person_type == "Infant" {
            }
            passenger_array.append(passenger)
        }
        
        passenger_array[0]["lead_passenger"] = "1"
        
        return passenger_array
    }
//    func getPassengers() -> [Any] {
//        
//        // adding passenger information...
//        var passenger_array: [[String: String]] = []
//        for model in DPassengerModel.adultArray {
//            if model.isSelected == true {
//                
//                let passenger: [String: String] =
//                
//                ["Gender": model.gender_value ?? "1",
//                 "lead_passenger": "0",
//                 "passenger_type": model.person_type,
//                 "Title": model.title_value ?? "1",
//                 "FirstName": model.first_name!,
//                 "LastName": model.last_name!,
//                 "DateOfBirth": model.dateOf_birth ?? "",
//                 "PassportNumber": model.passport_no ?? "",
//                 "PassportExpiry": model.passport_expiry ?? "",
//                 "PassportIssueCountry": "91",
//                 //                     "selection": "1"
//                ]
//                passenger_array.append(passenger)
//            }
//        }
//        
//        for model in DPassengerModel.childArray {
//            if model.isSelected == true {
//                
//                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
//                                                   "lead_passenger": "0",
//                                                   "passenger_type": model.person_type,
//                                                   "Title": model.title_value ?? "1",
//                                                   "FirstName": model.first_name!,
//                                                   "LastName": model.last_name!,
//                                                   "DateOfBirth": model.dateOf_birth ?? "",
//                                                   "PassportNumber": model.passport_no ?? "",
//                                                   "PassportExpiry": model.passport_expiry ?? "",
//                                                   "PassportIssueCountry": "91",
//                                                   //                                                   "selection": "1"
//                ]
//                passenger_array.append(passenger)
//            }
//        }
//        
//        for model in DPassengerModel.infantArray {
//            if model.isSelected == true {
//                
//                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
//                                                   "lead_passenger": "0",
//                                                   "passenger_type": model.person_type,
//                                                   "Title": model.title_value ?? "1",
//                                                   "FirstName": model.first_name!,
//                                                   "LastName": model.last_name!,
//                                                   "DateOfBirth": model.dateOf_birth ?? "",
//                                                   "PassportNumber": model.passport_no ?? "",
//                                                   "PassportExpiry": model.passport_expiry ?? "",
//                                                   "PassportIssueCountry": "91",
//                                                   //                                                   "selection": "1"
//                ]
//                passenger_array.append(passenger)
//            }
//        }
//        passenger_array[0]["lead_passenger"] = "1"
//        return passenger_array
//    }
}


extension PassengersListVC: UITableViewDataSource, UITableViewDelegate, passengerFormCellDelegate {

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DPassengerModel.allPassengerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FlightPaxCell") as? FlightPaxCell
        if cell == nil {
            tableView.register(UINib(nibName: "FlightPaxCell", bundle: nil), forCellReuseIdentifier: "FlightPaxCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FlightPaxCell") as? FlightPaxCell
        }

        // display information...
//        cell?.txtTitle.delegate = self
        cell?.txtFirstName.delegate = self
        cell?.txtLastName.delegate = self
//        cell?.txtGender.delegate = self
        cell?.txtPassportNo.delegate = self
//        cell?.txtNationality.delegate = self
//        cell?.txtDob.delegate = self
//        cell?.txtPassportNo.delegate = self
//        cell?.txtIssuingCountry.delegate = self
//        cell?.txtPPExpDate.delegate = self
        
//        cell?.txtTitle.tag = indexPath.row
        cell?.txtFirstName.tag = indexPath.row
        cell?.txtLastName.tag = indexPath.row
        cell?.txtGender.tag = indexPath.row
        cell?.txtPassportNo.tag = indexPath.row
        cell?.txtNationality.tag = indexPath.row
        cell?.txtDob.tag = indexPath.row
        cell?.txtPassportNo.tag = indexPath.row
        cell?.txtIssuingCountry.tag = indexPath.row
        cell?.txtPPExpDate.tag = indexPath.row
        
        cell?.lblPaxType.text = String.init(format: "%@",DPassengerModel.allPassengerArray[indexPath.row].title_form)
        cell?.displayPassenger_information(model: DPassengerModel.allPassengerArray[indexPath.row], isDomestic: isDomestic)
        cell?.delegate = self
        
        let passenger = DPassengerModel.allPassengerArray[indexPath.row]
        let titles = passenger.person_type == "Adult" ? ["Mr", "Mrs", "Ms"] : ["Mstr","Miss"]
        cell?.configure(with: titles, selected: passenger.title_name)

        cell?.onTitleChanged = { [weak self] title_name in
            DPassengerModel.allPassengerArray[indexPath.row].title_name = title_name
            DPassengerModel.allPassengerArray[indexPath.row].title_value = self?.getTitleId(title: title_name, personType: passenger.person_type)

        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    func getTitleId( title: String, personType: String) -> String? {
        
        let normalizedTitle = title.lowercased()
        let normalizedType = personType.lowercased()
        
//        if normalizedType == "adult" {
            switch normalizedTitle {
            case "mr": return "1"
            case "ms": return "2"
            case "miss": return "3"
            case "master": return "4"
            case "mrs": return "5"
            default: return ""
            }
//        } else {
//            // Child
//            switch normalizedTitle {
//            case "mstr": return "1"
//            case "miss": return "2"
//            default: return ""
//            }
//        }
    }
    
    // MARK: - passengerFormCellDelegate
    func titleButtion_Action(sender: UIButton, cell: UITableViewCell) {
        
        fieldTags = 12
        
        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        
        
 
        let mr = UIAction.init(title: "MR.") { _ in
  
            print("Mr Selected")
            DPassengerModel.allPassengerArray[self.selectedIndex].title_name = "MR."
            DPassengerModel.allPassengerArray[self.selectedIndex].gender_value = "Male"
            self.tblPassenger.reloadData()
        }
        let ms = UIAction.init(title: "MS.") { _ in
            print("Ms Selected")
            DPassengerModel.allPassengerArray[self.selectedIndex].title_name = "MS."
            DPassengerModel.allPassengerArray[self.selectedIndex].gender_value = "Female"
            self.tblPassenger.reloadData()
        }
        let mrs = UIAction.init(title: "MRS.") { _ in
            print("Mrs Selected")
            DPassengerModel.allPassengerArray[self.selectedIndex].title_name = "MRS."
            DPassengerModel.allPassengerArray[self.selectedIndex].gender_value = "Female"
            self.tblPassenger.reloadData()
        }
        
        let menu = UIMenu.init(title: "Select Title", children: [mr, ms, mrs])
        
        sender.showsMenuAsPrimaryAction = true
        sender.menu = menu
 
    }
    
    func genderButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        /*
        fieldTags = 13
        
        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        
        let male = UIAction.init(title: "Male") { _ in
  
            print("Male Selected")
            DPassengerModel.allPassengerArray[self.selectedIndex].gender = "Male"
            self.tblPassenger.reloadData()
        }
        let female = UIAction.init(title: "Female") { _ in
            print("Female Selected")
            DPassengerModel.allPassengerArray[self.selectedIndex].gender = "Female"
            self.tblPassenger.reloadData()
        }

        let menu = UIMenu.init(title: "Select Gender", children: [male, female])
        
        sender.showsMenuAsPrimaryAction = true
        sender.menu = menu
         */
    }
    
    func ppNationalityButton_Action(sender: UIButton, cell: UITableViewCell) {
        self.view.endEditing(true)

        fieldTags = 14
        
        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        // getting current position...
//        let parent_view = sender.superview
//        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let nextObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ISOCodeVC") as! ISOCodeVC
        nextObj.delegate = self
        nextObj.DCatType = .ISOCode
        nextObj.countries_array = countries_array
        self.present(nextObj, animated: true, completion: nil)
//        let nextObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CountryCodeVC") as! CountryCodeVC
//        if let presentationController = nextObj.presentationController as? UISheetPresentationController {
//            presentationController.detents = [.medium(), .large()] //.medium(),.large()
//            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false // Inside Scrolling
//            presentationController.prefersGrabberVisible = true // grabber button
//            presentationController.preferredCornerRadius = 24 // radius
//        }
//        nextObj.delegate = self
//        nextObj.DCatType = .Nationality
//        nextObj.countries_array = countryListArray
//        self.present(nextObj, animated: true)
    }
    
    func dobButton_Action(sender: UIButton, cell: UITableViewCell) {
        self.view.endEditing(true)

        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        
        let model = DPassengerModel.allPassengerArray[selectedIndex]
        let passType = model.person_type
        
        fieldTags = 10
        
        // date pop view...
        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
        picker_popView.delegate = self
        picker_popView.setDate(_date: sel_date)
        
        picker_popView.setMinimumDate(_date: gettingMinMaxDates(maxBool: false, pass_type: passType))
        picker_popView.setMaximumDate(_date: gettingMinMaxDates(maxBool: true, pass_type: passType))
        if model.person_type == "Infant" {
//            picker_popView.setMaximumDate(_date: NSDate() as Date)
        }
        
        self.view.addSubview(picker_popView)
    }
    
    func ppIssuingCountryButton_Action(sender: UIButton, cell: UITableViewCell) {
        self.view.endEditing(true)

        fieldTags = 15
        
        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        
//        // getting current position...
//        let parent_view = sender.superview
//        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
//        fieldRect.size.width = fieldRect.size.width
//
//        // table pop view...
//        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
//        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        tbl_popView.delegate_ppCountry = self
//        tbl_popView.DType = .PassPortCountry
//        tbl_popView.passport_array = countryListArray
//        tbl_popView.changeMainView_Frame(rect: fieldRect)
//        self.view.addSubview(tbl_popView)
        
        
        
    }
    
    func ppExpiryButton_Action(sender: UIButton, cell: UITableViewCell) {
        self.view.endEditing(true)

        let indexPath = tblPassenger?.indexPath(for: cell)
        selectedIndex = (indexPath?.row)!
        fieldTags = 11
        
        // date pop view...
        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
        picker_popView.delegate = self
        picker_popView.setDate(_date: Date())
        picker_popView.setMinimumDate(_date: gettingMinMaxDates(maxBool: true, pass_type: "PPExpiry"))
        self.view.addSubview(picker_popView)
    }
    
    func textFieldDidChange(textField: UITextField, cell: UITableViewCell) {
        
        // main actions...
        let loCell = cell as! FlightPaxCell
        let indexPath = tblPassenger?.indexPath(for: cell)
        
        if textField == loCell.txtFirstName {
            DPassengerModel.allPassengerArray[(indexPath?.row)!].first_name = textField.text
        }
        else if textField == loCell.txtLastName {
            DPassengerModel.allPassengerArray[(indexPath?.row)!].last_name = textField.text
        }
        else if textField == loCell.txtPassportNo {
            DPassengerModel.allPassengerArray[(indexPath?.row)!].passport_no = textField.text
        }

        else {}
    }
    
    func didTapReturn(textField: UITextField, cell: UITableViewCell) {
        
        print("MoveToNext")
        let paxCell = cell as! FlightPaxCell

        if textField == paxCell.txtFirstName {
            paxCell.txtLastName.becomeFirstResponder()
        }
        else if textField == paxCell.txtLastName {
            paxCell.txtPassportNo.becomeFirstResponder()
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
        }else if pass_type == "Infant" {
            if maxBool == true {
                // Newborn: youngest date (today)
                dateComponent = DateComponents(year: 0)
            } else {
                // Oldest possible infant: exactly 2 years ago
                dateComponent = DateComponents(year: -2)
            }
        }
        else if pass_type == "PPExpiry" {
            
            dateComponent.month = 6
        }
        else {
            dateComponent.year = -2
        }
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: DTravelModel.departDate)
        return futureDate
    }
  
}
