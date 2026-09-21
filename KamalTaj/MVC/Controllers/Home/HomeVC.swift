//
//  HomeVC.swift
//  Internacia
//
//  Created by Admin on 28/10/22.
//

import UIKit
import AVFoundation

enum ModuleType {
    case Flight
    case Hotel
    case Bus
}


class HomeVC: UIViewController, TopDestinationsProtocol {
    func selectToDestHotels(index: Int) {
        print("Hotel index: \(index)")
        print()
        let model = trendingHotel_Array[index]
        
        let hotelInfo: [String: String] = [
            "stateprovince": model.stateName,
            "cityid": model.city_id ?? "",
            "countrycode": model.countryCode ?? "",
            "StateProvinceCode": model.stateCode,
            "country": model.countryName ?? "",
            "Destination": model.cityName ?? "",
            "cache_hotels_count": model.hotelCount ?? "",
            "origin": model.origin_id ?? ""
        ]
        
        DHTravelModel.hotelCity_dict = hotelInfo
        moveToHotelSearchListScreen()
        
        
    }
    
    func selectFlightDest(index: Int) {
        print("Flight index: \(index)")
        let model = trendingFlight_Array[index]
        
        
        

//            if DTravelModel.tripType == .OneWay || DTravelModel.tripType == .Round {
        DTravelModel.tripType = .OneWay
        DTravelModel.departAirline = ["airline_top_destination": "", "airline_city": model.from_airport_name ?? "", "airline_code": model.from_airport_code ?? "", "airline_country": "", "airline_fullName": model.from_airport_name ?? "", "airline_id": "", "airline_name": model.from_airport_name ?? ""]
        DTravelModel.destinationAirline = ["airline_top_destination": "", "airline_city": model.to_airport_name ?? "", "airline_code": model.to_airport_code ?? "", "airline_country": "", "airline_fullName": model.to_airport_name ?? "", "airline_id": "", "airline_name": model.to_airport_name ?? ""]
                DTravelModel.departDate = departDate
                DTravelModel.returnDate = returnDate
                DTravelModel.preferedAirLine = preferedAirline

//            }
            let flightSearchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightSearchListVC") as! FlightSearchListVC
            self.navigationController?.pushViewController(flightSearchObj, animated: true)
    }
    
    func selectBusesDest(index: Int) {
        print("Bus index: \(index)")
    }
    
    func selectpromocode(message: String) {
        self.view.makeToast(message: message)
    }
    
    // MARK: - IBOutlets
    // Home
    @IBOutlet weak var tbl_ads: UITableView!
    @IBOutlet weak var ads_tbl_hconstraint: NSLayoutConstraint!
    @IBOutlet weak var TopSCView: NSLayoutConstraint!
    @IBOutlet weak var coll_tabModules: UICollectionView!
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var img_currency: UIImageView!
    
    var traveller = TravellerType.Adult
    var module =  ModuleType.Flight
    
    enum TravellerType {
        case Adult
        case Child
        case Infant
    }
    
    var adultCount: Int = 1
    var childCount: Int = 0
    var infantCount: Int = 0
    
    var topOffer_Array: [DCommonTopOfferItems] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
//    var toHolidayDestinationArray: [DCommonTrendingPackageItem] = []
    var promocodeArray: [DCommonTopOfferItems] = []
    
    var view_currencyPop: CurrencyView?
    var temp_currencyModel: DCurrencyItem?
    
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    
    let module_array = [
        ("Flight", "ic_flight_module"),
        ("Hotels", "ic_hotel_module")
        
    ]
    // Hotel
    @IBOutlet weak var lbl_checkInDate: UILabel!
    @IBOutlet weak var lbl_checkOutDate: UILabel!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_numberOfNights: UILabel!
    @IBOutlet weak var lbl_numberOfRooms: UILabel!
    @IBOutlet weak var lbl_guestDetails: UILabel!
    
    // one way elements...
    var checkIn_date: Date?
    var checkOut_date: Date?
    
    
    @IBOutlet weak var view_Flight: UIView!
    @IBOutlet weak var view_Hotel: UIView!

    @IBOutlet weak var hotel_height: NSLayoutConstraint!
    
    // MARK: - Flight
    
    @IBOutlet weak var view_flightTripType: UIView!
    @IBOutlet weak var view_flights : UIView!
    @IBOutlet weak var view_oneWayRound: UIView!
    @IBOutlet weak var tf_sourceCity: UITextField!
    @IBOutlet weak var tf_destinationCity: UITextField!
    @IBOutlet weak var lbl_class: UILabel!
    
    @IBOutlet weak var lbl_departDate: UILabel!
    @IBOutlet weak var view_returnDate: UIView!
    @IBOutlet weak var lbl_returnDate: UILabel!
    
    @IBOutlet var view_classPop: UIView!
    @IBOutlet weak var view_classPopSub: UIView!
    
    @IBOutlet weak var view_travallerPop: UIView!
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var lbl_infantCount: UILabel!
    @IBOutlet weak var lbl_adult: UILabel!
    @IBOutlet weak var lbl_child: UILabel!
    @IBOutlet weak var lbl_infant: UILabel!
    
    @IBOutlet weak var btn_addCity: UIButton!
    
    @IBOutlet weak var heiAddCityBtn: NSLayoutConstraint!
    @IBOutlet weak var view_multiCity: UIView!
    @IBOutlet weak var tbl_multiCity: UITableView!
    @IBOutlet weak var addCities_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var tf_prefferedAirline: UITextField!
    @IBOutlet weak var btn_preferedAirline: UIButton!

    var preferedAirline : String = ""

    
    var defaultColor: UIColor?
    var calSelectedDate = Date()
    
    // one way elements...
    var departDate = Date()
    var returnDate = Date()
    var returnDateBool = false
    
    var departAirline: [String: Any]?
    var destinationAirline: [String: Any]?
    var destinationBool = false
    var cityIndex: Int = 0
    var mulityCititesListArray: [DCityModel] = []
    
    
    //    MARK: Transfers
//    @IBOutlet weak var  view_transfer: UIView!
    
    @IBOutlet weak var view_infantTraveller: UIView!
    
//    MARK: Bus
//    @IBOutlet weak var tf_bSource: UITextField!
//    @IBOutlet weak var tf_bDestination: UITextField!
//    @IBOutlet weak var lbl_bSelectedDate: UILabel!
//
//    //MARK: - Variables
//    var bSourceCity : [String: Any]?
//    var bDestinationCity : [String: Any]?
//    var bDepartDate = Date()


