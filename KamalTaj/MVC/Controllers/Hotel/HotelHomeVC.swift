//
//  HotelHomeVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

class HotelHomeVC: UIViewController, TravellerTitleDelegate {
    //Remove non-used Delegates
    func travellerTitle(title: String) {
        
        tf_dstanceNear.text = title
    }
    
  
    
    
    // MARK:- Outlets
//    @IBOutlet weak var lbl_checkInDay: UILabel!
    @IBOutlet weak var lbl_checkInDate: UILabel!
//    @IBOutlet weak var lbl_checkInMonth: UILabel!
    
//    @IBOutlet weak var lbl_checkOutDay: UILabel!
    @IBOutlet weak var lbl_checkOutDate: UILabel!
//    @IBOutlet weak var lbl_checkOutMonth: UILabel!
    
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_numberOfNights: UITextField!
    
    @IBOutlet weak var lbl_numberOfRooms: UILabel!
//    @IBOutlet weak var lbl_guestCount: UILabel!
    @IBOutlet weak var lbl_guestDetails: UILabel!
    @IBOutlet weak var view_header: UIView!
    
    // calendar popview...
    @IBOutlet weak var view_calendarPop: UIView!
    @IBOutlet weak var lbl_calendarTitle: UILabel!
    @IBOutlet weak var btn_leftLoc: UIButton!
    @IBOutlet weak var view_JBCalendar: JTHorizontalCalendarView!
    
    //var view_currencyPop: CurrencyView?
    @IBOutlet weak var night_WConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var distnce_WContraint: NSLayoutConstraint!
    @IBOutlet weak var distanceView: CRView!
    @IBOutlet weak var tf_dstanceNear: UITextField!
    @IBOutlet weak var btn_selectLocation: UIButton!
    @IBOutlet weak var coll_ads: UICollectionView!
    @IBOutlet weak var coll_ads_HContraints: NSLayoutConstraint!

    
    
    var topOffer_Array: [DCommonTrendingHotelItems] = []

    var btn_selectBool: Bool = false
    // MARK:- Variables
    var defaultColor: UIColor?
    var calendarManager = JTCalendarManager()
    var calSelectedDate = Date()
    
    // one way elements...
    var checkIn_date: Date?
    var checkOut_date: Date?
    var returnDateBool = false
    var text: String? = ""
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceView.isHidden = true
        // add views...
        DCommonModel.trendingHotel_Array.forEach({ item in
            topOffer_Array.append(item)
//            if item.module == "hotel" {
//                topOffer_Array.append(item)
//            }
        })
        addFrameAdd_views()
//        view.backgroundColor = .appColor
        // bottom shadow...
        view_header.viewShadow()
        tf_city.text = text
        // defult depart is today date...
        checkIn_date = Date()
        checkOut_date = Date().addingTimeInterval(24*60*60)
        checkInAndCheckOutDates(isFirst: true)
        
        // calendar setup...
        calendarManager.delegate = self
        calendarManager.contentView = self.view_JBCalendar
        calendarManager.setDate(Date())
        calendarTitleDisplay(sDate: Date())
        
