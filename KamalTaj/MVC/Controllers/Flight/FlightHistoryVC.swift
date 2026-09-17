//
//  FlightHistoryVC.swift
//  EasiTripBooking
//
//  Created by Nandu on 04/03/25.
//

import UIKit

class FlightHistoryVC: UIViewController, FBookingCellDelegate {
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var flightArr : [DFlightHistoryItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDelegate()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flightMyBookings_APIConnection()
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
    
    func displayFlightBookingInfo() {
        
        flightArr.removeAll()
        //MARK: - ToDo
        print(DFlightBookingHistoryModel.upcoming_flight_bookings.count)
        flightArr = DFlightBookingHistoryModel.upcoming_flight_bookings
        print(flightArr.count)
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


extension FlightHistoryVC: UITableViewDelegate, UITableViewDataSource/*, FBookingCellDelegate*/ {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
        if cell == nil {
            tableView.register(UINib(nibName: "FBookingCell", bundle: nil), forCellReuseIdentifier: "FBookingCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
        }

        cell?.displayFlightHistory_List(historyModel: flightArr[indexPath.row])
        cell?.delegate = self
        cell?.selectionStyle = .none
//        if bookingType == .Past {
//            cell?.btn_cancelBooking.isHidden = true
//        }

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - FBookingCellDelegate
    func cancelFlightBooking(model: DFlightHistoryItem) {
        
        let showAlert = UIAlertController.init(title: "Alert!", message: String.init(format: "Do you want cancel the booking"), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            // delete passenger...
            self.flightCancelApi(model: model)
        })
        showAlert.addAction(okAction)
        showAlert.addAction(UIAlertAction.init(title:  "No", style: .cancel, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    func viewFlighVoucher(model: DFlightHistoryItem) {
        
        let url = "\(TMX_Base_URL)/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
        let downloadUrl =  "\(TMX_Base_URL)/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
        navigateToVoucher(url: url,downloadUrl: downloadUrl, id: model.booking_id!)
    }
}

extension FlightHistoryVC {
    
    // MARK: - API's
    func flightMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Flight_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Flight Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        DFlightBookingHistoryModel.createFlightHistoryModels(result_array: result_dict)
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Flight Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayFlightBookingInfo()
        }
    }
    
    func flightCancelApi(model: DFlightHistoryItem){
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["app_reference": model.booking_id ?? "",
                                        "booking_source": model.booking_source ?? "","transaction_origin": model.origin ?? ""]
        var paramString:[String: String] = [:]
        paramString["flight_cancel"] = VKAPIs.getJSONString(object: params)
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_CancelBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Flight Cancel Booking Response: \(String(describing: resultObj))")

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
                    print("Flight Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }

            SwiftLoader.hide()
            self.flightMyBookings_APIConnection()
        }
    }
}
