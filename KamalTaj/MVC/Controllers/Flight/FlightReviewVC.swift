//
//  FlightReviewVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import SDWebImageSVGCoder
class FlightReviewVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var tbl_flightDetails: UITableView!
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    @IBOutlet weak var tbl_payment: UITableView!
    
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    @IBOutlet weak var hei_flightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hei_paymentConstraint: NSLayoutConstraint!
    
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
    @IBOutlet weak var lbl_rewardDiscount: UILabel!

    @IBOutlet weak var view_discount: UIView!
    @IBOutlet weak var view_discount_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_rewardDiscount: UIView!
    @IBOutlet weak var view_rewardDiscount_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_totalAmount: CustomFontLabel!

//    @IBOutlet weak var btn_applyPromo: CRButton!
//    
//    @IBOutlet weak var btn_selectPromo: UIButton!
//    @IBOutlet weak var btn_cancelPromo: CRButton!
//    @IBOutlet weak var txt_promo: UITextField!
//
//    
//    var selectedPromo: DCommonTopOfferItems?
//    var baseConvenienceFare: Float = FinalBreakupModel.convenienceFare

    
    var passenger_array: [DPassengerItem] = []
    var flight_details_array: [DFlightStopsItem] = []
    

    var paymentMethod = "PNHB1"
 
    
    var paramString:[String:String] = [:]
    var SSRPaymentDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .appColor
        displayInformationAndDelegates()
        reloadInformation()
//        btn_cancelPromo.isHidden = true
//        self.btn_selectPromo.isHidden = false

    }
    
    // MARK:- Helpers
    func displayInformationAndDelegates() {
        // display...
        lbl_mobile.text = "\(DPassengerModel.country_code["DialCode"] ?? "") \(DPassengerModel.mobile_no)"
        lbl_emailId.text = DPassengerModel.email_id
        
        
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        
        tbl_flightDetails.delegate = self
        tbl_flightDetails.dataSource = self
        tbl_payment.delegate = self
        tbl_payment.dataSource = self
  
    }
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_baseFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", FinalBreakupModel.baseFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// String.init(format: "%@ %.0f", FinalBreakupModel.currency, FinalBreakupModel.baseFare)
        lbl_taxFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", FinalBreakupModel.totalTax * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String.init(format: "%@ %.0f", FinalBreakupModel.currency, FinalBreakupModel.totalTax)
        
        lbl_totalFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", ((FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare) -  FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)) // String.init(format: "%@ %.0f", FinalBreakupModel.currency, FinalBreakupModel.totalFare)
        
        lbl_gstFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", FinalBreakupModel.gstFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// String.init(format: "%@ %.0f", FinalBreakupModel.currency, FinalBreakupModel.gstFare)
        lbl_convenienceFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", FinalBreakupModel.convenienceFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_discount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) //* (DCurrencyModel.currency_saved?.currency_value ?? 1.0)
        lbl_extraService.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", 0.0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        if DFlightStopsModel.flightTrip_array.count != 0 {
            lbl_checkInBaggage.text = DFlightStopsModel.flightTrip_array[0].baggage
            lbl_handBaggage.text = DFlightStopsModel.flightTrip_array[0].cabin_baggage
        }
        

        var price: Float = 0.0
        price = ( FinalBreakupModel.seatsFare + FinalBreakupModel.mealsFare + FinalBreakupModel.baggageFare)
        lbl_extraService.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_totalAmount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD",((FinalBreakupModel.totalFare + price) - FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))

        lbl_totalFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", ((FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare + price)  -  FinalBreakupModel.discount - FinalBreakupModel.rewardDiscount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
       
        if FinalBreakupModel.discount == 0.0 {
            view_discount.isHidden = true
            view_discount_HConstraint.constant = 0
        }else{
            view_discount.isHidden = false
            view_discount_HConstraint.constant = 30
            lbl_discount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        }
        if FinalBreakupModel.rewardDiscount == 0.0 {
            view_rewardDiscount.isHidden = true
            view_rewardDiscount_HConstraint.constant = 0
        }else{
            view_rewardDiscount.isHidden = false
            view_rewardDiscount_HConstraint.constant = 30
            lbl_rewardDiscount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (FinalBreakupModel.rewardDiscount  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        }

        
    }
    
    func reloadInformation() {

        flight_details_array = DFlightStopsModel.flightTrip_array
        passenger_array = DPassengerModel.allPassengerArray

        if DFlightStopsModel.activePaymentOptions.contains(where: { $0.method == paymentMethod }) == false,
           let first = DFlightStopsModel.activePaymentOptions.first?.method {

            paymentMethod = first
        }
        tbl_passengerDetails.reloadData()
        tbl_flightDetails.reloadData()
        tbl_payment.reloadData()

        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 35) + 40)
        hei_flightConstraint.constant = CGFloat((flight_details_array.count * 200) + 40)
        hei_paymentConstraint.constant = CGFloat((DFlightStopsModel.activePaymentOptions.count * 55) + 50)
    }
    
    // MARK: - ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        //        removePromo()
        //
        //        FinalBreakupModel.discount = 0.0

        self.navigationController?.popViewController(animated: true)

    }