    override func viewDidLoad() {
        super.viewDidLoad()
        // add views...

        adjustTopSpacingForStatusBar()
        setupModuleviews()
        setupPopUpViews()
        configureCurrency()
        
        homePageAdsList_APIConnection()
        getAllPromoCode_APIConnection()
        
        DCityModel.mulityCitiesArray.removeAll()
        mulityCititesListArray = DCityModel.createModel()
//        mulityCititesListArray = DCityModel.createModel()
        
        clearInformationAfterBooking()
//        clearBusInfoAfterBooking()
        // MARK: - Module Setup
        setupFlights()
        setupHotel()
//        setupBus()
        
        updateTravellerInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addTableCollViewDelegates()
        addSideMenu()
    }
    
    override func viewDidLayoutSubviews() {
        coll_tabModules.layoutIfNeeded()
    }
    // MARK: - Setup Functions
    private func setupFlights() {
        departAirline = [
            "airline_country": "India",
            "airline_top_destination": "6",
            "airline_fullName": "Bengaluru International Airport, Bangalore, India",
            "airline_name": "Bengaluru International Airport",
            "airline_id": "801",
            "airline_code": "BLR",
            "airline_city": "Bangalore"
        ]
        
        destinationAirline = [
            "airline_id": "1921",
            "airline_country": "UAE",
            "airline_name": "Dubai International Airport",
            "airline_code": "DXB",
            "airline_city": "Dubai",
            "airline_fullName": "Dubai International Airport, Dubai, UAE",
            "airline_top_destination": "5"
        ]
        
        updateDepartDestinationCity()
    }
    
    private func setupHotel() {
        let hotelInfo: [String: String] = ["stateprovince": "Karnataka", "cityid": "111124", "countrycode": "IN", "StateProvinceCode": "KA", "country": "India", "Destination": "Bangalore", "cache_hotels_count": "0", "origin": "42209"]
        
        tf_city.text = "\(hotelInfo["Destination"]!), \(hotelInfo["country"]!)"
        DHTravelModel.hotelCity_dict = hotelInfo
        print(hotelInfo)
    }
//    private func setupBus(){
//        DBTravelModel.departDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
//        updateDepartDateUI()
//    }
    //MARK: - UI Setup
    func setupModuleviews(){
        view_Hotel.isHidden = true
        view_returnDate.isHidden = false
//        view_transfer.isHidden = true
        
        view_returnDate.alpha = 0.5
        view_returnDate.isUserInteractionEnabled = false
    }
    
