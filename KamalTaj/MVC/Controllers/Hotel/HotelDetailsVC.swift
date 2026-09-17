//
//  HotelDetailsVC.swift
//  Hoetus
//
//  Created by Rahul on 16/07/23.
//

import UIKit
import MapKit


class HotelDetailsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var icarousel_mainView: iCarousel!
    @IBOutlet weak var page_Ctrl: UIPageControl!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var rating_view: FloatRatingView!
    
    @IBOutlet weak var lbl_roomName: UILabel!
    @IBOutlet weak var lbl_roomPrice: UILabel!
    
    @IBOutlet weak var lbl_checkIn: UILabel!
    @IBOutlet weak var lbl_checkOut: UILabel!
    @IBOutlet weak var lbl_rooms: UILabel!
    @IBOutlet weak var lbl_guests: UILabel!
    
    @IBOutlet weak var lbl_noofNights: UILabel!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    @IBOutlet weak var top_SCHcontraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var map_address: UILabel!
    
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_showMore: UIButton!
    
    @IBOutlet weak var img_showMore: UIImageView!
    
    @IBOutlet weak var coll_facilities: UICollectionView!
    
    @IBOutlet weak var coll_HContraint: NSLayoutConstraint!
    @IBOutlet weak var img_host: UIImageView!
    @IBOutlet weak var lbl_hostName: UILabel!
    @IBOutlet weak var lbl_hostdescription: UILabel!
    @IBOutlet weak var tbl_review: UITableView!
    @IBOutlet weak var tbl_review_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_customerReview: UITableView!
    @IBOutlet weak var tbl_customerReview_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btn_socialMedia: UIButton!
    @IBOutlet weak var lbl_emptyReviews: UILabel!
    @IBOutlet weak var lbl_emptycustomerReview: UILabel!
    
    
    @IBOutlet weak var roundedHotelImgView: RoundedView!
    @IBOutlet weak var topBar_HContraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_hotel_policy: UILabel!
    var allTrips_stopsArray: [DFlightStopsItem] = []

    // MARK: - Variables...
    var select_hotel: DHotelSearchItem?
    var hotelDetail_model = DHotelDetailsModel()
    var media_array: [String] = []
    var hotel_reviewa: [HReviewsItem] = []
    var showLess = false
    var isBottomViewHide: Bool = false
    var customer_reviews : [CReviewItem] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//            roundedHotelImgView.bottomLeft = false
