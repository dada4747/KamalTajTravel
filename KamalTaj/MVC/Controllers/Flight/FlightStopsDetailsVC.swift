//
//  FlightStopsDetailsVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FlightStopsDetailsVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var scroll_mainView: UIScrollView!
    @IBOutlet weak var lbl_emptyMessage: UILabel!
    @IBOutlet weak var tbl_flightStops: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    @IBOutlet weak var view_header: CRView!
    
    // Base fare elements...
    @IBOutlet weak var lbl_adult: UILabel!
    @IBOutlet weak var lbl_adultPrice: UILabel!
    
    @IBOutlet weak var view_child: UIView!
    @IBOutlet weak var lbl_child: UILabel!
    @IBOutlet weak var lbl_childPrice: UILabel!
    @IBOutlet weak var child_HContraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_infant: UIView!
    @IBOutlet weak var lbl_infant: UILabel!
    @IBOutlet weak var lbl_infantPrice: UILabel!
    @IBOutlet weak var infant_HContraint: NSLayoutConstraint!
    
    // Taxes elements...
    @IBOutlet weak var lbl_taxesFeePrice: UILabel!
    @IBOutlet weak var lbl_convenienceFee: UILabel!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    @IBOutlet weak var lbl_grandTotal_bottom: UILabel!
    // varables...
    var allTrips_HeadsArray: [DFlightStopsHeadItem] = []
    var allTrips_stopsArray: [[DFlightStopsItem]] = []
    
    var departFlight_item: DFlightSearchItem?
    var returnFlight_item: DFlightSearchItem?
    var departFlight_itemMulti: DFlightSearchMultiItem?
    var stop_count = 0
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // bottom shadow...
        print(departFlight_item)
        view_header.viewShadow()
//        view.backgroundColor = .appColor
        // table delegates...
        tbl_flightStops.delegate = self
        tbl_flightStops.dataSource = self
        
        if #available(iOS 15, *) {
            self.tbl_flightStops.sectionHeaderTopPadding = 0
        }
        
        
        // getting stops inforamtion..
        scroll_mainView.isHidden = true
        DFlightStopsModel.clearAll_StopsInformation()
        
        if let details_array = DFlightSearchModel.flightDetailsDict[DTravelModel.airlineDepart_id] as? [Any] {
            
            for i in 0 ..< details_array.count {
                if let stops_array = details_array[i] as? [Any] {
                    DFlightStopsModel.createTrip_StopsModel(stopsArray: stops_array)
                }
            }
        }
        
        
        if let detialsReturn_array = DFlightSearchModel.flightDetailsReturnDict[DTravelModel.airlineReturn_id] as? [Any] {
            if let stops_array = detialsReturn_array[0] as? [Any] {
                DFlightStopsModel.createTrip_StopsModel(stopsArray: stops_array)
            }
        }
        
        self.reloadInformation()
        
        //gettingDepartFlight_StopsDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helper
    func displayPassengerAndTotalPrice() {
        
        // hidden child & infant fare...
        child_HContraint.constant = 0
        view_child.isHidden = true
        
        infant_HContraint.constant = 0
        view_infant.isHidden = true
        
        // passenger price...
        var adult_price: Float = 0.0
        var child_price: Float = 0.0
        var infant_price: Float = 0.0
        

        var passArray: [PassBreakupModel] = []
        
        if DTravelModel.tripType == .Multi || DTravelModel.tripType == .Round {
            if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
                passArray += returnFlight_item!.passengerFare_array
                passArray += departFlight_item!.passengerFare_array
            }else if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false {
                passArray += departFlight_itemMulti!.passengerFare_array
                print( departFlight_itemMulti!.passengerFare_array)
                print( departFlight_itemMulti!.passengerFare_array)
            } else {
             passArray += departFlight_itemMulti!.passengerFare_array
            }
        } else if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
            passArray += returnFlight_item!.passengerFare_array

        } else {
            passArray += departFlight_item!.passengerFare_array

        }        //passArray.append(model!.passengerFare_array)
        
        //var passengerArray = model!.passengerFare_array
