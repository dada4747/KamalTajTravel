//
//  DFlightAddOnsModel.swift
//  EzyAirline
//
//  Created by Rahul on 02/04/25.
//

import Foundation

struct DFlightAddOnsModel {
    
    // static info...
    static var is_domestic = true
    static var search_key = ""
    static var search_id = ""
    static var airline_imgUrl = ""
    static var temp_stops: Int = 0
    
    static var mealsMain_Dict: [String: [DFlightMealsItem]] = [:]
    static var baggageMain_Dict: [String: [DFlightBaggageItem]] = [:]
    
//    static var seatRootDict:[String: [String: Any]] = [:]
    
//    static var seats_keys_array: [String] = []
    static var meals_keys_array: [String] = []
    static var baggage_keys_array: [String] = []
    
//    static var seats_array: [DFlightSeatItem] = []
    static var meals_array: [DFlightMealsItem] = []
    static var baggage_array: [DFlightBaggageItem] = []
    static var seatLopaToken : String = ""
    static var returnSeatLopaToken: String = ""
    
    
    static var orderedSeatMapData: [[[Seat]]] = []

    
    init() {
    }
    
    // clear all search information...
    static func clearAll_SearchInformation() {
        
        // remove all array...
//        seats_array.removeAll()
        orderedSeatMapData.removeAll()
        
    }
    static func createFlightAddOnsMealModel(response_dict: [String: Any]) {
        meals_array.removeAll()
        meals_array.removeAll()
        baggage_array.removeAll()
        meals_keys_array.removeAll()
        mealsMain_Dict.removeAll()
        
        if let mealsArray = response_dict["Meals"] as?  [[Any]] {
            var mealsDictionary: [String: [[String: Any]]] = [:]
            for (index, mealSet) in mealsArray.enumerated() {
                var mealList: [[String: Any]] = []
                print("mealSet: \(mealSet)")
                for meal in mealSet {
                    print("meal\(meal)")
//                    print(meal["Origin"])
                    if let mealDict = meal as? [String: Any] {
                        mealList.append(mealDict)
                    }
                }
                
                let key = "meal\(index + 1)"
                print(mealList[index]["Origin"] ?? "Not found")
                mealsDictionary[key] = mealList
            }
            
            print("✅ Meals Dictionary: \(mealsDictionary)")

            let allKeys = Array(mealsDictionary.keys)
            print("allKeys: \(allKeys)")
            
            self.meals_keys_array = allKeys

            print("meals_keys_array: \(meals_keys_array)")
            
            for i in 0 ..< meals_keys_array.count {
                
                let key_string = meals_keys_array[i]
                
                if let meals_array = mealsDictionary[key_string] {
                    
                    self.meals_array.removeAll()
                    
                    for itemObj in meals_array {
                        
                        let models = DFlightMealsItem.init(details: itemObj)
                        self.meals_array.append(models)
                    }
                }
                
                self.mealsMain_Dict[key_string] = self.meals_array //static var mealsMain_Dict: [String: [DFlightMealsItem]] = [:]
                
            }
        }
                
        if let baggageArray = response_dict["Baggage"] as? [[Any]] {
            var baggageDictionary: [String: [[String: Any]]] = [:]

            for (index, baggageSet) in baggageArray.enumerated() {
                var baggageList: [[String: Any]] = []
                for baggage in baggageSet {
                    if let baggageDict = baggage as? [String: Any] {
                        baggageList.append(baggageDict)
                    }
                }
                let key = "baggage\(index + 1)"
                baggageDictionary[key] = baggageList
            }
            
            print("✅ Baggage Dictionary: \(baggageDictionary)")

            let allKeys = Array(baggageDictionary.keys)
            print("allKeys: \(allKeys)")
        
            
            self.baggage_keys_array = allKeys
            
            print("baggage_keys_array: \(baggage_keys_array)")
            
            for i in 0 ..< baggage_keys_array.count {
                
                let key_string = baggage_keys_array[i]
                
                if let loBaggage_array = baggageDictionary[key_string] {
                    
                    self.baggage_array.removeAll()
                    
                    for itemObj in loBaggage_array {
                        
                        let models = DFlightBaggageItem.init(details: itemObj)
                        self.baggage_array.append(models)
                    }
                }
                self.baggageMain_Dict[key_string] = self.baggage_array
            }
        }
    }
    static func clearFightAddOnsModel(){
        orderedSeatMapData.removeAll()
        meals_array.removeAll()
        meals_keys_array.removeAll()
        mealsMain_Dict.removeAll()
        baggage_array.removeAll()
        baggageMain_Dict = [:]
        baggage_keys_array.removeAll()
        mealsMain_Dict = [:]
    }
    