//    @IBAction func selectPromoAction(_ sender: Any) {
//        
//        let flightPromo = DCommonModel.topOffer_Array.filter{ $0.module == "flight"}
//        if flightPromo.count == 0 {
//            self.view.makeToast(message: "No Promocode available ")
//        }else {
//            let filterObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "ApplyPromoCodeVC") as! ApplyPromoCodeVC
//            filterObj.modalPresentationStyle = .fullScreen
//            filterObj.promoCodeArray = flightPromo
//            filterObj.promoCodeDelegate = self
//            self.present(filterObj, animated: true, completion: nil)
//        }
//        
//    }
//    @IBAction func cancelPRomoAction(_ sender: Any) {
//        baseConvenienceFare = FinalBreakupModel.convenienceFare
//
//        self.btn_selectPromo.isHidden = false
//        txt_promo.text = nil
//        btn_cancelPromo.isHidden = true
//        btn_applyPromo.setTitle("APPLY", for: .normal)
//        FinalBreakupModel.discount = 0.0
//        self.displayBookingPriceInfo()
//        
//    }
//    @IBAction func promoBtnClicked(_ sender: Any) {
//        aplyPromo()
//        
//    }
//    func removePromo() {
//        FinalBreakupModel.discount  = 0.0
//        baseConvenienceFare = FinalBreakupModel.convenienceFare
//        selectedPromo = nil
//        self.btn_applyPromo.setTitle("APPLY", for: .normal)
//        self.btn_cancelPromo.isHidden = true
//        self.btn_selectPromo.isHidden = false
//        self.txt_promo.text = nil
//        self.view.makeToast(message: "Promo Code Not Valid for this booking")
//        self.displayBookingPriceInfo()
//        FinalBreakupModel.promoCode = ""
//    }
//    func appliedPromo() {
//        print(FinalBreakupModel.convenienceFare)
//        self.btn_applyPromo.setTitle("APPLIED", for: .normal)
//        self.btn_cancelPromo.isHidden = false
//        self.btn_selectPromo.isHidden = true
//        self.view.makeToast(message: "Promo Code Applied Successfully")
//        self.displayBookingPriceInfo()
//        FinalBreakupModel.promoCode = txt_promo.text ?? ""
//    }
//    func aplyPromo(){
//        print(txt_promo.text?.isEmpty)
//        if (txt_promo.text?.isEmpty == true) {
//            self.view.makeToast(message: "Please select promo code")
//        } else {
//            SwiftLoader.show(animated: true)
//            
//            let userId = ""
//            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"flight","total_amount_val":FinalBreakupModel.totalFare,"user_id":userId.getUserId(),"email": DPassengerModel.email_id ?? "","convenience_fee": FinalBreakupModel.convenienceFare,"currency":"INR","search_id": DFlightSearchModel.search_id ]
//            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
//            
//            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
//                if success == true {
//                    print("Promo code success responce: \(String(describing: resultObj))")
//                    
//                    if let result = resultObj as? [String: Any] {
//                        if result["status"] as? Bool == true {
//                            
//                            // response data...
//                            // print(result["discount_value"] as! String)
//                            
//                            var value: Float = 0.0
//                            value = Float(String.init(describing: result["discount_value"]!))!
//                            
//                            
//                            //let value = Float(result["discount_value"] as? String ?? "0.0")
//                            
//                            if  FinalBreakupModel.totalFare <= (self.selectedPromo?.minimum_amount ?? 0.0)! || (value > FinalBreakupModel.totalFare) {
//                                self.removePromo()
//                                
//                            }else {
//                                FinalBreakupModel.discount  = value
//                                self.baseConvenienceFare = Float(String.init(describing: result["convenience_fee"]!))!//Float(result["discount_value"] as! String)!
//                                self.appliedPromo()
//                            }
//                        } else {
//                            
//                            // error message...
//                            if let message_str = result["message"] as? String {
//                                self.view.makeToast(message: message_str)
//                            }
//                        }
//                    } else {
//                        print("Promo code formate : \(String(describing: resultObj))")
//                    }
//                }
//                SwiftLoader.hide()
//                
//            }
//            
//        }
//    }

    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        
        //self.view.makeToastActivity(message: "In Progress...")
        flightPreBooking_HTTPConnection()
    }
    
}