//        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
            //let returnModel = returnFlight_item
            //passArray.append(returnModel!.passengerFare_array)
            //passengerArray = model!.passengerFare_array + returnModel!.passengerFare_array
//            passArray += returnFlight_item!.passengerFare_array
//        }
        
        for pass_model in passArray {
            
            if pass_model.passenger_type == "infant" {
                
                // infant price information...
                infant_HContraint.constant = 25
                view_infant.isHidden = false
                
                infant_price = infant_price + pass_model.base_fare //pass_model.tax_fare
                let single_price = infant_price/Float(pass_model.passenger_count)
                
                lbl_infant.text = String(format: "%d Infant ( %d*%.0f )", pass_model.passenger_count, pass_model.passenger_count, single_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
                lbl_infantPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", infant_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
            }
            else if pass_model.passenger_type == "child" {
                
                // child price information...
                child_HContraint.constant = 25
                view_child.isHidden = false
                
                child_price = child_price + pass_model.base_fare
                let single_price = child_price/Float(pass_model.passenger_count)
                
                lbl_child.text = String(format: "%d Child ( %d*%.0f )", pass_model.passenger_count, pass_model.passenger_count, single_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
                lbl_childPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", child_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
            }
            else {
                // adult price information...
                adult_price = adult_price + pass_model.base_fare
                let single_price = adult_price/Float(pass_model.passenger_count)
                
                lbl_adult.text = String(format: "%d Adult ( %d*%.0f )", pass_model.passenger_count, pass_model.passenger_count, single_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
                lbl_adultPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", adult_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
            }
        }
        
        var tax_price: Float = 0
        var total_price: Float = 0
        var base_fare: Float = 0
        var conv_price: Float = 0
        if DTravelModel.tripType == .OneWay {
            tax_price = tax_price + departFlight_item!.tax_price + departFlight_item!.gst_price
            total_price = total_price + departFlight_item!.ticket_price
            base_fare = departFlight_item!.base_fare
            print(base_fare)
            conv_price = total_price - (tax_price + base_fare)
            
        } else  {
            if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
                
                tax_price = tax_price + returnFlight_item!.tax_price + returnFlight_item!.gst_price + departFlight_item!.tax_price + departFlight_item!.gst_price
                
                total_price = total_price + returnFlight_item!.ticket_price + departFlight_item!.ticket_price
                base_fare = departFlight_item!.base_fare + returnFlight_item!.base_fare
                conv_price = total_price - (tax_price + base_fare)

            } else {
                tax_price = tax_price + departFlight_itemMulti!.tax_price + departFlight_itemMulti!.gst_price
                total_price = total_price + departFlight_itemMulti!.ticket_price
                base_fare = departFlight_itemMulti!.base_fare
                
                conv_price = total_price - (tax_price + base_fare)

            }
            
        }
//        if DTravelModel.tripType != .Multi || DTravelModel.tripType != .Round  {
//
//            tax_price = tax_price + departFlight_item!.tax_price
//            total_price = total_price + departFlight_item!.ticket_price
//
//        }else if DTravelModel.tripType != .Round{
//            tax_price = tax_price + departFlight_item!.tax_price
//            total_price = total_price + departFlight_item!.ticket_price
//
//
//        } else {
//
//            tax_price = tax_price + departFlight_itemMulti!.tax_price
//            total_price = total_price + departFlight_itemMulti!.ticket_price
//
//            if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
//
//                tax_price = tax_price + returnFlight_item!.tax_price
//                total_price = total_price + returnFlight_item!.ticket_price
//            }
//        }
        

        // total fare...

        lbl_taxesFeePrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", tax_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// String(format: "%@ %.0f", departFlight_item?.currency_code ?? "USD", tax_price)
        lbl_convenienceFee.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (conv_price ) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// String(format: "%@ 0.00", FinalBreakupModel.currency)
        lbl_grandTotal.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (total_price  ) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", departFlight_item?.currency_code ?? "USD", total_price)
        lbl_grandTotal_bottom.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", (total_price  ) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
    }
    
    func reloadInformation() {
        
        // getting stop details...
        self.allTrips_stopsArray = DFlightStopsModel.flightTripStops_array
        self.allTrips_HeadsArray = DFlightStopsModel.flightTripHead_array
        print(allTrips_stopsArray.count)
        print(allTrips_HeadsArray.count)
        // if stops list not avaliables...
        if allTrips_stopsArray.count == 0 {
            //self.lbl_emptyMessage.isHidden = false
            return
        }
        self.displayPassengerAndTotalPrice()
        
        // heights...
        var heightValue: Int = 0
        for modelArray in allTrips_stopsArray {
            
            heightValue = heightValue + 66 // headers height
            for i in 0 ..< modelArray.count {
                
                let model = modelArray[i]
                if model.triptype_index == 1 {
                    heightValue = heightValue + 40 // layover height
                }
                else {
                    heightValue = heightValue + 157 /*+ 20*/// stops height
                }
            }
        }
        self.tbl_flightStops.reloadData()
        self.tbl_HContraint.constant = CGFloat(heightValue)
        self.scroll_mainView.isHidden = false
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        print("stop_count:  \(stop_count)")
        
        DFlightSearchModel.stop_count = stop_count
        // move to Passengers screen...
//        let passengObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "PassengersListVC") as! PassengersListVC
//        self.navigationController?.pushViewController(passengObj, animated: true)
        
        gettingFlight_StopsDetails()
    }
}

