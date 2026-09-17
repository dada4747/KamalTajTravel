//
//  FlightFiltersVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol
protocol flightFiltersDelegate {
    func filtersApply_removeIntimation()
}


// class...
class FlightFiltersVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_sort: UIButton!
    @IBOutlet weak var view_header: UIView!
    
    // MARK:- filter
    @IBOutlet weak var scroll_filters: UIScrollView!
    @IBOutlet weak var lbl_priceAmt: UILabel!
    @IBOutlet weak var view_silderMain: UIView!
    
    @IBOutlet weak var view_noofStops: UIView!
    @IBOutlet weak var view_departTime: UIView!
    @IBOutlet weak var view_arrivalTime: UIView!
    @IBOutlet weak var tbl_airlines: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    
    // MARK:- sort
    @IBOutlet weak var scroll_sortView: UIScrollView!
    @IBOutlet weak var btn_priceLow: UIButton!
    @IBOutlet weak var btn_priceHigh: UIButton!
    
    @IBOutlet weak var btn_departEarly: UIButton!
    @IBOutlet weak var btn_deaprtLate: UIButton!
    
    @IBOutlet weak var btn_durationShort: UIButton!
    @IBOutlet weak var btn_durationLong: UIButton!
    
    @IBOutlet weak var btn_arrivalEarly: UIButton!
    @IBOutlet weak var btn_arrivalLate: UIButton!
    
    
    // variables...
    var delegate: flightFiltersDelegate?
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    var defaultColor = UIColor.ThemeColor_Blue
    var sort_number = -1
    
    var onePort_value: Float = 0.0
    var final_min: Float = 0.0
    var final_max: Float = 1.0
    
    var noofStops: [Int] = [0, 0, 0]
    var depart: [Int] = [0, 0, 0, 0]
    var arrival: [Int] = [0, 0, 0, 0]
    var flightSel_array: [String] = []
    
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // bottom shadow...
        view_header.viewShadow()
        
        defaultColor = .ThemeColor_Blue// btn_filter.backgroundColor!
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
        
        // min and max values...
        final_min = DFlightFilters.price_selection.0
        final_max = DFlightFilters.price_selection.1
        if final_min == final_max {
            final_max = final_min + 1
        }
        
        // price information...
        rangeSlider.lowerValue = Double((final_min - DFlightFilters.price_default.0)/(onePort_value * 10))
        rangeSlider.upperValue = Double((final_max - DFlightFilters.price_default.0)/(onePort_value * 10))
        lbl_priceAmt.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) - \(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) "
