//
//  FlightAddOnsVC.swift
//  MTM
//
//  Created by Nandu on 21/12/23.
//

import UIKit

class FlightAddOnsVC: UIViewController {
    
    var flightSeatsVC = FlightSeatVC()
    var flightMealsVC = FlightMealsVC()
    var flightBaggageVC = FlightBaggageVC()

    @IBOutlet weak var containerSeats: UIView!
    @IBOutlet weak var containerMeals: UIView!
    @IBOutlet weak var containerBaggage: UIView!
    
    
    @IBOutlet weak var btn_seats: UIButton!
    @IBOutlet weak var btn_meals: UIButton!
    @IBOutlet weak var btn_baggage: UIButton!
    
    @IBOutlet weak var lbl_totalPrice: UILabel!
    @IBOutlet weak var lbl_titlePop: UILabel!
    @IBOutlet var view_popUp: UIView!
    @IBOutlet weak var tbl_viewPop: UITableView!
    @IBOutlet weak var hei_tblConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_PriceInfoPop: UIView!
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_OCFare: UILabel!
    @IBOutlet weak var lbl_extraSeatFare: UILabel!
    @IBOutlet weak var lbl_extraMealsFare: UILabel!
    @IBOutlet weak var lbl_extraBaggageFare: UILabel!
    @IBOutlet weak var view_extraSeatFare: UIStackView!
    @IBOutlet weak var view_extraMealsFare: UIStackView!
    @IBOutlet weak var view_extraBaggageFare: UIStackView!
    @IBOutlet weak var lbl_totalAmount: UILabel!
    @IBOutlet weak var lbl_discountFare: UILabel!
    @IBOutlet weak var view_discoundFare: UIStackView!
    @IBOutlet weak var lbl_gstFare: UILabel!
    @IBOutlet weak var lbl_rewardDiscount: UILabel!
    @IBOutlet weak var view_rewardDiscount: UIStackView!
    
    @IBOutlet weak var view_bfare: UIStackView!
    @IBOutlet weak var view_btax: UIStackView!
    @IBOutlet weak var view_bGst: UIStackView!
    
    @IBOutlet weak var view_bconvenience: UIStackView!
    @IBOutlet weak var lbl_totalLabel: UILabel!
    var baseConvenienceFare: Float = FinalBreakupModel.convenienceFare

    var gstSelected : Bool = false
    var paramString: [String: String] = [:]
    var skipParam : [String: String] = [:]
    var tripIndex = 0
    
    enum Segues {
        
        static let toMealsChild = "ToMeals"
        static let toBaggageChild = "ToBaggage"
        static let toSeatsChild = "ToSeatsChild"
    }
    
    var addOnsType = FlightAddOns.Seats
    enum FlightAddOns {
        case Seats
        case Meals
        case Baggage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupContainerViews()
        setup()
    }
    func clearAllAddOns() {
        for i in 0..<DPassengerModel.allPassengerArray.count {
            DPassengerModel.allPassengerArray[i].mealsArray.removeAll()
            DPassengerModel.allPassengerArray[i].baggageArray.removeAll()
            DPassengerModel.allPassengerArray[i].seatsArray.removeAll()
        }
        // Also reset the fare models if needed
        FinalBreakupModel.seatsFare = 0
        FinalBreakupModel.mealsFare = 0
        FinalBreakupModel.baggageFare = 0
        FinalBreakupModel.convenienceFare = baseConvenienceFare
        // Optional:
        // Reset cached dictionaries
//        DFlightAddOnsModel.orderedSeatMapData.removeAll()
    }
    func setup() {
        
        containerSeats.isHidden = false
        containerMeals.isHidden = true
        containerBaggage.isHidden = true
        
//        line_XConstraint.constant = btn_seats.frame.origin.x
//        line_WidthConstraint.constant = btn_seats.frame.size.width
        
        // Example: access grandparent
        if let tab1 = view.viewWithTag(101) as? CRView {
            tab1.backgroundColor = UIColor(hexString: "#F4F5F9")
            tab1.borderColor = UIColor(hexString: "#FF8A37")
        }
//        if let parentView = btn_seats.superview?.superview as? CRView {
//        }
        
        displayPriceBreakUp()
        
        tbl_viewPop.delegate = self
        tbl_viewPop.dataSource = self
        
        self.view_popUp.isHidden = true
        self.view_popUp.frame = self.view.frame
        self.view.addSubview(self.view_popUp)
        
        self.view_PriceInfoPop.frame = self.view.frame
        self.view_PriceInfoPop.isHidden = true
        self.view.addSubview(view_PriceInfoPop)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.toMealsChild {
            if let destVC = segue.destination as? FlightMealsVC {
                self.flightMealsVC = destVC
                destVC.delegate = self
            }
        }
        if segue.identifier == Segues.toBaggageChild {
            if let destVC = segue.destination as? FlightBaggageVC {
                self.flightBaggageVC = destVC
                destVC.delegate = self
            }
        }
        
        if segue.identifier == Segues.toSeatsChild {
            if let destVC =  segue.destination as? FlightSeatVC {
                self.flightSeatsVC = destVC
                destVC.delegate = self
            }
        }
    }
    
