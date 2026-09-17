//
//  FlightSearchListVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import AVFoundation
class FlightSearchListVC: UIViewController, flightFiltersDelegate {

    //MARK:- Outlets
    @IBOutlet weak var lbl_fromCity: UILabel!
    @IBOutlet weak var lbl_toCity: UILabel!
    @IBOutlet weak var lbl_emptyMessage: UILabel!
    
    @IBOutlet weak var lbl_class: UILabel!
    @IBOutlet weak var lbl_journeyDate: UILabel!
    @IBOutlet weak var lbl_noofPassengers: UILabel!
    
    @IBOutlet weak var lbl_departurePrice: UILabel!
    @IBOutlet weak var lbl_returnPrice: UILabel!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    @IBOutlet weak var tbl_flightList: UITableView!
    
    
    @IBOutlet weak var view_roundDemostic: UIView!
    @IBOutlet weak var tbl_flightDepart: UITableView!
    @IBOutlet weak var tbl_flightReturn: UITableView!
    
    @IBOutlet weak var view_returnPriceMenu: UIView!
    @IBOutlet weak var tbl_YContrain: NSLayoutConstraint!
    @IBOutlet weak var tbl_HConstrain: NSLayoutConstraint!
    @IBOutlet weak var scroll_WContraint: NSLayoutConstraint!
    
//    @IBOutlet weak var img_price: UIImageView!
//    
//    @IBOutlet weak var img_depart: UIImageView!
//    @IBOutlet weak var img_arrivel: UIImageView!
//    @IBOutlet weak var img_duration: UIImageView!
    @IBOutlet weak var view_header: CRView!
    @IBOutlet weak var lbl_resultCount: UILabel!
    
//    var sortByPrice = true
//    var sortByDepart = true
//    var sortByArrivel = true
//    var sortByDuration = true
//    var sort_number: Int = 0

    // MARK:- Variables
    var searchKey = ""
    var departFlights_array: [DFlightSearchItem] = []
    var returnFlights_array: [DFlightSearchItem] = []
    var mulitFlights_array: [DFlightSearchMultiItem] = []

    
    var departFlight_item: DFlightSearchItem?
    var returnFlight_item: DFlightSearchItem?
    var departFlight_itemMulti: DFlightSearchMultiItem?
    var prefferedAirline : String?
    var audioPlayer : AVAudioPlayer?
//    var lendingPlay: AVQueuePlayer = {
//        
//        let url1 = Bundle.main.url(forResource: "landing-load", withExtension: "mp3")!
//        let url2 = Bundle.main.url(forResource: "flight-pre-load", withExtension: "mp3")!
//        let item1 = AVPlayerItem(url: url1)
//        let item2 = AVPlayerItem(url: url2)
//
//        let queue = AVQueuePlayer(items: [item1, item2])
//        return queue
//        }()

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // bottom shadow...
        view_header.viewShadow()
        //lendingPlay.play()

        // display information
        view_returnPriceMenu.isHidden = true
        displayInformationAndDelegates()
        
        // clear selected airline ids...
        DTravelModel.airlineDepart_id = ""
        DTravelModel.airlineReturn_id = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func playSound(sound: String) {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK:- Helper
    func displayInformationAndDelegates(){
        self.lbl_class.text = DTravelModel.flight_class

        if DTravelModel.tripType == .Multi {
            
            // display city information...
            self.lbl_fromCity.text = DCityModel.mulityCitiesArray[0].depart_cityCode
            self.lbl_toCity.text = DCityModel.mulityCitiesArray[DCityModel.mulityCitiesArray.count-1].arrival_cityCode
            self.lbl_noofPassengers.text = "\(DTravelModel.passengerCount()) Passenger"
//            self.lbl_class.text = DTravelModel.flight_class
            let jourDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: DCityModel.mulityCitiesArray[0].start_date!)
            self.lbl_journeyDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: jourDate)
        }
        else {
            
            // display city information...
            self.lbl_fromCity.text = DTravelModel.departAirline["airline_code"] as? String
            self.lbl_toCity.text = DTravelModel.destinationAirline["airline_code"] as? String
            self.lbl_noofPassengers.text = "\(DTravelModel.passengerCount()) Travellers"
            self.lbl_journeyDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: DTravelModel.departDate)
        }
        
        // getting flights...
        DFlightSearchModel.clearAll_SearchInformation()
        gettingFlight_SearchList()
    }