    static func createFightAddOnsModel(response_dict: [String: Any]) {
        orderedSeatMapData.removeAll()
        meals_array.removeAll()
        meals_keys_array.removeAll()
        mealsMain_Dict.removeAll()
        baggage_array.removeAll()

        if let baggageArray = response_dict["Baggage"] as? [[Any]] {
            var baggageDictionary: [String: [[String: Any]]] = [:]

            for (index, baggageSet) in baggageArray.enumerated() {
                var baggageList: [[String: Any]] = []
                for baggage in baggageSet {
                    if let baggageDict = baggage as? [String: Any] {
                        baggageList.append(baggageDict)
                    }
                }
//                let key = "baggage\(index + 1)"
//                let newKey = "\(baggageList[index]["Origin"] ?? "") → \(baggageList[index]["Destination"] ?? "")"//"\(baggageList[index])"
//                baggageDictionary[newKey] = baggageList
                if let first = baggageList.first {
                    let origin = first["Origin"] as? String ?? ""
                    let destination = first["Destination"] as? String ?? ""
                    
                    let newKey = "\(origin) → \(destination)"
                    baggageDictionary[newKey] = baggageList
                }
            }
            
            print("✅ Baggage Dictionary: \(baggageDictionary)")

            let allKeys = Array(baggageDictionary.keys)
            print("allKeys: \(allKeys)")
        
            
            self.baggage_keys_array = allKeys
            
            print("baggage_keys_array: \(baggage_keys_array)")
            
            for i in 0 ..< baggage_keys_array.count {
                
                let key_string = baggage_keys_array[i]
                
                if let loBaggage_array = baggageDictionary[key_string] {
                    
                    self.baggage_array.removeAll()
                    
                    for itemObj in loBaggage_array {
                        
                        let models = DFlightBaggageItem.init(details: itemObj)
                        self.baggage_array.append(models)
                    }
                }
                self.baggageMain_Dict[key_string] = self.baggage_array
            }
        }
        if let mealsArray = response_dict["Meals"] as?  [[Any]] {
            var mealsDictionary: [String: [[String: Any]]] = [:]
            for (index, mealSet) in mealsArray.enumerated() {
                var mealList: [[String: Any]] = []
                for meal in mealSet {
                    if let mealDict = meal as? [String: Any] {
                        mealList.append(mealDict)
                    }
                }
                if let firstMeal = mealList.first {
                    let origin = firstMeal[""]
                    let newKey = "\(firstMeal["Origin"] ?? "") → \(firstMeal["Destination"] ?? "")"
                    mealsDictionary[newKey] = mealList
                }
                //                let key = "meal\(index + 1)"
                //                let newKey = "\(mealList[index]["Origin"] ?? "") → \(mealList[index]["Destination"] ?? "")"
                //                mealsDictionary[newKey] = mealList
            }
            
            print("✅ Meals Dictionary: \(mealsDictionary)")
            
            let allKeys = Array(mealsDictionary.keys)
            print("allKeys: \(allKeys)")
            
            self.meals_keys_array = allKeys
            
            print("meals_keys_array: \(meals_keys_array)")
            
            for i in 0 ..< meals_keys_array.count {
                
                let key_string = meals_keys_array[i]
                
                if let meals_array = mealsDictionary[key_string] {
                    
                    self.meals_array.removeAll()
                    
                    for itemObj in meals_array {
                        
                        let models = DFlightMealsItem.init(details: itemObj)
                        self.meals_array.append(models)
                    }
                }
                
                self.mealsMain_Dict[key_string] = self.meals_array //static var mealsMain_Dict: [String: [DFlightMealsItem]] = [:]
                
            }
        }
        
    
        
        
        if let seatArray = response_dict["Seat"] as? [[[Any]]] {
         
            self.orderedSeatMapData = seatArray.map { flight in
                // Determine the max number of columns in this flight
                let maxColumns = flight.map { $0.count }.max() ?? 0
                
                return flight.map { row in
                    // Convert Any → Seat
                    let seatRow = row.compactMap { seatItem -> Seat in
                        if let seatDict = seatItem as? [String: Any] {
                            return Seat(from: seatDict)
                        } else {
                            return Seat.emptySeat() // fallback
                        }
                    }
                    
                    // Pad row to max columns
                    var paddedRow = seatRow
                    if paddedRow.count < maxColumns {
                        let diff = maxColumns - paddedRow.count
                        paddedRow.append(contentsOf: Array(repeating: Seat.emptySeat(), count: diff))
                    }
                    
                    // Insert aisle (empty seat) in the middle
                    let middleIndex = maxColumns / 2
                    paddedRow.insert(Seat.emptySeat(), at: middleIndex)
                    
                    return paddedRow
                }
            }
         }
     }
}

struct DFlightMealsItem  {
    var mealId: String = ""
    var origin: String = ""
    var destination: String = ""
    var price: Float = 0.0
    var descriptionText: String? = ""
    var code: String = ""
    var type: String = ""
    var journeyType: String = ""
    var isSelected = false


    init(details: [String: Any]) {
        if let mealId = details["MealId"] as? String {
            self.mealId = mealId
        }
        if let origin = details["Origin"] as? String {
            self.origin = origin
        }
        if let destination = details["Destination"] as? String {
            self.destination = destination
        }
        if let price = details["Price"] as? Double {
            self.price = Float(price)
            print(price)
        }
        if let descriptionText = details["Description"] as? String {
            self.descriptionText = descriptionText
        }
        if let code = details["Code"] as? String {
            self.code = code
        }
        if let type = details["Type"] as? String {
            self.type = type
        }
        if let journeyType = details["JourneyType"] as? String {
            self.journeyType = journeyType
        }
    }
}