    func setupPopUpViews(){
        // Remove other subviews with specific tags
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            for view in keyWindow.subviews where [101, 102, 103, 104, 105, 106].contains(view.tag) {
                view.removeFromSuperview()
            }
            
            // MARK: Home - Currency Pop View
            self.view_currencyPop = CurrencyView.loadViewFromNib() as? CurrencyView
            self.view_currencyPop?.isHidden = true
            self.view_currencyPop?.tag = 102
            keyWindow.addSubview(self.view_currencyPop!)
            
            // MARK: Flight
            // Flight Class Pop-up
            self.view_classPop.isHidden = true
            self.view_classPop.tag = 101
            self.view_classPop.frame = self.view.frame
            keyWindow.addSubview(self.view_classPop)
            
            // Flight Traveller Pop-up
            self.view_travallerPop.isHidden = true
            self.view_travallerPop.tag = 103
            self.view_travallerPop.frame = self.view.frame
            keyWindow.addSubview(self.view_travallerPop)
            
        }
        getCurrencyConverterList()
        
    }
    
    func adjustTopSpacingForStatusBar(){
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = windowScene.statusBarManager {
            let topPadding = statusBarManager.statusBarFrame.height
            TopSCView.constant = -topPadding
        } else {
            TopSCView.constant = 0
        }
    }
    
    
    func addTableCollViewDelegates() {
        
        // table delegates...
        tbl_ads.delegate = self
        tbl_ads.dataSource = self
        
        tbl_ads.rowHeight = UITableView.automaticDimension
        tbl_ads.estimatedRowHeight = 140
        
        tbl_multiCity.delegate = self
        tbl_multiCity.dataSource = self
        tbl_multiCity.rowHeight = 289
        tbl_multiCity.estimatedRowHeight = 289
        // delegate...
        coll_tabModules.delegate = self
        coll_tabModules.dataSource = self
        
        // register...
        coll_tabModules.register(UINib.init(nibName: "HomeModulesCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeModulesCVCell")
    }
    
    func addSideMenu() -> Void {
        
        // remove if existed...
        let window = getWindow()
        let menu_view = window?.viewWithTag(50000)
        if menu_view != nil {
            menu_view?.removeFromSuperview()
        }
        
        // slider menu...
        let side_menu = Bundle.main.loadNibNamed("SliderMenuView", owner: nil, options: nil)![0] as! SliderMenuView
        side_menu.frame = CGRect.init(x: -self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        side_menu.delegate = self
        side_menu.btn_bg.alpha = 0
        side_menu.tag = 50000
        UIApplication.shared.keyWindow?.addSubview(side_menu)
    }
    
    //MARK: - Update UI
    func updateTableViewHeight() {
        tbl_ads.layoutIfNeeded()
        
        let height = tbl_ads.contentSize.height
        print("tbl_ads \(height)")
        for cell in tbl_ads.visibleCells {
            let height = cell.frame.size.height
            print("Cell height: \(height)")
        }
        for i in 0..<tbl_ads.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: i, section: 0)
            let rect = tbl_ads.rectForRow(at: indexPath)
            print("Row \(i): \(rect.height)")
        }
        ads_tbl_hconstraint.constant = height
    }
    
    func displayAds() {
        trendingHotel_Array = DCommonModel.trendingHotel_Array
        
        trendingFlight_Array = DCommonModel.trendingFligh_Array
//        toHolidayDestinationArray = DCommonModel.trendingPackage_Array
        promocodeArray = DCommonModel.topOffer_Array
        DispatchQueue.main.async {
            self.tbl_ads.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateTableViewHeight()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func displayPromocode(){
        displayAds()
        topOffer_Array = DCommonModel.topOffer_Array
    }
    
    func updateTravellerInfo() {
        DTravelModel.adultCount = adultCount
        DTravelModel.childCount = childCount
        DTravelModel.infantCount = infantCount
        
        lbl_adult.text =  "\(DTravelModel.adultCount) AD"
        lbl_child.text =  "\(DTravelModel.childCount) CH"
        lbl_infant.text =  "\(DTravelModel.infantCount) IN"
    }
    
    func configureCurrency() {
        
        // getting currecy list...
        if DStorageModel.currency_array.count != 0 {
        } else {
            DStorageModel.gettingCurrencyCountries()
        }
    }

    //MARK: - IBAction
    @IBAction func setUpTravellerCount(_ sender: UIButton) {
        if sender.tag == 10 {
            if adultCount > 1 {
                adultCount = adultCount - 1
            }
            if adultCount < infantCount {
                infantCount = 0
            }
        }
        else if sender.tag == 11 {
            
            if adultCount + childCount < 9 {
                adultCount = adultCount + 1
            }
            else {
                self.view_travallerPop.makeToast(message: "Max 9 passengers (Adult + child) allowed")
            }
        }
        
        // Childs
        else if sender.tag == 20 {
            if childCount > 0 {
                childCount = childCount - 1
            }
        }
        else if sender.tag == 21 {
            if adultCount + childCount < 9 {
                childCount = childCount + 1
            }
            else {
                self.view_travallerPop.makeToast(message: "Max 9 passengers (Adult + child) allowed")
            }
        }
        // infants
        else if sender.tag == 30 {
            if infantCount > 0 {
                infantCount = infantCount - 1
            }
        }
        else if sender.tag == 31 {
            if infantCount < adultCount  {
                infantCount = infantCount + 1
            }else{
                self.view_travallerPop.makeToast(message: "Max 1 Infant allowed per Adult.")
            }
        }
        
        else {}
        
        // display count...
        lbl_adultCount.text = "\(adultCount)"
        lbl_childCount.text = "\(childCount)"
        lbl_infantCount.text = "\(infantCount)"
    }
    
    @IBAction func travellersOkClicked(_ sender: Any) {
        
        updateTravellerInfo()
        view_travallerPop.isHidden = true
    }
    
    @IBAction func hideTravellerPopClicked(_ sender: Any) {
        
        view_travallerPop.isHidden = true
    }
    
    
    
    // MARK: - ButtonAction
    @IBAction func menuBtnClicked(_ sender: UIButton) {
        // menu moving...
        appDel.sideMenu_actions()
    }
    
    @IBAction func currencyBtnClicked(_ sender: UIButton) {
        
        self.view_currencyPop?.isFrom = ""
        self.view_currencyPop?.displayInformation()
        self.view_currencyPop?.delegate = self
        self.view_currencyPop?.isHidden = false
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.bringSubviewToFront(self.view_currencyPop!)
        }
    }
}
//MARK: Bus
//extension HomeVC {
//    func updateDepartDateUI() {
//        lbl_bSelectedDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: departDate)
//
//    }
//    func updateBusDepartDestinationCity(){
//        tf_bSource.text = bSourceCity?["label"] as? String ?? ""
//        tf_bDestination.text = bDestinationCity?["label"] as? String ?? ""
//
//    }
//    func moveToBusCitiesSelection(){
//        let searchObj = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BSearchCitiesVC") as! BSearchCitiesVC
//        searchObj.delegate = self
//        self.present(searchObj, animated: true, completion: nil)
//    }
//    @IBAction func busSourceButtonAction(_ sender: Any) {
//        // selelect source city
//        cityIndex = 1
//        moveToBusCitiesSelection()
//    }
//    @IBAction func busDestinationButtonAction(_ sender: Any) {
//        //select destination city
//        cityIndex = 2
//        moveToBusCitiesSelection()
//    }
//    
//    @IBAction func switchBusLocationAction(_ sender: Any) {
//        //switch loaction button action
//        if tf_bSource.text?.isEmpty == true {
//            self.view.makeToast(message: "Please Select Departure")
//            
//        } else if tf_bDestination.text?.isEmpty == true  {
//            
//            self.view.makeToast(message: "Please Select Destination")
//            
//        } else {
//            let tempCity = tf_bSource.text
//            tf_bSource.text = tf_bDestination.text
//            tf_bDestination.text = tempCity
//            let tempCities = bSourceCity
//            bSourceCity = bDestinationCity
//            bDestinationCity = tempCities
//        }
//    }
//    @IBAction func selectDateAction(_ sender: Any) {
//        module = .Bus
//        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
//        picker_popView.delegate = self
//        picker_popView.setMinimumDate(_date: Date())
//        self.view.addSubview(picker_popView)
//
//    }
//    @IBAction func searchBusesAction(_ sender: UIButton) {
//        
//        //search flight
//        let whitespace = CharacterSet.whitespacesAndNewlines
//        var messageStr = ""
//
//        if tf_bSource.text?.count == 0 || tf_bSource.text?.trimmingCharacters(in: whitespace).count == 0 {
//            messageStr = "Please select departure city"
//
//        } else if tf_bDestination.text?.count == 0 || tf_bDestination.text?.trimmingCharacters(in: whitespace).count == 0 {
//            messageStr = "Please select destination city"
//        }
//        else if tf_bSource.text == tf_bDestination.text {
//            messageStr = "The destination from and to cannot be the same"
//        }
//        if messageStr.count != 0 {
//
//            self.view.makeToast(message: messageStr)
//        } else {
//            moveToSearchBusses()
//        }
//    }
//    func moveToSearchBusses(){
//        DBTravelModel.sourceCity =   bSourceCity!
//        DBTravelModel.destinationCity = bDestinationCity!
//        DBTravelModel.departDate = bDepartDate
//        
//        //movel to buses list....
//        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusesSearchListVC") as! BusesSearchListVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//MARK: Bus Delegates
//extension HomeVC : searchBusesCitiesDelegate {
//    
//    func searchBus_info(busInfo: [String : Any]) {
//        
//        if cityIndex == 1 {
//            
//            // dispaly from city...
//            bSourceCity = busInfo
//            tf_bSource.text = busInfo["label"] as? String ?? ""
//        }
//        else if cityIndex == 2 {
//            
//            // display to city...
//            bDestinationCity = busInfo
//            tf_bDestination.text = busInfo["label"] as? String ?? ""
//        }
//
//    }
//}