//        lbl_priceAmt.text = "\(DFlightFilters.currency_code) \(final_min) - \(DFlightFilters.currency_code) \(final_max)"
        
        
        // stops information display...
        noofStops = DFlightFilters.noofStops
        for i in 0 ..< noofStops.count {
            if noofStops[i] != 0 {
                
                // color changes...
                for childView in view_noofStops.subviews {
                    if childView.tag == (i + 10) {
                        numberofStopsDefaultColor(childView: childView, indexS: i)
                    }
                }
            }
        }
        
        
        // Depart information...
        depart = DFlightFilters.depart
        for i in 0 ..< depart.count {
            if depart[i] != 0 {

                // color changes...
                for childView in view_departTime.subviews {
                    if childView.tag == (i + 10) {
                        departureDefaultColorImages(childView: childView, indexS: i)
                    }
                }
            }
        }
        
        // arrival information...
        arrival = DFlightFilters.arrival
        for i in 0 ..< arrival.count {
            if arrival[i] != 0 {
                
                // color changes...
                for childView in view_arrivalTime.subviews {
                    if childView.tag == (i + 10) {
                        arrivalDefaultColorImages(childView: childView, indexS: i)
                    }
                }
            }
        }
        
        // selected airlines...
        flightSel_array = DFlightFilters.flightSelection_array
        tbl_airlines.reloadData()
    }
    
    func displaySort_information() {
        
        // sort...
        sort_number = DFlightFilters.sort_number
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_departEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_deaprtLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_durationShort.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_durationLong.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_arrivalEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_arrivalLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        
        // actions...
        if sort_number == 0 {
            btn_priceLow.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 1 {
            btn_priceHigh.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 2 {
            btn_departEarly.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 3 {
            btn_deaprtLate.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 4 {
            btn_durationShort.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 5 {
            btn_durationLong.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 6 {
            btn_arrivalEarly.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 7 {
            btn_arrivalLate.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else {}
    }
    
    
    // MARK:- Helpers
    func addDelegatesAndElements() {
        
        // delegates...
        tbl_airlines.delegate = self
        tbl_airlines.dataSource = self
        tbl_HContraint.constant = CGFloat(DFlightFilters.flight_array.count * 30)
        
        // Range slider adding...
        rangeSlider.frame = CGRect.init(x: 0, y: 5, width: (self.view.frame.size.width-30), height: 20)
        
        rangeSlider.thumbBorderWidth = 0
        rangeSlider.thumbTintColor = defaultColor
        rangeSlider.trackTintColor = .gray
        rangeSlider.trackHighlightTintColor = defaultColor
        rangeSlider.lowerValue = 0
        rangeSlider.upperValue = 1
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(slider:)), for: .valueChanged)
        view_silderMain.addSubview(rangeSlider)
        
        // min and max...
        onePort_value = (DFlightFilters.price_default.1 - DFlightFilters.price_default.0) / 10
        if onePort_value == 0 {
            onePort_value = 0.1
        }
        rangeSliderValueChanged(slider: rangeSlider)
        print("One part : \(onePort_value)")
    }
    
    @objc func rangeSliderValueChanged(slider: RangeSlider) {
        
        // min and max...
        final_min = DFlightFilters.price_default.0 + (onePort_value * Float(slider.lowerValue * 10))
        final_max = DFlightFilters.price_default.0 + (onePort_value * Float(slider.upperValue * 10))

        // display price...
        lbl_priceAmt.text = "\(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) - \(String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "INR", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) "
//        lbl_priceAmt.text = "\(DFlightFilters.currency_code) \(final_min) - \(DFlightFilters.currency_code) \(final_max)"
    }
    
    //MARK:- ColorChnages
    func numberofStopsDefaultColor(childView: UIView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = UIColor.init(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
                childView.backgroundColor = UIColor.white
                
                // select color...
                if noofStops[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.backgroundColor = defaultColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    
    func departureDefaultColorImages(childView: UIView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                // default image...
                let img_subChild = subChild as! UIImageView
                if childView.tag == 10 {
                    
                    img_subChild.image = UIImage.init(named: "ic_earlyMorn")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_earlyMornH")
                    }
                }
                else if childView.tag == 11 {
                    
                    img_subChild.image = UIImage.init(named: "ic_morning")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_morningH")
                    }
                }
                else if childView.tag == 12 {
                    
                    img_subChild.image = UIImage.init(named: "ic_midday")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_middayH")
                    }
                }
                else if childView.tag == 13 {
                    
                    img_subChild.image = UIImage.init(named: "ic_evening")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_eveningH")
                    }
                }
                else {}
            }
            
            // text color
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = UIColor.init(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
                childView.backgroundColor = UIColor.white
                
                // select color...
                if depart[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.backgroundColor = defaultColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    
    func arrivalDefaultColorImages(childView: UIView, indexS: Int) {
        
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                // default image...
                let img_subChild = subChild as! UIImageView
                if childView.tag == 10 {
                    
                    img_subChild.image = UIImage.init(named: "ic_earlyMorn")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_earlyMornH")
                    }
                }
                else if childView.tag == 11 {
                    
                    img_subChild.image = UIImage.init(named: "ic_morning")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_morningH")
                    }
                }
                else if childView.tag == 12 {
                    
                    img_subChild.image = UIImage.init(named: "ic_midday")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_middayH")
                    }
                }
                else if childView.tag == 13 {
                    
                    img_subChild.image = UIImage.init(named: "ic_evening")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_eveningH")
                    }
                }
                else {}
            }
            
            // text color...
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = UIColor.init(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
                childView.backgroundColor = UIColor.white
                
                // select color...
                if arrival[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.backgroundColor = defaultColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterAndSortButtonsClicked(_ sender: UIButton) {
        
        // color changes...
        btn_filter.backgroundColor = UIColor.white
        btn_filter.setTitleColor(UIColor.black, for: .normal)
        btn_sort.backgroundColor = UIColor.white
        btn_sort.setTitleColor(UIColor.black, for: .normal)
        
        // selection color..
        sender.backgroundColor = defaultColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        // filter, sort views showing...
        scroll_filters.isHidden = true
        scroll_sortView.isHidden = true
        if sender.tag == 10 {
            scroll_filters.isHidden = false
        } else {
            scroll_sortView.isHidden = false
        }
    }
    
    @IBAction func saveAndCancelButtonsClicked(_ sender: UIButton) {
        
        // move to back screen...
        if sender.tag == 10 {

            // sort...
            DFlightFilters.sort_number = sort_number
            
            // price filter added...
            if (rangeSlider.lowerValue > Double(DFlightFilters.price_default.0)) || (rangeSlider.upperValue < Double( DFlightFilters.price_default.1)) {
                DFlightFilters.price_selection = (final_min, final_max)
            }
            
            // stops..
            DFlightFilters.noofStops = noofStops
            DFlightFilters.depart = depart
            DFlightFilters.arrival = arrival
            DFlightFilters.flightSelection_array = flightSel_array
            
            // delegates...
            delegate?.filtersApply_removeIntimation()
        }else{
            DFlightFilters.sort_number = -1
            /*if (rangeSlider.lowerValue > Double(DFlightFilters.price_default.0)) || (rangeSlider.upperValue < Double( DFlightFilters.price_default.1)) {*/
            DFlightFilters.price_selection = DFlightFilters.price_default
//            }
            DFlightFilters.noofStops = [0, 0, 0]
            DFlightFilters.depart = [0, 0, 0, 0]
            DFlightFilters.arrival = [0, 0, 0, 0]
            DFlightFilters.flightSelection_array = []
            flightSel_array = []
            tbl_airlines.reloadData()
            delegate?.filtersApply_removeIntimation()

        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- Filter_Button
    @IBAction func noofStopsButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if noofStops[sender.tag - 10] == 1 {
            noofStops[sender.tag - 10] = 0
        } else {
            noofStops[sender.tag - 10] = 1
        }
        print("Noof stops : \(noofStops)")
        
        
        // color changes...
        for childView in view_noofStops.subviews {
            if childView.tag == sender.tag {
                numberofStopsDefaultColor(childView: childView, indexS: (sender.tag - 10))
            }
        }
    }
    
    @IBAction func departTimeButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if depart[sender.tag - 10] == 1 {
            depart[sender.tag - 10] = 0
        } else {
            depart[sender.tag - 10] = 1
        }
        print("Depart :\(depart)")
        
        
        // color changes...
        for childView in view_departTime.subviews {
            if childView.tag == sender.tag {
                departureDefaultColorImages(childView: childView, indexS:(sender.tag - 10))
            }
        }
    }
    
    @IBAction func arrivalTimeButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if arrival[sender.tag - 10] == 1 {
            arrival[sender.tag - 10] = 0
        } else {
            arrival[sender.tag - 10] = 1
        }
        print("Arrival \(arrival)")
        
        
        // color changes...
        for childView in view_arrivalTime.subviews {
            if childView.tag == sender.tag {
                arrivalDefaultColorImages(childView: childView, indexS:(sender.tag - 10))
            }
        }
    }
    
    @IBAction func allSortingButtonsClicked(_ sender: UIButton) {
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_departEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_deaprtLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_durationShort.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_durationLong.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        btn_arrivalLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        btn_arrivalEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        // actions...
        if sort_number == (sender.tag - 10) {
            sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
            sort_number = -1
        } else {
            sender.setImage(UIImage.init(named: "ic_checked"), for: .normal)
            sort_number = (sender.tag - 10)
        }
    }
}

extension FlightFiltersVC: UITableViewDataSource, UITableViewDelegate, flitersAirlineCellDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DFlightFilters.flight_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FFlitersAirlineCell") as? FFlitersAirlineCell
        if cell == nil {
            tableView.register(UINib(nibName: "FFlitersAirlineCell", bundle: nil), forCellReuseIdentifier: "FFlitersAirlineCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FFlitersAirlineCell") as? FFlitersAirlineCell
        }
        cell?.delegate = self
        
        // display information...
        cell?.displayAirline_infomration(airline_name: (DFlightFilters.flight_array[indexPath.row]), selection_array: flightSel_array)
        cell?.selectionStyle = .none
        return cell!
    }

    // MARK:- CellActions
    func selectAirlineButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // get index path...
        let indexPath = tbl_airlines .indexPath(for: cell)
        let airline_name = DFlightFilters.flight_array[(indexPath?.row)!]
        
        // check airline existed or not...
        var existIndex = -1
        for i in 0 ..< flightSel_array.count {
            
            let airline = flightSel_array[i]
            if airline_name == airline {
                existIndex = i
                break
            }
        }
        
        // add or remove element...
        if existIndex == -1 {
            flightSel_array.append(airline_name)
        } else {
            flightSel_array.remove(at: existIndex)
        }
        tbl_airlines.reloadData()
    }
}