extension FlightStopsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FStopsHeaderCell") as? FStopsHeaderCell
        if cell == nil {
            tableView.register(UINib(nibName: "FStopsHeaderCell", bundle: nil), forCellReuseIdentifier: "FStopsHeaderCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FStopsHeaderCell") as? FStopsHeaderCell
        }
        
        // display headers informations...
        cell?.display_information(headModel: allTrips_HeadsArray[section])
//        allTrips_HeadsArray[section].from_cityCode
//        cell?.lbl_noofStops.text = "\(allTrips_stopsArray.count - 1) Stops"

        cell?.lbl_journeyType.text = DTravelModel.flight_class

        if DTravelModel.tripType == .OneWay {
            cell?.lbl_duration.text = "\(departFlight_item?.travel_hours ?? "")"
            cell?.lbl_noofStops.text = "\(departFlight_item?.noof_stops ?? 0) Stops"

        }else{
            if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic {
                
                if section == 0 {
                    cell?.lbl_duration.text = "\(departFlight_item?.travel_hours ?? "")"
                    cell?.lbl_noofStops.text = "\(departFlight_item?.noof_stops ?? 0) Stops"

                }else {
                    cell?.lbl_duration.text = "\(returnFlight_item?.travel_hours ?? "")"
                    cell?.lbl_noofStops.text = "\(returnFlight_item?.noof_stops ?? 0) Stops"

                }
                
            }else{
                cell?.lbl_duration.text =  "\(departFlight_itemMulti?.flightsSearch_array[section].duration_seconds.toHourMinuteString ?? "")"
                cell?.lbl_noofStops.text = "\(departFlight_itemMulti?.flightsSearch_array[section].noof_stops ?? 0) Stops"
                
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let singleTripStops = allTrips_stopsArray[indexPath.section]
        if singleTripStops[indexPath.row].triptype_index == 1 {
            return 40
        }
        return 157
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return allTrips_HeadsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let singleTripStops = allTrips_stopsArray[section]
        return singleTripStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // getting signle trip stops...
        let singleTripStops = allTrips_stopsArray[indexPath.section]
        
        // overlayout cell...
        if singleTripStops[indexPath.row].triptype_index == 1 {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FStopLayoverCell") as? FStopLayoverCell
            if cell == nil {
                tableView.register(UINib(nibName: "FStopLayoverCell", bundle: nil), forCellReuseIdentifier: "FStopLayoverCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FStopLayoverCell") as? FStopLayoverCell
            }
            
            // display information...
            cell?.displayOverlay_information(overModel: singleTripStops[indexPath.row])
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
            cell?.displayStops_information(stopModel: singleTripStops[indexPath.row])
            stop_count += 1

            cell?.selectionStyle = .none
            return cell!
        }
    }
}