//            roundedHotelImgView.bottomRight = false
//            view_header.isHidden = true

        if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
                let topPadding = window?.safeAreaInsets.top ?? 0
                topBar_HContraint.constant = topPadding
            top_SCHcontraint.constant = -topPadding
            } else {
                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                topBar_HContraint.constant = statusBarHeight
                
                top_SCHcontraint.constant = -statusBarHeight
            }
       

        // bottom shadow...
        view_header.viewShadow()
        
        // icarousel delegates...
        icarousel_mainView.delegate = self
        icarousel_mainView.dataSource = self
        icarousel_mainView.isPagingEnabled = true
        icarousel_mainView.type = iCarouselType.linear
        
        tbl_review.delegate = self
        tbl_review.dataSource = self
        tbl_customerReview.delegate = self
        tbl_customerReview.dataSource = self

        coll_facilities.delegate = self
        coll_facilities.dataSource = self
        
        // register...
        coll_facilities.register(UINib.init(nibName: "FacilityCVCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCVCell")
        if let flowLayout = coll_facilities.collectionViewLayout as? UICollectionViewFlowLayout {
            let leftAlignedLayout = LeftAlignedCollectionViewFlowLayout()
//            leftAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            leftAlignedLayout.minimumInteritemSpacing = 8
            leftAlignedLayout.minimumLineSpacing = 8
            leftAlignedLayout.scrollDirection = .vertical
//            leftAlignedLayout.estimatedItemSize = .zero
            
            coll_facilities.collectionViewLayout = leftAlignedLayout
        }
        
        gettingHotel_Details()
        displayRoomAndGuest_Information()
        
        // API call...
//        DHotelRoomsModel.roomCombinations.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayHotelMap(){
        map_address.text = select_hotel?.hotel_address
        // add annotation on map
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(Double(hotelDetail_model.latitude), Double(hotelDetail_model.longtitude))
        mapView.addAnnotation(point)
        
        // zoom
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2DMake(Double(hotelDetail_model.latitude), Double(hotelDetail_model.longtitude))
        region.span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.setRegion(region, animated: true)
    }
    func displayHostDetails(){
        let model = DHotelDetailsModel.hostDetails
        lbl_hostName.text = "\(model.fname ?? "") \(model.lname ?? "")"
        lbl_hostdescription.text = model.description
        let url = URL.init(string: model.image!.replacingOccurrences(of: " ", with: "%20"))
        img_host.sd_setImage(with: url)
    }
    
    @IBAction func modify_guest_rooms(_ sender: Any) {
        let addRoomObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelAddRoomsVC") as! HotelAddRoomsVC
        addRoomObj.delegate = self
        addRoomObj.modalPresentationStyle = .overFullScreen
        addRoomObj.modalTransitionStyle = .coverVertical
        self.navigationController?.present(addRoomObj, animated: true)
    }
    
    @IBAction func showMoreDetailClicked(_ sender: Any) {
        if showLess == false {
            showLess = true
        }else {
            showLess = false
        }
        
        displayAboutDetails()
        
    }
    
//    @IBAction func alternateSkipAction(_ sender: UIButton) {
//        let passengObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelGuestInfoVC") as! HotelGuestInfoVC
//        self.navigationController?.pushViewController(passengObj, animated: true)
//        
//    }
    
    func displayAboutDetails(){

        let details = hotelDetail_model.description
        
        btn_showMore.isHidden = false
        img_showMore.isHidden = false
        lbl_description.textAlignment = .justified
        lbl_description.setHTMLText(details, fontName: "Poppins-Regular", fontSize: 14, color: UIColor(hexString: "#333333"))
        
        if lbl_description.attributedText?.length == 0 {
            btn_showMore.isHidden = true
            img_showMore.isHidden = true
            lbl_description.textAlignment = .center
            lbl_description.attributedText = NSAttributedString.init(string: "Description is not available")
        }
        
        // display information...
        if showLess == false {
            lbl_description.numberOfLines = 3
            btn_showMore.setTitle("Show More", for: .normal)
            img_showMore.image = UIImage(named: "ic_arrowdown")
        } else {
            lbl_description.numberOfLines = 0
            btn_showMore.setTitle("Show Less", for: .normal)
            img_showMore.image = UIImage(named: "ic_arrowup")
            
        }
        
    }
    func calculateFacilitiesHeight() {
//        calculateFacilitiesHeight2()
        coll_facilities.reloadData()
        DispatchQueue.main.async {
            self.coll_facilities.layoutIfNeeded()
            let contentHeight = self.coll_facilities.collectionViewLayout.collectionViewContentSize.height
            self.coll_HContraint.constant = contentHeight
            print("Facilities content height:", contentHeight)
        }
    }
    func calculateFacilitiesHeight2() {
        coll_facilities.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.coll_facilities.layoutIfNeeded()
            let height = self.coll_facilities.collectionViewLayout.collectionViewContentSize.height
            self.coll_HContraint.constant = height
            print("Correct height:", height)
        }
    }