        coll_ads.delegate = self
        coll_ads.dataSource = self
        coll_ads.register(UINib.init(nibName: "TopDestinationCVCell", bundle: nil), forCellWithReuseIdentifier: "TopDestinationCVCell")
        if let layout = coll_ads?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        // add default room...
        AddRoomModel.addRooms_array.removeAll()
        let rooms_array = AddRoomModel.createModel()
        displayRoomAndGuest_Information()
        showOffers()

    }
    func showOffers(){
        coll_ads.reloadData()
        var rowHeights: [CGFloat] = []
        for indexPath in 0..<coll_ads.numberOfItems(inSection: 0) {
            var cellHeight: CGFloat = 0.0
            if indexPath % 2 == 0 {
                // First cell in the row
                if indexPath == 0 {
                    cellHeight = 200.0
                } else if indexPath == 4 {
                    cellHeight = 200.0
                } else {
                    cellHeight = 145
                }
            } else {
                // Second cell in the row
                if indexPath == 3 {
                    cellHeight = 200.0
                } else if indexPath == 7 {
                    cellHeight = 200
                } else {
                    cellHeight = 145
                }
            }
            //            return cellHeight
            let cellHeights =  cellHeight//calculateCellHeight(with: text)
            let columnIndex = indexPath % Int(2)
            
            if columnIndex == 0 {
                // Start of a new row, add a new row height
                rowHeights.append(cellHeights)
            } else {
                // Not the start of a new row, update the row height if necessary
                let rowIndex = indexPath / Int(2)
                rowHeights[rowIndex] = max(rowHeights[rowIndex], cellHeights)
            }
        }
        
        // Step 5: Sum up the row heights to determine the total height of the UICollectionView
        let totalHeight = rowHeights.reduce(0, +)
        coll_ads_HContraints.constant = totalHeight - 100
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func distanceButtonAction(_ sender: UIButton) {
        let tempDistance = ["Distance","1 KM ","2 KM","5 KM","10 KM","12 KM","15 KM"]

        print("distane butn clikked")
        var globalPoint : CGPoint = (distanceView.superview?.convert(distanceView.frame.origin, to: nil))!
        print(globalPoint)
        globalPoint.y += 45
        var fieldRect: CGRect = CGRect(origin: globalPoint, size: CGSize(width: self.view.frame.size.width / 2 - 15, height:0))
        fieldRect.origin = globalPoint
        fieldRect.size.width = distanceView.frame.size.width
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_title = self
        tbl_popView.DType = .Title
        tbl_popView.title_array = tempDistance
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        tbl_popView.tbl_view.frame.size.height = CGFloat(40 * tempDistance.count)
        tbl_popView.view_main.frame.size.height = CGFloat(40 * tempDistance.count)
        tbl_popView.tbl_view.isScrollEnabled = false
        self.view.addSubview(tbl_popView)
    }
    @IBAction func searchLocationSelect(_ sender: Any) {
        self.btn_selectBool = !btn_selectBool
        if btn_selectBool {
            self.btn_selectLocation.setImage(UIImage(named: "checkmark.square.fill"), for: .normal)
            distanceView.isHidden = false
            print(self.view.frame.size.width)
            print(self.night_WConstraint.constant)
            self.night_WConstraint.constant = (self.view.frame.size.width / 2 ) + 5

            self.distnce_WContraint.constant = self.view.frame.size.width / 2 + 5
            
            print(self.night_WConstraint.constant)
        } else {
            self.btn_selectLocation.setImage(UIImage(named: "ic_check_p"), for: .normal)
            distanceView.isHidden = true
            self.night_WConstraint.constant  =  15

        }
    }
    // MARK:- Notifications
    @objc func clearInformationAfterBooking() {
        
        tf_city.text = ""
        
        // defult depart is today date...
        checkIn_date = Date()
        checkOut_date = Date().addingTimeInterval(24*60*60)
        checkInAndCheckOutDates(isFirst: true)
        
        // add default room...
        AddRoomModel.addRooms_array.removeAll()
        let rooms_array = AddRoomModel.createModel()
        print("Rooms count :\(rooms_array.count)")
        displayRoomAndGuest_Information()
    }
    
    // MARK:- Helpers
    func addFrameAdd_views() {
        

        // calendar pop adding to window...
        for views in (UIApplication.shared.keyWindow?.subviews)! {
            if views.tag == 100 || views.tag == 102 {
                views.removeFromSuperview()
            }
        }
        self.view_calendarPop.isHidden = true
        self.view_calendarPop.tag = 100
        self.view_calendarPop.frame = self.view.frame
        UIApplication.shared.keyWindow?.addSubview(self.view_calendarPop)
        
        // currency pop view...
//        self.view_currencyPop = CurrencyView.loadViewFromNib() as? CurrencyView
//        self.view_currencyPop?.isHidden = true
//        self.view_currencyPop?.tag = 102
//        UIApplication.shared.keyWindow?.addSubview(self.view_currencyPop!)
        
        // getting currecy list...
        if DStorageModel.currency_array.count != 0 {
            //self.view_currencyPop?.displayInformation()
        } else {
            DStorageModel.gettingCurrencyCountries()
        }
    }
    
    func displayRoomAndGuest_Information() {
        
        // Adult and child counts...
        var mAdults: Int = 0
        var mChilds: Int = 0
        for model in AddRoomModel.addRooms_array {
            
            mAdults = mAdults + model.adult_count
            mChilds = mChilds + model.child_count
        }
        
        // display information...
        lbl_numberOfRooms.text = "\(AddRoomModel.addRooms_array.count)"
//        lbl_guestCount.text = "\(mAdults + mChilds)"
        lbl_guestDetails.text = "\(mAdults) AD \(mChilds) CH"

    }
    
    func checkInAndCheckOutDates(isFirst: Bool) {
        
        // check-In date, month, year...
//        lbl_checkInDay.text = DateFormatter.getDateString(formate: "EEEE", date: checkIn_date!)
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: checkIn_date!)
//        lbl_checkInMonth.text = DateFormatter.getDateString(formate: "MMMM", date: checkIn_date!)
        
        // check-Out date, month, year...
//        lbl_checkOutDay.text = DateFormatter.getDateString(formate: "EEEE", date: checkOut_date!)
        lbl_checkOutDate.text = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: checkOut_date!)
