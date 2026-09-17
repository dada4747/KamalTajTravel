//
//  FlightHomeVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FlightHomeVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var view_flightTripType: UIView!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_oneWayRound: UIView!
    @IBOutlet weak var tf_sourceCity: UITextField!
    @IBOutlet weak var tf_destinationCity: UITextField!
    
    @IBOutlet weak var lbl_class: UILabel!
    @IBOutlet weak var view_multiCity: UIView!
    @IBOutlet weak var tbl_multiCity: UITableView!
    @IBOutlet weak var btn_addCity: UIButton!
    @IBOutlet weak var addCities_HConstraint: NSLayoutConstraint!
    
    // dates lables...
    @IBOutlet weak var lbl_departDate: UILabel!
//    @IBOutlet weak var lbl_departDay: UILabel!
    
    @IBOutlet weak var view_returnDate: UIView!
    @IBOutlet weak var lbl_returnDate: UILabel!
//    @IBOutlet weak var lbl_returnDay: UILabel!
    
    // traveller detsil views...
    @IBOutlet weak var view_travellersType: UIView!
    
    // calendar popview...
    @IBOutlet weak var view_calendarPop: UIView!
    @IBOutlet weak var lbl_calendarTitle: UILabel!
    @IBOutlet weak var view_JBCalendar: JTHorizontalCalendarView!
    
    // class pop view...
    @IBOutlet var view_classPop: UIView!
    @IBOutlet weak var view_classPopSub: UIView!
//    @IBOutlet weak var btn_class: UIButton!
    @IBOutlet weak var btn_currency: UIButton!
    //var view_currencyPop: CurrencyView?
    
    // traveller pop view...
    @IBOutlet weak var view_travallerPop: UIView!
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var lbl_infantCount: UILabel!
    @IBOutlet weak var lbl_adult: UILabel!
    @IBOutlet weak var lbl_child: UILabel!
    @IBOutlet weak var lbl_infant: UILabel!
    
    @IBOutlet weak var tf_prefferedAirline: UITextField!
    
    @IBOutlet weak var coll_ads: UICollectionView!
    
    @IBOutlet weak var groupNoticeView: UIView!
    @IBOutlet weak var groupNoticeBtn: UIButton!
    @IBOutlet weak var travellerDoneBtn: UIButton!
    var topOffer_Array: [DCommonTopOfferItems] = []

    // MARK: - Variables
    var defaultColor: UIColor?
    var calendarManager = JTCalendarManager()
    var calSelectedDate = Date()
    
    // one way elements...
    var departDate = Date()
    var returnDate = Date()
    var returnDateBool = false
    
    var departAirline: [String: String]?
    var destinationAirline: [String: String]?
    var destinationBool = false
    
 
    var traveller = TravellerType.Adult
    enum TravellerType {
        case Adult
        case Child
        case Infant
    }
    
    var adultCount: Int = 1
    var childCount: Int = 0
    var infantCount: Int = 0
    
    var cityIndex: Int = 0
    var mulityCititesListArray: [DCityModel] = []
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        topOffer_Array = DCommonModel.topOffer_Array
        DCommonModel.topOffer_Array.forEach({ item in
            if item.module == "flight" {
                topOffer_Array.append(item)
            }
        })