//    func displayInformationAndDelegates() {
//        
//        if DTravelModel.tripType == .Multi {
//            
//            // display city information...
//            self.lbl_fromCity.text = DCityModel.mulityCitiesArray[0].depart_cityCode
//            self.lbl_toCity.text = DCityModel.mulityCitiesArray[DCityModel.mulityCitiesArray.count-1].arrival_cityCode
//            self.lbl_noofPassengers.text = "\(DTravelModel.passengerCount()) Travellers"
//            
//            let jourDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: DCityModel.mulityCitiesArray[0].start_date!)
//            self.lbl_journeyDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: jourDate)
//        }
//        else {
//            
//            // display city information...
//            self.lbl_fromCity.text = DTravelModel.departAirline["airline_code"] as? String ?? ""
//            self.lbl_toCity.text = DTravelModel.destinationAirline["airline_code"] as? String ?? ""
//            self.lbl_noofPassengers.text = "\(DTravelModel.passengerCount()) Passengers"
//            self.lbl_journeyDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: DTravelModel.departDate)
//        }
//        
//        // getting flights...
//        DFlightSearchModel.clearAll_SearchInformation()
//        gettingFlight_SearchList()
//    }
    
    func frameAdjustmentMethod() {
        
        // its round trip...
        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
            
            // if its domestic flights...
            if DFlightSearchModel.is_domestic == true {
                
                // open muliple depart and return tables...
                tbl_flightList.isHidden = true
                view_roundDemostic.isHidden = false
                view_returnPriceMenu.isHidden = false
                tbl_YContrain.constant = 65
                
                let wScal = (self.view.frame.size.width / 100)
                scroll_WContraint.constant = self.view.frame.size.width + (wScal*80)
            }
            else {
                scroll_WContraint.constant = self.view.frame.size.width
            }
            
            // scroll view height at iphon 4 & 5...
            if self.view.frame.size.width == 320.0 {
                tbl_HConstrain.constant = self.view.frame.size.width
            }
            else {
                let fieldRect = self.view.convert(tbl_flightList.bounds, from: tbl_flightList)
                tbl_HConstrain.constant = self.view.frame.size.height - (fieldRect.origin.y + 20)
            }
        }
        else {
            // open muliple depart and return tables...
            tbl_flightList.isHidden = false
            view_roundDemostic.isHidden = true
            view_returnPriceMenu.isHidden = true
            tbl_YContrain.constant = 15
            
            
            // default frames...
            if DTravelModel.tripType == .Multi || (DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false) {
                
                var heightVal = 0
                for models in mulitFlights_array {
                    heightVal = heightVal + (models.flightsSearch_array.count * 120) //+ 10
                }
                tbl_HConstrain.constant = CGFloat(heightVal)
            }
            else {
                tbl_HConstrain.constant = CGFloat((228) * self.departFlights_array.count)
            }
            scroll_WContraint.constant = self.view.frame.size.width
        }
    }
    
    func reloadFlightInformation() {
        
        // getting array list...
        lbl_emptyMessage.isHidden = true
        if (DTravelModel.tripType == .Multi) || (DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false) {
            
            // mulit city formate...
            //            tbl_flightList.separatorStyle = .singleLine
            mulitFlights_array = DFlightSearchModel.flightMulti_array
            lbl_resultCount.text = "\(mulitFlights_array.count) flights found"
            if mulitFlights_array.count == 0 {
                lbl_emptyMessage.isHidden = false
                return
            }
        }
        else {
            
            // normal list formate...
            departFlights_array = DFlightSearchModel.flightsDepart_array
            returnFlights_array = DFlightSearchModel.flightsReturn_array
            if DTravelModel.tripType == .OneWay {
                lbl_resultCount.text = "\(departFlights_array.count) flights found"

            } else if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
                lbl_resultCount.text = "\(departFlights_array.count) depart and \(returnFlights_array.count) return flights found"
            }
            
            if departFlights_array.count == 0 && returnFlights_array.count == 0 {
                lbl_emptyMessage.isHidden = false
                return
            }
        }
        
        // reload data...
        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
            
            // depart and return...
            tbl_flightDepart.delegate = self
            tbl_flightDepart.dataSource = self
            
            tbl_flightReturn.delegate = self
            tbl_flightReturn.dataSource = self
            self.tbl_flightDepart.reloadData()
            self.tbl_flightReturn.reloadData()
        }
        else {
            
            // table delegates...
            tbl_flightList.delegate = self
            tbl_flightList.dataSource = self
            
            tbl_flightList.estimatedRowHeight = 226
            self.tbl_flightList.reloadData()
        }
        
        frameAdjustmentMethod()
        DFlightFilters.getAirlinesAndPrice_fromResponse()
        filtersApply_removeIntimation()
    }
    
    func roundTripPriceCalculation() {
        
        // currency and total price...
        var currencyCode = departFlight_item?.currency_code ?? ""
        if currencyCode.count == 0 {
            currencyCode = returnFlight_item?.currency_code ?? ""
        }
        let totalPrice = (returnFlight_item?.ticket_price ?? 0) + (departFlight_item?.ticket_price ?? 0)
        
        // display infromation...
        lbl_departurePrice.text =  String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", departFlight_item?.ticket_price ?? 0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", currencyCode, departFlight_item?.ticket_price ?? 0)
        lbl_returnPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", returnFlight_item?.ticket_price ?? 0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", currencyCode, returnFlight_item?.ticket_price ?? 0)
        lbl_totalPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", totalPrice * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", currencyCode, totalPrice)
        
    }
    
    // MARK:- flightFiltersDelegate
    func filtersApply_removeIntimation() {
        print("Filtered Depart Count:", departFlights_array.count)
//        if DTravelModel.preferedAirLine.isEmpty  {
            
//        }else{
//            DFlightFilters.flightSelection_array.append(DTravelModel.preferedAirLine.capitalized)
//        }
//        DFlightFilters.flightSelection_array.removeAll()
//
//        if !DTravelModel.preferedAirLine.isEmpty {
//            DFlightFilters.flightSelection_array.append(DTravelModel.preferedAirLine.capitalized)
//        }
        // adding filters...
        let allFilters = DFlightFilters.applyAll_filterAndSorting(_depart: DFlightSearchModel.flightsDepart_array,
                                                                  _return: DFlightSearchModel.flightsReturn_array,
                                                                  _mulit: DFlightSearchModel.flightMulti_array)
        departFlights_array = allFilters.0
        returnFlights_array = allFilters.1
        mulitFlights_array = allFilters.2
        
        if DTravelModel.tripType == .OneWay {
            
            lbl_resultCount.text = "\(departFlights_array.count) flights found"
            
        } else if DTravelModel.tripType == .Round &&
                    DFlightSearchModel.is_domestic == true {
            
            lbl_resultCount.text = "\(departFlights_array.count) depart and \(returnFlights_array.count) return flights found"
            
        } else {
            
            // Multi city or International Round
            lbl_resultCount.text = "\(mulitFlights_array.count) flights found"
        }
        
        // showing no elements...
        self.lbl_emptyMessage.isHidden = true
        if departFlights_array.count == 0 && returnFlights_array.count == 0 && mulitFlights_array.count == 0 {
            self.lbl_emptyMessage.isHidden = false
        }
        
        // reload data...
        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
            tbl_flightDepart.reloadData()
            tbl_flightReturn.reloadData()
        }
        else {
            tbl_flightList.reloadData()
        }
        frameAdjustmentMethod()
    }
    
