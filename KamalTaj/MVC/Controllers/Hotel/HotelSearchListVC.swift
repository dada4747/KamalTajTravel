//
//  HotelSearchListVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit
import AVFoundation
class HotelSearchListVC: UIViewController {
    
    // MARK:- Outlet
    @IBOutlet weak var tbl_hotelsList: UITableView!
    @IBOutlet weak var lbl_emptyMessage: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_hotelSearch: UIView!
    @IBOutlet weak var tf_hotelSearch: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_checkInDate: UILabel!
    //    @IBOutlet weak var lbl_checkOutDate: UILabel!
    @IBOutlet weak var lbl_numOfRooms: UILabel!
    @IBOutlet weak var lbl_guestCount: UILabel!
    
    @IBOutlet weak var lbl_hotelCount: UILabel!
    
    var departFlight_item: DFlightSearchItem?
    //round way
    var returnFlight_item: DFlightSearchItem?
    
    var allTrips_HeadsArray: [DFlightStopsHeadItem] = []
    var allTrips_stopsArray: [[DFlightStopsItem]] = []
    
    // varibales...
    var hotelsList_array: [DHotelSearchItem] = []
    var hotelsMain_array: [DHotelSearchItem] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var star_rating: [Int] = [0, 0, 0, 0, 0]
    
    var RoomsCount = NSMutableArray()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // bottom shadow...
        view_header.viewShadow()
        //        DHotelSearchModel.hotelsSearch_array.removeAll()
        
        //        trendingHotel_Array = DCommonModel.trendingHotel_Array
        
        // table delegates...
        tbl_hotelsList.delegate = self
        tbl_hotelsList.dataSource = self
        tbl_hotelsList.rowHeight = UITableView.automaticDimension
        tbl_hotelsList.estimatedRowHeight = 243

        
        //        self.view_hotelSearch.isHidden = true
        self.tf_hotelSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        displayRoomAndGuest_Information()
        
        // get hotels list...
        gettingHotels_SearchList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helpers
    func displayRoomAndGuest_Information() {
        
        // display information...
        lbl_numOfRooms.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guestCount.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests"
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "dd MMM", date: DHTravelModel.checkin_date) + " - " +  DateFormatter.getDateString(formate: "dd, MMM", date: DHTravelModel.checkout_date)
        let destination = DHTravelModel.hotelCity_dict?["Destination"] as? String ?? ""
        let country = DHTravelModel.hotelCity_dict?["country"] as? String ?? ""

