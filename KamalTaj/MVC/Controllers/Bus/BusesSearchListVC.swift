//
//  BusesSearchListVC.swift
//  EasiTripBooking
//
//  Created by Admin on 16/10/25.
//

import UIKit
import AVFoundation
class BusesSearchListVC: UIViewController, BusFilterDelegate {
    func filterApply_removeIntimation() {
        let allfilter = DBusFilters.applyAll_filterAndSorting(_depart: DBusSearchModel.busSearch_array)
        busesSearchList_array = allfilter
        self.lbl_busesCount.text = "\(busesSearchList_array.count) Buses Found / \(DBusSearchModel.busSearch_array.count)"
        if busesSearchList_array.count == 0 {
            self.lbl_emptyMessage.isHidden = false
        } else {
            self.lbl_emptyMessage.isHidden = true
        }
        tbl_buses_list.reloadData()
        
    }
    
    @IBOutlet weak var lbl_emptyMessage: UILabel!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_from_city: UILabel!
    @IBOutlet weak var lbl_to_city: UILabel!
    @IBOutlet weak var lbl_travel_date: UILabel!
    @IBOutlet weak var lbl_busesCount: UILabel!
    @IBOutlet weak var tbl_buses_list: UITableView!
    @IBOutlet weak var tblPolicy: UITableView!
    @IBOutlet weak var heiTblConstraint: NSLayoutConstraint!
    @IBOutlet var viewCancellationPop: UIView!

    var busesSearchList_array : [DBusesSearchItem] = []
    var selectedCancellationPolicies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayInfo()
        self.lbl_from_city.text = DBTravelModel.sourceCity["label"] as? String ?? ""
        self.lbl_to_city.text = DBTravelModel.destinationCity["label"] as? String ?? ""
        self.lbl_travel_date.text = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: DBTravelModel.departDate)

        addDelegates()
        addPopup()

        gettingBusesListAPI()
        
        // bottom shadow...
        view_header.viewShadow()

    }
    
    //MARK: - IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Function
    func displayInfo(){
        
        lbl_emptyMessage.isHidden = true
        busesSearchList_array = DBusSearchModel.busSearch_array
        self.lbl_busesCount.text = "\(busesSearchList_array.count) Buses Found / \(busesSearchList_array.count)"

        DBusFilters.getOperatorAndPrice_fromResponse()
        filterApply_removeIntimation()

    }
    func addPopup() {
        viewCancellationPop.isHidden = true
        viewCancellationPop.frame = self.view.frame
        self.view.addSubview(viewCancellationPop)
        
        
    }
    func addDelegates(){
        tblPolicy.delegate = self
        tblPolicy.dataSource = self
        tblPolicy.rowHeight = UITableView.automaticDimension
        tblPolicy.estimatedRowHeight = 50

        tbl_buses_list.delegate = self
        tbl_buses_list.dataSource = self
        tbl_buses_list.rowHeight = UITableView.automaticDimension
        tbl_buses_list.estimatedRowHeight = 120
    }
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        
        // if data not available...
        if DBusSearchModel.busSearch_array.count == 0 {
           
            self.view.makeToast(message: "Flights information not available.")
            return
        }
        
        
        // move to filters screen...
        let filterObj = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusFilterVC") as! BusFilterVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    @IBAction func closeCancellationPopup(_ sender: UIButton) {
        viewCancellationPop.isHidden = true
    }
    
}
//MARK: - UITableviewDelagate And DataSource
extension BusesSearchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblPolicy {
            return 40
        } else {
            return UITableView.automaticDimension //120

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPolicy {
            return selectedCancellationPolicies.count + 1
        } else {
            return busesSearchList_array.count
        }

        //hotelsList_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblPolicy {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CancPolicyTVCell") as? CancPolicyTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "CancPolicyTVCell", bundle: nil), forCellReuseIdentifier: "CancPolicyTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CancPolicyTVCell") as? CancPolicyTVCell
            }
