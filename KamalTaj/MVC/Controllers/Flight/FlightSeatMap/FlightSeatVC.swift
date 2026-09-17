//
//  FlightSeatVC.swift
//  MTM
//
//  Created by Nandu on 19/07/23.
//

import UIKit

protocol seatsChildVCDelegate {
    
    func updateSeatsPriceInfo()
    func showSeatPricePopUp(tripIndex: Int)
}

class FlightSeatVC: UIViewController {
    
    @IBOutlet weak var coll_trips: UICollectionView!
    @IBOutlet weak var coll_seats: UICollectionView!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var btn_seats: UIButton!
    @IBOutlet weak var lbl_seatsCount: UILabel!
    @IBOutlet weak var lbl_seatsSelectedPrice: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    var delegate: seatsChildVCDelegate?

//    var seatMaps: [SeatMapData] = []
//    var selectedIndex = 0
    
    var currentSeatsGrid: [[FSeatDetails?]] = []
    
    var selectedSeatsDict: [String: Set<String>] = [:]
    
    
    
    var allFlights: [[[Seat]]] = []   // Full nested seat structure
    var selectedFlightIndex = 0       // Index for selected flight
    var selectedSeatsMap: [Int: Set<String>] = [:]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSeatMaps()
        
    }
    
    override func viewDidLayoutSubviews() {
        view_header.dropShadow()//dropShadow(color: UIColor.gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    func setupSeatMaps() {
        //        seatMaps = parseSeatMapJSON()
        allFlights = DFlightAddOnsModel.orderedSeatMapData
        print(allFlights.count)
//        updateSeatLayout(for: seatMaps[selectedIndex].seatDetails!, spaceIndex: Int(seatMaps[selectedIndex].seatDetails!.space) ?? 3)
        addDelegates()
        if allFlights.count > 0 {
            updateFlightSeatSelection()

        }else{

        }
        
                lbl_status.isHidden = true
                coll_seats.isHidden = false
                if allFlights.isEmpty {
                    lbl_status.isHidden = false
                    coll_seats.isHidden = true
                }

    }
    
    // MARK: - Helpers
    func addDelegates() {
        
        coll_trips.delegate = self
        coll_trips.dataSource = self
        
        // register...
        coll_seats.register(UINib.init(nibName: "FlightSeatsCVCell", bundle: nil), forCellWithReuseIdentifier: "FlightSeatsCVCell")
        
        coll_trips.register(UINib.init(nibName: "FlightTripCVCell", bundle: nil), forCellWithReuseIdentifier: "FlightTripCVCell")
        let seatLayout = UICollectionViewFlowLayout()
        seatLayout.scrollDirection = .vertical
        seatLayout.minimumLineSpacing = 10
        seatLayout.minimumInteritemSpacing = 10
        coll_seats.collectionViewLayout = seatLayout
        
        if allFlights.count != 0 {
            
            // delegate...
            coll_seats.delegate = self
            coll_seats.dataSource = self
            
            for _ in 0 ..< allFlights.count {
                
                let seatDict: [String: Any] = [:]
                
                for j in 0 ..< DPassengerModel.allPassengerArray.count {
                    
                    var model  = DPassengerModel.allPassengerArray[j]
                    model.seatsArray.append(seatDict)
                    DPassengerModel.allPassengerArray[j] = model
                }
            }
            
            print("Seat Info : \(DPassengerModel.allPassengerArray)")
            
            loadSeatsSegments()
        }
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seatsInfoBtnClicked(_ sender: UIButton) {
        let currentTripKey = allFlights[selectedFlightIndex]  // Ensure this matches your key type
        guard selectedFlightIndex < allFlights.count else {
            self.view.makeToast(message: "No Seats Available")

            return }

//        if selectedSeatsDict[currentTripKey]?.isEmpty ?? true {
//            self.view.makeToast(message: "No Seats Available")
//            return
//        }
        
        delegate?.showSeatPricePopUp(tripIndex: selectedFlightIndex)
    }
}

extension FlightSeatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coll_seats {
            let seat = allFlights[selectedFlightIndex][indexPath.section][indexPath.item]
            
