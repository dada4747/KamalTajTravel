//
//  FlightBaggageVC.swift
//  MTM
//
//  Created by Nandu on 20/12/23.
//

import UIKit

protocol baggageChildVCDelegate {
    
    func updateBaggagePriceInfo()
    func showBaggagePricePopUp(tripIndex: Int)
}

class FlightBaggageVC: UIViewController {
    
    @IBOutlet weak var coll_trips: UICollectionView!
    @IBOutlet weak var tbl_baggage: UITableView!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_bagSelectedCount: UILabel!
    @IBOutlet weak var lbl_bagSelectedPrice: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    var delegate: baggageChildVCDelegate?
    var baggage_array:[DFlightBaggageItem] = []
    
    var selectedIndex = 0
    var selectedIndexTbl = 0
    var expandedRows: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDelegate()
        createBaggageInfo()
        let validIndexes = DPassengerModel.allPassengerArray.enumerated().compactMap {
            $0.element.isInfant ? nil : $0.offset
        }

        expandedRows = Set(validIndexes)

        for i in 0..<DPassengerModel.allPassengerArray.count {
            DPassengerModel.allPassengerArray[i].isSelected = !DPassengerModel.allPassengerArray[i].isInfant
        }

    }
    
    override func viewDidLayoutSubviews() {
//        view_header.dropShadow(color: UIColor.gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    // MARK: - Helpers
    func addDelegate() {
        
        // delegate...
        coll_trips.delegate = self
        coll_trips.dataSource = self
        
        // register...
        coll_trips.register(UINib.init(nibName: "FlightTripCVCell", bundle: nil), forCellWithReuseIdentifier: "FlightTripCVCell")
    }
    
    func createBaggageInfo() {
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            if DPassengerModel.allPassengerArray[i].isInfant {
                continue
            }
            
            var model = DPassengerModel.allPassengerArray[i]
            
            for _ in 0 ..< DFlightAddOnsModel.baggage_keys_array.count {
                
                let baggageItem = DFlightBaggageItem.init(details: [:])
                model.baggage_array.append(nil)
                model.baggageArray.append(baggageItem)
                print("model: \(model.meals_array)")
                DPassengerModel.allPassengerArray[i] = model
            }
        }

//        updateBaggageSelection()
        reloadBaggageData()
    }
    
    func reloadBaggageData() {
        self.lbl_status.isHidden = false
        tbl_baggage.isHidden = true

        if DFlightAddOnsModel.baggage_keys_array.count != 0 {
            
            baggage_array.removeAll()
            
            let key_string = DFlightAddOnsModel.baggage_keys_array[selectedIndex]
            baggage_array = DFlightAddOnsModel.baggageMain_Dict[key_string] ?? []
            
            self.lbl_status.isHidden = false
            tbl_baggage.isHidden = true
            
            if baggage_array.count != 0 {
                self.lbl_status.isHidden = true
                tbl_baggage.isHidden = false
                
                tbl_baggage.delegate = self
                tbl_baggage.dataSource = self
                
                tbl_baggage.reloadData()
            }
            
            coll_trips.reloadData()
        }
    }
    
    // MARK: - ButtonAction
    @IBAction func baggageInfoBtnClicked(_ sender: UIButton) {
        if baggage_array.count == 0 {
            self.view.makeToast(message: "No Baggage Available")
            return
        }
        delegate?.showBaggagePricePopUp(tripIndex: selectedIndex)
    }

}

