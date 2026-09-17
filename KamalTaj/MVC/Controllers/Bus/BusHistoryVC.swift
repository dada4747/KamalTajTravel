//
//  BusHistoryVC.swift
//  EasiTripBooking
//
//  Created by Nandu on 04/03/25.
//

import UIKit

class BusHistoryVC: UIViewController {
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var busArr:  [DBusHistoryItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        busMyBookings_APIConnection()
    }
    

    
    // MARK: - Helpers
    func addDelegate() {
    
        tblHistory.delegate = self
        tblHistory.dataSource = self
        tblHistory.rowHeight = UITableView.automaticDimension;
        tblHistory.estimatedRowHeight = 500
    }
    
    func displayBusBookingInfo(){
        busArr.removeAll()
        busArr = DBusBookingHistoryModel.bus_bookings

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

extension BusHistoryVC: UITableViewDelegate, UITableViewDataSource, BBookingCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
        if cell == nil {
            tableView.register(UINib(nibName: "BusHistoryCell", bundle: nil), forCellReuseIdentifier: "BusHistoryCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
        }
        cell?.displayBusList(busModel: busArr[indexPath.row])
        cell?.delegate = self
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - BBookingCellDelegate
    func viewBusBooking(model: DBusHistoryItem) {
        let url  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_voucher"
        let downloadUrl  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_pdf"
        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.ticket!)
    }
    
    func cancelBusBooking(model: DBusHistoryItem) {
        busCancel_APIConnection(model: model)
    }

}

extension BusHistoryVC {
    
    // MARK: - API's
    func busMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Bus_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                    DBusBookingHistoryModel.createBusHistoryModels(result_array: result_dict)
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Bus Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayBusBookingInfo()
        }
    }
    
    func busCancel_APIConnection(model: DBusHistoryItem){
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["book_id": model.app_reference ?? "",
                                        "booking_source": model.booking_source ?? ""]
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: "bus/cancel_booking_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Bus Cancel Booking Response: \(String(describing: resultObj))")

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
                    print("Bus Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }

            SwiftLoader.hide()
            self.busMyBookings_APIConnection()
        }
    }
}