//    func calculateFacilitiesHeight(){
//        print(hotelDetail_model.popularFacility_array)
//        coll_facilities.layoutIfNeeded()
//        print(coll_facilities.frame.size.height)
//        let contentHeight = coll_facilities.collectionViewLayout.collectionViewContentSize.height
//        coll_HContraint.constant = contentHeight
//        print(contentHeight)
//        coll_facilities.reloadData()
//    }

    func displayHotelReviews(){
        
        tbl_customerReview.reloadData()
        tbl_review.reloadData()
        tbl_review_HConstraint.constant = hotel_reviewa.count > 0 ? CGFloat(hotel_reviewa.count * 55) : 40
        tbl_customerReview_HConstraint.constant = customer_reviews.count > 0 ? calculateTableViewHeight() : 40
    }
    
    func calculateTableViewHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        var cellHeights: [CGFloat] = []
        
        // Loop through each cell in the table view
        for section in 0..<tbl_customerReview.numberOfSections {
            let sectionHeaderHeight = tbl_customerReview.delegate?.tableView?(tbl_customerReview, heightForHeaderInSection: section) ?? 0
            cellHeights.append(sectionHeaderHeight)
            totalHeight += sectionHeaderHeight

            for row in 0..<tbl_customerReview.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let cellRect = tbl_customerReview.rectForRow(at: indexPath)
                let cellHeight = cellRect.height
                cellHeights.append(cellHeight)
                totalHeight += cellHeight
            }
        }
        
        return totalHeight
    }
    
    // MARK:- Helpers
    func displayRoomAndGuest_Information() {
        // hotel information...
        lbl_hotelName.text = select_hotel?.hotel_name
        lbl_hotelAddress.text = select_hotel?.hotel_address
        rating_view.rating = Double((select_hotel?.hotel_rating)!)
        
        lbl_noofNights.text = "( \(DHTravelModel.noof_nights) Nights )"
        lbl_totalPrice.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ((select_hotel!.hotel_price)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        lbl_grandTotal.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((select_hotel!.hotel_price + (select_hotel?.hotel_gst ?? 0)) * Float(DHTravelModel.noof_nights))  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
        
        // display information...
        lbl_rooms.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guests.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests, "
        lbl_checkIn.attributedText = getAtributedString(date: DHTravelModel.checkin_date)
        lbl_checkOut.attributedText = getAtributedString(date: DHTravelModel.checkout_date)
        
    }
    
    func getAtributedString(date: Date) -> NSAttributedString {
        let startDay = DateFormatter.getDateString(formate: "dd", date: date)
        let startMonth = DateFormatter.getDateString(formate: "MMM", date: date)
        
        let attributedString = NSMutableAttributedString()
        
        // Create attributes for the date numbers (22 and 10)
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16), // Adjust font size as needed
            .foregroundColor: UIColor.black // Adjust color as needed
        ]
        
        // Create attributes for the month names (Feb and Mar)
        let monthAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12), // Adjust font size as needed
            .foregroundColor: UIColor.gray // Adjust color as needed
        ]
        attributedString.append(NSAttributedString(string: startDay, attributes: numberAttributes))
        attributedString.append(NSAttributedString(string: " ", attributes: nil)) // Add space between numbers and months
        attributedString.append(NSAttributedString(string: startMonth, attributes: monthAttributes))
        
        return attributedString
    }
    
    
    func displayHotelDetails() {
        
        // media image display...
        media_array = self.hotelDetail_model.media_array
        hotel_reviewa = DHotelDetailsModel.hotelReviews
        customer_reviews = DHotelDetailsModel.customerReviews
        lbl_emptyReviews.isHidden = hotel_reviewa.isEmpty == true ? false : true
        lbl_emptycustomerReview.isHidden = customer_reviews.isEmpty == true ? false : true

        self.page_Ctrl.numberOfPages = media_array.count
        self.icarousel_mainView.reloadData()
        lbl_hotel_policy.text = self.hotelDetail_model.policy
        // rooms...
        self.view.isUserInteractionEnabled = true
        //        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
        
        // price information...
        displayHotelMap()
        displayAboutDetails()
        displayHostDetails()
        calculateFacilitiesHeight()
        displayHotelReviews()
        btn_socialMedia.isHidden = hotelDetail_model.video_link == "" ? true : false
        coll_facilities.reloadData()

    }

    // MARK: - ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func socialMediaLink(_ sender: UIButton) {
    }
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        
        // if room not avaiables...