//MARK: Flights
extension HomeVC {
    // MARK: - Update UI
    func updateDepartAndReturnDates() {
        lbl_departDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: departDate)
        lbl_returnDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: returnDate)
    }
    
    func updateDepartDestinationCity(){
        tf_sourceCity.text = departAirline?["airline_name"] as? String
        tf_destinationCity.text = destinationAirline?["airline_name"] as? String
    }
    func updateFlightTripTypeUI(forTag tag: Int) {
        
        for childView in view_flightTripType.subviews {
            // 1. Cast childView to your custom @IBDesignable class CRView
            guard let crView = childView as? CRView else { continue }
            
            let isSelected = crView.tag == tag
            
            // 2. Safely apply your custom designable properties directly
            crView.backgroundColor = isSelected ? UIColor(hexString: "#BB060A") : .white
            crView.borderWidth = isSelected ? 0 : 1
            crView.borderColor = isSelected ? UIColor(hexString: "#BB060A") : UIColor(hexString: "#003B95")
            
            // If you want to dynamically adjust cornerRadius or maskBounds on selection, do it here:
            crView.cornerRadius = 8
            crView.maskBounds = true
            
            // 3. Update the labels and images inside this view
            for childSubView in crView.subviews {
                if let lbl = childSubView as? UILabel {
                    lbl.textColor = isSelected ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#003B95")
                }
                if let imageView = childSubView as? UIImageView {
                    imageView.image = UIImage(named: isSelected ? "ic_circle_fill_white" : "ic_circle_white")
                    imageView.contentMode = .scaleToFill
                }
            }
        }
        
        // Common state reset
        view_returnDate.isHidden = false
        view_returnDate.alpha = 0.5
        view_returnDate.isUserInteractionEnabled = false
        
        view_oneWayRound.isHidden = true
        view_flights.isHidden = false
        view_multiCity.isHidden = true
        
        if tag == 12 {
            DTravelModel.tripType = .Multi
            view_multiCity.isHidden = false
            addCities_HConstraint.constant = CGFloat(289 * mulityCititesListArray.count)
            
            tbl_multiCity.reloadData()
            tbl_multiCity.layoutIfNeeded()
            
            print("hotel_height :\(hotel_height.constant)")
        } else {
            view_flights.isHidden = false
            view_oneWayRound.isHidden = false
            print("hotel_height :\(hotel_height.constant)")
            
            if tag == 11 {
                DTravelModel.tripType = .Round
                view_returnDate.alpha = 1.0
                view_returnDate.isHidden = false
                view_returnDate.isUserInteractionEnabled = true
                
                returnDateBool = true
                returnDate = Calendar.current.date(byAdding: .day, value: 1, to: departDate)!
                updateDepartAndReturnDates()
            } else {
                DTravelModel.tripType = .OneWay
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - OBJC Function
//    @objc func clearBusInfoAfterBooking(){
//        tf_bSource.text = ""
//        tf_bDestination.text = ""
//        bDepartDate = Date()
//    }
    @objc func clearInformationAfterBooking() {
        
        // flight Trip Types colors changing...
        for childView in view_flightTripType.subviews {
            
            for childSubView in childView.subviews {
                let child_view = childSubView as? UIImageView
                child_view?.image = UIImage.init(named: "ic_circle_white")
                childView.backgroundColor = .white
                
                
                if childView.tag == 10 {
                    child_view?.image = UIImage.init(named: "ic_circle_fill_white")
                    childView.backgroundColor = UIColor(hexString: "#BB060A")
                }
            }
        }
        
        DTravelModel.preferedAirLine = ""
        preferedAirline = ""
        // one way & multi cities views...
        view_returnDate.alpha = 0.5
        view_returnDate.isHidden = true
        view_returnDate.isUserInteractionEnabled = false
        view_oneWayRound.isHidden = false
        
        // source and destination infomration...
        tf_sourceCity.text = ""
        tf_destinationCity.text = ""
        
        // selected dates...
        departDate = Date()
        returnDate = Calendar.current.date(byAdding: .day, value: 1, to: departDate)!
        returnDateBool = false
        updateDepartAndReturnDates()
        
        DTravelModel.clearAllTraveller()
        
        // display traveller count...
        lbl_adultCount.text = "\(DTravelModel.adultCount) AD"
        lbl_childCount.text = "\(DTravelModel.childCount) CH"
        lbl_infantCount.text = "\(DTravelModel.infantCount) IN"
        
        
        DCityModel.mulityCitiesArray.removeAll()
        mulityCititesListArray = DCityModel.createModel()
//        mulityCititesListArray = DCityModel.createModel()
        tbl_multiCity.reloadData()
        
        // color changing...
        DTravelModel.flight_class = "Economy"
        lbl_class.text = String.init(format: " %@",DTravelModel.flight_class)
        for childView in view_classPopSub.subviews {
            if childView is UIButton {
                
                let btn_view = childView as! UIButton
                btn_view.setTitleColor(UIColor.black, for: .normal)
                if btn_view.tag == 10 {
                    btn_view.setTitleColor(UIColor(hexString: "#003B95"), for: .normal)
                }
            }
        }
        //        hotel
        tf_city.text = ""
        
        // defult depart is today date...
        checkIn_date = Date()
        checkOut_date = Date().addingTimeInterval(24*60*60)
        updateCheckInCheckOutDates(isFirst: true)
        
        // add default room...
        AddRoomModel.addRooms_array.removeAll()
        let rooms_array = AddRoomModel.createModel()
        updateRoomAndGuestInfo()
    }
    
    // MARK: - Navigation
    func moveToFlightCitiesSelection() {
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .Airline
        searchObj.delegate = self
        if cityIndex != 1 {
        }
        self.present(searchObj, animated: true, completion: nil)
    }
    
    func moveToFlightSearchListScreen() {
        if DTravelModel.tripType == .OneWay || DTravelModel.tripType == .Round {
            DTravelModel.departAirline = departAirline!
            DTravelModel.destinationAirline = destinationAirline!
            DTravelModel.departDate = departDate
            DTravelModel.returnDate = returnDate
            DTravelModel.preferedAirLine = preferedAirline

        }
        let flightSearchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightSearchListVC") as! FlightSearchListVC
        self.navigationController?.pushViewController(flightSearchObj, animated: true)
    }
    // MARK: - IBActions
    @IBAction func flightTripTypeClicked(_ sender: UIButton) {
        updateFlightTripTypeUI(forTag: sender.tag)
    }
    
    @IBAction func sourceDestination_CitiesClicked(_ sender: UIButton) {
        
        // button actions...
        if sender.tag == 10 {
            cityIndex = 1
        } else {
            cityIndex = 2
        }
        // select city...
        moveToFlightCitiesSelection()
    }
    
    @IBAction func switchSearchCtities(_ sender: Any) {
        if tf_sourceCity.text?.isEmpty == true {
            self.view.makeToast(message: "Please Select Departure")
            
        } else if tf_destinationCity.text?.isEmpty == true  {
            
            self.view.makeToast(message: "Please Select Destination")
            
        } else {
            let tempCity = tf_sourceCity.text
            tf_sourceCity.text = tf_destinationCity.text
            tf_destinationCity.text = tempCity
            let tempAirline = departAirline
            departAirline = destinationAirline
            destinationAirline = tempAirline
        }
    }
    
    @IBAction func departReturn_DatesClicked(_ sender: UIButton) {
        module = .Flight
        
        returnDateBool = false
        if sender.tag == 11 {
            returnDateBool = true
        }
        
        // date pop view...
        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
        picker_popView.delegate = self
        if returnDateBool {
            
            picker_popView.setMinimumDate(_date: departDate)
            picker_popView.setDate(_date: returnDate)
            
        } else {
            picker_popView.setDate(_date: departDate)
            picker_popView.setMinimumDate(_date: Date())
            
        }
        picker_popView.dateType = .Date
        self.view.addSubview(picker_popView)
    }
    
    @IBAction func travellersClicked(_ sender: Any) {
        
        adultCount = DTravelModel.adultCount
        childCount = DTravelModel.childCount
        infantCount = DTravelModel.infantCount
        
        // display count...
        lbl_adultCount.text = "\(adultCount)"
        lbl_childCount.text = "\(childCount)"
        lbl_infantCount.text = "\(infantCount)"
        
        self.view_infantTraveller.isHidden = false
        self.view_travallerPop.isHidden = false
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.bringSubviewToFront(self.view_travallerPop)
        }
    }
    
    @IBAction func advancedOptionsClicked(_ sender: UIButton) {
        self.view_classPop.isHidden = false
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.bringSubviewToFront(self.view_classPop)
        }
    }
    
    @IBAction func classPopHiddenButtonClicked(_ sender: UIButton) {
        self.view_classPop.isHidden = true
    }
    
    @IBAction func selectClassButtonClicked(_ sender: UIButton) {
        
        // color changing...
        for childView in view_classPopSub.subviews {
            if childView is UIButton {
                
                let btn_view = childView as! UIButton
                btn_view.setTitleColor(UIColor.black, for: .normal)
                if btn_view.tag == sender.tag {
                    btn_view.setTitleColor(UIColor(hexString: "#003B95"), for: .normal)
                }
            }
        }
        
        // class actions...
        if sender.tag == 10 {
            DTravelModel.flight_class = "Economy"
        }
        else if sender.tag == 11 {
            DTravelModel.flight_class = "Premium Economy"
        }
        else if sender.tag == 12 {
            DTravelModel.flight_class = "Business"
        }
        else if sender.tag == 13 {
            DTravelModel.flight_class = "First"
        }
        else {}
        self.view_classPop.isHidden = true
        
        lbl_class.text = String.init(format: "%@",DTravelModel.flight_class)
    }
    
    
    @IBAction func addCityClicked(_ sender: UIButton) {
        
        let valid = muticityTotalFormValidation()
        if valid == true {
            
            if mulityCititesListArray.count <= 5 {
                
                // add one city and reload infomration....
                mulityCititesListArray = DCityModel.createModel()
                addCities_HConstraint.constant = CGFloat(289 * mulityCititesListArray.count) //+ 96 /*+ 120*/
               // hotel_height.constant = addCities_HConstraint.constant + 100/*368*/
                print("hotel_height :\(hotel_height.constant)")
                
                tbl_multiCity.reloadData()
                tbl_multiCity.layoutIfNeeded()
                
            }
            
//            // add city button hidden at mulit cities count = 5(Max)...
//            btn_addCity.isHidden = false
//            if mulityCititesListArray.count == 5 {
//                btn_addCity.isHidden = true
//            }
            // add city button hidden at mulit cities count = 5(Max)...
              btn_addCity.isHidden = false
              heiAddCityBtn.constant = 44
              if mulityCititesListArray.count == 5 {
                  btn_addCity.isHidden = true
                  heiAddCityBtn.constant = 0
              }
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        
        if DTravelModel.tripType == .OneWay || DTravelModel.tripType == .Round {
            
            // form validations...
            let whitespace = CharacterSet.whitespacesAndNewlines
            var messageStr = ""
            if tf_sourceCity.text?.count == 0 || tf_sourceCity.text?.trimmingCharacters(in: whitespace).count == 0 {
                messageStr = "Please select departure city"
            }
            else if tf_destinationCity.text?.count == 0 || tf_destinationCity.text?.trimmingCharacters(in: whitespace).count == 0 {
                messageStr = "Please select destination city"
            }
            else {
                
                if DTravelModel.tripType == .Round {
                    
                    // user selected past date...
                    let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: departDate)
                    let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                    
                    let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: returnDate)
                    let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                    
                    if (loDepartDate.compare(loCalDate) == .orderedDescending)  {
                        messageStr = "Please select return date greater than depart date !"
                    }
                }
            }
            
            // validation message...
            if messageStr.count != 0 {
                self.view.makeToast(message: messageStr)
            } else {
                moveToFlightSearchListScreen()
            }
        }
        else {
            let valid = muticityTotalFormValidation()
            if valid == true {
                moveToFlightSearchListScreen()
            }
            
        }
    }
    @IBAction func prefferedFlights_Clicked(_ sender: Any) {
//        if sender.tag == 10 {
//
//        }else {
//
//        }
        moveToPrefferedFlight()
    }
    @IBAction func remocePrefered(_ sender: Any) {
        preferedAirline = ""
        DTravelModel.preferedAirLine = ""
        tf_prefferedAirline.text = ""
        updatePrefferedBtn()
    }
    func updatePrefferedBtn(){
        btn_preferedAirline.isHidden = true
        if tf_prefferedAirline.text?.isEmpty == false {
            btn_preferedAirline.isHidden = false
        }
    }
    func moveToPrefferedFlight(){
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .PrefferAirline
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
}