//    @IBAction func departFilterButtonAction(_ sender: Any) {
//        if sortByDepart {
//            sortByDepart = false
//            sort_number = 2
//            UIView.animate(withDuration: 0.2) { () -> Void in
//              self.img_depart.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            }
//            
//        } else {
//            sortByDepart = true
//            sort_number = 3
//            
//            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
//              self.img_depart.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
//            }, completion: nil)
//        }
//        DFlightFilters.sort_number = sort_number
//
//        filtersApply_removeIntimation()
//    }
//    @IBAction func arrivelButtonFilterApply(_ sender: Any) {
//        if sortByArrivel {
//            sortByArrivel = false
//            sort_number = 7
//            UIView.animate(withDuration: 0.2) { () -> Void in
//              self.img_arrivel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            }
//            
//        } else {
//            sortByArrivel = true
//            sort_number = 6
//            
//            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
//              self.img_arrivel.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
//            }, completion: nil)
//        }
//        DFlightFilters.sort_number = sort_number
//
//        filtersApply_removeIntimation()
//    }
    
//    @IBAction func durationFilterButtonAction(_ sender: Any) {
//        if sortByDuration {
//            sortByDuration = false
//            sort_number = 5
//            UIView.animate(withDuration: 0.2) { () -> Void in
//              self.img_duration.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            }
//            
//        } else {
//            sortByDuration = true
//            sort_number = 4
//            
//            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
//              self.img_duration.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
//            }, completion: nil)
//        }
//        DFlightFilters.sort_number = sort_number
//
//        filtersApply_removeIntimation()
//    }
    
