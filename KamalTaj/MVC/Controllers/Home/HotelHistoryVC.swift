//
//  HotelHistoryVC.swift
//  EasiTripBooking
//
//  Created by Nandu on 04/03/25.
//

import UIKit

class HotelHistoryVC: UIViewController {
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var hotelArr : [DHotelHistoryItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hotelMyBookings_APIConnection()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helpers
    func addDelegate() {
    
        tblHistory.delegate = self
        tblHistory.dataSource = self
        tblHistory.rowHeight = UITableView.automaticDimension;
        tblHistory.estimatedRowHeight = 500
    }
    
    func displayHotelBookingInfo() {
        hotelArr.removeAll()
        hotelArr = DHotelBookingHistoryModel.upcoming_hotel_bookings
        tblHistory.reloadData()
    }
    
    func navigateToVoucher(url: String, downloadUrl: String, id: String){
        
        let pay_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HistoryVoucherVC") as! HistoryVoucherVC
        pay_vc.payment_url = url
        pay_vc.download_url = downloadUrl
        pay_vc.booking_id = id
        self.navigationController?.pushViewController(pay_vc, animated: true)
    }

}


extension HotelHistoryVC: UITableViewDelegate, UITableViewDataSource, HBookingCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HBookingCell") as? HBookingCell
        if cell == nil {
            tableView.register(UINib(nibName: "HBookingCell", bundle: nil), forCellReuseIdentifier: "HBookingCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HBookingCell") as? HBookingCell
        }
        // display information...
        cell?.displayHotelBooking(model: hotelArr[indexPath.row])
        
        cell?.delegate = self
        cell?.selectionStyle = .none
//        if bookingType == .Past {
//            cell?.btn_cancelBooking.isHidden = true
//        }

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - HBookingCellDelegate
    func viewHotelVoucher(model: DHotelHistoryItem) {
        
        let url  = "\(TMX_Base_URL)/voucher/hotel/\(model.app_reference!)/\(model.bookingSource!)/\(model.status!)/show_voucher"
        let downloadUrl  = "\(TMX_Base_URL)/voucher/hotel/\(model.app_reference!)/\(model.bookingSource!)/\(model.status!)/show_pdf"
        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    
    func cancelBooking(model: DHotelHistoryItem) {
        let showAlert = UIAlertController.init(title: "Alert!", message: String.init(format: "Do you want cancel the booking"), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            // delete passenger...
            self.hotelCancel_APIConnection(model: model)
        })
        showAlert.addAction(okAction)
        showAlert.addAction(UIAlertAction.init(title:  "No", style: .cancel, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
    

}

extension HotelHistoryVC {
    
    // MARK: - Api's
    func hotelMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Hotel_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        
                    DHotelBookingHistoryModel.createHotelHistoryModels(result_array: result_dict)
                        
//                        if let hotel_dict = result_dict["hotels"] as? [String: Any] {
//                            if let data_dict = hotel_dict["data"] as? [String: Any] {
//                                if let data_array = data_dict["booking_details"] as? [[String: Any]] {
//                                    DBookingHistoryModel.createHotelMyBookingsModels(result_array: data_array)
//                                }
//                            }
//                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayHotelBookingInfo()
        }
    }
    
    func hotelCancel_APIConnection(model: DHotelHistoryItem){
//        let user_id = ""
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["book_id": model.app_reference ?? "",
                                        "booking_source": model.bookingSource ?? ""]
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: "hotel/cancel_booking_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Hotel Cancel Booking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.hotelMyBookings_APIConnection()
        }
    }
}