extension FlightReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_passengerDetails  {
            return passenger_array.count
        }
        else if tableView == tbl_payment {
            return DFlightStopsModel.activePaymentOptions.count
        }
        else {
            return flight_details_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tbl_passengerDetails  {
            return 35
        }
        else if tableView == tbl_payment {
            return 55
        }
        else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_payment {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            if cell == nil {
                tableView.register(UINib(nibName: "PaymentMethodcell", bundle: nil), forCellReuseIdentifier: "PaymentMethodcell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            }

            // display information...
            cell?.lblPayment.text = DFlightStopsModel.activePaymentOptions[indexPath.row].name
//            cell?.imgPayment.image = UIImage(named: paymentArray[indexPath.row]["name"] ?? "")
//            cell?.imgPayment.sd_setImage(with: URL.init(string: DFlightStopsModel.activePaymentOptions[indexPath.row].imgurl))
            let urlString = DFlightStopsModel.activePaymentOptions[indexPath.row].imgurl

            print("SVG URL:", urlString)

            cell?.imgPayment.image = nil
            cell?.imgPayment.contentMode = .scaleAspectFit

            if let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedURL) {

                cell?.imgPayment.sd_setImage(
                    with: url,
                    placeholderImage: nil,
                    options: [.refreshCached],
                    context: [.imageCoder : SDImageSVGCoder.shared]
                ) { image, error, cacheType in

                    print("SVG Image:", image as Any)
                    print("SVG Error:", error as Any)
                }
            }
            cell?.imgSelection.image = UIImage(named: "ic_radio")
            if paymentMethod == DFlightStopsModel.activePaymentOptions[indexPath.row].method {
                cell?.imgSelection.image = UIImage(named: "ic_radio_selected")
            }


            cell?.selectionStyle = .none
            return  cell!
        } else if tableView == tbl_passengerDetails {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
            if cell == nil {
                tableView.register(UINib(nibName: "PassengerCell", bundle: nil), forCellReuseIdentifier: "PassengerCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
            }
            cell?.view_display.isHidden = false
            
            // display information...
            if tableView == tbl_passengerDetails {
                let model = passenger_array[indexPath.row]
                cell?.lbl_displayName.text = String(format: "%d.  %@ %@ %@", indexPath.row+1,  model.title_name!, model.first_name!,  model.last_name!)
            }
            else {}
            
            cell?.selectionStyle = .none
            return cell!
            
        }
        else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FStopsDetailsCell") as? FStopsDetailsCell
            if cell == nil {
                tableView.register(UINib(nibName: "FStopsDetailsCell", bundle: nil), forCellReuseIdentifier: "FStopsDetailsCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FStopsDetailsCell") as? FStopsDetailsCell
            }
            
            // display information...
            cell?.displayStops_information(stopModel: flight_details_array[indexPath.row])
            cell?.bg_view.layer.borderWidth = 0
            cell?.bg_view.layer.borderColor = UIColor.clear.cgColor
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tbl_payment {
            paymentMethod = DFlightStopsModel.activePaymentOptions[indexPath.row].method
            tbl_payment.reloadData()
        }
    }

}
//


extension FlightReviewVC {
    
    // MARK: - API's
    func flightPreBooking_HTTPConnection() {

        if let payment_url = SSRPaymentDict["retun_url"] as? String {
            
//            // move to payment...
//            let pay_vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentGatewayVC") as! PaymentGatewayVC
//            pay_vc.payment_url = payment_url
//            self.navigationController?.pushViewController(pay_vc, animated: true)
        }
        else {
            
            if paymentMethod != "PNHB1" {
                let jsonStr = paramString["flight_book"] ?? ""
                var params = VKAPIs.getObject(jsonString: jsonStr) as? [String: Any] ?? [:]
                params["payment_method"] = paymentMethod
                
                paramString["flight_book"] = VKAPIs.getJSONString(object: params)
            }

            SwiftLoader.show(animated: true)
            // calling apis...
            var urlString = ""
            if FLIGHT_PreBooking.contains("http") || FLIGHT_PreBooking.contains("https") {
                urlString = FLIGHT_PreBooking
            } else {
                urlString = "\(TMX_Base_URL)/\(FLIGHT_PreBooking)"
            }
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_PreBooking, httpMethod: .POST)
            { (resultObj, success, error) in
                
                // success status...
                if success == true {
                    print("Flight Pre Book success: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response date...
                            if let data_dict = result["data"] as? [String: Any] {
                                
                                // move to payment...
                                let pay_vc = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightPaymentVC") as! FlightPaymentVC
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
                        print("Flight Pre Book formate : \(String(describing: resultObj))")
                    }
                } else {
                    print("Flight Pre Book error : \(String(describing: error?.localizedDescription))")
                }
                SwiftLoader.hide()
            }
        }
    }
}
//extension FlightReviewVC: PromoCodeDelegate {
//    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
//        
//        selectedPromo = promoCode
//        txt_promo.text = promoCode.promoCode
//    }
//    
//
//}