    func addSecondChildVC() {
        
        addChild(flightBaggageVC)
        view.addSubview(flightBaggageVC.view)
        flightBaggageVC.didMove(toParent: self)
        flightBaggageVC.view.frame = self.view.bounds
    }
    
    // MARK: - Helpers
    private func setupContainerViews() {
        
        //addChild(flightSeatsVC)
        addChild(flightMealsVC)
        addChild(flightBaggageVC)
        
        self.view.addSubview(flightSeatsVC.view)
        self.view.addSubview(flightMealsVC.view)
        self.view.addSubview(flightBaggageVC.view)
        
        flightSeatsVC.didMove(toParent: self)
        flightMealsVC.didMove(toParent: self)
        flightBaggageVC.didMove(toParent: self)
        
        flightSeatsVC.view.frame = self.view.bounds
        flightMealsVC.view.frame = self.view.bounds
        flightBaggageVC.view.frame = self.view.bounds
        
    }
    
    func reloadTableView() {
        
        tbl_viewPop.reloadData()
        tbl_viewPop.layoutIfNeeded()
        hei_tblConstraint.constant = self.tbl_viewPop.contentSize.height + 200
    }
    
    func displayPriceBreakUp() {
        
        var seatsFare: Float = 0.0
        var mealsFare: Float = 0.0
        var baggageFare: Float = 0.0
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            
            let model = DPassengerModel.allPassengerArray[i]
            
            //seats fare...
            for j in 0 ..< model.seatsArray.count {
                
                let seatCharge = model.seatsArray[j]["seatPrice"] as? String ?? "0.0"
                
                let result = seatCharge.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                
                print("result: \(result)")
                
                let fare: Float = Float(String.init(describing: result))!
                
                //let fare: Float = Float(String.init(describing: model.seatsArray[j]["seat_charge"] ?? 0.0))!
                seatsFare = seatsFare + fare
            }
            
            //meals fare...
            for k in 0 ..< model.mealsArray.count {
                mealsFare = mealsFare + Float(model.mealsArray[k].price)
            }
            
            //baggage fare...
            for l in 0 ..< model.baggageArray.count {
                baggageFare = baggageFare + Float(model.baggageArray[l].price)
            }
        }
        
        FinalBreakupModel.seatsFare = seatsFare
        FinalBreakupModel.mealsFare = mealsFare
        FinalBreakupModel.baggageFare = baggageFare

        let total_price = (FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare + FinalBreakupModel.baggageFare + FinalBreakupModel.mealsFare + FinalBreakupModel.seatsFare) - FinalBreakupModel.discount - FinalBreakupModel.rewardDiscount
        