extension FlightStopsDetailsVC {
    
    // MARK:- API's
    func gettingFlight_StopsDetails()  {
        
        SwiftLoader.show(animated: true)
        
        // session and routing id...
        var token = ""
        var token_key = ""
        var auth_key = ""
        var booking_source = ""
        
        let lcc_Array:[Any] = []
        var search_access_key_Array:[Any] = []
        var token_Array:[Any] = []
        var token_key_Array:[Any] = []
        var promo_plan_Array:[Any] = []
        
        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
            
            // depart keys...
            let departToken = (departFlight_item?.token) ?? ""
            let departTokenKey = (departFlight_item?.token_key) ?? ""
            let departAuthKey = (departFlight_item?.auth_key) ?? ""
            let departBookingSource = (departFlight_item?.booking_source) ?? ""
            
            // return keys...
            let returnToken = (returnFlight_item?.token) ?? ""
            let returnTokenKey = (returnFlight_item?.token_key) ?? ""
            let returnAuthKey = (returnFlight_item?.auth_key) ?? ""
            let returnBookingSource = (returnFlight_item?.booking_source) ?? ""
            
            search_access_key_Array.append(departAuthKey)
            search_access_key_Array.append(returnAuthKey)
            
            token_Array.append(departToken)
            token_Array.append(returnToken)
            
            token_key_Array.append(departTokenKey)
            token_key_Array.append(returnTokenKey)
            
            promo_plan_Array.append(departBookingSource)
            promo_plan_Array.append(returnBookingSource)
            
        }
        else if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false {
             token = (departFlight_itemMulti?.token) ?? ""
             token_key = (departFlight_itemMulti?.token_key) ?? ""
             auth_key = (departFlight_itemMulti?.auth_key) ?? ""
             booking_source = (departFlight_itemMulti?.booking_source) ?? ""
            
            search_access_key_Array.append(auth_key)
            token_Array.append(token)
            token_key_Array.append(token_key)
            promo_plan_Array.append(booking_source)
            
        }
        else {
            
            if DTravelModel.tripType == .Multi {
                
                token = (departFlight_itemMulti?.token) ?? ""
                token_key = (departFlight_itemMulti?.token_key) ?? ""
                auth_key = (departFlight_itemMulti?.auth_key) ?? ""
                booking_source = (departFlight_itemMulti?.booking_source) ?? ""
                
            } else {
                
                token = (departFlight_item?.token) ?? ""
                token_key = (departFlight_item?.token_key) ?? ""
                auth_key = (departFlight_item?.auth_key) ?? ""
                booking_source = (departFlight_item?.booking_source) ?? ""
            }
            
            search_access_key_Array.append(auth_key)
            token_Array.append(token)
            token_key_Array.append(token_key)
            promo_plan_Array.append(booking_source)
        }
        
        // params...
        let params:[String: Any] = ["is_domestic": DFlightSearchModel.is_domestic, //"0"
                                    "token": token_Array,
                                    "token_key": token_key_Array,
                                    "search_access_key": search_access_key_Array,
                                    "is_lcc": lcc_Array,
                                    "promotional_plan_type": promo_plan_Array,
                                    "booking_type": "process_fare_quote",
                                    "booking_source": DFlightSearchModel.booking_source,
                                    "search_id": String.init(format: "%@", DFlightSearchModel.search_id),
                                    "customer_id":"".getUserId()]
        