//            cell?.displayBusInfo(model: busesSearchList_array[indexPath.row])
            if indexPath.row == 0 {
                cell?.lbl_time.text = "Time"
                cell?.lbl_charges.text = "Charge"
            } else {
                // Data starts from index 0, so subtract 1
                let policy = selectedCancellationPolicies[indexPath.row - 1]
                cell?.lbl_time.text = policy["time"] as? String ?? ""
                cell?.lbl_charges.text = policy["charge"] as? String ?? ""
                
            }
            cell?.selectionStyle = .none
            return cell!

        }else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "BSearchListCell") as? BSearchListCell
            if cell == nil {
                tableView.register(UINib(nibName: "BSearchListCell", bundle: nil), forCellReuseIdentifier: "BSearchListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "BSearchListCell") as? BSearchListCell
            }
            let model = busesSearchList_array[indexPath.row]
            cell?.displayBusInfo(model: model)
            cell?.onTapCancellationPolicy = { [weak self] in
                guard let self = self else { return }
                self.cancellationPolicy(model.canc ?? [])
            }
            cell?.onTapSelection = {[weak self] in
            guard let self = self else { return }
                self.selectSeatAction(model)
            }
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func cancellationPolicy(_ policies: [[String: Any]]) {
        selectedCancellationPolicies = policies
        tblPolicy.reloadData()
        heiTblConstraint.constant = CGFloat((selectedCancellationPolicies.count + 1) * 40)
        self.viewCancellationPop.isHidden = false

    }
    
    func selectSeatAction(_ model: DBusesSearchItem) {
        DBTravelModel.selectdBus = model
        gettingBusDetails()

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DBTravelModel.selectdBus = busesSearchList_array[indexPath.row]
//        gettingBusDetails()
////        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusDetailsVC") as! BusDetailsVC
////        vc.selectedBus = busesSearchList_array[indexPath.row]
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
}
//https://www.spotatrip.com/index.php/bus/search/445?bus_station_from=Bangalore&from_station_id=6395&bus_station_to=Chennai&to_station_id=2069&bus_date_1=18-05-2023
//MARK: - API Call's
extension BusesSearchListVC {
    func gettingBusesListAPI() {
        DBusSearchModel.clearModels()

        SwiftLoader.show(animated: true)
        let params: [String: Any] = ["bus_station_from": DBTravelModel.sourceCity["label"]!,"from_station_id":DBTravelModel.sourceCity["id"]!,"bus_station_to":DBTravelModel.destinationCity["label"]!,"to_station_id":DBTravelModel.destinationCity["id"]!,"bus_date_1": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DBTravelModel.departDate)]
        let paramString: [String: String] = ["bus_search" : VKAPIs.getJSONString(object: params)]
        // calling apis...
        VKAPIs.shared.getNewRequestXwwwform(params: paramString, file: "general/pre_bus_search_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus search list success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        // response data...
                        
                        DBusSearchModel.createModels(result_dict: result)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Bus search list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayInfo()
            SwiftLoader.hide()
        }
    }
    
    func gettingBusDetails(){
        SwiftLoader.show(animated: true)
        
        let params : [String : String] = ["route_schedule_id": DBTravelModel.selectdBus.RouteScheduleId ?? "", "journey_date": DBTravelModel.selectdBus.DeptTime ?? "", "route_code": DBTravelModel.selectdBus.RouteCode ?? "", "search_id": DBusSearchModel.search_id , "ResultToken": DBTravelModel.selectdBus.ResultToken ?? "",  "booking_source": DBusSearchModel.booking_source
        ]
        let paramString: [String: String] = ["bus_details": VKAPIs.getJSONString(object: params)]
        
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: "bus/bus_details_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            
//                            DBusDetailModel.create Model(details: data_dict)
                            DBusSeatModel.clearAllBusSeatModels()
                            DBusSeatModel.createBusSeatModels(result_dict: data_dict)
                            self.moveToSeatSelection()
                            
                        }
                    } else {
                        self.view.makeToast(message: result["message"] as! String)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("Bus details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus details error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
                self.navigationController?.popViewController(animated: true)

            }
            
            // getting rooms list...
            
            self.displayInfo()
            SwiftLoader.hide()
        }
    }
    func moveToSeatSelection(){
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusSeatsVC") as! BusSeatsVC
//        vc.selectedBus = busesSearchList_array[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