//        if DHotelRoomsModel.roomCombinations.count == 0 {
//            self.view.makeToast(message: "Rooms not available !")
//            return
//        }
        
        // move to Passengers screen...
        let passengObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "SelectRoomListVC") as! SelectRoomListVC
//        passengObj.roomCombinations = DHotelRoomsModel.roomCombinations
        passengObj.rooms_array = DHotelDetailsModel.roomsArray
        passengObj.roomSelect_index = 0
        passengObj.select_hotel = select_hotel
        passengObj.hotelDetail_model = hotelDetail_model
        
        self.navigationController?.pushViewController(passengObj, animated: true)
    }
}

extension HotelDetailsVC: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarouselDelegate
    func numberOfItems(in carousel: iCarousel) -> Int {
        return media_array.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        // crate view...
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height))
        tempView.backgroundColor = UIColor.clear
        
        // add image view...
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        tempView.addSubview(imgView)
        
        // loading image...
        let urlStr = media_array[index]
        imgView.sd_setImage(with: URL.init(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), completed: nil)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if option == iCarouselOption.spacing {
            return value * 1.01
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        page_Ctrl.currentPage = carousel.currentItemIndex
    }
}

extension HotelDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = hotelDetail_model.popularFacility_array[indexPath.item]
        label.font = UIFont(name: "Poppins-Medium", size: 12)
        label.sizeToFit()
        
        let cellPadding: CGFloat = 16//54 // Extra padding for spacing
        let width = label.frame.width + cellPadding
        print(width)
        let height: CGFloat = 20//41 // Fixed height
        
        return CGSize(width: width, height: height)    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hotelDetail_model.popularFacility_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCVCell", for: indexPath as IndexPath) as! FacilityCVCell
        
        let item = hotelDetail_model.popularFacility_array[indexPath.item]
        cell.lbl_name.text = item
        cell.lbl_name.font = UIFont(name: "Poppins-Medium", size: 12)
//        cell.lbl_facility.text = item
//        cell.img_facility.image = UIImage(named: "\(item)")
//        DHotelDetailsModel.amenities_list_array.forEach { (name, url) in
//            if name == item {
//                cell.loadImageFromURL(url: url)
//            }
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}
extension HotelDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_customerReview {
            return customer_reviews.count
        } else {
            return hotel_reviewa.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_review {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "AdminReviewsTVCell") as? AdminReviewsTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "AdminReviewsTVCell", bundle: nil), forCellReuseIdentifier: "AdminReviewsTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "AdminReviewsTVCell") as? AdminReviewsTVCell
            }
            let model = hotel_reviewa[indexPath.row]
            cell?.img_review.sd_setImage(with: URL.init(string: model.image!.replacingOccurrences(of: " ", with: "%20")))// = model.image
            cell?.loadSVGFromURL(url: model.image!)
            cell?.lbl_title.text = model.criteriaName
            cell?.view_rating.rating = model.rating
            cell?.lbl_ratingCount.text = "\(model.rating)"
            cell?.selectionStyle = .none
            return cell!
            
        } else {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CustomorReviewsTVCell") as? CustomorReviewsTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "CustomorReviewsTVCell", bundle: nil), forCellReuseIdentifier: "CustomorReviewsTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CustomorReviewsTVCell") as? CustomorReviewsTVCell
            }
            
            cell?.displayReview(model: customer_reviews[indexPath.row])
            cell?.selectionStyle = .none
            return cell!
        }
    }
}