//    @IBAction func pricingFilterButtonAction(_ sender: Any) {
//        if sortByPrice {
//            sortByPrice = false
//            sort_number = 1
//            UIView.animate(withDuration: 0.2) { () -> Void in
//              self.img_price.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            }
//            
//        } else {
//            sortByPrice = true
//            sort_number = 0
//            
//            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
//              self.img_price.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
//            }, completion: nil)
//        }
//        DFlightFilters.sort_number = sort_number
//
//        filtersApply_removeIntimation()
//    }
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        
        // if data not available...
        if DFlightSearchModel.flightsDepart_array.count == 0 &&
            DFlightSearchModel.flightsReturn_array.count == 0 &&
            DFlightSearchModel.flightMulti_array.count == 0 {
           
            self.view.makeToast(message: "Flights information not available.")
            return
        }
        
        
        // move to filters screen...
        let filterObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightFiltersVCNew") as! FlightFiltersVCNew
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    
    @IBAction func roundTripCityBookingClicked(_ sender: UIButton) {
        
        if departFlight_item == nil {
            self.view.makeToast(message: "Please select depart flight")
        }
        else if returnFlight_item == nil {
            self.view.makeToast(message: "Please select return flight")
        }
        else {
            
            // store airline ids...
            DTravelModel.airlineDepart_id = (departFlight_item?.token)!
            DTravelModel.airlineReturn_id = (returnFlight_item?.token)!
            
            // move to numbers stops screen...
            let stopsObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightStopsDetailsVC") as! FlightStopsDetailsVC
            stopsObj.departFlight_item = departFlight_item
            stopsObj.returnFlight_item = returnFlight_item
            self.navigationController?.pushViewController(stopsObj, animated: true)
        }
    }
}

