//
//  SelectRoomListVC.swift
//  Hoetus
//
//  Created by Rahul on 28/02/24.
//

import UIKit
extension SelectRoomListVC: hRoomsListCellDelegate {
    func cancelPolicy_Action(sender: UIButton, cell: UITableViewCell) {
        guard let indexPath = tbl_rooms.indexPath(for: cell) else { return }

        let html = rooms_array[indexPath.row].cancel_policy

        let alert = UIAlertController(title: "Cancellation Policy", message: nil, preferredStyle: .alert)

        // Convert HTML → Attributed String
        if let data = html?.data(using: .utf8) {
            if let attrStr = try? NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            ) {

                // Apply custom font to whole message
                let fullRange = NSRange(location: 0, length: attrStr.length)
                attrStr.addAttributes([
                    NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)!,
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ], range: fullRange)

                // set as alert message
                alert.setValue(attrStr, forKey: "attributedMessage")
            }
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
//    func cancelPolicy_Action(sender: UIButton, cell: UITableViewCell) {
//        let indexPath = tbl_rooms.indexPath(for: cell)
//        var msg = rooms_array[(indexPath?.row)!].cancel_policy
//        //        let str =  RoomCancelPolicy.generateCancellationPoliciesString(from: msg)
//        
//        let alert = UIAlertController(title: "Cancellation Policy",
//                                      message: msg,
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true)
//        
//    }
    
    func roomSeletion_Action(sender: UIButton, cell: UITableViewCell) {
        let indexPath = tbl_rooms.indexPath(for: cell)
        roomSelect_index = (indexPath?.row)!
        tbl_rooms.reloadData()
        showRoomDetails()
    }}
class SelectRoomListVC: UIViewController {
    
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_hotel_name: UILabel!
    @IBOutlet weak var lbl_checkInDate: UILabel!
    @IBOutlet weak var lbl_checkOutDate: UILabel!
    @IBOutlet weak var lbl_roomCount: UILabel!
    @IBOutlet weak var lbl_guestCount: UILabel!
    @IBOutlet weak var tbl_rooms: UITableView!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    var rooms_array: [DHotelRoomItem] = []
    var roomSelect_index = 0
    var hotelDetail_model = DHotelDetailsModel()
    var select_hotel: DHotelSearchItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_header.viewShadow()
        
        tbl_rooms.delegate = self;
        tbl_rooms.dataSource = self;
        tbl_rooms.rowHeight = UITableView.automaticDimension;
        tbl_rooms.estimatedRowHeight = 310
        showHotelDetails()
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        
        let roomModel = rooms_array[roomSelect_index]
        DHTravelModel.select_room = roomModel
        DHTravelModel.grand_total = Float(roomModel.room_price)
        
        hotelsRoomBlock_Booking()
    }
    
    func showHotelDetails(){
        lbl_hotel_name.text = select_hotel?.hotel_name
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "dd MMM", date: DHTravelModel.checkin_date)
        lbl_checkOutDate.text = DateFormatter.getDateString(formate: "dd MMM", date: DHTravelModel.checkout_date)
        lbl_roomCount.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guestCount.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests, "
        showRoomDetails()
    }
    func showRoomDetails(){
        let roomModel = rooms_array[roomSelect_index]
        
        lbl_grandTotal.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(roomModel.room_price)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        DispatchQueue.main.async {
            self.tbl_rooms.reloadData()
        }
        
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SelectRoomListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rooms_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomsListCell") as? HotelRoomsListCell
        if cell == nil {
            tableView.register(UINib(nibName: "HotelRoomsListCell", bundle: nil), forCellReuseIdentifier: "HotelRoomsListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomsListCell") as? HotelRoomsListCell
        }
        // selection colors...
        if roomSelect_index == indexPath.row {
            cell?.view_background.borderColor = UIColor(hexString: "#FF8A37")
            cell?.view_background.backgroundColor = UIColor(hexString: "#F4F5F9")
            cell?.view_selected.backgroundColor = .white
            cell?.img_selectImg.image = UIImage(named: "ic_circle_fillc")
        }else {
            cell?.view_selected.backgroundColor = UIColor(hexString: "#F4F5F9")
            cell?.view_background.backgroundColor = .white
            cell?.view_background.borderColor = UIColor(hexString: "#E5E5E5")
            cell?.img_selectImg.image = UIImage(named: "ic_circle")
        }
        let model = rooms_array[indexPath.row]
        cell?.displayRooms_information(rModel: model)
        cell?.delegate = self
        
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        roomSelect_index = indexPath.row
        
        DispatchQueue.main.async {
            self.tbl_rooms.reloadData()
        }
        
        showRoomDetails()
    }
}