extension HotelDetailsVC {
    func gettingHotel_Details() {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["ResultIndex": (select_hotel?.resultToken)!, //(select_hotel?.resultIndex)!
                                        "TraceId": (select_hotel?.resultToken)!,
                                        "HotelCode": (select_hotel?.hotel_code)!,
                                        "booking_source": (select_hotel?.booking_source)!,
                                        "op": "get_details",
                                        "search_id": DHotelSearchModel.search_id]
        print("params: \(params)")
        
        let paramString: [String: String] = ["hotel_details": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Details, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            self.hotelDetail_model = DHotelDetailsModel.createModel(dateInfo: data_dict)
                        }
                    } else {
                        
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Hotel details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel details error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            // getting rooms list...
            self.gettingHotel_RoomsList(roomParams: params)
        }
        /*if let data = JSONLoader.loadJSON(from: "hotelDetail") {
            if let dataDict = data["HotelDetails"] as? [String: Any] {
//                if let hotelInfoResult = dataDict["HotelInfoResult"] as? [String: Any] {
                    self.hotelDetail_model = DHotelDetailsModel.createModel(dateInfo: dataDict)
                    self.gettingHotel_RoomsList(roomParams: [:])
//                }
            }
        }*/
    }
    // MARK: - API's
//    func gettingHotel_Details()
    func gettingHotel_RoomsList(roomParams: [String: String]) {
        
        // params...
        var params = roomParams
        params["op"] = "get_room_details"
        print("params: \(params)")
        
        let paramString: [String: String] = ["room_list": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Room_List, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel rooms list success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            if let room_array = data_dict["data"] as? [[String: Any]] {
                                DHotelDetailsModel.roomsArray.removeAll()
                                DHotelDetailsModel.createRoomModels(dataInfo: room_array)
                            }
                        }
                    } else {
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Hotel rooms list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel rooms list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayHotelDetails()
            SwiftLoader.hide()
        }