extension FlightSearchListVC: UITableViewDelegate, UITableViewDataSource, fSearchListCellDelegate, fMulitSearchListCell {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if DTravelModel.tripType == .Multi ||
            (DFlightSearchModel.is_domestic == false && DTravelModel.tripType == .Round) {
            return mulitFlights_array.count
        }
        else {
            
            if tableView == tbl_flightReturn {
                return returnFlights_array.count
            } else {
                print("Table Depart Count:", departFlights_array.count)
                return departFlights_array.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DTravelModel.tripType == .Multi ||
            (DFlightSearchModel.is_domestic == false && DTravelModel.tripType == .Round) {
            
            let heightVal = mulitFlights_array[indexPath.row].flightsSearch_array.count * 138
            return CGFloat(heightVal) + 85
        }
        return UITableView.automaticDimension// 228
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // display informaiton...
        if DTravelModel.tripType == .Multi || (DFlightSearchModel.is_domestic == false && DTravelModel.tripType == .Round)  {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FMultiSearchListCell") as? FMultiSearchListCell
            if cell == nil {
                tableView.register(UINib(nibName: "FMultiSearchListCell", bundle: nil), forCellReuseIdentifier: "FMultiSearchListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FMultiSearchListCell") as? FMultiSearchListCell
            }
            cell?.delegate = self
            
            // display informations...
            cell?.lbl_currency.text = mulitFlights_array[indexPath.row].currency_code //String(format: "%@" ,DCurrencyModel.currency_saved?.currency_symbol ?? "AUD")
            cell?.lbl_price.text = String(format: "%.0f" , mulitFlights_array[indexPath.row].ticket_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%.2f", mulitFlights_array[indexPath.row].ticket_price)
            cell?.display_Information(flightArray: mulitFlights_array[indexPath.row].flightsSearch_array)
            
            cell?.lbl_refund.text = "Not refundable"
            if mulitFlights_array[indexPath.row].is_refund == true {
                cell?.lbl_refund.text = "Refundable"
            }
    
            cell?.selectionStyle = .none
            
            return cell!
        }
        else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FSearchListCell") as? FSearchListCell
            if cell == nil {
                tableView.register(UINib(nibName: "FSearchListCell", bundle: nil), forCellReuseIdentifier: "FSearchListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FSearchListCell") as? FSearchListCell
            }
            cell?.delegate = self
            
            
            // diplay informations...
            if tableView == tbl_flightReturn {
                cell?.display_information(fightModel: returnFlights_array[indexPath.row], selectItem: returnFlight_item)
            } else {
                cell?.display_information(fightModel: departFlights_array[indexPath.row], selectItem: departFlight_item)
            }
            
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if DFlightSearchModel.is_domestic == true && DTravelModel.tripType == .Round {
            
            if tableView == tbl_flightDepart {
                
                // depart flight selection
                self.departFlight_item = departFlights_array[indexPath.row]
                tableView.reloadData()
                roundTripPriceCalculation()
            }
            else if tableView == tbl_flightReturn {
                
                // return flight selection
                self.returnFlight_item = returnFlights_array[indexPath.row]
                tableView.reloadData()
                roundTripPriceCalculation()
            }
            else {}
        }
    }
    
    // MARK: - CellButtonActions
    func flightBooking_Action(sender: UIButton, cell: UITableViewCell) {
        
        // move to stops screen...
        let indexPath = tbl_flightList .indexPath(for: cell)
        //moveToStopsScreen(air_id: departFlights_array[(indexPath?.row)!].token!)
        
        moveToStopsScreen(model: departFlights_array[(indexPath?.row)!])
    }
    
    func fareRules_Action(sender: UIButton, cell: UITableViewCell) {
        
        // getting table...
        var tableView: UITableView?
        if let superView = cell.superview as? UITableView {
            tableView = superView
        }
       
        // main actions...
        let indexPath = tableView? .indexPath(for: cell)
        var auth_key = ""
        var data_access_key = ""
        var booking_source_key = ""
        if DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true {
            if tableView == tbl_flightDepart {
                data_access_key = departFlights_array[(indexPath?.row)!].token_key!
                booking_source_key = departFlights_array[(indexPath?.row)!].booking_source!
                auth_key = departFlights_array[(indexPath?.row)!].auth_key!
            } else {
                data_access_key = returnFlights_array[(indexPath?.row)!].token_key!
                booking_source_key = returnFlights_array[(indexPath?.row)!].booking_source!
                auth_key = returnFlights_array[(indexPath?.row)!].auth_key!
            }
        }
        else {
            data_access_key = departFlights_array[(indexPath?.row)!].token_key!
            booking_source_key = departFlights_array[(indexPath?.row)!].booking_source!
            auth_key = departFlights_array[(indexPath?.row)!].auth_key!
        }
        
        // fair rules APIS calling...
        if data_access_key.count != 0 && booking_source_key.count != 0 {
            
            gettingFlight_FairRules(data_access_key: data_access_key, booking_sourceKey: booking_source_key, authKey: auth_key)
        }
    }
    
    func flightBooking_MultiAction(sender: UIButton, cell: UITableViewCell) {
        
        // move to stops screen...
        let indexPath = tbl_flightList .indexPath(for: cell)
        departFlight_itemMulti = mulitFlights_array[(indexPath?.row)!]
        moveToStopsScreen(air_id: mulitFlights_array[(indexPath?.row)!].token!)
    }
    
    func fareRules_MultiAction(sender: UIButton, cell: UITableViewCell) {
        
        // cell index...
        let indexPath = tbl_flightList? .indexPath(for: cell)
        
        let data_accessKey = mulitFlights_array[(indexPath?.row)!].token_key!
        let booking_SourceKey = mulitFlights_array[(indexPath?.row)!].booking_source!
        let auth_key = mulitFlights_array[(indexPath?.row)!].auth_key!
        gettingFlight_FairRules(data_access_key: data_accessKey, booking_sourceKey: booking_SourceKey, authKey: auth_key)
    }
   
    func moveToStopsScreen(air_id: String) {
        
        DTravelModel.airlineDepart_id = air_id
       
        // move to numbers stops screen...
        let stopsObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightStopsDetailsVC") as! FlightStopsDetailsVC
        if DTravelModel.tripType == .Multi || DTravelModel.tripType == .Round {
            stopsObj.departFlight_itemMulti = departFlight_itemMulti
        } else {
            stopsObj.departFlight_item = departFlight_item
        }
        self.navigationController?.pushViewController(stopsObj, animated: true)
    }
    
    func moveToStopsScreen(model: DFlightSearchItem) {
        
        DTravelModel.airlineDepart_id = model.token! //"czoxOToiMTc1NTQ5NzUxNzU2MDIqXyowMCI7"//
        
        // move to numbers stops screen...
        let stopsObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightStopsDetailsVC") as! FlightStopsDetailsVC
        stopsObj.departFlight_item = model
        
        self.navigationController?.pushViewController(stopsObj, animated: true)
    }

    
}

extension FlightSearchListVC {
    
    // MARK: - API's
    func gettingFlight_SearchList() {
        
        SwiftLoader.show(animated: true)
        
        // journey types...
        var segmentDict = [String: Any] ()
        var segmentArray:[Any] = []
        var stops_array: [Any] = []
        var journeyType = "oneway"
        
        if DTravelModel.tripType == .Multi {
             journeyType = "multicity"
            
            // getting stop list...
            for model in DCityModel.mulityCitiesArray {
                
                let startDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: model.start_date!)
                let start_dateStr = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: startDate)
                
                let params = ["Origin": model.depart_cityCode!,
                              "CabinClass": DTravelModel.flight_class,
                              "Destination": model.arrival_cityCode!,
                              "DepartureDate": start_dateStr]
                stops_array.append(params)
            }
        }
        else {
            
            segmentDict["Origin"] = DTravelModel.departAirline["airline_code"]!
            segmentDict["Destination"] = DTravelModel.destinationAirline["airline_code"]!
            segmentDict["CabinClass"] = DTravelModel.flight_class
            segmentDict["DepartureDate"] = DateFormatter.getDateString(formate: "yyyy-MM-dd",
            date: DTravelModel.departDate)
            
            if DTravelModel.tripType == .Round {
                journeyType = "circle"
                segmentDict["return_date"] = DateFormatter.getDateString(formate: "yyyy-MM-dd",
                date: DTravelModel.returnDate)
            }
        }
        
        segmentArray.append(segmentDict)
        
        // params...
        var params: [String: Any] = ["AdultCount": "\(DTravelModel.adultCount)",
            "ChildCount": "\(DTravelModel.childCount)",
            "InfantCount": "\(DTravelModel.infantCount)",
            "JourneyType": journeyType,
            "PreferredAirlines": DTravelModel.preferedAirLine]
        
        params["Segments"] = segmentArray
        if DTravelModel.tripType == .Multi {
            params["Segments"] = stops_array
        }
        print("params: \(params)")
        
        let paramString: [String: String] = ["flight_search": VKAPIs.getJSONString(object: params)]

        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Flight search success: \(String(describing: resultObj))")
                
                // response data...
                if let result = resultObj as? [String: Any] {
                    //self.lendingPlay.pause()
                    if result["status"] as? Bool == false {
                        //self.playSound(sound: "all-empty-result")
                    }else {
//                        self.playSound(sound: "flight-post-load")
                    }
                    // flight type...
                    var isDomestic = true
                    if result["IsDomestic"] as? Bool == false {
                        isDomestic = false
                    }
                    self.searchKey = ""
                    if let search_key = result["cache_file_name"] as? String {
                        self.searchKey = search_key
//                        self.gettingFlightDetails_HTTPConnection(searchKey: search_key)
                    }
                    // round trip in international...
                    if isDomestic == false && DTravelModel.tripType == .Round || DTravelModel.tripType == .Multi {
                        DFlightSearchModel.createModels_InterRoundOrMulti(result_dict: result)
                    } else {
                        DFlightSearchModel.createModels(result_dict: result)
                        print("API flights count:", result["Flights"])
                        print("Parsed depart count:", DFlightSearchModel.flightsDepart_array.count)
                    }
                } else {
                    print("Flight search formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight search error : \(String(describing: error?.localizedDescription))")
            }
            self.reloadFlightInformation()
            self.gettingFlightDetails_HTTPConnection(searchKey: self.searchKey)

            SwiftLoader.hide()
        }
    }
    
    
    func gettingFlightDetails_HTTPConnection(searchKey: String) {
//        if let data = JSONLoaderAny.loadJSON(from: "flightdetails") {
//            if let result = data as? [[String: Any]] {
//                // response data...
//                //self.playSound(sound: "flight-post-load")
//
//                DFlightSearchModel.flightDetailsDict = result[0]
//                if result.count == 2 {
//                    DFlightSearchModel.flightDetailsReturnDict = result[1]
//                }
//                
//            } else {
//                self.view.makeToast(message: "Unable to fetch the data")
//                print("Flight Details formate : \(String(describing: data))")
//            }
//        }
        
        SwiftLoader.hide()

        
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["search_key": searchKey]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: params, file: FLIGHT_Details, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Flight Details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [[String: Any]] {
                    // response data...
                    //self.playSound(sound: "flight-post-load")

                    DFlightSearchModel.flightDetailsDict = result[0]
                    if result.count == 2 {
                        DFlightSearchModel.flightDetailsReturnDict = result[1]
                    }
                    
                } else {
                    self.view.makeToast(message: "Unable to fetch the data")
                    print("Flight Details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight Details error : \(String(describing: error?.localizedDescription))")
            }
            //self.lendingPlay.pause()
//            self.playSound(sound: "flight-post-load")
            SwiftLoader.hide()
        }
         
    }

    func gettingFlight_FairRules(data_access_key: String, booking_sourceKey: String, authKey: String) {
        
        SwiftLoader.show(animated: true)
        
        // params...
        let params:[String: String] = ["search_access_key": authKey, "data_access_key": data_access_key,"booking_source": booking_sourceKey]
        
        let paramString : [String : String] = ["farerules":VKAPIs.getJSONString(object: params)]
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: FLIGHT_FareRules, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Fair rules success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dictArray = result["data"] as? [[String: Any]] {
                            
                            let modelsArray = DFairRulesModel.createModel(data_array: data_dictArray)
                            self.moveToFairRulesScreen(fairRules: modelsArray)
                        }
                    } else {
                        
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Fair rules formate : \(String(describing: resultObj))")
                }
            } else {
                print("Fair rules error : \(String(describing: error?.localizedDescription))")
            }
            SwiftLoader.hide()
        }
    }
    
    func moveToFairRulesScreen(fairRules: [DFairRulesModel]) {
        
        if fairRules.count != 0 {
            
            // move to fair rules screen...
            let fairObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightFairRules") as! FlightFareRules
            fairObj.fairRules_array = fairRules
            self.navigationController?.present(fairObj, animated: true, completion: nil)
//            self.navigationController?.pushViewController(fairObj, animated: true)
        } else {
            self.view.makeToast(message: "Please try again")
        }
    }
}