        //print("params: \(params)")
        
        let paramString: [String: String] = ["farequote_data": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_FairQoute, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Flight details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            DFlightStopsModel.clearAll_StopsInformation()
                            DFlightAddOnsModel.clearFightAddOnsModel()
                            DFlightStopsModel.createStopModel(dataDict: data_dict)
                            
                            // move to Passengers screen...
                            let passengObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "PassengersListVC") as! PassengersListVC
                            self.navigationController?.pushViewController(passengObj, animated: true)
                        }
                    } else {
                        
                        // error message...
                        //self.sessionExpairAlert(result_dict: result)
                        self.navigationController?.popViewController(animated: true)
                        if let message_str = result["message"] as? String {
                            kWindow?.makeToast(message: message_str)
                        }
                        else {
                            if let message_str = result["msg"] as? String {
                                kWindow?.makeToast(message: message_str)
                            }
                        }
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                    kWindow?.makeToast(message: error?.localizedDescription ?? "")
                    print("Flight details formate : \(String(describing: resultObj))")
                }
            } else {
                
                self.navigationController?.popViewController(animated: true)
                kWindow?.makeToast(message: error?.localizedDescription ?? "")
                print("Flight Stop details error : \(String(describing: error?.localizedDescription))")
//                SwiftLoader.hide()
//                return
            }
            SwiftLoader.hide()
            
            // it will fire at api succeess...
            //NotificationCenter.default.post(name: yFareQoute, object: nil, userInfo: nil)
        }
    }
    
