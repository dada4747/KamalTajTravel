//
//  HotelFiltersVC.swift
//  Hoetus
//
//  Created by Rahul on 16/07/23.
//

import UIKit

// protocol...
protocol hotelFiltersDelegate {
    func hotelsFiltersApply_removeIntimation()
}

// class...
class HotelFiltersVC: UIViewController {

    // MARK:- Outlets
//    @IBOutlet weak var btn_filter: UIButton!
//    @IBOutlet weak var btn_sort: UIButton!
    
    // MARK:- filter
    @IBOutlet weak var scroll_filters: UIScrollView!
    @IBOutlet weak var lbl_priceRange1: UILabel!
    @IBOutlet weak var lbl_priceRange2: UILabel!
    @IBOutlet weak var view_silderMain: UIView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var tbl_locations: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!

    @IBOutlet weak var view_starRating: UIView!
    @IBOutlet weak var btn_wifi: UIButton!
    @IBOutlet weak var btn_breakfast: UIButton!
    @IBOutlet weak var btn_parking: UIButton!
    @IBOutlet weak var btn_swimPool: UIButton!
    
    
    // MARK:- sort
    @IBOutlet weak var scroll_sortView: UIScrollView!
    @IBOutlet weak var btn_priceLow: UIButton!
    @IBOutlet weak var btn_priceHigh: UIButton!
    
    @IBOutlet weak var btn_starLow: UIButton!
    @IBOutlet weak var btn_starHigh: UIButton!
    
    @IBOutlet weak var btn_AZ: UIButton!
    @IBOutlet weak var btn_ZA: UIButton!
    @IBOutlet weak var view_sort: CRView!
    @IBOutlet weak var view_filter: CRView!
    @IBOutlet weak var view_sortAndFilter: UIView!

    
    // variables...
    var delegate: hotelFiltersDelegate?
    var defaultColor = UIColor.appColor
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    var onePort_value: Float = 0.0
    var final_min: Float = 0.0
    var final_max: Float = 1.0
    
    var star_rating: [Int] = [0, 0, 0, 0, 0]
    var amenities: [Int] = [0, 0, 0, 0]
    var sort_number: Int = -1
    
    var locationSel_array: [String] = []

    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_sortAndFilter.viewShadow()

//        defaultColor = btn_filter.backgroundColor!
        addDelegatesAndElements()
        