//MARK: - * Hotel Module
extension HomeVC {
    
    // MARK: - Update UI
    func updateRoomAndGuestInfo() {
        // Adult and child counts...
        var mAdults: Int = 0
        var mChilds: Int = 0
        for model in AddRoomModel.addRooms_array {
            
            mAdults = mAdults + model.adult_count
            mChilds = mChilds + model.child_count
        }
        
        // display information...
        lbl_numberOfRooms.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guestDetails.text = "\(mAdults) AD \(mChilds) CH"
    }
    
    func updateCheckInCheckOutDates(isFirst: Bool) {
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: checkIn_date!)
        lbl_checkOutDate.text = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: checkOut_date!)
        
        // no of nights...
        let night_no = DateFormatter.getDaysBetweenTwoDates(startDate: checkIn_date!, endDate: checkOut_date!)
        tf_numberOfNights.text = "\(night_no) Nights"
    }
    
    // MARK: - Navigation
    func moveToHotelSearchListScreen(){
        // Adult and child counts...
        var mAdults: Int = 0
        var mChilds: Int = 0
        for model in AddRoomModel.addRooms_array {
            
            mAdults = mAdults + model.adult_count
            mChilds = mChilds + model.child_count
        }
        
        // store infomration...
        DHTravelModel.adult_count = mAdults
        DHTravelModel.child_count = mChilds
        DHTravelModel.checkin_date = checkIn_date!
        DHTravelModel.checkout_date = checkOut_date!
        DHTravelModel.noof_nights = DateFormatter.getDaysBetweenTwoDates(startDate: DHTravelModel.checkin_date,
                                                                         endDate: DHTravelModel.checkout_date)
        
        
        let hSearchObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelSearchListVC") as! HotelSearchListVC
        self.navigationController?.pushViewController(hSearchObj, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func searchHCityAction(_ sender: Any) {
        let searchObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "SearchHotelCitiesVC") as! SearchHotelCitiesVC
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
    
    @IBAction func checkInCheckOut_DatesClicked(_ sender: UIButton) {
        module = .Hotel
        returnDateBool = false
        if sender.tag == 11 {
            returnDateBool = true
        }
        
        // date pop view...
        let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
        picker_popView.delegate = self
        if returnDateBool {
            
            picker_popView.setMinimumDate(_date: self.checkIn_date!)
            picker_popView.setDate(_date: self.checkOut_date!)
            
        } else {
            picker_popView.setDate(_date: self.checkIn_date!)
            picker_popView.setMinimumDate(_date: Date())
        }
        
        picker_popView.dateType = .DateAndTime
        self.view.addSubview(picker_popView)
    }
    
    @IBAction func guestAndRoomCountAction(_ sender: Any) {
        let addRoomObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelAddRoomsVC") as! HotelAddRoomsVC
        addRoomObj.delegate = self
        self.navigationController?.pushViewController(addRoomObj, animated: true)
    }
    
    @IBAction func hotelSearchButtonClick(sender : UIButton) {
        
        let whitespace = CharacterSet.whitespacesAndNewlines
        if tf_city.text?.count == 0 || tf_city.text?.trimmingCharacters(in: whitespace).count == 0 {
            
            self.view.makeToast(message: "Please select hotel city")
        }
        else {
            moveToHotelSearchListScreen()
        }
    }
}

// MARK: - UICollectionViewDelegate and DataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let estimatedWidth = module_array[indexPath.row].0.size(withAttributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 16.0)!]).width + 66
//        
//        return CGSize(width: estimatedWidth, height: 44)
//    }
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let leftRightInset: CGFloat = 20 + 20
        let spacing: CGFloat = 10 * (itemsPerRow - 1)
        
        let availableWidth = collectionView.frame.width - leftRightInset - spacing
        let cellWidth = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: cellWidth, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return module_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeModulesCVCell", for: indexPath as IndexPath) as! HomeModulesCVCell
        
        //display information...
        if selectedIndex == indexPath {
            cell.updateSelection(isSelected: selectedIndex == indexPath)
            
        }
        cell.lbl_title.text = module_array[indexPath.row].0
        cell.img_icon.image = UIImage(named: module_array[indexPath.row].1)
        cell.updateSelection(isSelected: selectedIndex == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        self.hotel_height.constant = 774/*738*/
        self.selectedIndex = indexPath // Save selected index
//        if self.selectedIndex.row == 2 {
//            self.module = .Bus
//            
//            self.view_Flight.isHidden = true
//            self.view_Hotel.isHidden = true
//            self.view_transfer.isHidden = false
//            self.hotel_height.constant =   412
//            DTravelModel.moduleType = .Bus
//        }
//        else
        if self.selectedIndex.row == 1 {
            
            self.module = .Hotel
            DTravelModel.moduleType = .Hotel
            self.view_Flight.isHidden = true
            self.view_Hotel.isHidden = false
//            self.view_transfer.isHidden = true
            
            self.hotel_height.constant = 412
        }
        else if self.selectedIndex.row == 0 {
            
            self.module = .Flight
            DTravelModel.moduleType = .Flight
            self.view_Hotel.isHidden = true
            self.view_Flight.isHidden = false
//            self.view_transfer.isHidden = true
            self.updateFlightTripTypeUI(forTag: 10)
            
        }
        else {
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        coll_tabModules.reloadData() // Refresh UI
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

//MARK: - Tableview delegate and datasource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_multiCity {
            return 289
            
        }else{
            if indexPath.row == 0 {
                return 338
            } else if indexPath.row == 1 {
                return 340
            } else if indexPath.row == 2 {
                return 69 + 222
            }  else {
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_multiCity {
            return mulityCititesListArray.count
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell creation...
        if tableView == tbl_multiCity {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FlightCitiesCell") as? FlightCitiesCell
            if cell == nil {
                tableView.register(UINib(nibName: "FlightCitiesCell", bundle: nil), forCellReuseIdentifier: "FlightCitiesCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FlightCitiesCell") as? FlightCitiesCell
            }
            cell?.delegate = self
            
            // cancel button visibility...
            cell?.btn_cancel.isHidden = false
            if mulityCititesListArray.count < 3 {
                cell?.btn_cancel.isHidden = true
            }
            
            // display inforation...
            cell?.tf_departureCity.text = mulityCititesListArray[indexPath.row].depart_cityName
            cell?.tf_destinationCity.text = mulityCititesListArray[indexPath.row].arrival_cityName
            cell?.tf_selectDate.text = mulityCititesListArray[indexPath.row].start_date
            
            cell?.selectionStyle = .none
            return cell!
        }
        
        else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
            if cell == nil {
                tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
            }
            cell?.selectionStyle = .none
            cell?.topDestinationsDelegate = self
            switch indexPath.row {
            case 0:
                cell?.adsType = "Hotel"
                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
                
            case 1:
                cell?.adsType = "Flight"
                cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
                
            case 2:
                cell?.adsType = "PromoCode"
                print("Home Add Cell:Homepage: \(promocodeArray.count)")
                cell?.topHolidayDestination(trendingHolidayPackage: promocodeArray)
                
            default:
                return UITableViewCell()
            }
            
            return cell!
        }
        
    }
    
    func muticityTotalFormValidation() -> Bool {
        
        // form validations...
        print(mulityCititesListArray.count)
        var message = ""
        for i in 0 ..< mulityCititesListArray.count {
            
            if mulityCititesListArray[i].depart_cityName == "" {
                message = "Please select departure city - \(i + 1)"
                break
            }
            else if mulityCititesListArray[i].arrival_cityName == "" {
                message = "Please select destination city - \(i + 1)"
                break
            }
            else if mulityCititesListArray[i].depart_cityId == mulityCititesListArray[i].arrival_cityId {
                
                message = "The destination from and to cannot be the same - \(i + 1)"
                break
            }
            else if mulityCititesListArray[i].start_date == "" {
                message = "Please select date - \(i + 1)"
                break
            }
            else {}
        }
        
        // alert if anyone not fileds...
        if message.count != 0 {
            self.view.makeToast(message: message)
            return false
        }
        else {
            return true
        }
    }
    func mutiCityDateValidations(indexS: Int) {
        
        // if date changes at middle...
        if DCityModel.mulityCitiesArray.count > indexS + 1 {
            if DCityModel.mulityCitiesArray[indexS + 1].start_date != "" {
                
                // no.of days between dates...
                let firstDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                      date: DCityModel.mulityCitiesArray[indexS].start_date!)
                let secondDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                       date: DCityModel.mulityCitiesArray[indexS+1].start_date!)
                let days = DateFormatter.getDaysBetweenTwoDates(startDate: firstDate,
                                                                endDate: secondDate)
                print("Days between dates : \(days)")
                // clear the dates if days less than zero...
                if days <= 0 {
                    for i in 0 ..< DCityModel.mulityCitiesArray.count {
                        if i > indexS {
                            DCityModel.mulityCitiesArray[i].start_date = ""
                        }
                    }
                }
            }
        }
        
        // reload informations...
        mulityCititesListArray = DCityModel.mulityCitiesArray
        tbl_multiCity.reloadData()
    }
}
//MARK: - Mulicity Cell CellButtonActions delegate
extension HomeVC: flightCitiesCellDelegate {
    // MARK: - Select departure
    func departureCity_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        destinationBool = false
        multiCitiesSelectValidations(index: indexS, isDate: false)
    }
    
    // MARK: - Select Destination City
    func destinationCity_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        destinationBool = true
        multiCitiesSelectValidations(index: indexS, isDate: false)
    }
    
    //MARK: - select departure date
    func selectDate_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        multiCitiesSelectValidations(index: indexS, isDate: true)
    }
    
    //MARK: - Remove Multiciy
    func cancelButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // remove select city from the list...
        let indexPath = tbl_multiCity.indexPath(for: cell)
        DCityModel.mulityCitiesArray.remove(at: (indexPath?.row)!)
        
        // display remaining cities..
        mulityCititesListArray = DCityModel.mulityCitiesArray
        tbl_multiCity.reloadData()
        addCities_HConstraint.constant = CGFloat(289 * mulityCititesListArray.count)// + 35
