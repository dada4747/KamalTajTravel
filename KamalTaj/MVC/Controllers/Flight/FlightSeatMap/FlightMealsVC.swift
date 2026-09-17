//
//  FlightMealsVC.swift
//  MTM
//
//  Created by Nandu on 20/12/23.
//

import UIKit

protocol MealsChildDelegate {
    func updateMealsPriceInfo()
    func showMealsPricePopUp(tripIndex: Int)
}

class FlightMealsVC: UIViewController {

    @IBOutlet weak var coll_trips: UICollectionView!
    @IBOutlet weak var tbl_meals: UITableView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var lbl_mealsSelectedCount: UILabel!
    @IBOutlet weak var lbl_mealsSelectedPrice: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    var delegate: MealsChildDelegate?
    var meals_array:[DFlightMealsItem] = []
    
    var selectedIndex = 0
    var selectedIndexTbl = 0
    var expandedRows: Set<Int> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDelegate()
        createMealsInfo()
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helpers
    func addDelegate() {
        
        // delegate...
        coll_trips.delegate = self
        coll_trips.dataSource = self
        
        // register...
        coll_trips.register(UINib.init(nibName: "FlightTripCVCell", bundle: nil), forCellWithReuseIdentifier: "FlightTripCVCell")
    }
    
    func createMealsInfo() {
        print(DPassengerModel.allPassengerArray.count)
        print(DFlightAddOnsModel.meals_keys_array.count)
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            if DPassengerModel.allPassengerArray[i].isInfant {
                continue
            }
            
            var model = DPassengerModel.allPassengerArray[i]
            
            for _ in 0 ..< DFlightAddOnsModel.meals_keys_array.count {
                
                let mealsItem = DFlightMealsItem.init(details: [:])
                model.meals_array.append(nil)
                model.mealsArray.append(mealsItem)
                print("model: \(model.meals_array)")
                DPassengerModel.allPassengerArray[i] = model
            }
        }

//        updateMealsSelection()
        reloadMealsData()
    }
    
    func reloadMealsData() {
        lbl_status.isHidden = false
        tbl_meals.isHidden = true

        if DFlightAddOnsModel.meals_keys_array.count != 0 {
            
            meals_array.removeAll()
            
            let key_string = DFlightAddOnsModel.meals_keys_array[selectedIndex]
            meals_array = DFlightAddOnsModel.mealsMain_Dict[key_string] ?? []
            
            lbl_status.isHidden = false
            tbl_meals.isHidden = true
            
            if meals_array.count != 0 {
                
                lbl_status.isHidden = true
                tbl_meals.isHidden = false
                
                tbl_meals.delegate = self
                tbl_meals.dataSource = self
                
                tbl_meals.reloadData()
            }
            
            coll_trips.reloadData()
        }
    }
    
    // MARK: - ButtonAction
    @IBAction func mealsInfoBtnClicked(_ sender: UIButton) {
        
        if meals_array.count == 0 {
            self.view.makeToast(message: "No Meals Available")
            return
        }
        
        delegate?.showMealsPricePopUp(tripIndex: selectedIndex)
    }
}

extension FlightMealsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = DFlightStopsModel.flightTrip_array[indexPath.section]
//        let mo = DFlightAddOnsModel.meals_array[indexPath.row]
        let nameStr = DFlightAddOnsModel.meals_keys_array[indexPath.row]
        print("nameStr inSize meals \(nameStr)")
        let text = "\( model.depart_airportcode ?? "") → \(model.arrival_airportcode ?? "")"
                // Calculate Width based on Text
        let estimatedWidth = nameStr.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)!]).width + 40 // Adding Padding
                
                // Set a minimum and maximum width
                let minWidth: CGFloat = 50
                let maxWidth: CGFloat = collectionView.frame.width - 50
        return CGSize(width: min(max(estimatedWidth, minWidth), maxWidth), height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DFlightAddOnsModel.meals_keys_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightTripCVCell", for: indexPath as IndexPath) as! FlightTripCVCell
        
        //display information...
        let nameStr = DFlightAddOnsModel.meals_keys_array[indexPath.row]
        print("nameStr inSize \(nameStr)")
        let model = DFlightStopsModel.flightTrip_array[indexPath.section]
        cell.img_airline.sd_setImage(with: URL.init(string: String(format: "%@/%@",DFlightSearchModel.airline_imgUrl, model.airline_image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        let title = nameStr

        print(title)
        cell.configure(with: title, isSelected: selectedIndex == indexPath.row)
        cell.img_wiidthConstraint.constant = 0
        cell.img_leftConstraint.constant = 0
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        reloadMealsData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension FlightMealsVC: UITableViewDelegate, UITableViewDataSource, FlightAddMealsDelegate {

    
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
            cell?.displayFlightMeals_Info(loArr: meals_array, model: model.mealsArray[selectedIndex])
        } else {
            cell?.displayFlightMeals_Info(loArr: [], model: model.mealsArray[selectedIndex] )
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
        let indexPath = tbl_meals.indexPath(for: cell)
        selectedIndexTbl = (indexPath?.row)!
        
        for i in 0 ..< meals_array.count {
            meals_array[i].isSelected = false
        }
        meals_array[mealsIndex].isSelected = true
        print(meals_array)
        print(meals_array[mealsIndex])
        print(meals_array[mealsIndex].descriptionText)
        DPassengerModel.allPassengerArray[selectedIndexTbl].mealsItem = meals_array[mealsIndex]
        DPassengerModel.allPassengerArray[selectedIndexTbl].meals_array[selectedIndex] = meals_array[mealsIndex].origin
        DPassengerModel.allPassengerArray[selectedIndexTbl].mealsArray[selectedIndex] = meals_array[mealsIndex]
        
        tbl_meals.reloadData()
        
        updateMealsSelection()
    }
    
    func updateMealsSelection() {
        
        var meals_price: Float = 0.0
        var count = 0
        
        var tempMealsArr: [DFlightMealsItem] = []
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            let model = DPassengerModel.allPassengerArray[i]
            
            if model.isInfant {
                continue
            }
            
            tempMealsArr.append(model.mealsArray[selectedIndex])
        }
        
        for i in 0 ..< tempMealsArr.count {
            
            let model = tempMealsArr[i]
             
            let token = model.isSelected
            meals_price += Float(model.price)
            
            if token {
                count += 1
            }
        }
        
        
        /*
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            let model = DPassengerModel.allPassengerArray[i]
            
            let token = model.mealsItem.resultToken ?? ""
            meals_price += model.mealsItem.price
            
            if !token.isEmpty {
                count += 1
            }
        }
        */
        
        let totalPassengers = DPassengerModel.allPassengerArray.filter { !$0.isInfant }.count
        lbl_mealsSelectedCount.text = "\(count) of \(totalPassengers) Meal(s) Selected"
        lbl_mealsSelectedPrice.text = String(format: "%.0f %@", (meals_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD")//baggage_priceString.init(format: "INR %.0f", meals_price)
        
        FinalBreakupModel.mealsFare = meals_price
        
        delegate?.updateMealsPriceInfo()
    }
    
    
}