//    func gettingFlight_ExtraServices(completion: @escaping (Bool) -> Void) {
//        SwiftLoader.show(animated: true)
//        
//        // session and routing id...
//        var token = ""
//        var token_key = ""
//        var auth_key = ""
//        var booking_source = ""
//        
//        let lcc_Array:[Any] = []
//        var search_access_key_Array:[Any] = []
//        var token_Array:[Any] = []
//        var token_key_Array:[Any] = []
//        var promo_plan_Array:[Any] = []
//        
//        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
//            
//            // depart keys...
//            let departToken = (departFlight_item?.token) ?? ""
//            let departTokenKey = (departFlight_item?.token_key) ?? ""
//            let departAuthKey = (departFlight_item?.auth_key) ?? ""
//            let departBookingSource = (departFlight_item?.booking_source) ?? ""
//            
//            // return keys...
//            let returnToken = (returnFlight_item?.token) ?? ""
//            let returnTokenKey = (returnFlight_item?.token_key) ?? ""
//            let returnAuthKey = (returnFlight_item?.auth_key) ?? ""
//            let returnBookingSource = (returnFlight_item?.booking_source) ?? ""
//            
//            search_access_key_Array.append(departAuthKey)
//            search_access_key_Array.append(returnAuthKey)
//            
//            token_Array.append(departToken)
//            token_Array.append(returnToken)
//            
//            token_key_Array.append(departTokenKey)
//            token_key_Array.append(returnTokenKey)
//            
//            promo_plan_Array.append(departBookingSource)
//            promo_plan_Array.append(returnBookingSource)
//            
//        }
//        else if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false {
//             token = (departFlight_itemMulti?.token) ?? ""
//             token_key = (departFlight_itemMulti?.token_key) ?? ""
//             auth_key = (departFlight_itemMulti?.auth_key) ?? ""
//             booking_source = (departFlight_itemMulti?.booking_source) ?? ""
//            
//            search_access_key_Array.append(auth_key)
//            token_Array.append(token)
//            token_key_Array.append(token_key)
//            promo_plan_Array.append(booking_source)
//            
//        }
//        else {
//            
//            if DTravelModel.tripType == .Multi {
//                
//                token = (departFlight_itemMulti?.token) ?? ""
//                token_key = (departFlight_itemMulti?.token_key) ?? ""
//                auth_key = (departFlight_itemMulti?.auth_key) ?? ""
//                booking_source = (departFlight_itemMulti?.booking_source) ?? ""
//                
//            } else {
//                
//                token = (departFlight_item?.token) ?? ""
//                token_key = (departFlight_item?.token_key) ?? ""
//                auth_key = (departFlight_item?.auth_key) ?? ""
//                booking_source = (departFlight_item?.booking_source) ?? ""
//            }
//            
//            search_access_key_Array.append(auth_key)
//            token_Array.append(token)
//            token_key_Array.append(token_key)
//            promo_plan_Array.append(booking_source)
//        }
//        //        var reqParams = {
//        //          "search_access_key": [
//        //            "57d33434617ad0bc43f22a95affaae91*_*1*_*rWLU3ij7FwxpTU86"
//        //          ],
//        //          "search_id": 27560,
//        //          "booking_source": "PTBSID0000000002",
//        //          "token_key": [
//        //            "61a6c6dd0562e38196782e777b25ccf5"
//        //          ],
//        //          "booking_type": "extraservices",
//        //          "promotional_plan_type": [
//        //            "PTBSID0000000002"
//        //          ]
//        //        }
//        // params...
//        let params:[String: Any] = [
//            "search_access_key": search_access_key_Array,
//            "search_id": String.init(format: "%@", DFlightSearchModel.search_id),
//            "booking_source": DFlightSearchModel.booking_source,
//            "token_key": token_key_Array,
//            "booking_type": "extraservices",
//            "promotional_plan_type": promo_plan_Array
//
////            "is_domestic": DFlightSearchModel.is_domestic, //"0"
////                                    "token": token_Array,
////                                    "is_lcc": lcc_Array,
////                                    "customer_id":"".getUserId()
//        ]
//        
//        //print("params: \(params)")
//        
//        let paramString: [String: String] = ["Extraservices_data": VKAPIs.getJSONString(object: params)]
//        
//        // calling apis...
//        VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_ExtraServices, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Flight Extra Services success: \(String(describing: resultObj))")
//                completion(true)
//
//                if let result = resultObj as? [String: Any] {
//                    if result["status"] as? Bool == true {
//                        // response date...
//                        if let data_dict = result["data"] as? [String: Any] {
//                            if let extra = data_dict["ExtraServiceDetails"] as? [String: Any] {
//                                
//                                DFlightAddOnsModel.createFightAddOnsModel(response_dict: extra)
//                            }
//
//                            // move to Passengers screen...
////                            SwiftLoader.hide()
//                            return
//                        }
//                    } else {
//                        // If data_dict is missing, treat as failure
//                        // error message...
//                        //self.sessionExpairAlert(result_dict: result)
////                        self.navigationController?.popViewController(animated: true)
//                        if let message_str = result["message"] as? String {
//                            kWindow?.makeToast(message: message_str)
//                        }
//                        else {
//                            if let message_str = result["msg"] as? String {
//                                kWindow?.makeToast(message: message_str)
//                            }
//                        }
////                        completion(false)
////                        SwiftLoader.hide()
//                        return
//                    }
//                } else {
//                    self.navigationController?.popViewController(animated: true)
//                    kWindow?.makeToast(message: error?.localizedDescription ?? "")
//                    print("Flight Extra Services formate : \(String(describing: resultObj))")
//                    // If data_dict is missing, treat as failure
//                    completion(false)
////                    SwiftLoader.hide()
//                    return
//                }
//            } else {
//                
//                self.navigationController?.popViewController(animated: true)
//                kWindow?.makeToast(message: error?.localizedDescription ?? "")
//                print("Flight Extra Services error : \(String(describing: error?.localizedDescription))")
//                // If data_dict is missing, treat as failure
//                completion(false)
////                SwiftLoader.hide()
//                return
//            }
////            SwiftLoader.hide()
//            
//            // it will fire at api succeess...
//            //NotificationCenter.default.post(name: yFareQoute, object: nil, userInfo: nil)
//        }
//    }
}