        displayFilters_information()
        displaySort_information()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Display
    func displayFilters_information() {
        
        // price information...
        rangeSlider.lowerValue = Double((DHotelFilters.price_selection.0 - DHotelFilters.price_default.0)/(onePort_value * 10))
        rangeSlider.upperValue = Double((DHotelFilters.price_selection.1 - DHotelFilters.price_default.0)/(onePort_value * 10))
        
        
        final_min = DHotelFilters.price_selection.0
        final_max = DHotelFilters.price_selection.1
//        lbl_priceRange1.text = "\(DFlightFilters.currency_code) \(final_min)"
//        lbl_priceRange2.text = "\(DFlightFilters.currency_code) \(final_max)"
        
        lbl_priceRange1.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) "
        lbl_priceRange2.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))"

        // stars color changes information...
        star_rating = DHotelFilters.star_rating
        for i in 0 ..< star_rating.count {
            if star_rating[i] != 0 {
                
                // color changes...
                for childView in view_starRating.subviews {
                    if childView.tag == (i + 10) {
                        starsDefaultColorImages(childView: childView, indexS: i)
                    }
                }
            }
        }
        
        
        // amenities images changing...
        amenities = DHotelFilters.amenities

        if amenities[0] == 1 {
            btn_wifi.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        if amenities[1] == 1 {
            btn_breakfast.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        if amenities[2] == 1 {
            btn_parking.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        if amenities[3] == 1 {
            btn_swimPool.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        
        locationSel_array = DHotelFilters.locationSelection_array
        tbl_locations.reloadData()


    }
    
    func displaySort_information() {
        
        // sort...
        sort_number = DHotelFilters.sort_number
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        btn_starLow.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_starHigh.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        btn_AZ.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_ZA.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        
        // actions...
        if sort_number == 0 {
            btn_priceLow.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else if sort_number == 1 {
            btn_priceHigh.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else if sort_number == 2 {
            btn_starLow.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else if sort_number == 3 {
            btn_starHigh.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else if sort_number == 4 {
            btn_AZ.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else if sort_number == 5 {
            btn_ZA.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else {}
    }
    
    func starsDefaultColorImages(childView: UIView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                let img_subChild = subChild as! UIImageView
                img_subChild.image = UIImage.init(named: "ic_star_grey")
                if star_rating[indexS] == 1 {
                    img_subChild.image = UIImage.init(named: "ic_star")
                }
            }
            
            // text color
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                childView.layer.borderWidth = 1
                childView.layer.borderColor = UIColor.placehoderColor.cgColor

                // select color...
                if star_rating[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.backgroundColor = .white
                    childView.layer.borderWidth = 1
                    childView.layer.borderColor = UIColor.secAppColor.cgColor
                }
            }
        }
    }
    
    
    // MARK:- Helpers
    func addDelegatesAndElements() {
        tbl_locations.delegate = self
        tbl_locations.dataSource = self
        tbl_HContraint.constant = CGFloat(DHotelFilters.location_array.count * 40)

        // Range slider adding...
        rangeSlider.frame = CGRect.init(x: 0, y: 0, width: (self.view.frame.size.width-30), height: 20)
        rangeSlider.thumbBorderWidth = 2
//        rangeSlider.rang = 5
        rangeSlider.thumbBorderColor = .appColor
        rangeSlider.thumbTintColor = .white
        rangeSlider.trackTintColor = .gray
        rangeSlider.trackHighlightTintColor = .appColor
        rangeSlider.lowerValue = 0
        rangeSlider.upperValue = 1
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(slider:)), for: .valueChanged)
        view_silderMain.addSubview(rangeSlider)
        
        // min and max...
        onePort_value = (DHotelFilters.price_default.1 - DHotelFilters.price_default.0) / 10
        if onePort_value == 0 {
            onePort_value = 0.1
        }
        rangeSliderValueChanged(slider: rangeSlider)
    }
    
    @objc func rangeSliderValueChanged(slider: RangeSlider) {
        
        // min and max...
        final_min = DHotelFilters.price_default.0 + (onePort_value * Float(slider.lowerValue * 10))
        final_max = DHotelFilters.price_default.0 + (onePort_value * Float(slider.upperValue * 10))
        
        // display price...
        lbl_priceRange1.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) " //"\(DFlightFilters.currency_code) \(final_min)"
        lbl_priceRange2.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))"
        //""\(DFlightFilters.currency_code) \(final_max)"

    }
    
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterAndSortButtonsClicked(_ sender: UIButton) {
        
        // color changes...
        view_filter.backgroundColor = UIColor(hexString: "#FF8A37")

        view_sort.backgroundColor = .clear

        // selection color..
        // filter, sort views showing...
        scroll_filters.isHidden = true
        scroll_sortView.isHidden = true
        if sender.tag == 10 {
//            scroll_filters.isHidden = false
            scroll_filters.isHidden = false
            view_filter.backgroundColor = UIColor(hexString: "#FF8A37")
            view_sort.backgroundColor = .clear
        } else {
            scroll_sortView.isHidden = false
            view_sort.backgroundColor = UIColor(hexString: "#FF8A37")
            view_filter.backgroundColor = .clear
        }
    }
    
    @IBAction func saveAndCancelButtonsClicked(_ sender: UIButton) {
        
        // move to back screen...
        if sender.tag == 10 {
            // sort...
            DHotelFilters.sort_number = sort_number

            // price filter added...
            if (rangeSlider.lowerValue > Double(DHotelFilters.price_default.0)) || (rangeSlider.upperValue < Double( DHotelFilters.price_default.1)) {
                DHotelFilters.price_selection = (final_min, final_max)
            }

            // stops..
            DHotelFilters.star_rating = star_rating
            DHotelFilters.amenities = amenities
            DHotelFilters.locationSelection_array = locationSel_array

        }
        else {
            // reset filters...
            DHotelFilters.getHotelssAndPrice_fromResponse()
        }
        
        // delegates...
        delegate?.hotelsFiltersApply_removeIntimation()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-
    @IBAction func starRatingButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if star_rating[sender.tag - 10] == 1 {
            star_rating[sender.tag - 10] = 0
        } else {
            star_rating[sender.tag - 10] = 1
        }
        // color changes...
        for childView in view_starRating.subviews {
            if childView.tag == sender.tag {
                starsDefaultColorImages(childView: childView, indexS:(sender.tag - 10))
            }
        }
    }
    
    @IBAction func amenitiesButtonClicked(_ sender: UIButton) {
        
        // selection index changings...
        if amenities[sender.tag - 10] == 1 {
            amenities[sender.tag - 10] = 0
            sender.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        } else {
            amenities[sender.tag - 10] = 1
            sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    
    @IBAction func allSortingButtonsClicked(_ sender: UIButton) {
        
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        btn_starLow.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_starHigh.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        btn_AZ.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        btn_ZA.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        
        // actions...
        if let parentView = sender.superview {
            parentView.backgroundColor = UIColor.white
            
            if sort_number == (sender.tag - 10) {
                sender.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
                sort_number = -1
                parentView.backgroundColor = UIColor.white
                
            } else {
                sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
                sort_number = (sender.tag - 10)
                //                parentView.backgroundColor = UIColor.init(hexString: "#FFFCF3") // Change to your preferred color
                
            }
        }
        
    }
}
extension HotelFiltersVC: UITableViewDataSource, UITableViewDelegate, flitersHotelLocationCellDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == tbl_dropDown {
//            return hotelNamesDisplay_array.count
//        }
//        else if tableView == tbl_facilities {
//            return DHotelFilters.facility_array.count
//        }
//        else {
            return DHotelFilters.location_array.count
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if tableView == tbl_dropDown {
//            
//            // cell creation...
//            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
//            if cell == nil {
//                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
//            }
//            //cell?.delegate = self
//            
//            // display information...
//            cell?.lbl_title.text = hotelNamesDisplay_array[indexPath.row]
//            cell?.selectionStyle = .none
//            return cell!
//            
//        } else {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotelLocationsCell") as? HotelLocationsCell
        if cell == nil {
            tableView.register(UINib(nibName: "HotelLocationsCell", bundle: nil), forCellReuseIdentifier: "HotelLocationsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HotelLocationsCell") as? HotelLocationsCell
                        }
            cell?.delegate = self
            
            //            if tableView == tbl_facilities {
            //                // display information...
            //                cell?.accessibilityLabel = "Facility"
            //                cell?.displayLocation_infomration(location_name: (DHotelFilters.facility_array[indexPath.row]), selection_array: facility_selection_array)
            //            }
            //            else {
            // display information...
            cell?.accessibilityLabel = "Location"
            cell?.displayLocation_infomration(location_name: (DHotelFilters.location_array[indexPath.row]), selection_array: locationSel_array)
            //            }
//        }

            cell?.selectionStyle = .none
            return cell!
//        }
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == tbl_dropDown {
//            
//            DHotelFilters.hotelNameSelected = hotelNamesDisplay_array[indexPath.row]
//            tf_hotelSearch.text = DHotelFilters.hotelNameSelected
//            view_dropDown.isHidden = true
//        }
    }

    // MARK:- CellActions
    func selectLocationButton_Action(sender: UIButton, cell: UITableViewCell) {
        
//        if cell.accessibilityLabel == "Facility" {
//            
//            // get index path...
//            let indexPath = tbl_facilities .indexPath(for: cell)
//            let board_name = DHotelFilters.facility_array[(indexPath?.row)!]
//            
//            // check location existed or not...
//            var existIndex = -1
//            for i in 0 ..< facility_selection_array.count {
//                
//                let board = facility_selection_array[i]
//                if board_name == board {
//                    existIndex = i
//                    break
//                }
//            }
//            
//            // add or remove element...
//            if existIndex == -1 {
//                facility_selection_array.append(board_name)
//            } else {
//                facility_selection_array.remove(at: existIndex)
//            }
//            
//            tbl_facilities.reloadData()
//        }
//        else {
            
            // get index path...
            let indexPath = tbl_locations .indexPath(for: cell)
            let location_name = DHotelFilters.location_array[(indexPath?.row)!]
            
            // check location existed or not...
            var existIndex = -1
            for i in 0 ..< locationSel_array.count {
                
                let location = locationSel_array[i]
                if location_name == location {
                    existIndex = i
                    break
                }
            }
            
            // add or remove element...
            if existIndex == -1 {
                locationSel_array.append(location_name)
            } else {
                locationSel_array.remove(at: existIndex)
            }
            tbl_locations.reloadData()
        }
//    }
}