//        groupNoticeView.isHidden = true
//        view.backgroundColor = .appColor
        // Do any additional setup after loading the view.
        DStorageModel.gettingAirlineCodeList()
        DStorageModel.gettingStateList()
        // bottom shadow...
        view_header.viewShadow()
        
        // calendar pop adding to window...
        addingCalendarPop()
        
        
        // defult depart is today date...
        defaultColor = lbl_departDate.textColor
        setUpDepartAndReturnDates()
        
        // hidden return view...
        view_returnDate.isHidden = false
        view_returnDate.alpha = 0.5
        view_returnDate.isUserInteractionEnabled = false
    
        // calendar setup...
        calendarManager.delegate = self
        calendarManager.contentView = self.view_JBCalendar
        calendarManager.setDate(Date())
        calendarTitleDisplay(sDate: Date())
        
        
        
        // table delegates
        tbl_multiCity.delegate = self
        tbl_multiCity.dataSource = self
        displaySelectedCurrency()
        
        
        coll_ads.delegate = self
        coll_ads.dataSource = self
        coll_ads.register(UINib.init(nibName: "HomeOffersCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeOffersCVCell")
        showOffers()
        // multicities...
        DCityModel.mulityCitiesArray.removeAll()
        mulityCititesListArray = DCityModel.createModel()
        mulityCititesListArray = DCityModel.createModel()
        
        clearInformationAfterBooking()
//        departAirline = ["airline_city": "Bangalore", "airline_id": "801", "airline_top_destination": "6", "airline_country": "India", "airline_name": "Bengaluru International Airport", "airline_code": "BLR", "airline_fullName": "Bengaluru International Airport, Bangalore, India"]
//        destinationAirline = ["airline_city": "Delhi", "airline_name": "Indira Gandhi International Airport", "airline_country": "India", "airline_id": "1709", "airline_code": "DEL", "airline_top_destination": "6", "airline_fullName": "Indira Gandhi International Airport, Delhi, India"]
//        tf_sourceCity.text = departAirline?["airline_city"]
//        tf_destinationCity.text = destinationAirline?["airline_city"]
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(clearInformationAfterBooking),
                                               name: NSNotification.Name(rawValue: kClearBooking), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countryListGettingNotification(notification:)),
                                               name: NSNotification.Name(rawValue: kCurrencyNotify), object: nil)
        */
    }
    func showOffers(){
        coll_ads.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NotificationCenter.default.post(name: NSNotification.Name(kMainTabHidden), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications
    @objc func clearInformationAfterBooking() {
        
        // flight Trip Types colors changing...
        for childView in view_flightTripType.subviews {
            
            for childSubView in childView.subviews {
                let child_view = childSubView as? UIImageView
                child_view?.image = UIImage.init(named: "ic_circle_white")
                childView.backgroundColor = .white //.placeholder

                if childView.tag == 10 {
                    child_view?.image = UIImage.init(named: "ic_circle_fill_white")
                    childView.backgroundColor = .ThemeColor_Blue
                }
            }
        }
        
        // one way & multi cities views...
        view_returnDate.alpha = 0.5
        view_returnDate.isHidden = true
        view_returnDate.isUserInteractionEnabled = false
        view_multiCity.isHidden = true
        view_oneWayRound.isHidden = false
        addCities_HConstraint.constant = 130
        
        // source and destination infomration...
        tf_sourceCity.text = ""
        tf_destinationCity.text = ""
        
        // selected dates...
        departDate = Date()
        returnDate = Calendar.current.date(byAdding: .day, value: 1, to: departDate)!
        returnDateBool = false
        setUpDepartAndReturnDates()
        
        DTravelModel.clearAllTraveller()
        
        // display traveller count...
        lbl_adultCount.text = "\(DTravelModel.adultCount) AD"
        lbl_childCount.text = "\(DTravelModel.childCount) CH"
        lbl_infantCount.text = "\(DTravelModel.infantCount) IN"
                
        //  mulit city clear...
        DCityModel.mulityCitiesArray.removeAll()
        mulityCititesListArray = DCityModel.createModel()
        mulityCititesListArray = DCityModel.createModel()
        tbl_multiCity.reloadData()
        //addCities_HConstraint.constant = CGFloat(116 * mulityCititesListArray.count)
        
        
        // color changing...
        DTravelModel.flight_class = "Economy"
        lbl_class.text = String.init(format: " %@",DTravelModel.flight_class)
        for childView in view_classPopSub.subviews {
            if childView is UIButton {
                
                let btn_view = childView as! UIButton
                btn_view.setTitleColor(UIColor.black, for: .normal)
                if btn_view.tag == 10 {
                    btn_view.setTitleColor(UIColor.ThemeColor_Blue, for: .normal)
                }
            }
        }
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
    @objc func countryListGettingNotification(notification: Notification) {
        //self.view_currencyPop?.displayInformation()
        displaySelectedCurrency()
    }
    
    func displaySelectedCurrency() {
        
        // currency display...
        for model in DStorageModel.currency_array {
            if model.index == 1 {
                self.btn_currency.setTitle(String.init(format: "Currency > %@", model.currency_code!), for: .normal)
                break
            }
        }
    }
    
    // MARK:- Helpers
    func addingCalendarPop() {
        
        // calendar pop adding to window...
        for views in (UIApplication.shared.keyWindow?.subviews)! {
            if views.tag == 100 || view.tag == 101 || view.tag == 102 || view.tag == 103 {
                views.removeFromSuperview()
            }
        }
        self.view_calendarPop.isHidden = true
        self.view_calendarPop.tag = 100
        self.view_calendarPop.frame = self.view.frame
        UIApplication.shared.keyWindow?.addSubview(self.view_calendarPop)
        
        // flight class pop...
        self.view_classPop.isHidden = true
        self.view_classPop.tag = 101
        self.view_classPop.frame = self.view.frame
        UIApplication.shared.keyWindow?.addSubview(self.view_classPop)
        
        // currency pop view...
//        self.view_currencyPop = CurrencyView.loadViewFromNib() as? CurrencyView
//        self.view_currencyPop?.isHidden = true
//        self.view_currencyPop?.tag = 102
//        UIApplication.shared.keyWindow?.addSubview(self.view_currencyPop!)
        
        // traveller pop view...
        self.view_travallerPop.isHidden = true
        self.view_travallerPop.tag = 103
        self.view_travallerPop.frame = self.view.frame
        UIApplication.shared.keyWindow?.addSubview(self.view_travallerPop)
//        groupNoticeView.isHidden = true
        // getting currecy list...
        if DStorageModel.currency_array.count != 0 {
            //self.view_currencyPop?.displayInformation()
        } else {
            DStorageModel.gettingCurrencyCountries()
        }
    }
    func updateTravellerInfo() {
        
        DTravelModel.adultCount = adultCount
        DTravelModel.childCount = childCount
        DTravelModel.infantCount = infantCount
        
        lbl_adult.text =  "\(DTravelModel.adultCount) AD"//String.init(format: "Adult %02d", DTravelModel.adultCount)
        lbl_child.text =  "\(DTravelModel.childCount) CH"//String.init(format: "Child %02d", DTravelModel.childCount)
        lbl_infant.text =  "\(DTravelModel.infantCount) IN"//String.init(format: "Infant %02d", DTravelModel.infantCount)
    }
    
    func setUpDepartAndReturnDates() {
        
        // display depart date, month, year...
//        lbl_departDay.text = DateFormatter.getDateString(formate: "EEEE", date: departDate)
        lbl_departDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: departDate)
        
        // display return date, month, year...
//        lbl_returnDay.text = DateFormatter.getDateString(formate: "EEEE", date: returnDate)
        lbl_returnDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: returnDate)
    }

    func moveToCitiesSelection() {
        
        // search city...
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .Airline
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
        //self.navigationController?.pushViewController(searchObj, animated: true)
        //NotificationCenter.default.post(name: NSNotification.Name(kMainTabHidden), object: nil)
 
    }
    
    func moveToPrefferedFlight(){
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .PrefferAirline
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
    
    func moveToSearchListScreen() {
        
        // store oneway/round information...
        if DTravelModel.tripType == .OneWay || DTravelModel.tripType == .Round {
            
            DTravelModel.departAirline = departAirline!
            DTravelModel.destinationAirline = destinationAirline!
            DTravelModel.departDate = departDate
            DTravelModel.returnDate = returnDate
        }
        // move to flight list...
        let flightSearchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightSearchListVC") as! FlightSearchListVC
        self.navigationController?.pushViewController(flightSearchObj, animated: true)
        //NotificationCenter.default.post(name: NSNotification.Name(kMainTabHidden), object: nil)
    }
    
   
    // MARK: - _MulitTrip validations
    func muticityTotalFormValidation() -> Bool {
        
        // form validations...
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
    
    // MARK: - ButtonActions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flightTripTypeClicked(_ sender: UIButton) {
        
        // flight Trip Types selection...
        for childView in view_flightTripType.subviews {
            for childSubView in childView.subviews {
                
                childView.backgroundColor = .white //.placeholder
                if let child_view = childSubView as? UILabel {
                    //child_view.image = UIImage.init(named: "ic_circle_white")
                    child_view.textColor = .black
                }
                
                if childView.tag == sender.tag {
                    childView.backgroundColor = .ThemeColor_Blue
                    if let child_view = childSubView as? UILabel {
                        //child_view.image = UIImage.init(named: "ic_circle_fill_white")
                        child_view.textColor = .white
                        
                    }
                }
            }
        }
        
        // hidden return date view...
        view_returnDate.isHidden = false
        view_returnDate.alpha = 0.5
        view_returnDate.isUserInteractionEnabled = false
        
        // one way & multi cities views...
        view_multiCity.isHidden = true
        view_oneWayRound.isHidden = true
        if sender.tag == 12 {
            
            DTravelModel.tripType = .Multi
            view_multiCity.isHidden = false
            addCities_HConstraint.constant = CGFloat(110 * mulityCititesListArray.count) // cellhight + no.of cities
            
        } else {
            
            view_oneWayRound.isHidden = false
            addCities_HConstraint.constant = 130 // 295
            
            if sender.tag == 11 {
                DTravelModel.tripType = .Round
                view_returnDate.alpha = 1.0
                view_returnDate.isHidden = false
                view_returnDate.isUserInteractionEnabled = true
                
                // set return date by default...
                returnDateBool = true
                returnDate = Calendar.current.date(byAdding: .day, value: 1, to: departDate)!
                setUpDepartAndReturnDates()
            }
            else {
                DTravelModel.tripType = .OneWay
            }
        }
    }
    
    @IBAction func sourceDestination_CitiesClicked(_ sender: UIButton) {
        
        // button actions...
        if sender.tag == 10 {
            cityIndex = 1
        } else {
            cityIndex = 2
        }
        // select city...
        moveToCitiesSelection()
    }
    
    @IBAction func prefferedFlights_Clicked(_ sender: Any) {
//        if sender.tag == 10 {
//
//        }else {
//
//        }
        moveToPrefferedFlight()
    }
    @IBAction func travellerTypeClicked(_ sender: UIButton) {
        
        // traveller Types colors changing...
        for childView in view_travellersType.subviews {
            let child_view = childView as! UIButton
            child_view.backgroundColor = UIColor.white
            child_view.setTitleColor(UIColor.black, for: .normal)
        }
        sender.backgroundColor = defaultColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        // button actions...
        if sender.tag == 10 {
            traveller = .Adult
        }
        else if sender.tag == 11 {
            traveller = .Child
        }
        else {
            traveller = .Infant
        }
        
    }
    
    @IBAction func advancedOptionsClicked(_ sender: UIButton) {
        self.view_classPop.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_classPop)
    }
    
    @IBAction func travellersClicked(_ sender: Any) {
        refreshUI()                           // initialise labels / banner

        adultCount = DTravelModel.adultCount
        childCount = DTravelModel.childCount
        infantCount = DTravelModel.infantCount
        
        // display count...
        lbl_adultCount.text = "\(adultCount)"
        lbl_childCount.text = "\(childCount)"
        lbl_infantCount.text = "\(infantCount)"
        
        self.view_travallerPop.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_travallerPop)
    }
    
    @IBAction func setUpTravellerCount(_ sender: UIButton) {
        var attemptedOverLimit = false

        // adults
        if sender.tag == 10 {
            if adultCount > 1 {
                adultCount = adultCount - 1
            }
            
            // if infants more than adults making infants 0
            if adultCount < infantCount {
                infantCount = 0
            }
        }
        else if sender.tag == 11 {
            adultCount = adultCount + 1

            if adultCount + childCount > 9 {
                attemptedOverLimit = true

            }else{
                var attemptedOverLimit = false

            }
            /*if adultCount + childCount < 9 {
                adultCount = adultCount + 1
            }
            else {
                attemptedOverLimit = true

//                self.view.makeToast(message: "Max 9 passengers (Adult + child) allowed")
                kWindow?.makeToast(message: "Max 9 passengers (Adult + child) allowed")
                
            }*/
        }
            
        // Childs
        else if sender.tag == 20 {
            if childCount > 0 {
                childCount = childCount - 1
            }
        }
        else if sender.tag == 21 {
                            childCount = childCount + 1

            if adultCount + childCount > 9 {
                attemptedOverLimit = true

            }else{
                var attemptedOverLimit = false

            }
//            if adultCount + childCount < 9 {
//                childCount = childCount + 1
//            }
//            else {
//                attemptedOverLimit = true
//
//                kWindow?.makeToast(message: "Max 9 passengers (Adult + child) allowed")
//            }
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
            }
        }
        
        else {}
        refreshUI(overLimit: attemptedOverLimit)