//        hotel_height.constant = addCities_HConstraint.constant + 474/*368*/
        btn_addCity.isHidden = false
//        btn_addCity.isHidden = false
        heiAddCityBtn.constant = 44
    }
    
    //MARK: - MultiCity Selection Validation
    func multiCitiesSelectValidations(index: Int, isDate: Bool) {
        
        // validate befor form is empty or not...
        var message = ""
        if 0 < index {
            
            if mulityCititesListArray[index-1].depart_cityName == "" {
                message = "Please select departure city - \(index)"
            }
            else if mulityCititesListArray[index-1].arrival_cityName == "" {
                message = "Please select destination city - \(index)"
            }
            else if mulityCititesListArray[index-1].start_date == "" {
                message = "Please select date - \(index)"
            }
            else {}
        }
        
        // if any filed empty walkup alert...
        if message.count != 0 {
            self.view.makeToast(message: message)
        }
        else {
            
            // select city...
            cityIndex = index + 100
            if isDate == true {
                
                var loDate = Date()
                if index > 0 {
                    loDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: mulityCititesListArray[index-1].start_date!)
                }
                let picker_popView = Bundle.main.loadNibNamed("DatePickerPopView", owner: nil, options: nil)![0] as! DatePickerPopView
                picker_popView.delegate = self
                
                picker_popView.setMinimumDate(_date: loDate)
                self.view.addSubview(picker_popView)
                
            }
            else {
                moveToCitiesSelection()
            }
        }
    }
    
    func moveToCitiesSelection() {
        
        // search city...
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .Airline
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
}