/*                if let data = JSONLoader.loadJSON(from: "roomList") {
                    if let data_dict = data["RoomList"] as? [String: Any] {
                        if let room_array = data_dict["GetHotelRoomResult"] as? [String: Any] {
                            if let room = room_array["HotelRoomsDetails"] as? [[String: Any]] {
                            DHotelDetailsModel.createRoomModels(dataInfo: room)
                            }
        
                        }
                    }
        //            if let dataDict = data["RoomList"] as? [[String: Any]] {
        //                DHotelDetailsModel.createRoomModels(dataInfo: dataDict)
                        self.displayHotelDetails()
        //            }
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



extension HotelDetailsVC {
//    func loadecostay(){
//        DHotelSearchModel.hotelsSearch_array.removeAll()
//        
//        SwiftLoader.show(animated: true)
//        print(AddRoomModel.addRooms_array)
//        // getting room details...
//        
//        var room_array: [Any] = []
//        
//        for model in AddRoomModel.addRooms_array {
//            
//            // room details...
//            var room: [String: Any] = ["NoOfAdults": "\(model.adult_count)"]
//            room["NoOfChild"] = "\(model.child_count)"
//            room["ChildAge_1"] = []
//            
//            if model.child_count == 1 {
//                room["ChildAge_1"] = [model.child_age1]
//            }
//            else if model.child_count == 2 {
//                room["ChildAge_1"] = [model.child_age1, model.child_age2]
//            }
//            else {}
//            room_array.append(room)
//        }
//        
//        let room1ch: [String] = []
//        
//        
//        var adultCounts: [String] = []
//        var childCounts: [String] = []
//        let array = room_array
//        for dict in array {
//            if let adultCount = (dict as? [String: Any])?["NoOfAdults"] {
//                adultCounts.append(adultCount as! String)
//            }
//            if let childCount = (dict as? [String: Any])?["NoOfChild"]{
//                childCounts.append(childCount as! String)
//            }
//            
//        }
//        
//        // Ensure that we have exactly 3 elements in the adultCounts array
//        if adultCounts.count < 3 {
//            let missingCount = 3 - adultCounts.count
//            adultCounts.append(contentsOf: Array(repeating: "0", count: missingCount))
//        } else if adultCounts.count > 3 {
//            adultCounts.removeLast(adultCounts.count - 3)
//        }
//        
//        if childCounts.count < 3 {
//            let missingCount = 3 - childCounts.count
//            childCounts.append(contentsOf: Array(repeating: "0", count: missingCount))
//        } else if childCounts.count > 3 {
//            childCounts.removeLast(childCounts.count - 3)
//        }
//        
//        var room1childagearray: [String] = []
//        var room2childagearray: [String] = []
//        var room3childagearray: [String] = []
//        
//        for room in AddRoomModel.addRooms_array.prefix(3) {
//            
//            if let childAge1 = room.child_age1 as? String, let childAge2 = room.child_age2 as? String {
//                room1childagearray.append(String(childAge1))
//                room1childagearray.append(String(childAge2))
//            } else {
//                room1childagearray = ["0", "0"]
//            }
//        }
//        
//        for room in  AddRoomModel.addRooms_array.prefix(3) {
//            if let childAge1 = room.child_age1 as? String, let childAge2 = room.child_age2 as? Int {
//                room2childagearray.append(String(childAge1))
//                room2childagearray.append(String(childAge2))
//            } else {
//                room2childagearray = ["0", "0"]
//            }
//        }
//        
//        for room in  AddRoomModel.addRooms_array.prefix(3) {
//            if let childAge1 = room.child_age1 as? String, let childAge2 = room.child_age2 as? Int {
//                room3childagearray.append(String(childAge1))
//                room3childagearray.append(String(childAge2))
//            } else {
//                room3childagearray = ["0", "0"]
//            }
//        }
//        print(adultCounts)
//        print(childCounts)
//        print("room1childagearray:", room1childagearray)
//        print("room2childagearray:", room2childagearray)
//        print("room3childagearray:", room3childagearray)
//        
//        let newParam:[String: Any] = [
//            "city": "\(DHTravelModel.hotelCity_dict!["value"] ?? "")",
//            "hotel_destination": DHTravelModel.hotelCity_dict!["id"] ?? "",
//            "location": "",
//            "radius": "1",
//            "latitude": "",
//            "longitude": "",
//            "countrycode": "",
//            "search_type": "city_search",
//            "hotel_checkin": DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DHTravelModel.checkin_date),//"29-04-2024",
//            "hotel_checkout": DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DHTravelModel.checkout_date),//"30-04-2024",
//            "rooms": "\(AddRoomModel.addRooms_array.count)",//"2",
//            "adult": adultCounts,
//            "child": childCounts,
//            "childAge_1": room1childagearray,
//            "childAge_2": room2childagearray,
//            "childAge_3": room3childagearray,
//            "theme_cat": "" ?? "",
//        ]
//        
//        // calling apis...
//        VKAPIs.shared.getRequestRaw(params: [:], file: HOTEL_Search, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Hotel search list success: \(String(describing: resultObj))")
//                
//                if let result = resultObj as? [String: Any] {
//                    if result["status"] as? Bool == true {
//                        
//                        // response data...
//                        
//                        DHotelSearchModel.createModels(result_dict: result)
//                        self.displaySearchId()
//                    } else {
//                        
//                        // error message...
//                        if let message_str = result["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Hotel search list formate : \(String(describing: resultObj))")
//                }
//            } else {
//                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//            }
//
//            SwiftLoader.hide()
//        }
//    }
}
extension HotelDetailsVC: hotelAddRoomsDelegate {
    func hotelAddRoom_SelectionAction() {
//        print("Old Search id: \(DHotelSearchModel.search_id)")
//        
//        print("Reload details here")
//        print("get search id from api")
//        loadecostay()
        
    }
    func displaySearchId() {
        print("New Search id: \(DHotelSearchModel.search_id)")
        gettingHotel_Details()
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