//
//        // display count...
//        lbl_adultCount.text = "\(adultCount)"
//        lbl_childCount.text = "\(childCount)"
//        lbl_infantCount.text = "\(infantCount)"
    }
    private func refreshUI(overLimit justAttempted: Bool = false) {

        lbl_adultCount.text = "\(adultCount)"
        lbl_childCount.text = "\(childCount)"
        lbl_infantCount.text = "\(infantCount)"

        // Show banner if (1) user just tried to exceed cap OR (2) total already > cap
        let total = adultCount + childCount
        let shouldShow = justAttempted || total > 9

        // Only act when visibility changes
        guard groupNoticeView.isHidden == shouldShow else { return }

        // Animated toggle
        UIView.transition(with: groupNoticeView,
                          duration: 0.25,
                          options: .transitionCrossDissolve) {
            self.groupNoticeView.isHidden = !shouldShow
        }
        groupNoticeBtn.isHidden = groupNoticeView.isHidden
        travellerDoneBtn.isHidden = !groupNoticeView.isHidden

    }
    @IBAction func travellersOkClicked(_ sender: Any) {
        
        updateTravellerInfo()
        view_travallerPop.isHidden = true
    }
    
    @IBAction func hideTravellerPopClicked(_ sender: Any) {
        
        view_travallerPop.isHidden = true
    }
    
    @IBAction func currencyButtonClicked(_ sender: UIButton) {
//        self.view_currencyPop?.isHidden = false
//        self.view_currencyPop?.displayInformation()
//        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_currencyPop!)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
//        if DTravelModel.preferedAirLine.isEmpty  {
//       
//               }else{
//                   DFlightFilters.flightSelection_array.append(DTravelModel.preferedAirLine.capitalized)
//               }
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
            else if tf_sourceCity.text == tf_destinationCity.text {
                messageStr = "The destination from and to cannot be the same"
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
                moveToSearchListScreen()
            }
        }
        else {
            
            // form validation
            let valid = muticityTotalFormValidation()
            if valid == true {
                moveToSearchListScreen()
            }
        }
    }
    @IBAction func applyGroupBookingAction(_ sender: Any) {
        DTravelModel.adultCount = adultCount
        DTravelModel.childCount = childCount
        DTravelModel.infantCount = infantCount
        
        view_travallerPop.isHidden = true
        let popupVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FGroupEnquiryPopupVC") as! FGroupEnquiryPopupVC
        popupVC.modalPresentationStyle = .overFullScreen // Full screen with background dim
        popupVC.modalTransitionStyle = .crossDissolve   // Smooth transition
//                popupVC.delegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func addCityClicked(_ sender: UIButton) {
        
        let valid = muticityTotalFormValidation()
        if valid == true {
            
            if mulityCititesListArray.count <= 5 {
                
                // add one city and reload infomration....
                mulityCititesListArray = DCityModel.createModel()
                tbl_multiCity.reloadData()
                addCities_HConstraint.constant = CGFloat(110 * mulityCititesListArray.count)
            }
            
            // add city button hidden at mulit cities count = 5(Max)...
            btn_addCity.isHidden = false
            if mulityCititesListArray.count == 5 {
                btn_addCity.isHidden = true
            }
        }
    }
    
    // MARK:- PopupButtons
    @IBAction func departReturn_DatesClicked(_ sender: UIButton) {
        /*
        // if user choose return date...
        returnDateBool = false
        if sender.tag == 11 {
            returnDateBool = true
        }
        self.view_calendarPop.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_calendarPop)
        */
        
        let calendar_popView = Bundle.main.loadNibNamed("CalendarPopView", owner: nil, options: nil)![0] as! CalendarPopView
        calendar_popView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(calendar_popView)
        
        // if user choose return date...
        returnDateBool = false
        if sender.tag == 11 {
            // return date...
            returnDateBool = true
            calendar_popView.departDate = departDate
            calendar_popView.calSelectedDate = departDate
        }
    }
    
    @IBAction func calenderHiddenClicked(_ sender: UIButton) {
         view_calendarPop.isHidden = true
    }
    
    @IBAction func calendarDateSetClicked(_ sender: UIButton) {
        
        // set calendar date as depart/return...
        if DTravelModel.tripType == .Multi {
            
            let index = cityIndex - 100
            if index > 0 {
                
                let beforeDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                       date: DCityModel.mulityCitiesArray[index-1].start_date!)
                if (beforeDate.compare(calSelectedDate) == .orderedDescending)  {
                    self.view.makeToast(message: "Please select return date greater than depart date !")
                    return
                }
            }
            
            DCityModel.mulityCitiesArray[index].start_date = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: calSelectedDate)
            view_calendarPop.isHidden = true
            mutiCityDateValidations(indexS: index)
        }
        else {
            
            if !returnDateBool {
                departDate = calSelectedDate
            }
            else {
                
                // user selected past date...
                let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: departDate)
                let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                
                let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: calSelectedDate)
                let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                
                if (loDepartDate.compare(loCalDate) == .orderedDescending)  {
                    self.view.makeToast(message: "Please select return date greater than depart date !")
                    return
                } else {
                    returnDate = calSelectedDate
                }
            }
            setUpDepartAndReturnDates()
            view_calendarPop.isHidden = true
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
                    btn_view.setTitleColor(UIColor.ThemeColor_Blue, for: .normal)
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
}