//MARK: Sidemenu Delegate
extension HomeVC: SliderMenuViewDelegate {
    
    // MARK:- SMenuViewDelegate
    func sliderMenuActions(section_name: String) {
        let userId = ""
        // menu moving...
        let appDele : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDele.sideMenu_actions()
        print("slider menu : \(section_name)")
        
        let navControl = getRootNavigation()
        
        // menu actions...
        if section_name == "My Account" {
            if userId.getUserId().isEmpty {
                view.makeToast(message: "Please Login")
            } else {
                // move to my profile...
//                let profile_vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
//                profile_vc.hidesBottomBarWhenPushed = true
//                profile_vc.isFrom = "Menu"
//                self.navigationController?.pushViewController(profile_vc, animated: true)
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 2
                }

            }
        }
        else if section_name == "Home" {
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
            }

        }
        else if section_name == "My Bookings" {
            if userId.getUserId().isEmpty {
                view.makeToast(message: "Please Login")
            } else {
                
                // move to my bookings...
//                                let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
////                                                bookVC.from = "menu"
//                                navControl?.pushViewController(bookVC, animated: true)
                // move to My Bookings tab
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
        }
        else if section_name == "About Us" {
            
            
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .AboutUs
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Contact Us" {
            
            // move to contact us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .ContactUs
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Privacy Policy" {
            
            // move to Privacy...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Privacy
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Terms & Conditions" {
            
            // move to about us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Terms
            navControl?.pushViewController(vc, animated: true)
        } else if section_name == "My Rewards" || section_name == "Wallet" {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
            navControl?.pushViewController(vc, animated: true)
        }else if section_name == "Change Password" {
            let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            navControl?.pushViewController(changePassVC, animated: true)
            
        } else if section_name == "Rate Us" {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
            
            navControl?.pushViewController(vc, animated: true)
        }else if  section_name == "Notifications" {
            //            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            navControl?.pushViewController(vc, animated: true)
        } else if section_name == "Create Account"{
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            VC.isFrom = "Menu"
            navControl?.pushViewController(VC, animated: true)
        }
        else if section_name == "Logout" || section_name == "Login" {
            
            if profile_dict != nil {
                //user logout...
                UserDefaults.standard.set(nil, forKey: TMXUser_Profile)
            }
            
            // move to Login(Change root for window)...
            let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            let navigationController = UINavigationController(rootViewController: loginObj!)
            navigationController.isNavigationBarHidden = true
            appDel.window?.rootViewController = navigationController
        }
        
        else {}
    }
}

//MARK: - Currency Delegate
extension HomeVC : CurrencyDelegate {
    
    // get currency converter...
    func getCurrencyConverterList() -> Void {
        
        // currency api...
        CommonLoader.shared.startLoader(in: view)
        
        DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        if DCurrencyModel.currency_saved == nil {
            DCurrencyModel.setDefaultCurrency()
            DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        }
        TMXClass.shared.getCurrencyConverterList { [weak self] (message) in
            
            // adding inforamtion
            let old_currency = DCurrencyModel.retriveCurrency()
            for model in DCurrencyModel.currency_array {
                if old_currency?.currency_id == model.currency_id {
                    
                    DCurrencyModel.saveCurrency(model: model)
                    DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
                    break
                }
            }
            
            // success response
            if message == "Success" {
                self?.displayCurrency()
            }
            CommonLoader.shared.stopLoader()
        }
    }
    
    func displayCurrency() {
        
        temp_currencyModel = DCurrencyModel.currency_saved
        let code = DCurrencyModel.currency_saved?.currency_country ?? "USD"
        self.getCurrencyValue_APIConnection(toCurrency: code)
        lbl_currency.text = code
        img_currency.image = UIImage.init(named: String.init(format: "%@.png",code))
        
    }
    
    // MARK: - CurrencyDelegate
    func currencyListActions(model: DCurrencyItem) {
        
        temp_currencyModel = model
        
        img_currency.image = UIImage.init(named: String.init(format: "%@.png", model.currency_country!))
        lbl_currency.text = model.currency_country
        
        getCurrencyValue_APIConnection(toCurrency: model.currency_country ?? "USD")
        //        updateCurrencyValue(currency_value: model.currency_value)
    }
}
//MARK: - Flight delegates
extension HomeVC : searchCitiesDelegate {
    