struct DFlightBaggageItem {
    var baggageId: String = ""
    var origin: String = ""
    var destination: String = ""
    var price: Float = 0.0
    var weight: String = ""
    var code: String = ""
    var journeyType: String = ""
    var isSelected = false

    init(details: [String: Any]) {
        if let baggageId = details["BaggageId"] as? String {
            self.baggageId = baggageId
        }
        if let origin = details["Origin"] as? String {
            self.origin = origin
        }
        if let destination = details["Destination"] as? String {
            self.destination = destination
        }
        if let price = details["Price"] as? Double {
            self.price = Float(price)
        }
        if let weight = details["Weight"] as? String {
            self.weight = weight
        }
        if let code = details["Code"] as? String {
            self.code = code
        }
        if let journeyType = details["JourneyType"] as? String {
            self.journeyType = journeyType
        }
    }
}


//MARK: -  New model


// MARK: - SeatMapResponse
struct SeatMapResponse {
    var data: [String: FlightData] = [:]

    init(dictionary: [String: Any]) {
        if let dataDict = dictionary["data"] as? [String: Any] {
            for (key, value) in dataDict {
                if let flightDataDict = value as? [String: Any] {
                    data[key] = FlightData(dictionary: flightDataDict)
                }
            }
        }
    }
}

// MARK: - FlightData
struct FlightData {
    var status: Int = 0
    var message: String = ""
    var flightSeatLopa: FlightSeatLopa?

    init(dictionary: [String: Any]) {
        if let statusValue = dictionary["status"] as? Int {
            self.status = statusValue
        }
        if let messageValue = dictionary["message"] as? String {
            self.message = messageValue
        }
        if let flightSeatLopaDict = dictionary["FlightSeatLopa"] as? [String: Any] {
            self.flightSeatLopa = FlightSeatLopa(dictionary: flightSeatLopaDict)
        }
    }
}

// MARK: - FlightSeatLopa
struct FlightSeatLopa {
    var columns: String = ""
    var rows: String = ""
    var space: String = ""
    var seats: [String: FSeatDetails] = [:]
    var lopaToken: String = ""

    init(dictionary: [String: Any]) {
        if let columnsValue = dictionary["Coulmns"] as? String {
            self.columns = columnsValue
        }
        if let rowsValue = dictionary["Rows"] as? String {
            self.rows = rowsValue
        }
        if let spaceValue = dictionary["Space"] as? String {
            self.space = spaceValue
        }
        if let lopaTokenValue = dictionary["LopaToken"] as? String {
            self.lopaToken = lopaTokenValue
        }
        if let seatsDict = dictionary["Seats"] as? [String: Any] {
            for (key, value) in seatsDict {
                if let seatDetailsDict = value as? [String: Any] {
                    seats[key] = FSeatDetails(dictionary: seatDetailsDict)
                }
            }
        }
    }
}

// MARK: - SeatDetails
struct FSeatDetails {
    var flag: String = ""
    var seatPrice: Int = 0
    var emgFlag: String = ""

    init(dictionary: [String: Any]) {
        if let flagValue = dictionary["FLAG"] as? String {
            self.flag = flagValue
        }
        if let seatPriceValue = dictionary["SeatPrice"] as? Int {
            self.seatPrice = seatPriceValue
        }
        if let emgFlagValue = dictionary["EmgFlag"] as? String {
            self.emgFlag = emgFlagValue
        }
    }
}

// MARK: - SeatMapData
struct SeatMapData {
    var type: String = ""
    var seatDetails: FlightSeatLopa?

    init(type: String, seatDetails: FlightSeatLopa?) {
        self.type = type
        self.seatDetails = seatDetails
    }
}
struct FairMealModel {
    var origin: String
    var mealName: String
    var price: Float
    var currency: String

    init(dictionary: [String: Any]) {
        if let originValue = dictionary["origin"] as? String {
            self.origin = originValue
        } else {
            self.origin = ""
        }
        
        if let mealNameValue = dictionary["meal_name"] as? String {
            self.mealName = mealNameValue
        } else {
            self.mealName = ""
        }
        
        if let priceValue = dictionary["price"] as? String, let floatPrice = Float(priceValue) {
            self.price = floatPrice
        } else {
            self.price = 0.0
        }

        if let currencyValue = dictionary["currency"] as? String {
            self.currency = currencyValue
        } else {
            self.currency = ""
        }
    }
    
    
}
struct BaggageItem {
    var description: String? = ""
    var type: String? = ""
    var value: Int? = 0
    init(description: [String: Any]) {
        
        if let desc = description["description"] as? String {
            self.description = desc
        }
        if let typeValue = description["type"] as? String {
            self.type = typeValue
        }
        if let valueValue = description["value"] as? Int {
            self.value = valueValue
        }
        if let value = description["value"] as? String {
            self.value = Int(value)!
        }
    }
}