extension FlightHomeVC: UITableViewDelegate, UITableViewDataSource, flightCitiesCellDelegate, searchCitiesDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mulityCititesListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        // downline hidden...
//        cell?.line_down.isHidden = false
//        if indexPath.row == (mulityCititesListArray.count - 1) {
//            cell?.line_down.isHidden = true
//        }
//        
        // display inforation...
        cell?.tf_departureCity.text = mulityCititesListArray[indexPath.row].depart_cityName
        cell?.tf_destinationCity.text = mulityCititesListArray[indexPath.row].arrival_cityName
        cell?.tf_selectDate.text = mulityCititesListArray[indexPath.row].start_date
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK:- CellButtonActions
    func departureCity_Action(sender: UIButton, cell: UITableViewCell) {
        
        // selection index...
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        destinationBool = false
        multiCitiesSelectValidations(index: indexS, isDate: false)
    }
    
    func destinationCity_Action(sender: UIButton, cell: UITableViewCell) {
        
        // selection index...
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        destinationBool = true
        multiCitiesSelectValidations(index: indexS, isDate: false)
    }
    
    func selectDate_Action(sender: UIButton, cell: UITableViewCell) {
        
        // selection index...
        let indexPath = tbl_multiCity .indexPath(for: cell)
        let indexS = (indexPath?.row)!
        
        multiCitiesSelectValidations(index: indexS, isDate: true)
    }
    
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
                //view_calendarPop.isHidden = false
                
                var loDate = Date()
                if index > 0 {
                    loDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: mulityCititesListArray[index-1].start_date!)
                }
                
                let calendar_popView = Bundle.main.loadNibNamed("CalendarPopView", owner: nil, options: nil)![0] as! CalendarPopView
                calendar_popView.lbl_calendarTitle.backgroundColor = .ThemeColor_Blue