extension FlightBaggageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = DFlightStopsModel.flightTrip_array[indexPath.section]
        let nameStr = DFlightAddOnsModel.baggage_keys_array[indexPath.row]
        print("nameStr inSize \(nameStr)")

        let text = "\( model.depart_airportcode ?? "") -> \(model.arrival_airportcode ?? "")"
                // Calculate Width based on Text
                let estimatedWidth = nameStr.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)!]).width + 40 // Adding Padding
                
                // Set a minimum and maximum width
                let minWidth: CGFloat = 50
                let maxWidth: CGFloat = collectionView.frame.width - 50
        return CGSize(width: min(max(estimatedWidth, minWidth), maxWidth), height: 32)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return DFlightAddOnsModel.baggage_keys_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightTripCVCell", for: indexPath as IndexPath) as! FlightTripCVCell
        
        //display information...
        let nameStr = DFlightAddOnsModel.baggage_keys_array[indexPath.row]
        let model = DFlightStopsModel.flightTrip_array[indexPath.section]
        cell.img_airline.sd_setImage(with: URL.init(string: String(format: "%@/%@",DFlightSearchModel.airline_imgUrl, model.airline_image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        let title = nameStr
//        cell.lbl_cityCode.text = "\( model.depart_airportcode ?? "") -> \(model.arrival_airportcode ?? "")"
        cell.configure(with: title, isSelected: selectedIndex == indexPath.row)
        cell.img_wiidthConstraint.constant = 0
        cell.img_leftConstraint.constant = 0
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        reloadBaggageData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension FlightBaggageVC: UITableViewDelegate, UITableViewDataSource, FlightAddMealsDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DPassengerModel.allPassengerArray.filter { !$0.isInfant }.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if expandedRows.contains(indexPath.row) {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FlightAddOnsCell") as? FlightAddOnsCell
        if cell == nil {
            tableView.register(UINib(nibName: "FlightAddOnsCell", bundle: nil), forCellReuseIdentifier: "FlightAddOnsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FlightAddOnsCell") as? FlightAddOnsCell
        }
        
        // display information...
        let validPassengers = DPassengerModel.allPassengerArray.filter { !$0.isInfant }
        let model = validPassengers[indexPath.row]
        
        cell?.lbl_title.text = "\(model.first_name ?? "") \(model.last_name ?? "")"
        
        if model.isSelected {
            cell?.displayFlightBaggage_Info(loArr: baggage_array, model: model.baggageArray[selectedIndex])
        } else {
            cell?.displayFlightBaggage_Info(loArr: [], model: model.baggageArray[selectedIndex])
        }

        cell?.delegate = self
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let validPassengers = DPassengerModel.allPassengerArray.filter { !$0.isInfant }
        selectedIndexTbl = DPassengerModel.allPassengerArray.firstIndex(where: {
            $0.first_name == validPassengers[indexPath.row].first_name &&
            $0.last_name == validPassengers[indexPath.row].last_name
        }) ?? indexPath.row

        if expandedRows.contains(indexPath.row) {

            // Close clicked row
            expandedRows.remove(indexPath.row)
            DPassengerModel.allPassengerArray[selectedIndexTbl].isSelected = false

        } else {

            // Open clicked row
            expandedRows.insert(indexPath.row)
            DPassengerModel.allPassengerArray[selectedIndexTbl].isSelected = true
        }

        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - FlightAddMealsDelegate
    func flightAddMeals(mealsIndex: Int, cell: UITableViewCell) {
        
        // selected index...
        let indexPath = tbl_baggage .indexPath(for: cell)
        selectedIndexTbl = (indexPath?.row)!
        
        for i in 0 ..< baggage_array.count {
            baggage_array[i].isSelected = false
        }
        
        baggage_array[mealsIndex].isSelected = true
        
        DPassengerModel.allPassengerArray[selectedIndexTbl].baggageItem = baggage_array[mealsIndex]
        DPassengerModel.allPassengerArray[selectedIndexTbl].baggage_array[selectedIndex] = baggage_array[mealsIndex].baggageId
        DPassengerModel.allPassengerArray[selectedIndexTbl].baggageArray[selectedIndex] = baggage_array[mealsIndex]
        
        tbl_baggage.reloadData()
        
        updateBaggageSelection()
    }
    
    func updateBaggageSelection() {
        
        var baggage_price: Float = 0.0
        var count = 0
        
        var tempBaggageArr: [DFlightBaggageItem] = []
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            let model = DPassengerModel.allPassengerArray[i]
            
            if model.isInfant {
                continue
            }
            
            tempBaggageArr.append(model.baggageArray[selectedIndex])
        }
        
        for i in 0 ..< tempBaggageArr.count {
            
            let model = tempBaggageArr[i]
             
            let token = model.isSelected
            baggage_price += Float(model.price)
            
            if token {
                count += 1
            }
        }
        let totalPassengers = DPassengerModel.allPassengerArray.filter { !$0.isInfant }.count
        lbl_bagSelectedCount.text = "\(count) of \(totalPassengers) Baggage(s) Selected"
        lbl_bagSelectedPrice.text = String(format: "%.0f %@", (baggage_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")//String.init(format: "INR %.2f", baggage_price)
        
        FinalBreakupModel.baggageFare = baggage_price
        
        delegate?.updateBaggagePriceInfo()
    }
}