        lbl_totalPrice.text = String(format: "%.0f %@", (total_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")//baggage_priceString.init(format: "INR %.0f", total_price)
        
        displayBookingPriceInfo()
    }
    
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_baseFare.text = String(format: "%.0f %@", (FinalBreakupModel.baseFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")//String.init(format: "INR %.0f",  FinalBreakupModel.baseFare)]
        lbl_taxFare.text = String.init(format: "%.0f %@",  (FinalBreakupModel.totalTax * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_OCFare.text = String.init(format: "%.0f %@", (FinalBreakupModel.convenienceFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_gstFare.text = String.init(format: "%.0f %@", (FinalBreakupModel.gstFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        // flight add ons...
        lbl_extraSeatFare.text = String.init(format: "%.0f %@",  (FinalBreakupModel.seatsFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_extraMealsFare.text = String.init(format: "%.0f %@",  (FinalBreakupModel.mealsFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_extraBaggageFare.text = String.init(format: "%.0f %@", (FinalBreakupModel.baggageFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_discountFare.text = String.init(format: "%.0f %@",  (FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        lbl_rewardDiscount.text = String.init(format: "%.0f %@",  (FinalBreakupModel.rewardDiscount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        
        var totalFare: Float = 0.0
        totalFare = (FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare + FinalBreakupModel.seatsFare + FinalBreakupModel.mealsFare + FinalBreakupModel.baggageFare) - FinalBreakupModel.discount - FinalBreakupModel.rewardDiscount
        
        lbl_totalAmount.text = String.init(format: "%.0f %@", (totalFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        
        var isShowBaseFare: Bool = true
        
        self.view_bfare.isHidden = true
        self.view_btax.isHidden = true
        self.view_bGst.isHidden = true
        self.view_bconvenience.isHidden = true
        
        self.view_extraSeatFare.isHidden = false
        self.view_extraMealsFare.isHidden = false
        self.view_extraBaggageFare.isHidden = false
        self.view_discoundFare.isHidden = true
        self.view_rewardDiscount.isHidden = true
//        lbl_totalLabel.text = "Total Fare"

        if FinalBreakupModel.seatsFare == 0 {
            self.view_extraSeatFare.isHidden = true
            isShowBaseFare = false
        }
        if FinalBreakupModel.baggageFare == 0 {
            self.view_extraBaggageFare.isHidden = true
            isShowBaseFare = false
        }
        if FinalBreakupModel.mealsFare == 0 {
            self.view_extraMealsFare.isHidden = true
            isShowBaseFare = false
        }
        if FinalBreakupModel.discount == 0 {
            self.view_discoundFare.isHidden = true
        }
        if FinalBreakupModel.rewardDiscount == 0 {
            self.view_rewardDiscount.isHidden = true
        }
        var totalExtraFare: Float = 0.0
        totalExtraFare = ( FinalBreakupModel.seatsFare + FinalBreakupModel.mealsFare + FinalBreakupModel.baggageFare)
        
        self.lbl_totalLabel.text = "Total Extra Fare"
        lbl_totalAmount.text = String.init(format: "%.0f %@", (totalExtraFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD")
        lbl_totalPrice.text = String(format: "%.0f %@", (totalExtraFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
//        if isShowBaseFare {
//            self.view_bfare.isHidden = false
//            self.view_btax.isHidden = false
//            self.view_bGst.isHidden = false
//            self.view_bconvenience.isHidden = false
//            self.lbl_totalLabel.text = "Total Extra Fare"
//        }
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        
        clearAllAddOns()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addOnsBtnClicked(_ sender: UIButton) {
        
        containerMeals.isHidden = true
        containerBaggage.isHidden = true
        containerSeats.isHidden = true
//        guard let selectedView = sender.superview as? CRView else { return }
//        let selectedTag = selectedView.tag
        
        if let tab1 = view.viewWithTag(101) as? CRView {
            tab1.backgroundColor = .white
            tab1.borderColor = .init(hexString: "#CACACA")
        }
        if let tab2 = view.viewWithTag(102) as? CRView {
            tab2.backgroundColor = .white
            tab2.borderColor = .init(hexString: "#CACACA")
        }
        if let tab3 = view.viewWithTag(103) as? CRView {
            tab3.backgroundColor = .white
            tab3.borderColor = .init(hexString: "#CACACA")
        }
        
        if sender.tag == 11 {
            // show meals vc
            containerMeals.isHidden = false
            
//            line_XConstraint.constant = btn_meals.frame.origin.x
//            line_WidthConstraint.constant = btn_meals.frame.size.width
        }
        else if sender.tag == 12 {
            // show baggage vc
            containerBaggage.isHidden = false
            
//            line_XConstraint.constant = btn_baggage.frame.origin.x
//            line_WidthConstraint.constant = btn_baggage.frame.size.width
        }
        else {
            
            // show seat vc
            containerSeats.isHidden = false
//            line_XConstraint.constant = btn_seats.frame.origin.x
//            line_WidthConstraint.constant = btn_seats.frame.size.width
        }
        if let selectedView = sender.superview as? CRView {
            selectedView.borderColor = .init(hexString: "#FF8A37")
            selectedView.backgroundColor = .init(hexString: "#F4F5F9")
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        
    }
    
    @IBAction func dismissPopBtnClicked(_ sender: UIButton) {
        self.view_popUp.isHidden = true
    }
    
    @IBAction func infoPriceBtnClicked(_ sender: Any) {
        self.view_PriceInfoPop.isHidden = false
    }
    
    @IBAction func dismissPricePopBtnClicked(_ sender: Any) {
        self.view_PriceInfoPop.isHidden = true
    }

    @IBAction func continueBtnClicked(_ sender: UIButton) {
        if FinalBreakupModel.promoCode == "" {
            updateConvenience()
            
        }
        else {
           aplyPromo()
        }
        
        //        getAppReference_FLIGHT()
        
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        clearAllAddOns()
        let nextObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightReviewVC") as! FlightReviewVC
        nextObj.paramString = skipParam
        self.navigationController?.pushViewController(nextObj, animated: true)

    }
}

extension FlightAddOnsVC : MealsChildDelegate, baggageChildVCDelegate, seatsChildVCDelegate {

    //MARK: - MealsChildDelegate
    func updateMealsPriceInfo() {
        displayPriceBreakUp()
    }
    
    func showMealsPricePopUp(tripIndex: Int) {
        
        self.tripIndex = tripIndex
        
        addOnsType = .Meals
        lbl_titlePop.text = "Your Meals"
        view_popUp.isHidden = false
        tbl_viewPop.reloadData()
        //hei_tblConstraint.constant = CGFloat(50 * DPassengerModel.allPassengerArray.count) + 200
        
        reloadTableView()
    }
    
    //MARK: - baggageChildVCDelegate
    func updateBaggagePriceInfo() {
        displayPriceBreakUp()
    }
    
    func showBaggagePricePopUp(tripIndex: Int) {
        
        addOnsType = .Baggage
        lbl_titlePop.text = "Your Baggage"
        view_popUp.isHidden = false
        tbl_viewPop.reloadData()
        //hei_tblConstraint.constant = CGFloat(50 * DPassengerModel.allPassengerArray.count) + 200
        
        reloadTableView()
        
    }
    
    //MARK: - seatsChildVCDelegate
    func updateSeatsPriceInfo() {
        displayPriceBreakUp()
    }
    
    func showSeatPricePopUp(tripIndex: Int) {
        
        self.tripIndex = tripIndex
        
        addOnsType = .Seats
        lbl_titlePop.text = "Your Seats"
        view_popUp.isHidden = false
        tbl_viewPop.reloadData()
        //hei_tblConstraint.constant = CGFloat(50 * DPassengerModel.allPassengerArray.count) + 200
        
        reloadTableView()
    }
    func getPassengers() -> [Any]{
        
        // adding passenger information...
        var passenger_array: [[String: Any]] = []
//        var baggageId_array:[String?] = []
//        var mealsId_array:[String?] = []
//        var seatId_array:[String?] = []
        
        for model in DPassengerModel.allPassengerArray {
            print("model: \(model)")
//            if model.isSelected == true {
                
//                for i in 0 ..< model.seatsArray.count {
//                    
//                    let seatsId = model.seatsArray[i]["seatId"] as? String ?? ""
//                    
//                    if seatsId.isEmpty {
//                        seatId_array.append(nil)
//                    } else {
//                        seatId_array.append(seatsId)
//                    }
//                }
                
//                for j in 0 ..< model.baggageArray.count {
//                    
//                    let baggageId = model.baggageArray[j].baggageId
//                    if baggageId.isEmpty {
//                        baggageId_array.append(nil)
//                    } else {
//                        baggageId_array.append(baggageId)
//                    }
//                }
                
//                for k in 0 ..< model.mealsArray.count {
//                    
//                    let mealsId = model.mealsArray[k].mealId
//                    
//                    if mealsId.isEmpty {
//                        mealsId_array.append(nil)
//                    } else {
//                        mealsId_array.append(mealsId)
//                    }
//                }
                
                var passenger: [String: Any] = ["Gender": model.gender_value ?? "1",
                                                "lead_passenger": "0",
                                                "passenger_type": model.person_type,
                                                "Title": model.title_value ?? "1",
                                                "FirstName": model.first_name!,
                                                "LastName": model.last_name!,
                                                "DateOfBirth": model.dateOf_birth ?? "",
                                                "PassportNumber": model.passport_no ?? "",
                                                "PassportExpiry": model.passport_expiry ?? "",
                                                "PassportIssueCountry": model.issued_country ?? "91",
//                                                "seat": seatId_array,
//                                                "meal" : mealsId_array,
//                                                "baggage" : baggageId_array,
//                                                "selection": "1"
                ]
                
                //VKAPIs.getJSONString(object: seatId_array)]
                
                //            if model.isDBSLogin && DTravelModel.BookingType != "Self" {
                //                passenger["PassengerSelection"] = model.HRMSEmpId ?? ""
                //            }
                
//                if model.person_type == "Child" {
//                    passenger["PaxType"] = 2
//                    passenger["travellerType"] = "childrens"
//                }
//                
//                if model.person_type == "Infant" {
//                    passenger["PaxType"] = 3
//                    passenger["travellerType"] = "infants"
//                }
                passenger_array.append(passenger)
//            }
        }
        
        passenger_array[0]["lead_passenger"] = "1"
        print(passenger_array)
        return passenger_array
    }

}

extension FlightAddOnsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if addOnsType == .Baggage {
            return DPassengerModel.allPassengerArray[section].baggageArray.count
        } else if addOnsType == .Meals {
            return DPassengerModel.allPassengerArray[section].mealsArray.count
        } else {
            return DPassengerModel.allPassengerArray[section].seatsArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DPassengerModel.allPassengerArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DPassengerModel.allPassengerArray[section].title_form
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FlightAddOnsInfoCell") as? FlightAddOnsInfoCell
        if cell == nil {
            tableView.register(UINib(nibName: "FlightAddOnsInfoCell", bundle: nil), forCellReuseIdentifier: "FlightAddOnsInfoCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FlightAddOnsInfoCell") as? FlightAddOnsInfoCell
        }
        
        if addOnsType == .Baggage {
            let model = DPassengerModel.allPassengerArray[indexPath.section].baggageArray[indexPath.row]
            
            cell?.lbl_name.text = "\(model.origin) - \(model.destination) : \(String(model.weight))"
            cell?.lbl_price.text = String(format: "%.0f %@", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        }
        else if addOnsType == .Meals {
            
            let model = DPassengerModel.allPassengerArray[indexPath.section].mealsArray[indexPath.row]
            
            cell?.lbl_name.text = "\(model.origin) - \(model.destination) : \(model.descriptionText ?? "N/A")"
            cell?.lbl_price.text = String(format: "%.0f %@", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
        }
        else {
            
            let model = DPassengerModel.allPassengerArray[indexPath.section].seatsArray[indexPath.row]

            let nameStr = model["flightInfo"] as? String ?? ""
            let nameArr = nameStr.components(separatedBy: ",")
            var journeyStr = ""
            if nameArr.count >= 2 {
                
                let airlineCode = nameArr[0]
                journeyStr = "\(nameArr[nameArr.count - 2]) - \(nameArr[nameArr.count - 1])"
            }
            else {
                
                //default...
                journeyStr = ""
            }
            
            cell?.lbl_name.text = "\(journeyStr) : Seat \(model["SeatCode"] as? String ?? "")"
            cell?.lbl_price.text = String(format: "%.0f %@", (Float(model["seatPrice"] as? String ?? "0.0") ?? 0.0) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")
            
        }

        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }

}

extension FlightAddOnsVC {
    
    
    // MARK: - API's
    func getAppReference_FLIGHT() {
        
        //        DStorageModel.module = "flight"
        //        DStorageModel.app_reference = ""
        //        flightPreBooking_HTTPConnection()
        // currency api...
        //        SwiftLoader.show(animated: true)
        
        //        TMXClass.shared.getAppReference_HTTPConnection { [weak self] (message) in
        
        // success response
        //            if message == "Success" {
        //                self?.flightCommitBooking_HTTPConnection()
        //            }
        //            else {
        //                //                SwiftLoader.hide()
        //            }
        //            SwiftLoader.hide()
        
        //        }
    }
//    func flightCommitBooking_HTTPConnection()  {
//        
//        let user_id = ""
//        let newParams : [String: Any] = [
//            //            "AppReference": DStorageModel.app_reference,
//            "PromoCode": "" ?? "",
//            "booking_source": DFlightStopsModel.preBookingItem?.booking_source ?? "",//"PTBSID0000000020",
//            "BookingSource": "B2C",
//            "SequenceNumber": 0,
//            //            "ResultToken": DFlightStopsModel.preBookingItem?.result_token ?? "",//"c7967af95639b31fbb69d2fb8e3d23bf*_*19*_*Qds6fHHL5z9lgsza",
//            "Passengers": getPassengersList(),
//            "ticketing": "HOLD"
//        ]
//        
//        SwiftLoader.show(animated: true)
//        // calling apis...
//        VKAPIs.shared.getRequestFormdata(params: [:], file: FLIGHT_PreBooking, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Flight Pre Book success: \(String(describing: resultObj))")
//                
//                if let result = resultObj as? [String: Any] {
//                    if result["Status"] as? Bool == true {
//                        
//                        // response date...
//                        if let data_dict = result["PreBooking"] as? [String: Any] {
//                            
//                            // move to payment...
//                            //                            DFlightReviewModel.createFlightReviewModel(dataDict: data_dict)
//                            //                            self.moveToReviewPage()
//                            
//                        }
//                    } else {
//                        // error message...
//                        if let message_str = result["message"] as? String {
//                            //                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Flight Pre Book formate : \(String(describing: resultObj))")
//                }
//            } else {
//                print("Flight Pre Book error : \(String(describing: error?.localizedDescription))")
//            }
//            SwiftLoader.hide()
//        }
//        //                }
//    }
    
    func extractDateComponents(from dateString: String) -> (day: String, month: String, year: String)? {
        let components = dateString.components(separatedBy: "-")
        guard components.count == 3 else { return nil }
        
        let day = components[0]
        let month = components[1]
        let year = components[2]
        
        return (day, month, year)
    }
    func generateDataDictionary(for type: String) -> [String: [String?]] {
        var dataDictionary: [String: [String?]] = [:]
        
        for i in 0..<DFlightAddOnsModel.orderedSeatMapData.count {
            let key = "\(type)_\(i)"
            var dataForFlight: [String?] = []
            
            for passenger in DPassengerModel.allPassengerArray {
                switch type {
                case "meal":
                    if passenger.mealsArray.indices.contains(i) {
                        dataForFlight.append(passenger.mealsArray[i].descriptionText ?? "")
                    } else {
                        dataForFlight.append(nil) // or "" if you prefer
                    }

                case "baggage":
                    if passenger.baggageArray.indices.contains(i) {
                        let weight = passenger.baggageArray[i].weight
                        dataForFlight.append(weight)
                    } else {
                        dataForFlight.append(nil)
                    }

                case "seat":
                    if passenger.seatsArray.indices.contains(i) {
                        dataForFlight.append(passenger.seatsArray[i]["seatKey"] as? String ?? "")
                    } else {
                        dataForFlight.append(nil)
                    }

                default:
                    break
                }
                //                switch type {
//                case "meal":
//                    dataForFlight.append(passenger.mealsArray[i].descriptionText ?? "")
//
//                case "baggage":
//                    if passenger.baggageArray.indices.contains(i) {
//                        let weight = passenger.baggageArray[i].weight
//                        dataForFlight.append(weight)
//                    } else {
//                        dataForFlight.append(nil) // No baggage for this flight
//                    }
//                case "seat":
//                    dataForFlight.append(passenger.seatsArray[i]["seatKey"] as? String ?? "")
//                default:
//                    break
//                }
            }
            
            dataDictionary[key] = dataForFlight
        }
        
        return dataDictionary
    }
//    func generateMealDictionary() -> [String: [String]] {
//        var mealDictionary: [String: [String]] = [:]
//        
//        for i in 0..<DFlightAddOnsModel.orderedSeatMapData.count {
//            let flightKey = "meal_\(i)"
//            var meals: [String] = []
//            
//            // Adding meals for each adult
//            for passenger in DPassengerModel.allPassengerArray {
//                meals.append(passenger.mealsArray[i].descriptionText)
//            }
//            
//            mealDictionary[flightKey] = meals
//        }
//        
//        return mealDictionary
//    }
    // MARK: - Utilities
    func moveToReviewPage() {
        
        print(DFlightAddOnsModel.orderedSeatMapData.count)
        for i in 0..<DFlightAddOnsModel.orderedSeatMapData.count {
            print(i)
            
        }
        let mealDictionary = generateDataDictionary(for: "meal")
        let baggageDictionary = generateDataDictionary(for: "baggage")
        let seatDictionary = generateDataDictionary(for: "seat")

//        print("Meal Dictionary:", mealDictionary)
//        print("Baggage Dictionary:", baggageDictionary)
//        print("Seat Dictionary:", seatDictionary)


        let user_id = ""
        
        // params...
        var params:[String: Any] =
        [ "token_key": DFlightStopsModel.preBookingItem?.token_key!,// "bd34e11898f8ce4fc82a5fab60ddbf32",
          "Email": DPassengerModel.email_id,
          "ContactNo": DPassengerModel.mobile_no ?? "",//"9960077482",// DPassengerModel.mobile_no,//"7795889630",
          "AddressLine1":"E-city",
          "City":"banglore",
          "PinCode":"4456666",
          "CountryCode":"IN",
          "CountryName":"India",
          "search_id": Int(DFlightSearchModel.search_id) ?? 0,//"2510",
          "total_amount_val": String.init(format: "%.2f", FinalBreakupModel.totalFare),//"72.00",
          "currency": DCurrencyModel.currency_saved?.currency_country ?? "INR",
          "currency_symbol":  DCurrencyModel.currency_saved?.currency_symbol ?? "$",//"$"
          "convenience_fee": String.init(format: "%.2f", FinalBreakupModel.convenienceFare),//"0.00",
          "tax": String.init(format: "% .2f", FinalBreakupModel.gstFare),
          "promo_code_discount_val": String.init(format: "%.2f", FinalBreakupModel.discount),//"0.00",
          "promo_code": FinalBreakupModel.promoCode,
          "customer_id": user_id.getUserId(),//"1297",
          "payment_method" : "PNHB1",
          "Passengers":getPassengers(),
          "reward_discount_amt": String.init(format: "%.2f", FinalBreakupModel.rewardDiscount),
          "total_reward_amt": String.init(format: "%.2f", FinalBreakupModel.reward_total_fare),// "276.68",
          "total_used_points": String.init(format: "%.2f", FinalBreakupModel.total_used_points) ,//"10",
          "reward_promo_code": FinalBreakupModel.reward_promo_code,
          "stop_count" : Int(DFlightSearchModel.stop_count),
        ]
        for i in 0..<DFlightSearchModel.stop_count {
                // Meal Data
                let mealKey = "meal_\(i)"
                let mealData = DPassengerModel.allPassengerArray.compactMap { passenger in
                    (passenger.mealsArray.indices.contains(i) ? passenger.mealsArray[i].mealId : nil)
                }.compactMap { $0 }
                if !mealData.isEmpty {
                    params[mealKey] = mealData
                }
                
                // Baggage Data
                let baggageKey = "baggage_\(i)"
                let baggageData = DPassengerModel.allPassengerArray.compactMap { passenger in
                    (passenger.baggageArray.indices.contains(i) ? passenger.baggageArray[i].baggageId : nil)
                }
                if !baggageData.isEmpty {
                    params[baggageKey] = baggageData
                }
                
                // Seat Data
                let seatKey = "seat_\(i)"
                let seatData = DPassengerModel.allPassengerArray.compactMap { passenger in
                    if passenger.seatsArray.indices.contains(i),
                       let seatInfo = passenger.seatsArray[i] as? [String: Any],
                       let seatKey = seatInfo["seatId"] as? String {
                        return seatKey
                    }
                    return nil
                }
                if !seatData.isEmpty {
                    params[seatKey] = seatData
                }
            }
        if gstSelected {
            params["gst_number"] = FinalBreakupModel.gstDetails.gst_address
            params["gst_company_name"] = FinalBreakupModel.gstDetails.gst_company_name
            params["gst_email"] = FinalBreakupModel.gstDetails.gst_email
            params["gst_phone"] = FinalBreakupModel.gstDetails.gst_phone
            params["gst_address"] = FinalBreakupModel.gstDetails.gst_address
            params["gst_state"] = FinalBreakupModel.gstDetails.gst_state
        }
        
        let param_tokens:[String: Any] = ["flight_token_table_id": DFlightStopsModel.preBookingItem?.flight_token_table_id ?? ""]
        
        //var paramString:[String: String] = [:]
        
        paramString["token"] = VKAPIs.getJSONString(object: param_tokens)
        paramString["flight_book"] = VKAPIs.getJSONString(object: params)
        paramString["search_ssr_hash"] =  DFlightStopsModel.preBookingItem?.search_hash ?? ""
        paramString["wallet_bal"] = VKAPIs.getJSONString(object: "off")
        paramString["booking_step"] = VKAPIs.getJSONString(object: "book")

        // move to next screen...
        let nextObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightReviewVC") as! FlightReviewVC
        nextObj.paramString = paramString
        self.navigationController?.pushViewController(nextObj, animated: true)
    }
    
//    func getPassengersList() -> [Any] {
//        
//        // adding passenger information...
//        var passenger_array: [[String: Any]] = []
//        var baggageId_array:[String?] = []
//        var mealsId_array:[String?] = []
//        var seatId_array:[String?] = []
//        
//        for model in DPassengerModel.allPassengerArray {
//            if model.isSelected == true {
//                
//                for i in 0 ..< model.seatsArray.count {
//                    print(model.seatsArray[i])
//                    let seatsId = model.seatsArray[i]["seatId"] as? String ?? ""
//                    
//                    if seatsId.isEmpty {
//                        seatId_array.append(nil)
//                    } else {
//                        seatId_array.append(seatsId)
//                    }
//                }
//                
//                for j in 0 ..< model.baggageArray.count {
//                    
//                    let baggageId = model.baggageArray[j].baggageId
//                    if baggageId.isEmpty {
//                        baggageId_array.append(nil)
//                    } else {
//                        baggageId_array.append(baggageId)
//                    }
//                }
//                
//                for k in 0 ..< model.mealsArray.count {
//                    print(model.mealsArray[k])
//                    let mealsId = model.mealsArray[k].mealId
//                    
//                    if mealsId.isEmpty {
//                        mealsId_array.append(nil)
//                    } else {
//                        mealsId_array.append(mealsId)
//                    }
//                }
//                
//                var passenger: [String: Any] = [
//                    "IsLeadPax": 0,
//                    "Title": model.title_name,
//                    "FirstName": model.first_name!,
//                    //                    "MiddleName": model.middle_name ?? "",
//                    "LastName": model.last_name ?? "",
//                    "PaxType": 1,
//                    "Gender": Int(model.gender_value ?? "0") ?? 1,
//                    "DateOfBirth": model.dateOf_birth ?? "",
//                    "PassportNumber": model.passport_no ?? "",
//                    "PassportExpiryDate": model.passport_expiry ?? "",
//                    "PassportIssuingCountry": model.issued_country_code,
//                    "Nationality": model.issued_country_code,
//                    "CountryCode": "NG",
//                    "CountryName": "NG",
//                    //                    "ContactNo": model.phone_number ?? "",
//                    //                    "PhoneAreaCode": model.phone_code ?? "",
//                    "PhoneExtensionCode": "",
//                    "City": "Bangalore",
//                    "PinCode": "560100",
//                    "AddressLine1": "Bangalore",
//                    "AddressLine2": "",
//                    "Email": model.email_id ?? "",
//                    "travellerType": "adults",
//                    "travellerTypeCount": 1,
//                    "BaggageId": baggageId_array, //VKAPIs.getJSONString(object: baggageId_array)
//                    "Baggage": "",
//                    "MealId": mealsId_array, // New-"mealid" VKAPIs.getJSONString(object: mealsId_array)
//                    "Meal": "",
//                    "SeatId": seatId_array,
//                    "PassengerSelection": "",
//                    "SelectedBaggage": "",
//                    "SelectedBaggageSector": 0,
//                    "SelectedBaggagePassengerIndex": 0,
//                    "SelectedMeal": "",
//                    "SelectedMealSector": 0,
//                    "SelectedMealPassengerIndex": 0,
//                    "SelectedSeats": "",
//                    "SelectedSelectorId": 0,
//                    //                    "PhoneCode": model.phone_code ?? "",
//                    "PassportExpiry": model.passport_expiry ?? "",
//                ] //VKAPIs.getJSONString(object: seatId_array)]
//                
//                //            if model.isDBSLogin && DTravelModel.BookingType != "Self" {
//                //                passenger["PassengerSelection"] = model.HRMSEmpId ?? ""
//                //            }
//                
//                if model.person_type == "Child" {
//                    passenger["PaxType"] = 2
//                    passenger["travellerType"] = "childrens"
//                }
//                
//                if model.person_type == "Infant" {
//                    passenger["PaxType"] = 3
//                    passenger["travellerType"] = "infants"
//                }
//                passenger_array.append(passenger)
//            }
//        }
//        
//        passenger_array[0]["IsLeadPax"] = 1
//        return passenger_array
//    }
    
    func setRandomPassportExpiryDateDomestic(passModel: DPassengerItem) -> String {
        
        var expiryDate = ""
        
        if true /*DTravelModel.isDomestic*/ { //DFlightSearchModel.is_domestic
            
            if (passModel.passport_expiry ?? "").isEmpty {
                
                //                let randomDate = DateFormatter.getRandomDatesBetween()
                //                expiryDate = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: randomDate)
            }
            else {
                expiryDate = passModel.passport_expiry ?? ""
                
            }
        } else {
            expiryDate = passModel.passport_expiry ?? ""
        }
        print("Pass Expiry Date: \(expiryDate)")
        return expiryDate
    }
    
    func setRandomDateOfBirthDomestic(passModel: DPassengerItem) -> String {
        
        var dateOfBirth = ""
        
        if true/*DTravelModel.isDomestic*/ {
            
            if (passModel.dateOf_birth ?? "").isEmpty {
                var randomDate = Date()
                if passModel.person_type == "Infant" {
                    //                    randomDate = DateFormatter.getRandomDatesBetween(yearsFrom: 0, yearsTo: -2)
                }
                else if passModel.person_type == "Child" {
                    //                    randomDate = DateFormatter.getRandomDatesBetween(yearsFrom: -2, yearsTo: -11)
                }
                else {
                    //                    randomDate = DateFormatter.getRandomDatesBetween(yearsFrom: -12, yearsTo: -100)
                }
                dateOfBirth = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: randomDate)
            }
            else {
                dateOfBirth = passModel.dateOf_birth ?? ""
                
            }
        } else {
            dateOfBirth = passModel.dateOf_birth ?? ""
        }
        print("Date Of Birth: \(dateOfBirth)")
        return dateOfBirth
        
    }
}




extension FlightAddOnsVC {
    func aplyPromo(){
            SwiftLoader.show(animated: true)
            
        var price: Float = 0.0
        price = ( FinalBreakupModel.seatsFare + FinalBreakupModel.mealsFare + FinalBreakupModel.baggageFare)
            let userId = ""
        let params: [String: Any] = ["promo_code":FinalBreakupModel.promoCode,"module":"flight","total_amount_val": price + FinalBreakupModel.totalFare ,"user_id": userId.getUserId(),"email": DPassengerModel.email_id ?? "","convenience_fee": FinalBreakupModel.convenienceFare,"currency":"INR","search_id": DFlightSearchModel.search_id ]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            // print(result["discount_value"] as! String)
                            
                            var value: Float = 0.0
                            value = Float(String.init(describing: result["discount_value"]!))!
//                            FinalBreakupModel.convenienceFare = Float(String.init(describing: result["convenience_fee"]!))!
                            FinalBreakupModel.convenienceFare = parseAmount(result["convenience_fee"])

                            FinalBreakupModel.discount = value
                            self.moveToReviewPage()
                        } else {
                            
                            // error message...
                            if let message_str = result["message"] as? String {
                                self.view.makeToast(message: message_str)
                            }
                        }
                    } else {
                        print("Promo code formate : \(String(describing: resultObj))")
                    }
                }
                SwiftLoader.hide()
                
            }
            
        }
    func updateConvenience(){
            SwiftLoader.show(animated: true)
            
        var price: Float = 0.0
        price = ( FinalBreakupModel.seatsFare + FinalBreakupModel.mealsFare + FinalBreakupModel.baggageFare)
            let userId = ""
//        {"module":"flight","total_amount_val":2950,"user_id":"2237","convenience_fee":266,"search_id":"797","currency":"INR"}
        let params: [String: Any] = ["module":"flight",
                                     "total_amount_val": (price + FinalBreakupModel.totalFare) - FinalBreakupModel.discount,
                                     "user_id": userId.getUserId(),
                                     "convenience_fee": FinalBreakupModel.convenienceFare,
                                     "currency":"INR",
                                     "search_id": DFlightSearchModel.search_id ]
            let paramString: [String: String] = ["get_convenience_fee": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestFormdata(params: paramString, file: "general/convenience_fee_mobile", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Convenience Fee success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            // print(result["discount_value"] as! String)
                            
//                            var value: Float = 0.0
//                            value = Float(String.init(describing: result["discount_value"]!))!
//                            FinalBreakupModel.convenienceFare = Float(String.init(describing: result["convenience_fee"]!))!
                            FinalBreakupModel.convenienceFare = parseAmount(result["convenience_fee"])

//                            FinalBreakupModel.discount = value
                            self.moveToReviewPage()
                        } else {
                            
                            // error message...
                            if let message_str = result["message"] as? String {
                                self.view.makeToast(message: message_str)
                            }
                        }
                    } else {
                        print("Convenience Fee invalid formate : \(String(describing: resultObj))")
                    }
                }
                SwiftLoader.hide()
                
            }
            
        }
    
}