//                calendar_popView.btn_setLoc.backgroundColor = .ThemeColor_Orange
                calendar_popView.delegate = self
                calendar_popView.departDate = loDate
                UIApplication.shared.keyWindow?.addSubview(calendar_popView)
            }
            else {
                moveToCitiesSelection()
            }
        }
    }
    
    func cancelButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // remove select city from the list...
        let indexPath = tbl_multiCity.indexPath(for: cell)
        DCityModel.mulityCitiesArray.remove(at: (indexPath?.row)!)
        
        // display remaining cities..
        mulityCititesListArray = DCityModel.mulityCitiesArray
        tbl_multiCity.reloadData()
        addCities_HConstraint.constant = CGFloat(110 * mulityCititesListArray.count)
        btn_addCity.isHidden = false
    }
    
    // MARK: - searchCitiesDelegate
    func searchAirline_info(airlineInfo: [String : Any]) {
        print("selected air line: \(airlineInfo)")
        tf_prefferedAirline.text = airlineInfo["name"] as? String ?? ""
        
        let airline_name = airlineInfo["name"] as? String ?? ""
        if airline_name == "ALL" {
            DTravelModel.preferedAirLine = ""
        } else {
            DTravelModel.preferedAirLine = airlineInfo["name"] as? String ?? ""
        }
        
        
        
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

extension FlightHomeVC: JTCalendarDelegate {
    
    // MARK:- JTCalendarDelegate
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        if calendarManager.dateHelper.date(Date(), isTheSameDayThan: loDayView.date) {
            
            // Today...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.red //UIColor.init(named: "#E3E3E3")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if calendarManager.dateHelper.date(calSelectedDate, isTheSameDayThan: loDayView.date) {
            
            // Selected date...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.lightGray //UIColor.init(named: "#2097D9")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
            
            // Other month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else if calendarManager.dateHelper.date(Date(), isEqualOrAfter: loDayView.date) {
            
            // same month passed dates...
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else {
            
            // Another day of the current month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.black
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        
        // today date getting with formate...
        let todayDateStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: Date())
        let todayDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: todayDateStr)
        
        // select date gettign with formate...
        let dateSelectStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: loDayView.date)
        let selectDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: dateSelectStr)
        
        
        // user selected past date...
        if todayDate.compare(selectDate) == .orderedDescending {
            self.view.makeToast(message: "Date already past")
        }
        else {
            
            // choose selection date....
            calSelectedDate = loDayView.date
            
            // Animation for the circleView
            loDayView.circleView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            UIView.transition(with: dayView, duration: 0.3, options: [], animations: {
                loDayView.circleView.transform = .identity
                self.calendarManager.reload()
            })
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month...
            if calendarManager.settings.weekModeEnabled {
                return
            }
            
            // Load the previous or next page if touch a day from another month...
            if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
                
                if self.view_JBCalendar.date.compare(loDayView.date) == .orderedAscending {
                    self.view_JBCalendar.loadNextPageWithAnimation()
                } else {
                    self.view_JBCalendar.loadPreviousPageWithAnimation()
                }
            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
        
        // Min date will be 2 month before today
        let minCalDate = calendarManager.dateHelper.add(to: Date(), months: 0)
        
        // Max date will be 2 month after today
        let maxCalDate = calendarManager.dateHelper.add(to: Date(), months: 24)
        
        return self.calendarManager.dateHelper.date(date, isEqualOrAfter: minCalDate, andEqualOrBefore: maxCalDate)
    }
    
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
        // next month...
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
        // previous month...
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarTitleDisplay(sDate: Date) {
        // calender month setup...
        lbl_calendarTitle.text = DateFormatter.getDateString(formate: "MMM yyyy", date: sDate)
    }
}