            if seat.isPlaceholder {
                return CGSize(width: 20, height: 50) // smaller width for aisle space
            } else {
                let totalWidth = collectionView.frame.width - 60
                print(allFlights[selectedFlightIndex][indexPath.section].count)
                let itemWidth = (Float(totalWidth) / Float(allFlights[selectedFlightIndex][indexPath.section].count))
                return CGSize(width: Int(itemWidth), height: 50)
            }
        }else{
            //            return CGSize(width: 120 , height: 32)
            let model = allFlights[indexPath.item].first?.first
            
            let title = "\(model?.origin ?? "") - \(model?.destination ?? "") (\(model?.airlineCode ?? ""), \(model?.flightNumber ?? ""))"
            // Calculate Width based on Text
            let estimatedWidth = title.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)!]).width + 70 // Adding Padding
            
            // Set a minimum and maximum width
            let minWidth: CGFloat = 50
            let maxWidth: CGFloat = collectionView.frame.width - 50
            return CGSize(width: min(max(estimatedWidth, minWidth), maxWidth), height: 32)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == coll_trips {
            return allFlights.count
        } else {
            //            let columns = Array(seatMaps[selectedIndex].seatDetails!.columns).map { String($0) }
            //            return columns.count + (Int(seatMaps[selectedIndex].seatDetails!.space) != nil && Int(seatMaps[selectedIndex].seatDetails!.space)! < columns.count ? 1 : 0)
            let row = allFlights[selectedFlightIndex][section]
            return row.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == coll_trips {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightTripCVCell", for: indexPath as IndexPath) as! FlightTripCVCell
            
            //display information...
            let model = allFlights[indexPath.item].first?.first
            cell.lbl_cityCode.text = "\(model?.origin ?? "") → \(model?.destination ?? "") (\(model?.airlineCode ?? ""), \(model?.flightNumber ?? ""))"
            let title = "\(model?.origin ?? "") → \(model?.destination ?? "") (\(model?.airlineCode ?? ""), \(model?.flightNumber ?? ""))"
            cell.configure(with: title, isSelected: selectedFlightIndex == indexPath.row)
            cell.img_airline.sd_setImage(with: URL.init(string: String(format: "%@%@/%@.gif", Base_Image_URL,DFlightSearchModel.airline_imgUrl, model!.airlineCode)))
            return cell
            
        } else {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightSeatsCVCell", for: indexPath as IndexPath) as! FlightSeatsCVCell
            
            let actualIndex = indexPath.item
            cell.isHidden = false
            let seat = allFlights[selectedFlightIndex][indexPath.section][indexPath.item]
            let seatId = seat.seatNumber
            let isSelected = selectedSeatsMap[selectedFlightIndex]?.contains(seatId) ?? false
            if selectedSeatsMap[selectedFlightIndex]?.contains(seat.seatNumber) == true {
                cell.configureWith(seat: seat, isSelected: true)
            } else {
                cell.configureWith(seat: seat, isSelected: false)
            }
            return cell
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == coll_seats {
            guard selectedFlightIndex >= 0 && selectedFlightIndex < allFlights.count else {
                return 0
            }
            return allFlights[selectedFlightIndex].count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == coll_trips {
            //            selectedIndex = indexPath.row
            collectionView.reloadData()
            //            updateSeatLayout(for: seatMaps[selectedIndex].seatDetails!, spaceIndex: Int(seatMaps[selectedIndex].seatDetails!.space) ?? 3)
            selectedFlightIndex = indexPath.row
            coll_trips.reloadData()
            loadSeatsSegments()
            updateFlightSeatSelection()
        } else {
            // Step 1: Get seat
            var seat = allFlights[selectedFlightIndex][indexPath.section][indexPath.item]
            let flightModel = allFlights[selectedFlightIndex].first?.first
            let title = "\(flightModel?.origin ?? "") → \(flightModel?.destination ?? "") (\(flightModel?.airlineCode ?? ""), \(flightModel?.flightNumber ?? ""))"
            
            // Step 2: Validate availability
            guard seat.availablityType == 1 else {
                // Seat not selectable
                return
            }
            
            // Step 3: Prepare selectedSeatsMap for current flight
            if selectedSeatsMap[selectedFlightIndex] == nil {
                selectedSeatsMap[selectedFlightIndex] = []
            }
            
            let seatKey = seat.seatNumber // Or use "\(seat.rowNumber)\(seat.columnLetter)"
            
            var selectedSeats = selectedSeatsMap[selectedFlightIndex] ?? []
//            let maxSelectableSeats = DPassengerModel.allPassengerArray.count
            let maxSelectableSeats = DPassengerModel.allPassengerArray.filter {
                !$0.isInfant
            }.count
            // Step 4: Deselect seat
            if selectedSeats.contains(seatKey) {
                selectedSeatsMap[selectedFlightIndex]?.remove(seatKey)
                
                // Clear from passenger model
//                for i in 0..<DPassengerModel.allPassengerArray.count {
                for i in 0..<DPassengerModel.allPassengerArray.count {

                    if DPassengerModel.allPassengerArray[i].isInfant {
                        continue
                    }
                    var model = DPassengerModel.allPassengerArray[i]
                    if model.seatsArray.count > selectedFlightIndex,
                       let existing = model.seatsArray[selectedFlightIndex]["seatKey"] as? String,
                       existing == seatKey {
                        model.seatsArray[selectedFlightIndex] = [:]
                        DPassengerModel.allPassengerArray[i] = model
                    }
                }
            } else {
                // Step 5: Select seat
                if selectedSeats.count < maxSelectableSeats {
                    selectedSeatsMap[selectedFlightIndex]?.insert(seatKey)
                    
                    // Assign seat to first unassigned passenger for this flight
//                    for i in 0..<DPassengerModel.allPassengerArray.count {
                    for i in 0..<DPassengerModel.allPassengerArray.count {

                        if DPassengerModel.allPassengerArray[i].isInfant {
                            continue
                        }
                        var model = DPassengerModel.allPassengerArray[i]
                        if model.seatsArray.count <= selectedFlightIndex {
                            // If array not big enough, append empty dicts
                            for _ in model.seatsArray.count...selectedFlightIndex {
                                model.seatsArray.append([:])
                            }
                        }
                        if model.seatsArray[selectedFlightIndex].isEmpty {
                            model.seatsArray[selectedFlightIndex] = [
                                "SeatCode": seatKey,
                                "seatKey": seatKey,
                                "seatPrice": "\(Float(seat.price))",
                                "seatId": seat.seatId,
                                "flightInfo": title
                            ]
                            DPassengerModel.allPassengerArray[i] = model
                            break
                        }
                    }
                } else {
                    self.view.makeToast(message: "🚨 Cannot select more than \(maxSelectableSeats) seats!")
                }
            }
            
            // Step 6: Refresh UI
            
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [indexPath])
            }
            DispatchQueue.main.async {
                self.updateFlightSeatSelection()
            }
        }
    }

    
    func updateFlightSeatSelection() {
        var seats_price: Float = 0.0
        var count = 0
        var seatsStr = ""
        var tempSeatArr: [[String: Any]] = []
        
        for i in 0 ..< DPassengerModel.allPassengerArray.count {
            let model = DPassengerModel.allPassengerArray[i]
            tempSeatArr.append(model.seatsArray[selectedFlightIndex])
        }
        
        print(tempSeatArr)
        
        for i in 0 ..< tempSeatArr.count {
            let model = tempSeatArr[i]
            
            if let seatCode = model["SeatCode"] as? String, !seatCode.isEmpty {
                seatsStr += (i == 0) ? seatCode : ",\(seatCode)"
            }
            
            let seatChargeStr = model["seatPrice"] as? String ?? "0"
            let result = seatChargeStr.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
            
            if let seatCharge = Float(result) {
                seats_price += seatCharge
            }
            
            if let _ = model["seatKey"] as? String {
                count += 1
            }
        }
        
        btn_seats.setTitle("Seats \(seatsStr)", for: .normal)
//        lbl_seatsCount.text = "\(count) of \(DPassengerModel.allPassengerArray.count) Seat(s) Selected"
        let totalSeatsAllowed = DPassengerModel.allPassengerArray.filter {
            !$0.isInfant
        }.count

        lbl_seatsCount.text = "\(count) of \(totalSeatsAllowed) Seat(s) Selected"
        lbl_seatsSelectedPrice.text = String(format: "%.0f %@", (seats_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD")//baggage_price String(format: "INR%.0f", seats_price)
        
        FinalBreakupModel.seatsFare = seats_price
        delegate?.updateSeatsPriceInfo()
    }
    
    func loadSeatsSegments() {
        
        //        // if seat data empty...
        //        let seatDict = allFlights[selectedFlightIndex].type
        //        //        let seatDict = DFlightAddOnsModel.seatRootDict[selectedRouteKey] ?? [:]
        //        lbl_status.isHidden = true
        //        coll_seats.isHidden = false
        //        if seatDict.isEmpty {
        //            lbl_status.isHidden = false
        //            coll_seats.isHidden = true
        //        }
        //
        //        for i in 0 ..< DPassengerModel.allPassengerArray.count {
        //            //            let currentTrip = selectedRouteKey // Assuming this is your trip identifier
        //            let currentTrip = allFlights[selectedFlightIndex]  // Identify current trip
        //
        //            let seatDict = DPassengerModel.allPassengerArray[i].seatsArray[selectedFlightIndex] // Extract seat dictionary
        //
        //            if !seatDict.isEmpty {
        //                // Extract seat details (row and column)
        //                if let row = seatDict["row"] as? Int, let column = seatDict["column"] as? String {
        //                    let seatKey = "\(row)\(column)"  // Example: "12A"
        //
        //                    if selectedSeatsDict[currentTrip] == nil {
        //                        selectedSeatsDict[currentTrip] = Set<String>()
        //                    }
        //                    selectedSeatsDict[currentTrip]?.insert(seatKey) // Add to the selected seats dictionary
        //                }
        //            }
        //        }
        
        guard selectedFlightIndex < allFlights.count else { return }
        
        let currentFlightSeats = allFlights[selectedFlightIndex]  // [[Seat]]
        
        // Hide or show seat view based on availability
        lbl_status.isHidden = !currentFlightSeats.isEmpty
        coll_seats.isHidden = currentFlightSeats.isEmpty
        
        // Fetch current trip key from first seat (e.g., flight number)
        guard let firstRow = currentFlightSeats.first,
              let firstSeat = firstRow.first else { return }
        
        let flightKey = firstSeat.flightNumber  // Or construct a custom key like "\(Origin)-\(Destination)-\(FlightNumber)"
        
        // Initialize or reset selected seats for this flight
        selectedSeatsDict[flightKey] = Set<String>()
        
        // Loop through all passengers and collect selected seats
        for passenger in DPassengerModel.allPassengerArray {
            let seatDict = passenger.seatsArray[selectedFlightIndex]  // ["row": 12, "column": "A"]
            
            if let row = seatDict["row"] as? Int,
               let column = seatDict["column"] as? String {
                let seatKey = "\(row)\(column)"  // e.g., "12A"
                selectedSeatsDict[flightKey]?.insert(seatKey)
                print(selectedSeatsDict)
            }
        }
        coll_seats.reloadData()
        
    }

//    func updateSeatLayout(for seatData: FlightSeatLopa, spaceIndex: Int) {
//        let columns = Int(seatData.columns) ?? 6
//        let rows = Int(seatData.rows) ?? 30
//        var seatGrid: [[FSeatDetails?]] = Array(repeating: Array(repeating: nil, count: columns), count: rows)
//        
//        // Populate seats in the grid while inserting empty spaces at spaceIndex
//        for (key, seat) in seatData.seats {
//            if let row = key.first?.asciiValue, let col = key.last?.wholeNumberValue {
//                let rowIndex = Int(row) - 65 // Convert 'A' -> 0, 'B' -> 1, etc.
//                let colIndex = col - 1
//                if colIndex == spaceIndex { continue } // Skip adding a seat in space column
//                seatGrid[rowIndex][colIndex] = seat
//            }
//        }
//        
//        self.currentSeatsGrid = seatGrid
//        coll_seats.reloadData()
//    }
}
 
//MARK: -
struct Seat {
    let airlineCode: String
    let flightNumber: String
    let origin: String
    let destination: String
    var availablityType: Int = -1
    let rowNumber: Int
    let price: Double
    let seatNumber: String
    let seatId: String
    let journeyType: String

    init(from dict: [String: Any]) {
        if let value = dict["AirlineCode"] as? String {
            airlineCode = value
        } else {
            airlineCode = ""
        }

        if let value = dict["FlightNumber"] as? String {
            flightNumber = value
        } else {
            flightNumber = ""
        }

        if let value = dict["Origin"] as? String {
            origin = value
        } else {
            origin = ""
        }

        if let value = dict["Destination"] as? String {
            destination = value
        } else {
            destination = ""
        }

        if let value = dict["AvailablityType"] as? Int {
            availablityType = value
        } else {
            availablityType = -1
        }

        if let value = dict["RowNumber"] as? Int {
            rowNumber = value
        } else {
            rowNumber = 0
        }

        if let value = dict["Price"] as? Double {
            price = value
        } else if let priceString = dict["Price"] as? String, let doubleVal = Double(priceString) {
            price = doubleVal
        } else {
            price = 0.0
        }

        if let value = dict["SeatNumber"] as? String {
            seatNumber = value
        } else {
            seatNumber = ""
        }

        if let value = dict["SeatId"] as? String {
            seatId = value
        } else {
            seatId = ""
        }

        if let value = dict["JourneyType"] as? String {
            journeyType = value
        } else {
            journeyType = ""
        }
    }
}

extension Seat {
    static func emptySeat() -> Seat {
        return Seat(from: [
            "AirlineCode": "",
            "FlightNumber": "",
            "Origin": "",
            "Destination": "",
            "AvailablityType": -1, // use -1 for identifying empty
            "RowNumber": 0,
            "Price": 0.0,
            "SeatNumber": "",
            "SeatId": "",
            "JourneyType": ""
        ])
    }

    var isPlaceholder: Bool {
        return availablityType == -1
    }
}
