//
//  DBusSeatModel.swift
//  MTM
//
//  Created by Nandu on 31/01/25.
//

import Foundation

struct DBusSeatModel {
    
    static var lowerDeckArray : [SeatDetails] = []
    static var upperDeckArray : [SeatDetails] = []
    static var pickupPointArray: [DPickupDropItem] = []
    static var dropPointArray: [DPickupDropItem] = []
    static var token : String = ""
    static var maxRows = 0
    static var maxColumns = 0
    
    static var maxRowsU = 0
    static var maxColumnsU = 0
    
    static func clearAllBusSeatModels() {
        
        lowerDeckArray.removeAll()
        upperDeckArray.removeAll()
        pickupPointArray.removeAll()
        dropPointArray.removeAll()
    }
    
    static func createBusSeatModels(result_dict: [String: Any]) {
        if let token = result_dict["token"] as? String {
            self.token = token
        }
        if let seatLayout = result_dict["details"] as? [String: Any] {
            
            // bus seats...
            if let seats = seatLayout["Seats"] as? [[String: Any]] {
                for seat in seats {
                    let item = SeatDetails.init(details: seat)
                    if item.isUpper == true {
                        self.upperDeckArray.append(item)
                    } else {
                        self.lowerDeckArray.append(item)
                    }
                }
            }
            // pickup point...
            if let pickup_point = seatLayout["Pickups"] as? [[String: Any]] {
                for point in pickup_point {
                    let item = DPickupDropItem.init(details: point, type: .pickup)
                    self.pickupPointArray.append(item)
                }
            }
            
            // drop point...
            if let drop_point = seatLayout["Dropoffs"] as? [[String: Any]] {
                for point in drop_point {
                    let item = DPickupDropItem.init(details: point, type: .dropoff)
                    self.dropPointArray.append(item)
                }
            }
        }
        
        // lower deck
        maxRows = getNumberOfColumns(busArray: lowerDeckArray)
        maxColumns  = getNumberOfRows(busArray: lowerDeckArray)
        
        // upper deck
        maxRowsU = getNumberOfColumns(busArray: upperDeckArray)
        maxColumnsU = getNumberOfRows(busArray: upperDeckArray)
        
        
//        // pickup point...
//        if let pickup_point = result_dict["boardingTimes"] as? [[String: Any]] {
//            for point in pickup_point {
//                let item = DPickupDropItem.init(details: point)
//                self.pickupPointArray.append(item)
//            }
//        }
//        
//        // drop point...
//        if let drop_point = result_dict["droppingTimes"] as? [[String: Any]] {
//            for point in drop_point {
//                let item = DPickupDropItem.init(details: point)
//                self.dropPointArray.append(item)
//            }
//        }
    }
    
    static func getNumberOfColumns(busArray: [SeatDetails]) -> Int {
        
        let sortedArray = busArray.sorted { item1, item2 in
            (item1.columnNo ?? 0) < (item2.columnNo ?? 0)
        }
        
        if sortedArray.count > 0 {
            let nocoloumns = sortedArray.last?.columnNo ?? 0
            return nocoloumns + 1
        }
        
        return 0
    }
    
    static func getNumberOfRows(busArray: [SeatDetails]) -> Int {
        
        let sortedArray = busArray.sorted { item1, item2 in
            (item1.rowNo ?? 0) < (item2.rowNo ?? 0)
        }
        
        if sortedArray.count > 0 {
            let rows = sortedArray.last?.rowNo ?? 0
            return rows + 1
        }
        
        return 0
    }
    
    static func getSeatDetails(rowId: Int, columnId: Int) -> SeatDetails? {
        
        let seat = lowerDeckArray.filter { item in
            item.columnNo == rowId && item.rowNo == DBusSeatModel.maxColumns - columnId - 1
        }.first
        
        return seat
    }
    
    static func getUpperSeatDetails(rowId: Int, columnId: Int) -> SeatDetails? {
        
        let seat = upperDeckArray.filter { item in
            item.columnNo == rowId && item.rowNo == DBusSeatModel.maxColumnsU - columnId - 1
        }.first
        
        return seat
    }
    