extension FlightHomeVC : CalendarPopViewDelegate {
    
    // MARK:- CalendarDelegate
    func CalDatePickUpView(_calendar: CalendarPopView, selDate: Date) {
        
        calSelectedDate = selDate
        
        // set calendar date as depart/return...
        if DTravelModel.tripType == .Multi {
            
            let index = cityIndex - 100
            if index > 0 {

                let beforeDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                       date: DCityModel.mulityCitiesArray[index-1].start_date!)
                if (beforeDate.compare(calSelectedDate) == .orderedDescending)  {
//                    kWindow?.makeToast(message: "Please select return date greater than depart date !")
                    calSelectedDate = beforeDate;
                    return
                }
            }
            
            DCityModel.mulityCitiesArray[index].start_date = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: calSelectedDate)
            //view_calendarPop.isHidden = true
            mutiCityDateValidations(indexS: index)
        }
        else {
            
            if !returnDateBool {
                departDate = selDate
                returnDate = departDate
            }
            else {
                // user selected past date...
                let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: departDate)
                let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: selDate)
                let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                if (loDepartDate.compare(loCalDate) == .orderedDescending)  {
//                    kWindow?.makeToast(message: "Please select return date greater than depart date !")
                    return
                } else {
                    returnDate = selDate
                }
            }
            setUpDepartAndReturnDates()
        }
    }
}


extension FlightHomeVC:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width:(coll_ads.frame.size.width)/1.4, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return topOffer_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            // cell creation...
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeOffersCVCell", for: indexPath as IndexPath) as! HomeOffersCVCell
//
//            //display information...
//        
//
//            cell.displayTopOffersInformation(model: topOffer_Array[indexPath.row])

        return UICollectionViewCell()//cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if adsType == "Hotel" {
//            print("this is selected hotel")
//            topDestHotelDelegate?.selectToDestHolidays(index:  indexPath.row)
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }
}