        lbl_city.text = destination + " , " + country
    }
    
    func displayHotelListMethod() {
        
        // reload tables...
        hotelsMain_array = DHotelFilters.applyAll_filterAndSorting(_hotels: DHotelSearchModel.hotelsSearch_array)
        hotelsList_array = hotelsMain_array
        lbl_hotelCount.text = "Showing \(hotelsList_array.count) results"
        // empty message...
        lbl_emptyMessage.isHidden = true
        btn_search.isHidden = false
        if hotelsList_array.count == 0 {
            lbl_emptyMessage.isHidden = false
            btn_search.isHidden = true
        }
        tbl_hotelsList.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            
            let filter_array = hotelsMain_array.filter { ($0.hotel_name! as NSString).localizedCaseInsensitiveContains(textField.text ??  "")}
            hotelsList_array = filter_array
        } else {
            hotelsList_array = hotelsMain_array
        }
        tbl_hotelsList.reloadData()
    }
    
    func attributeString(fromSting: String, searchString: String) -> NSMutableAttributedString {
        
        // getting range...
        let final_from = fromSting.lowercased() as NSString
        let final_search = searchString.lowercased()
        let rangeVal = final_from.range(of: final_search)
        
        // attribute string...
        let final_arribute = NSMutableAttributedString.init(string: fromSting)
        final_arribute.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor.init(red: 32.0/255.0, green: 151.0/255.0, blue: 217.0/255.0, alpha: 1.0),
                                    range: rangeVal)
        final_arribute.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont(name: "Poppins Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14.0),
                                    range: rangeVal)
        return final_arribute
    }
    
    // MARK:- ButtonActions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func hotelMapViewButtonClicked(_ sender: Any) {
        let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelMapVC") as! HotelMapVC
        //        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
        /*
        // Locate JSON file in the app bundle
        if let path = Bundle.main.path(forResource: "searchHotel", ofType: "json") {
            do {
                let fileURL = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: fileURL)
                
                // Convert JSON Data to Dictionary
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    //                    processJSONData(data: jsonDict)
                    DHotelSearchModel.hotelsSearch_array.removeAll()
                    DHotelSearchModel.createModels(result_dict: jsonDict)
                    
                    let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelMapVC") as! HotelMapVC
                    //        filterObj.delegate = self
                    self.navigationController?.pushViewController(filterObj, animated: true)
                    
                } else {
                    print("Failed to convert JSON to Dictionary")
                }
            } catch {
                print("Error loading JSON file: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found")
        }*/
        
    }
    @IBAction func searchAndCancelButtonsClicked(_ sender: UIButton) {
        
        if sender.tag == 10 {
            self.view_hotelSearch.isHidden = false
        } else {
            
            self.tf_hotelSearch.text = ""
            hotelsList_array = hotelsMain_array
            tbl_hotelsList.reloadData()
            self.view_hotelSearch.isHidden = true
        }
    }
    
    @IBAction func hotelFiltersButtonClicked(_ sender: UIButton) {
        
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels information not available.")
            return
        }
        
        // move to filters screen...
        let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelFiltersVC") as! HotelFiltersVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    
    @IBAction func listfilterButtonAction(_ sender: Any) {
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels information not available.")
            return
        }
        
        // move to filters screen...
        let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelFiltersVC") as! HotelFiltersVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
}

extension HotelSearchListVC: hotelFiltersDelegate {
    
    // MARK:- hotelFiltersDelegate
    func hotelsFiltersApply_removeIntimation() {
        
        // display hotels...
        displayHotelListMethod()
        
        // scroll table to top including header
//        if hotelsList_array.count != 0 {
//            tbl_hotelsList.setContentOffset(.zero, animated: true)
//        }
        
        tbl_hotelsList.reloadData()

        tbl_hotelsList.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            self.tbl_hotelsList.setContentOffset(

                CGPoint(x: 0, y: -self.tbl_hotelsList.adjustedContentInset.top),

                animated: true

            )

        }
    }
}

extension HotelSearchListVC: UITableViewDelegate, UITableViewDataSource, hSearchListCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return hotelsList_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HSearchListCell") as? HSearchListCell
            if cell == nil {
                tableView.register(UINib(nibName: "HSearchListCell", bundle: nil), forCellReuseIdentifier: "HSearchListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HSearchListCell") as? HSearchListCell
            }
            cell?.delegate = self
            cell?.display_hotelsearchInformation(hModel: hotelsList_array[indexPath.row])
            
            // search color...
            cell?.lbl_hotelName.attributedText = self.attributeString(fromSting: hotelsList_array[indexPath.row].hotel_name ?? "", searchString: self.tf_hotelSearch.text ?? "")
            
            cell?.selectionStyle = .none
            return cell!
            
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let indexPath = tbl_hotelsList .indexPath(for: cell)
//        DHTravelModel.select_hotel = hotelsList_array[(indexPath.row)]
//        
//        // move to details...
//        DispatchQueue.main.async {
//            
//            let hotelDetailObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelRoomsListVC") as! HotelRoomsListVC
//            hotelDetailObj.select_hotel = self.hotelsList_array[(indexPath.row)]
//            self.navigationController?.pushViewController(hotelDetailObj, animated: true)
//        }
    }
    // MARK:- hSearchListCellDelegate
    func hotelBooking_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_hotelsList .indexPath(for: cell)
        DHTravelModel.select_hotel = hotelsList_array[(indexPath?.row)!]
        
        // move to details...
        DispatchQueue.main.async {
            
            let hotelDetailObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelDetailsVC") as! HotelDetailsVC
            hotelDetailObj.select_hotel = self.hotelsList_array[(indexPath?.row)!]
            let tempArray = self.allTrips_stopsArray.flatMap { $0.filter { $0.triptype_index != 1 } }
            if DTravelModel.moduleType == .Flight {
                hotelDetailObj.allTrips_stopsArray = tempArray
            }
            self.navigationController?.pushViewController(hotelDetailObj, animated: true)
        }
    }
}