//        lbl_checkOutMonth.text = DateFormatter.getDateString(formate: "MMMM", date: checkOut_date!)
        
        // no of nights...
        let night_no = DateFormatter.getDaysBetweenTwoDates(startDate: checkIn_date!, endDate: checkOut_date!)
        tf_numberOfNights.text = "\(night_no) Nights"
    }
    
    
    
    // MARK:-  ButtonActions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchButtonClick(sender : UIButton) {
        
//        let hotelInfo = ["city": "Pune", "country": "Maharashtra", "id": "20256"]
//        tf_city.text = hotelInfo["city"]! + ", " + hotelInfo["country"]!
//        DHTravelModel.hotelCity_dict = hotelInfo
        
    
//        // validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        if tf_city.text?.count == 0 || tf_city.text?.trimmingCharacters(in: whitespace).count == 0 {

            self.view.makeToast(message: "Please select hotel city")
        }
        else {

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

            // move to hotel search screen...
            let hSearchObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelSearchListVC") as! HotelSearchListVC
            self.navigationController?.pushViewController(hSearchObj, animated: true)
            //NotificationCenter.default.post(name: NSNotification.Name(kMainTabHidden), object: nil)

        }
    }
    
    @IBAction func guestAndRoomCountAction(_ sender: Any) {
        
        // move to add hotels rooms...
        let addRoomObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelAddRoomsVC") as! HotelAddRoomsVC
        addRoomObj.delegate = self
        self.navigationController?.pushViewController(addRoomObj, animated: true)
        //NotificationCenter.default.post(name: NSNotification.Name(kMainTabHidden), object: nil)
 
    }
    
    @IBAction func currencyButtonClicked(_ sender: UIButton) {
//        self.view_currencyPop?.displayInformation()
//        self.view_currencyPop?.isHidden = false
//        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_currencyPop!)
    }
    
    @IBAction func searchCityAction(_ sender: Any) {
        
        // search city...
        let searchObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "SearchHotelCitiesVC") as! SearchHotelCitiesVC
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
        //self.navigationController?.pushViewController(searchObj, animated: true)
 
    }
    
    // MARK:- DateButtons
    @IBAction func departReturn_DatesClicked(_ sender: UIButton) {
        
        // if user choose return date...
        returnDateBool = false
        if sender.tag == 11 {
            returnDateBool = true
        }
        view_calendarPop.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(view_calendarPop)
    }
    
    
    @IBAction func calenderHiddenClicked(_ sender: UIButton) {
        view_calendarPop.isHidden = true
    }
    @IBAction func calendarNextPreviousMonthClicked(_ sender: UIButton) {

        if sender.tag == 10 {
            view_JBCalendar.loadNextPageWithAnimation()

        } else if sender.tag == 11 {
            view_JBCalendar.loadPreviousPageWithAnimation()

        }
    }
    @IBAction func calendarDateSetClicked(_ sender: UIButton) {
        
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
        
        checkInAndCheckOutDates(isFirst: false)
        view_calendarPop.isHidden = true
    }
}

