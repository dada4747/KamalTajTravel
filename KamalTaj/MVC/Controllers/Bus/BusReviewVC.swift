//
//  BusReviewVC.swift
//  EasiTripBooking
//
//  Created by Admin on 20/11/25.
//

import UIKit
import SDWebImageSVGCoder

class BusReviewVC: UIViewController {
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_travelDateTime: UILabel!
    @IBOutlet weak var lbl_bus_name: UILabel!
    @IBOutlet weak var lbl_bus_type: UILabel!

    @IBOutlet weak var lbl_travellerTime: UILabel!
    @IBOutlet weak var lbl_pickUpCity: UILabel!
    @IBOutlet weak var lbl_pickUpDate: UILabel!
    @IBOutlet weak var lbl_pickUpTime: UILabel!
    @IBOutlet weak var lbl_dropOffCity : UILabel!
    @IBOutlet weak var lbl_dropOffDate : UILabel!
    @IBOutlet weak var lbl_dropOffTime : UILabel!
    
    @IBOutlet weak var lbl_noOfSeats : UILabel!
    @IBOutlet weak var lbl_seatsNumbers : UILabel!
    
    @IBOutlet weak var lbl_total_Fare : UILabel!
    @IBOutlet weak var lbl_discount : UILabel!
    @IBOutlet weak var lbl_finalFare : UILabel!
    @IBOutlet weak var lbl_gst: UILabel!
    
    @IBOutlet weak var lbl_convenience_fee: UILabel!
    
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_payment: UITableView!
    @IBOutlet weak var hei_paymentConstraint: NSLayoutConstraint!
    
//    var paymentArray: [[String: String]] = {["name": "Mint", "method": "PNHB1"],"imgurl":""
//                                            ["name": "CommonwealthBank", "method": "PNHBB1", "imgurl":""],
//                                            ["name": "Razorpay", "method": "PNHB3", "imgurl":""],
//                                            ["name":"CommercialBank","method":"PNHB4", "imgurl":""]}
    var paymentMethod = "PNHB1"
    
    var passenger_array: [Int : String] = [:]
    
    var params:[String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInformationAndDelegates()
        reloadInformation()
        
        // bottom shadow...
        view_header.viewShadow()

        // Do any additional setup after loading the view.
    }
    func displayInformationAndDelegates() {
        self.lbl_emailId.text = PassengerInfo.email
        self.lbl_mobile.text = PassengerInfo.mobileNumber
         
        self.lbl_pickUpCity.text = DBusResultModel.selectedBus?.From
        self.lbl_dropOffCity.text = DBusResultModel.selectedBus?.To

        self.lbl_bus_name.text = DBTravelModel.selectdBus.CompanyName
        self.lbl_bus_type.text = DBTravelModel.selectdBus.BusTypeName
        lbl_travellerTime.text = DBTravelModel.selectdBus.Duration
        let deptDateTime = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: (DBTravelModel.selectdBus.DeptTime)!)
        self.lbl_pickUpDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: deptDateTime)
        self.lbl_pickUpTime.text = DateFormatter.getDateString(formate: "hh:mm a", date: deptDateTime)
        
        let arrDateTime = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: (DBTravelModel.selectdBus.ArrTime)!)
        self.lbl_dropOffDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrDateTime)
        self.lbl_dropOffTime.text = DateFormatter.getDateString(formate: "hh:mm a", date: arrDateTime)

        self.lbl_travelDateTime.text = DateFormatter.getDateString(formate: "dd MMM yyyy, hh:mm a", date: deptDateTime)

        self.lbl_noOfSeats.text = "No. of Seats \(DBusResultModel.bus_Selected_Seats_list.count)"
        let count = DBusResultModel.bus_Selected_Seats_list.map{String($0!.seatIndex) + "(\($0!.seatName ))"}
        
        self.lbl_seatsNumbers.text = count.joined(separator: ",")
        
        self.lbl_total_Fare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.bus_final_total_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        self.lbl_discount.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.bus_discount)
        
        self.lbl_finalFare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", ((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)) - DBusResultModel.bus_discount)
        
        self.lbl_gst.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.gst * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        self.lbl_convenience_fee.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", DBusResultModel.convenienceFee * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        
        tbl_payment.delegate = self
        tbl_payment.dataSource = self

        
    }
    func reloadInformation() {
        
        passenger_array = PassengerInfo.firstName
//        passenger_array = PassengerInfo.lastName
        
        tbl_passengerDetails.reloadData()
        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 35) + 40)
        
        tbl_payment.reloadData()
        hei_paymentConstraint.constant = CGFloat((DBusResultModel.activePaymentOptions.count * 55) + 50)
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        BusPreBooking_HTTPConnection()
    }
}
extension BusReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_payment {
            return DBusResultModel.activePaymentOptions.count
        }
        else {
            return passenger_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tbl_payment {
            return 55
        }
        else {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_payment {
            
//             cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            if cell == nil {
                tableView.register(UINib(nibName: "PaymentMethodcell", bundle: nil), forCellReuseIdentifier: "PaymentMethodcell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodcell") as? PaymentMethodcell
            }
            
            // display information...
            cell?.lblPayment.text = DBusResultModel.activePaymentOptions[indexPath.row].name
//            cell?.imgPayment.sd_setImage(with: URL.init(string: DBusResultModel.activePaymentOptions[indexPath.row].imgurl))
            let urlString = DBusResultModel.activePaymentOptions[indexPath.row].imgurl

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
            if paymentMethod == DBusResultModel.activePaymentOptions[indexPath.row].method {
                cell?.imgSelection.image = UIImage(named: "ic_radio_selected")
            }
            
            
            cell?.selectionStyle = .none
            return cell!
        }
        else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
            if cell == nil {
                tableView.register(UINib(nibName: "HPassengerCell", bundle: nil), forCellReuseIdentifier: "HPassengerCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
            }
            cell?.view_display.isHidden = false
            
            // display information...
            if tableView == tbl_passengerDetails {
                let firstName = PassengerInfo.firstName[indexPath.row] ?? ""
                let lastName = PassengerInfo.lastName[indexPath.row] ?? ""
                let title = PassengerInfo.nameTitle[indexPath.row] ?? ""
                cell?.lbl_displayName.text = "\(indexPath.row + 1). \(title) \(firstName) \(lastName)"
            }
            else {}
            
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tbl_payment {
            paymentMethod = DBusResultModel.activePaymentOptions[indexPath.row].method
            tbl_payment.reloadData()
        }
    }
    
}

// MARK: - API's
extension BusReviewVC {
func BusPreBooking_HTTPConnection() {
    SwiftLoader.show(animated: true)
    params["payment_method"] = paymentMethod
    var paramString: [String:String] = [:]
    paramString["confirm_book"] = VKAPIs.getJSONString(object: params)

    // calling apis...
    VKAPIs.shared.getRequestXwwwform(params: paramString, file: "bus/pre_booking_mobile", httpMethod: .POST)
    { (resultObj, success, error) in
        
        // success status...
        if success == true {
            print("Bus Pre Book success: \(String(describing: resultObj))")
            
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
                print("Bus Pre Book formate : \(String(describing: resultObj))")
            }
        } else {
            print("Bus Pre Book error : \(String(describing: error?.localizedDescription))")
        }
        SwiftLoader.hide()
    }
}
}