    static func validUpperRowIndexes() -> [Int] {
        
        var rows: [Int] = []
        
        for row in 0..<maxRowsU {
            for column in 0..<maxColumnsU {
                if getUpperSeatDetails(rowId: row, columnId: column) != nil {
                    rows.append(row)
                    break
                }
            }
        }
        
        return rows
    }
    
    static func validLowerRowIndexes() -> [Int] {
        
        var rows: [Int] = []
        
        for row in 0..<maxRows {
            for column in 0..<maxColumns {
                if getSeatDetails(rowId: row, columnId: column) != nil {
                    rows.append(row)
                    break
                }
            }
        }
        
        return rows
    }
}

// MARK: - SeatDetails
struct SeatDetails {
    var  columnNo: Int?
    var  height: Int = 0
    var  isLadiesSeat : Bool = false
    var  isMalesSeat : Bool = false
    var  isUpper: Bool = false
    var  rowNo: Int?
    var  seatFare: Float = 0.0
    var  seatIndex: Int = 0
    var  seatName: String = ""
    var  seatStatus: Bool = false
    var  seatType : Int = 0
    var  width: Int = 0
    var apiFare : Float = 0.0
//    var  price: Price?
    var isAvailable: Bool = false
    
    init(details:[String : Any]) {
        
        if let columnNo = details["Column"] as? String {
            self.columnNo = Int(columnNo)
        }
        
        if let height = details["Height"] as? String {
            self.height = Int(height) ?? 0
        }
        
        if let isLadiesSeat = details["IsLadiesSeat"] as? String {
           if isLadiesSeat == "false" {
                self.isLadiesSeat = false//na
            }else{
                self.isLadiesSeat = true//na
            }
        }
        
        if let isMalesSeat = details["isMalesSeat"] as? String {
            if isMalesSeat == "false" {
                self.isMalesSeat = false

            }else{
                self.isMalesSeat = true
            }

        }
        
//        if let isUpper = details["Deck"] as? Bool{
//            "Deck": "Upper"
//            self.isUpper = isUpper//na
//        }
        if let deck = details["Deck"] as? String{
            if deck == "Upper" {
                self.isUpper = true
            }else {
                self.isUpper = false
            }
        }
        
        if let rowNo = details["Row"] as? String{
            self.rowNo = Int(rowNo)
        }
        
        if let seatFare = details["Fare"] as? Double{
            self.seatFare = Float(seatFare)
        }
        
        if let seatIndex = details["SeatIndex"] as? Int{
            self.seatIndex = seatIndex
        }
        
        if let seatName = details["SeatNo"] as? String{
            self.seatName = seatName//na
        }
        if let apiFare = details["apiFare"] as? String {
            self.apiFare = Float(apiFare) ?? 0
        }
        if let APIFare = details["APIFare"] as? Double {
                   self.apiFare = Float(APIFare)
        }
//        if let seatStatus = details["SeatStatus"] as? Bool{
//            self.seatStatus = seatStatus
//        }
        
        if let seatType = details["SeatType"] as? String {
            self.seatType = Int(seatType) ?? 0
        }
        if let availabel = details["IsAvailable"] as? String{
           if  availabel == "false" {
                self.isAvailable = false
            }else {
                self.isAvailable = true
            }
        }
        if let width = details["Width"] as? String{
            self.width = Int(width) ?? 0
        }
    }
}
struct DPickupDropItem {
    
    var address: String
    var contact: String
    var landmark: String
    var area: String
    var code: String
    var name: String
    var time: String
    var type: PointType
    
    enum PointType {
        case pickup
        case dropoff
    }
    
    init(details: [String: Any], type: PointType) {
        
        self.address = details["Address"] as? String ?? ""
        self.contact = details["Contact"] as? String ?? ""
        self.landmark = details["Landmark"] as? String ?? ""
        self.type = type
        
        switch type {
        case .pickup:
            self.area = details["PickupArea"] as? String ?? ""
            self.code = "\(details["PickupCode"] ?? "")"
            self.name = details["PickupName"] as? String ?? ""
            self.time = details["PickupTime"] as? String ?? ""
            
        case .dropoff:
            self.area = details["DropArea"] as? String ?? ""
            self.code = "\(details["DropoffCode"] ?? "")"
            self.name = details["DropoffName"] as? String ?? ""
            self.time = details["DropoffTime"] as? String ?? ""
        }
    }
}