extension HotelHomeVC : searchHotelCitiesDelegate, hotelAddRoomsDelegate {
    
    // MARK:- searchHotelCitiesDelegate
    func searchHotel_info(hotelInfo: [String : String]) {
        print(hotelInfo)
        tf_city.text = hotelInfo["city"]! + ", " + hotelInfo["country"]!
        DHTravelModel.hotelCity_dict = hotelInfo
    }
    
    // MARK:- hotelAddRoomsDelegate
    func hotelAddRoom_SelectionAction() {
        self.displayRoomAndGuest_Information()
    }
}

extension HotelHomeVC: JTCalendarDelegate {
    
    // MARK:- JTCalendarDelegate
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        if calendarManager.dateHelper.date(Date(), isTheSameDayThan: loDayView.date) {
            
            // Today...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.red //UIColor.init("#E3E3E3")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if calendarManager.dateHelper.date(calSelectedDate, isTheSameDayThan: loDayView.date) {
            
            // Selected date...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.secInteraciaBlue //UIColor.init("#2097D9")
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
        if returnMonth(d: Date()) == returnMonth(d: sDate) {
            btn_leftLoc.isHidden = true
        } else {
            btn_leftLoc.isHidden = false
        }
        lbl_calendarTitle.text = DateFormatter.getDateString(formate: "MMM yyyy", date: sDate)
    }
    func returnMonth(d: Date) -> String {
        let month = DateFormatter.getDateString(formate: "MMM", date: d)
        return month
    }
}

extension HotelHomeVC:  UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, numberOfColumn number: CGFloat) -> CGFloat {
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topOffer_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell
        
        //display information...
//        cell.displayFlightInfo(model: topOffer_Array[indexPath.row])
        let item = topOffer_Array[indexPath.row]
//        cell.image.sd_setImage(with: URL.init(string: item.hotel_img_url!),completed: nil)
//        cell.from_dest.text = item.cityName
        cell.displayTrendingHotelInformation(model: item)
//        cell.image_hotel.sd_setImage(with: URL.init(string: item.hotel_img_url!),completed: nil)
//        cell.lbl_hotelCity.text = item.cityName
//        cell.lbl_exp.text = "( " + item.hotelCount! + " hotels )"
//        cell.lbl_fromTo.isHidden = true
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        topOffer_Array
        self.text = topOffer_Array[indexPath.row].cityName! + "," + topOffer_Array[indexPath.row].countryName!
        var a : [String: String] = [:]
        a["id"] = topOffer_Array[indexPath.row].id
        a["city"] = topOffer_Array[indexPath.row].cityName
        a["country"] = topOffer_Array[indexPath.row].countryName
        DHTravelModel.hotelCity_dict = a
        tf_city.text = text

    }
    
    func collectionView(collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
        var cellHeight: CGFloat = 0.0
        if indexPath.item % 2 == 0 {
            // First cell in the row
            if indexPath.item == 0 {
                cellHeight = 200.0
            } else if indexPath.item == 4 {
                cellHeight = 200.0
            } else {
                cellHeight = 145
            }
        } else {
            // Second cell in the row
            if indexPath.item == 3 {
                cellHeight = 200.0
            } else if indexPath.item == 7 {
                cellHeight = 200
            } else {
                cellHeight = 145
            }
        }
        return cellHeight
    }
}