    func searchAirline_info(airlineInfo: [String : Any]) {
        print("selected air line: \(airlineInfo)")
        preferedAirline = airlineInfo["code"] as? String ?? ""
        tf_prefferedAirline.text = airlineInfo["name"] as? String ?? ""
        
        let airline_name = airlineInfo["name"] as? String ?? ""
        if airline_name == "ALL" {
            DTravelModel.preferedAirLine = ""
        } else {
            DTravelModel.preferedAirLine = airlineInfo["code"] as? String ?? ""
        }
        updatePrefferedBtn()
    }
    func searchAirport_info(airlineInfo: [String : String]) {
        
        print("selected air lines: \(airlineInfo)")
        
        if cityIndex == 1 {
            
            // dispaly from city...
            departAirline = airlineInfo
            tf_sourceCity.text = airlineInfo["airline_city"]
        }
        else if cityIndex == 2 {
            
            // display to city...
            destinationAirline = airlineInfo
            tf_destinationCity.text = airlineInfo["airline_city"]
        }
        else {
            
            let index = cityIndex - 100
            if destinationBool == true {
                
                DCityModel.mulityCitiesArray[index].arrival_cityId = airlineInfo["airline_id"]
                DCityModel.mulityCitiesArray[index].arrival_cityCode = airlineInfo["airline_code"]
                DCityModel.mulityCitiesArray[index].arrival_cityName = airlineInfo["airline_city"]
            }
            else {
                DCityModel.mulityCitiesArray[index].depart_cityId = airlineInfo["airline_id"]
                DCityModel.mulityCitiesArray[index].depart_cityCode = airlineInfo["airline_code"]
                DCityModel.mulityCitiesArray[index].depart_cityName = airlineInfo["airline_city"]
            }
            mulityCititesListArray = DCityModel.mulityCitiesArray
            tbl_multiCity.reloadData()
        }
    }
}
//MARK: - Hotel Delegates //Add Room And Gust
extension HomeVC : hotelAddRoomsDelegate, searchHotelCitiesDelegate  {
    
    func hotelAddRoom_SelectionAction() {
        self.updateRoomAndGuestInfo()
    }
    
    // MARK:- searchHotelCitiesDelegate
    func searchHotel_info(hotelInfo: [String : Any]) {
        let destination = hotelInfo["Destination"] as? String ?? ""
        let country = hotelInfo["country"] as? String ?? ""
        
        tf_city.text = destination + ", " + country
        DHTravelModel.hotelCity_dict = hotelInfo
        print(hotelInfo)
    }
}

//MARK: - Date Delegate for all module
extension HomeVC :  DPickerPopViewDelegate {
    func datePickerPopView(_picker: DatePickerPopView, _date: Date) {
        calSelectedDate = _date
        
        if module == .Hotel {
            calSelectedDate = _date
            
            if returnDateBool == false {
                checkIn_date = calSelectedDate
                checkOut_date = checkIn_date?.addingTimeInterval(24*60*60)
            }
            else {
                
                // user selected past date...
                let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: checkIn_date!)
                let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                
                let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: calSelectedDate)
                let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                
                if (loDepartDate.compare(loCalDate) == .orderedDescending) || (loDepartDate.compare(loCalDate) == .orderedSame) {
                    self.view.makeToast(message: "Please select check-in date greater than check-out date !")
                    return
                } else {
                    checkOut_date = calSelectedDate
                }
            }
            
            updateCheckInCheckOutDates(isFirst: false)
            
        }
//        else if module == .Bus {
//            bDepartDate = _date
//            DBTravelModel.departDate = _date
////            DActivityTravelModel.departDate = _date
//            
//            
//            calSelectedDate = _date
//            lbl_bSelectedDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: calSelectedDate)
//        }
        else {
            if DTravelModel.tripType == .Multi {
                
                let index = cityIndex - 100
                if index > 0 {
                    
                    let beforeDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                           date: DCityModel.mulityCitiesArray[index-1].start_date!)
                    if (beforeDate.compare(calSelectedDate) == .orderedDescending)  {
                        kWindow?.makeToast(message: "Please select return date greater than depart date !")
                        calSelectedDate = beforeDate;
                        return
                    }
                }
                
                DCityModel.mulityCitiesArray[index].start_date = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: _date)
                //view_calendarPop.isHidden = true
                mutiCityDateValidations(indexS: index)
            }
            else {
                calSelectedDate = _date
                
                // set calendar date as depart/return...
                
                
                if !returnDateBool {
                    departDate = _date
                    returnDate = departDate
                }
                else {
                    // user selected past date...
                    let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: departDate)
                    let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                    let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: _date)
                    let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                    if (loDepartDate.compare(loCalDate) == .orderedDescending)  {
                        appDel.window?.makeToast(message: "Please select return date greater than depart date !")
                        return
                    } else {
                        returnDate = _date
                    }
                }
                updateDepartAndReturnDates()
                
            }
        }
    }
}

//MARK: - API's
extension HomeVC {
    
    // MARK: - HomePage
    func homePageAdsList_APIConnection() -> Void {
        
        //SwiftLoader.show(animated: true)
        // calling api...
        VKAPIs.shared.getRequest(file: HomePageAdsList, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("homePageAds success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let dataDict = result["data"] as? [String: Any] {
                            DCommonModel.createModels(result_dict: dataDict)
                        }
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("homePageAds formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayAds()
            SwiftLoader.hide()
        }
    }
    
    func getAllPromoCode_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // calling api...
        VKAPIs.shared.getRequest(file: Get_AllPromo, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Promo code success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        DCommonModel.createPromoCodeModels(result_dict: result)
                        
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            //                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Promo code formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayPromocode()
            CommonLoader.shared.stopLoader()
        }
    }
    
    func getCurrencyValue_APIConnection(toCurrency: String) -> Void {
        
        CommonLoader.shared.startLoader(in: view)
        
        let urlString = "\("http://prod.services.travelomatix.com/webservices/index.php/rest/currecny_value_details?amount=1&from=")\(BASE_CURRENCY)\("&to=")\(toCurrency)"
        
        print("urlString : \(urlString)")
        
        // Create URL
        let url = URL(string: urlString)
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                let result = VKAPIs.getObject(jsonString: dataString)
                
                if let responseDict = result as? [String: Any] {
                    
                    if let curr_value = responseDict["currency_value"] as? Float {
                        self.updateCurrencyValue(currency_value: curr_value)
                    }
                    
                    if let curr_value = responseDict["currency_value"] as? String {
                        self.updateCurrencyValue(currency_value: Float(curr_value) ?? 1.0)
                    }
                }
            }
        }
        task.resume()
        CommonLoader.shared.stopLoader()
    }
    
    func updateCurrencyValue(currency_value: Float) {
        
        print("Before: \(String(describing: temp_currencyModel))")
        temp_currencyModel?.currency_value = currency_value
        print("After: \(String(describing: temp_currencyModel))")
        DCurrencyModel.saveCurrency(model: temp_currencyModel!)
        DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        //        displayAds()
    }
}