extension SelectRoomListVC  {
    func hotelsRoomBlock_Booking() {
        
        SwiftLoader.show(animated: true)
        var image_url = ""
        if hotelDetail_model.media_array.count != 0 {
            image_url = hotelDetail_model.media_array[0]
        }
        let  final_url = VKAPIs.getJSONString(object: image_url)
        print(final_url)
        print(select_hotel?.hotel_code ?? "")
        // params...
        let params: [String: String] = ["HotelName": hotelDetail_model.hotelName,
                                        "HotelCode":"\( select_hotel?.hotel_code ?? "")",
                                        "HotelImage": final_url,
                                        "HotelAddress": hotelDetail_model.address,
                                        "StarRating": hotelDetail_model.hotelRating,
                                        "search_id": DHotelSearchModel.search_id,
                                        "ResultIndex": (select_hotel?.resultToken)!, //(select_hotel?.resultIndex)!
                                        "TraceId": hotelDetail_model.traceId,
                                        "CancellationPolicy":String(DHotelDetailsModel.roomsArray[roomSelect_index].cancel_policy ?? ""),
                                        "Roomuniqueid":String( DHotelDetailsModel.roomsArray[roomSelect_index].room_id ?? ""),
                                        "Booking_source": "\( select_hotel?.booking_source ?? "")",

        ]
        print("params: \(params)")
        
        let paramString: [String: String] = ["details": VKAPIs.getJSONString(object: params),
                                             "token" : DHTravelModel.select_room.room_token!,
                                             "TokenId": DHTravelModel.select_room.room_token_key!]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Room_Block, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Room block success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // move to Passengers screen...
                        let passengObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelGuestInfoVC") as! HotelGuestInfoVC
                        passengObj.selectedRoomIndex = self.roomSelect_index
                        self.navigationController?.pushViewController(passengObj, animated: true)
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            DHPreBookingModel.clearAll_Information()
                            DHPreBookingModel.createRoomBlockModel(dataDict: data_dict)
                        }
                    } else {
                        
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Room block formate : \(String(describing: resultObj))")
                }
            } else {
                print("Room block error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
        }
        /*if let data = JSONLoader.loadJSON(from: "roomBlock") {
            if let data_dict = data["BlockRoom"] as? [String: Any] {
                DHPreBookingModel.clearAll_Information()
                DHPreBookingModel.createRoomBlockModel(dataDict: data_dict)
                let passengObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelGuestInfoVC") as! HotelGuestInfoVC
                self.navigationController?.pushViewController(passengObj, animated: true)
                
            }
        }*/
    }

    
    func sessionExpairAlert(result_dict:  [String: Any]) {
        
        // error message...
        var final_msg = ""
        if let message_str = result_dict["message"] as? String {
            final_msg = message_str
        }
        
        // error code...
        var final_error = 0
        if let error_code = result_dict["error"] as? Int {
            final_error = error_code
        }
        
        if final_error == 400002 {
            
            // success action...
            let alertContorller = UIAlertController.init(title: "Alert!", message: final_msg, preferredStyle: .alert)
            let actionOk = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            })
            alertContorller.addAction(actionOk)
            self.present(alertContorller, animated: true, completion: nil)
        } else {
            self.view.makeToast(message: final_msg)
        }
    }
}