extension HotelSearchListVC {
    
    // MARK:- API's
    /*func gettingHotels_SearchList() {
        
        CommonLoader.shared.startLoader(in: view)
        
        // getting room details...
        var room_array: [Any] = []
        for i in 0..<AddRoomModel.addRooms_array.count {
            let model = AddRoomModel.addRooms_array[i]
            var room : [String: Any] = ["NoOfAdults": model.adult_count]
            room["NoOfChild"] = model.child_count
            room["childAge_\(i + 1)"] = []
            if model.child_count == 1 {
                room["childAge_\(i + 1)"] = ["\(model.child_age1)"]
            } else if model.child_count == 2 {
                room["childAge_\(i + 1)"] = ["\(model.child_age1)", "\(model.child_age2)"]
            } else {}
            room_array.append(room)
            
        }

        print(String(DHTravelModel.noof_nights))
        
        // params...
        let params: [String: Any] = ["CheckInDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkin_date),
                                     "CheckOutDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date),
                                     "RoomGuests": room_array,
                                     "CityId": DHTravelModel.hotelCity_dict!["id"]!,
                                     "NoOfRooms": "\(AddRoomModel.addRooms_array.count)",
                                     "NoOfNights": "\(DHTravelModel.noof_nights)"]
        print("params: \(params)")
        
        let paramString: [String: String] = ["hotel_search": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel search list success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {

                        // response data...
                        DHotelSearchModel.createModels(result_dict: result)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel search list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayHotelListMethod()
            CommonLoader.shared.stopLoader()
        }
 
        
//        if let jsonDict = JSONLoader.loadJSON(from: "searchHotel"){
//            DHotelSearchModel.hotelsSearch_array.removeAll()
//            DHotelSearchModel.createModels(result_dict: jsonDict)
//            self.displayHotelListMethod()
//        } else {
//            print("Failed to convert JSON to Dictionary")
//        }
    }*/
    func gettingHotels_SearchList() {
        
        SwiftLoader.show(animated: true)
        
        // getting room details...
        var room_array: [Any] = []
        for model in AddRoomModel.addRooms_array {
            
            // room details...
            var room: [String: Any] = ["NoOfAdults": "\(model.adult_count)"]
            room["NoOfChild"] = "\(model.child_count)"
            room["ChildAge_1"] = []
            if model.child_count == 1 {
                room["ChildAge_1"] = ["\(model.child_age1)"]
            }
            else if model.child_count == 2 {
                room["ChildAge_1"] = ["\(model.child_age1)", "\(model.child_age2)"]
            }
            else {}
            room_array.append(room)
        }
        print(String(DHTravelModel.noof_nights))
        DHTravelModel.roomCount  = AddRoomModel.addRooms_array.count
        
        // params...
        let params: [String: Any] = ["CheckInDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkin_date),
                                     "CheckOutDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date),
                                     "RoomGuests": room_array,
                                     "CityId": DHTravelModel.hotelCity_dict!["origin"]!,
                                     "NoOfRooms": "\(AddRoomModel.addRooms_array.count)",
                                     "NoOfNights": "\(DHTravelModel.noof_nights)"]
        print("params: \(params)")
        
        let paramString: [String: String] = ["hotel_search": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel search list success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        //self.lendingPlay.pause()
                        //self.playSound(sound: "hotel-post-load")

                        // response data...
                        DHotelSearchModel.createModels(result_dict: result)
                    } else {
                        //self.lendingPlay.pause()
                        //self.playSound(sound: "all-empty-result")
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel search list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayHotelListMethod()
            SwiftLoader.hide()
        }
    }
}
