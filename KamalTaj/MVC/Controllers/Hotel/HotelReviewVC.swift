//
//  HotelReviewVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import SDWebImageSVGCoder

class HotelReviewVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_checkIn: UILabel!
    @IBOutlet weak var lbl_checkOut: UILabel!
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    @IBOutlet weak var tbl_payment: UITableView!
    @IBOutlet weak var hei_paymentConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    
    // booking info...
    @IBOutlet weak var lbl_noOfRooms: UILabel!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var lbl_roomType: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    


    var passenger_array: [DHPassengerItem] = []
    var paymentMethod = "PNHB1"
    
    var paramString:[String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(paramString)
        displayInformationAndDelegates()
        reloadInformation()
    }
    
    // MARK:- Helpers
    func displayInformationAndDelegates() {
//        view.backgroundColor = .appColor
        // display...
        lbl_mobile.text = "\(DHPassengerModel.country_code["DialCode"] ?? "") \(DHPassengerModel.mobile_no)"
        lbl_emailId.text = DHPassengerModel.email_id
        
        lbl_checkIn.text = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkin_date)
        lbl_checkOut.text = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date)
        
        lbl_noOfRooms.text = "\(AddRoomModel.addRooms_array.count)"
        lbl_hotelName.text = DHPreBookingModel.hotelName
        lbl_hotelAddress.text = DHPreBookingModel.hotelAddress
        lbl_roomType.text = DHPreBookingModel.roomType
        
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        tbl_passengerDetails.contentInset = UIEdgeInsets.zero
        tbl_passengerDetails.sectionFooterHeight = 0
        if #available(iOS 15.0, *) {
            tbl_passengerDetails.sectionHeaderTopPadding = 0
        }
        tbl_payment.delegate = self
        tbl_payment.dataSource = self

    }
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_baseFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.baseFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_total.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ((FinalBreakupHotelModel.totalFare - FinalBreakupHotelModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_convenienceFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.gst * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_taxFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.convenienceFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_totalFare.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.baseFare + FinalBreakupHotelModel.gst + FinalBreakupHotelModel.convenienceFare) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        lbl_discount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.discount  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
    }
    
    func reloadInformation() {
        passenger_array = DHPassengerModel.allGuestsArray

        if DHPreBookingModel.activePaymentOptions.contains(where: { $0.method == paymentMethod }) == false,
           let first = DHPreBookingModel.activePaymentOptions.first?.method {

            paymentMethod = first
        }
        tbl_passengerDetails.reloadData()
        tbl_payment.reloadData()

        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 40) + 48)
        hei_paymentConstraint.constant = CGFloat((DHPreBookingModel.activePaymentOptions.count * 55) + 50)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        hotelPreBooking_HTTPConnection()
    }
    
}

extension HotelReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return 0

    }
    func numberOfSections(in tableView: UITableView) -> Int {

            return 1
    }
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_payment {
            return DHPreBookingModel.activePaymentOptions.count
        }

        return passenger_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_payment {
            return 55
        }

        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == tbl_payment {

            var cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            if cell == nil {
                tableView.register(UINib(nibName: "PaymentMethodcell", bundle: nil), forCellReuseIdentifier: "PaymentMethodcell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            }

            let option = DHPreBookingModel.activePaymentOptions[indexPath.row]
            cell?.lblPayment.text = option.name
//            cell?.imgPayment.sd_setImage(with: URL.init(string: DBusResultModel.activePaymentOptions[indexPath.row].imgurl))
//            print(DHPreBookingModel.activePaymentOptions[indexPath.row].imgurl)
//            print(URL(string: DHPreBookingModel.activePaymentOptions[indexPath.row].imgurl))
//            cell?.imgPayment.sd_setImage(
//                with: URL(string: DHPreBookingModel.activePaymentOptions[indexPath.row].imgurl)
//            )
            let urlString = DHPreBookingModel.activePaymentOptions[indexPath.row].imgurl

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
            if paymentMethod == DHPreBookingModel.activePaymentOptions[indexPath.row].method {
                cell?.imgSelection.image = UIImage(named: "ic_radio_selected")
            }

            cell?.selectionStyle = .none
            return cell!
        }

        var cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        if cell == nil {
            tableView.register(UINib(nibName: "HPassengerCell", bundle: nil), forCellReuseIdentifier: "HPassengerCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        }
        cell?.view_display.isHidden = false

        let model = passenger_array[indexPath.row]
        cell?.lbl_displayName.text = String(format: "%d.  %@ %@ %@", indexPath.row+1, model.title_name!, model.first_name!,  model.last_name!)

        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == tbl_payment {
            paymentMethod = DHPreBookingModel.activePaymentOptions[indexPath.row].method
            tbl_payment.reloadData()
        }
    }
    
}

extension HotelReviewVC {
    
    // MARK:- API's
    func hotelPreBooking_HTTPConnection() {
        print(paramString)

//        if paymentMethod != "PNHB1" {
//            let jsonStr = paramString["hotel_book"] ?? ""
//            var params = VKAPIs.getObject(jsonString: jsonStr) as? [String: Any] ?? [:]
//            params["payment_method"] = paymentMethod
//
//            paramString["hotel_book"] = VKAPIs.getJSONString(object: params)
//            
//            let jsonStr2 = paramString["hotel_params"] ?? ""
//            var params2 = VKAPIs.getObject(jsonString: jsonStr2) as? [String: Any] ?? [:]
//            params2["payment_method"] = paymentMethod
//
//            paramString["hotel_params"] = VKAPIs.getJSONString(object: params2)
//
//        }
        let jsonStr = paramString["hotel_book"] ?? ""

        var params =

        VKAPIs.getObject(jsonString: jsonStr)

        as? [String: Any] ?? [:]

        params["payment_method"] = paymentMethod

        paramString["hotel_book"] =

        VKAPIs.getJSONString(object: params)

        let jsonStr2 = paramString["hotel_params"] ?? ""

        var params2 =

        VKAPIs.getObject(jsonString: jsonStr2)

        as? [String: Any] ?? [:]

        params2["payment_method"] = paymentMethod

        paramString["hotel_params"] =

        VKAPIs.getJSONString(object: params2)

        CommonLoader.shared.startLoader(in: view)
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Pre_Booking, httpMethod: .POST)
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
