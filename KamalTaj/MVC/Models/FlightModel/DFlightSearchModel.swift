//
//  DFlightSearchModel.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

// MARK: - DFlightSearchModel
struct DFlightSearchModel {
    
    // static info...
    static var is_domestic = true
    static var search_key = ""
    static var airline_imgUrl = ""
    static var search_id = ""
    static var booking_source = ""
    static var stop_count: Int = 0
    
    static var flightsDepart_array: [DFlightSearchItem] = []
    static var flightsReturn_array: [DFlightSearchItem] = []
    static var flightMulti_array: [DFlightSearchMultiItem] = []
    
    static var flightDetailsDict: [String: Any] = [:]
    static var flightDetailsReturnDict : [String: Any] = [:]
    
    init() {
    }
    
    // clear all search information...
    static func clearAll_SearchInformation() {
        
        // repaly key and domestic...
        is_domestic = true
        search_key = ""
        
        // remove all array...
        flightsDepart_array.removeAll()
        flightsReturn_array.removeAll()
        flightMulti_array.removeAll()
        
        flightDetailsDict.removeAll()
        flightDetailsReturnDict.removeAll()
        
        // clear passenger break up..
        PassengerBreakupModel.total_baseFare = 0.0
        PassengerBreakupModel.total_taxFare = 0.0
        PassengerBreakupModel.passengerFare_array.removeAll()
        
        // clear final break up...
        FareBreakupModel.totalFare = 0.0
        FareBreakupModel.totalTax = 0.0
        FareBreakupModel.currency = "USD"
    }
    
    // functions...
    static func createModels(result_dict: [String: Any]) {
        
        // flight type...
        self.is_domestic = true
        if result_dict["IsDomestic"] as? Bool == false {
            self.is_domestic = false
        }
        
        if let searchID = result_dict["search_id"] as? Int {
            self.search_id = "\(searchID)"
        }
        
        if let bookingSource = result_dict["booking_source"] as? String {
            self.booking_source = bookingSource
        }
        // airline img_url....
        if let img_url = result_dict["airline_img_url"] as? String {
            airline_imgUrl = img_url
        }
        
        // search key...
        self.search_key = ""
        if let search_key = result_dict["cache_file_name"] as? String {
            self.search_key = search_key
        }
        
        // oneWay trip flights...
        if let flightsArray = result_dict["Flights"] as? [Any] {
            if flightsArray.count != 0 {
                if let departArray = flightsArray[0] as? [[String: Any]] {
                    for itemObj in departArray {
                        let models = DFlightSearchItem.init(details: itemObj)
                        flightsDepart_array.append(models)
                    }
                }
            }
        }
        
        // round trip flights...
        if let flightsArray = result_dict["Flights"] as? [Any] {
            if flightsArray.count == 2 {
                
                // depart array contain dictionaries...
                if let departArray = flightsArray[0] as? [[String: Any]] {
                    for itemObj in departArray {
                        let models = DFlightSearchItem.init(details: itemObj)
                        self.flightsDepart_array.append(models)
                    }
                }
                
                // return array contain dictionaries...
                if let returnArray = flightsArray[1] as? [[String: Any]] {
                    for itemObj in returnArray {
                        let models = DFlightSearchItem.init(details: itemObj)
                        self.flightsReturn_array.append(models)
                    }
                }
            }
        }
    }
    
    // funcations...
    static func createModels_InterRoundOrMulti(result_dict: [String: Any]) {
        
        // flight type...
        self.is_domestic = true
        if result_dict["IsDomestic"] as? Bool == false {
            self.is_domestic = false
        }
        
        if let searchID = result_dict["search_id"] as? Int {
            self.search_id = "\(searchID)"
        }
        
        // airline img_url....
        if let img_url = result_dict["airline_img_url"] as? String {
            airline_imgUrl = img_url
        }
        
        // search key...
        if let search_key = result_dict["search_key"] as? String {
            self.search_key = search_key
        }
        
        if let bookingSource = result_dict["booking_source"] as? String {
            self.booking_source = bookingSource
        }
    
        // internation round/ mulit city trip flights...
        if let flightsArray = result_dict["Flights"] as? [Any] {
            if flightsArray.count != 0 {
                if let departArray = flightsArray[0] as? [[String: Any]] {
                    for itemObj in departArray {
                        let models = DFlightSearchMultiItem.init(details: itemObj)
                        self.flightMulti_array.append(models)
                    }
                }
            }
        }
    }
    
    static func gettingDepart_arrivalIndex(select_date: Date) -> Int {
        
        // arrival types...
        let arrival_hours = Int(DateFormatter.getDateString(formate: "HH", date: select_date)) ?? 0
        let arrival_mintes = Int(DateFormatter.getDateString(formate: "mm", date: select_date)) ?? 0
        
        if (arrival_hours <= 6) && !(arrival_hours == 6 && arrival_mintes > 0)  {
            return 0
        }
        else if (arrival_hours <= 12) && !(arrival_hours == 12 && arrival_mintes > 0) {
            return 1
        }
        else if (arrival_hours <= 18) && !(arrival_hours == 18 && arrival_mintes > 0) {
            return 2
        }
        else {
            return 3
        }
    }
}

//MARK: - DFlightSearchMultiItem
struct DFlightSearchMultiItem {
    
    // elements...
    var airline_name: String?

    var airline_id: String?
    var token: String?
    var token_key: String?
    var auth_key: String?
    var booking_source: String?
    var currency_code: String = "INR"
    var is_refund = false
    var ticket_price: Float = 0.0
    var tax_price: Float = 0.0
    var base_fare: Float = 0.0
    var gst_price: Float = 0.0
    var flightsSearch_array: [DFlightSearchItem] = []
    var passBreakUp_info: [PassBreakupModel] = []
    var passengerFare_array: [PassBreakupModel] = []
    var flight_info: [String: Any] = [:]
    
    
    // filters....
    var stop_type: Int = 0
    var depart_type: Int = 0
    var arrival_type: Int = 0
    
    var start_date = Date()
    var end_date = Date()
    var duration_seconds: Int = 0
    
    
    // initialization...
    init(details: [String: Any]) {
        self.airline_name = ""

        self.airline_id = ""
        self.token = ""
        self.currency_code = "INR"
        self.flight_info = details
        
        // airline id...
        if let air_id = details["id"] as? String {
            self.airline_id = air_id
        }
        
        // token...
        if let token_id = details["Token"] as? String {
            self.token = token_id
        }

        
        if let tokeyKey = details["TokenKey"] as? String {
            self.token_key = tokeyKey
        }
        
        if let authKey = details["ProvabAuthKey"] as? String {
            self.auth_key = authKey
        }
        
        if let bookingSource = details["booking_source"] as? String {
            self.booking_source = bookingSource
        }
        
        // price info...
        if let fareDict = details["FareDetails"] as? [String: Any] {
            if let b2cPrice = fareDict["b2c_PriceDetails"] as? [String: Any] {
                
                self.ticket_price = Float(String.init(describing: b2cPrice["TotalFare"]!)) ?? 0.0
                self.tax_price = Float(String.init(describing: b2cPrice["TotalTax"]!)) ?? 0.0
                if let currency = b2cPrice["Currency"] as? String {
                    self.currency_code = currency
                }
                //                    if let  base_fare = b2cPrice["BaseFare"] as? String {
                                    self.base_fare = Float(String.init(describing: b2cPrice["BaseFare"]!)) ?? 0.0
                //                    }
                //                    if let gst_price = b2cPrice["GST"] as? String {
                                        self.gst_price = Float(String.init(describing: b2cPrice["GST"]!)) ?? 0.0
                //                    }

            }
        }
        
        // if price info array...
        if let fareDict = details["FareDetails"] as? [String: Any] {
            if let b2cPriceArr = fareDict["b2c_PriceDetails"] as? [Any] {
                if let b2cPrice = b2cPriceArr[0] as? [String: Any] {
                    
                    self.ticket_price = Float(String.init(describing: b2cPrice["TotalFare"]!)) ?? 0.0
                    self.tax_price = Float(String.init(describing: b2cPrice["TotalTax"]!)) ?? 0.0
                    if let currency = b2cPrice["Currency"] as? String {
                        self.currency_code = currency
                    }
                }
            }
        }
        
        if let pass_breakup = details["PassengerFareBreakdown"] as? [String: Any] {
            
            if let adult_dict = pass_breakup["ADT"] as? [String: Any] {
                var model = PassBreakupModel.init(passengerItem: adult_dict)
                model.passenger_type = "adult"
                self.passengerFare_array.append(model)
            }
            
            if let child_dict = pass_breakup["CHD"] as? [String: Any] {
                var model = PassBreakupModel.init(passengerItem: child_dict)
                model.passenger_type = "child"
                self.passengerFare_array.append(model)
            }
            
            if let infant_dict = pass_breakup["INF"] as? [String: Any] {
                var model = PassBreakupModel.init(passengerItem: infant_dict)
                model.passenger_type = "infant"
                self.passengerFare_array.append(model)
            }
            
            //PassBreakupModel.addPassFareBreakup(breakUp: pass_breakup)
        }
        
        // refund info...
        if let arrtDict = details["Attr"] as? [String: Any] {
            
            if arrtDict["IsRefundable"] as? Bool == true {
                self.is_refund = true
            }
        }
        
        // search items...
        if let flight_Array = details["SegmentSummary"] as? [[String: Any]] {
            
            for itemObj in flight_Array {
                let models = DFlightSearchItem.init(details: itemObj)
                self.flightsSearch_array.append(models)
            }
        }
        if let airlineDetails = details["AirlineDetails"] as? [String: Any]{
            if let airlineName = airlineDetails["AirlineName"] as? String {
                self.airline_name = airlineName
            }
            if let flightCode = airlineDetails["AirlineCode"] as? String {
                //                self.airline_img = "\(flightCode)"
            }
            if let flightNo = airlineDetails["FlightNumber"] {
                //                self.airline_code = self.airline_img! + " " + "\(flightNo)"
            }
        }
        // start and end time...
        if self.flightsSearch_array.count != 0 {
            self.start_date = self.flightsSearch_array[0].start_date
            self.end_date = self.flightsSearch_array[self.flightsSearch_array.count-1].end_date
        }
        
        
        // duration...
        let difference = Calendar.current.dateComponents([.second], from: start_date, to: end_date) //.hour, .minute,
        duration_seconds = difference.second!
        
        // depart and arrival types...
        depart_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: start_date)
        arrival_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: end_date)
        
        
        // stop under zero type...
        stop_type = 2
        var stop_1 = false
        for child_model in self.flightsSearch_array {
            if child_model.noof_stops == 0 {
                stop_1 = true
            } else {
                stop_1 = false
                break
            }
        }
        if stop_1 == true {
            stop_type = 0
        }
        
        // stop under 1 type...
        var stop_2 = false
        for child_model in self.flightsSearch_array {
            if child_model.noof_stops == 1 {
                stop_2 = true
            } else {
                stop_2 = false
                break
            }
        }
        if stop_2 == true {
            stop_type = 1
        }
    }
}


// MARK: - DFlightSearchItem
struct DFlightSearchItem {
    
    // elements...
    var airline_id: String?
    var token: String?
    var token_key: String?
    var auth_key: String?
    var booking_source: String?
    
    var airline_name: String?
    var airline_code: String?
    var airline_img: String?
    
    var depart_city: String?
    var depart_date: String?
    var depart_time: String?
    
    var arrival_city: String?
    var arrival_date: String?
    var arrival_time: String?

    var travel_hours: String?
    var noof_stops: Int = 0

    var currency_code: String?
    var is_refund = false
    var ticket_price: Float = 0.0
    var tax_price: Float = 0.0
    var base_fare: Float = 0.0
    var gst_price: Float = 0.0
    
    var flight_info: [String: Any] = [:]
    var passBreakUp_info: [PassBreakupModel] = []
    var passengerFare_array: [PassBreakupModel] = []
    

    // filters....
    var stop_type: Int = 0
    var depart_type: Int = 0
    var arrival_type: Int = 0
    
    var start_date = Date()
    var end_date = Date()
    var duration_seconds: Int = 0
    
    
    // initialization...
    init(details: [String: Any]) {
        
        // default info...
        self.airline_id = ""
        self.token = ""
        self.token_key = ""
        self.auth_key = ""
        self.booking_source = ""
        self.airline_name = ""
        self.airline_code = ""
        self.airline_img = ""
        
        self.depart_city = ""
        self.depart_date = ""
        self.depart_time = ""
        
        self.arrival_city = ""
        self.arrival_date = ""
        self.arrival_time = ""
        
        self.travel_hours = ""
        self.currency_code = "USD"
        self.flight_info = details
        
        
        var flight_dict:[String: Any] = [:]
        if DTravelModel.tripType == .OneWay || (DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == true) {
            
            // price info...
            if let fareDict = details["FareDetails"] as? [String: Any] {
                if let b2cPrice = fareDict["b2c_PriceDetails"] as? [String: Any] {
                    
                    FareBreakupModel.addTotalFare(fareItem: b2cPrice)
                    
                    if let currency = b2cPrice["Currency"] as? String {
                        self.currency_code = currency
                    }
                    self.ticket_price = Float(String.init(describing: b2cPrice["TotalFare"]!)) ?? 0.0
                                        
                    self.tax_price = Float(String.init(describing: b2cPrice["TotalTax"]!)) ?? 0.0
//                    if let  base_fare = b2cPrice["BaseFare"] as? String {
                    self.base_fare = Float(String.init(describing: b2cPrice["BaseFare"]!)) ?? 0.0
//                    }
//                    if let gst_price = b2cPrice["GST"] as? String {
                        self.gst_price = Float(String.init(describing: b2cPrice["GST"]!)) ?? 0.0
//                    }
                }
            }
            
            // if price info array...
            if let fareDict = details["FareDetails"] as? [String: Any] {
                if let b2cPriceArr = fareDict["b2c_PriceDetails"] as? [Any] {
                    if let b2cPrice = b2cPriceArr[0] as? [String: Any] {
                        
                        if let currency = b2cPrice["Currency"] as? String {
                            self.currency_code = currency
                        }
                        self.ticket_price = Float(String.init(describing: b2cPrice["TotalFare"]!)) ?? 0.0
                        self.tax_price = Float(String.init(describing: b2cPrice["TotalTax"]!)) ?? 0.0
                        
                        //                    if let  base_fare = b2cPrice["BaseFare"] as? String {
                                            self.base_fare = Float(String.init(describing: b2cPrice["BaseFare"]!)) ?? 0.0
                        //                    }
                        //                    if let gst_price = b2cPrice["GST"] as? String {
                                                self.gst_price = Float(String.init(describing: b2cPrice["GST"]!)) ?? 0.0
                        //                    }
                    }
                }
            }
            
            if let pass_breakup = details["PassengerFareBreakdown"] as? [String: Any] {
                
                if let adult_dict = pass_breakup["ADT"] as? [String: Any] {
                    var model = PassBreakupModel.init(passengerItem: adult_dict)
                    model.passenger_type = "adult"
                    self.passengerFare_array.append(model)
                }
                
                if let child_dict = pass_breakup["CHD"] as? [String: Any] {
                    var model = PassBreakupModel.init(passengerItem: child_dict)
                    model.passenger_type = "child"
                    self.passengerFare_array.append(model)
                }
                
                if let infant_dict = pass_breakup["INF"] as? [String: Any] {
                    var model = PassBreakupModel.init(passengerItem: infant_dict)
                    model.passenger_type = "infant"
                    self.passengerFare_array.append(model)
                }
                
                //PassBreakupModel.addPassFareBreakup(breakUp: pass_breakup)
            }
            
            // refund info...
            if let arrtDict = details["Attr"] as? [String: Any] {
                
                if arrtDict["IsRefundable"] as? Bool == true {
                    self.is_refund = true
                }
            }
            
            // token...
            if let token_id = details["Token"] as? String {
                self.token = token_id
            }
            
            if let tokeyKey = details["TokenKey"] as? String {
                self.token_key = tokeyKey
            }
            
            if let authKey = details["ProvabAuthKey"] as? String {
                self.auth_key = authKey
            }
            
            if let bookingSource = details["booking_source"] as? String {
                self.booking_source = bookingSource
            }
            
            if let segmentArray = details["SegmentSummary"] as? [Any] {
                if segmentArray.count != 0 {
                    if let segmentSummary = segmentArray[0] as? [String : Any] {
                        flight_dict = segmentSummary
                    
                    }
                }
            }
        }
        else {
            flight_dict = details
        }
        
        
        
        // flight details...
        if let airlineName = flight_dict["Airline_AirlineName"] as? String {
            self.airline_name = airlineName
        }
        if let flightCode = flight_dict["Airline_AirlineCode"] as? String {
            self.airline_img = "\(flightCode)"
        }
        if let flightNo = flight_dict["Airline_FlightNumber"] {
            self.airline_code = self.airline_img! + " " + "\(flightNo)"
        }
        
        if let t_hours = flight_dict["TotalDuaration"] as? String {
            self.travel_hours = t_hours
            duration_seconds = Int(t_hours.secondFromString)

        }
        if let no_stops = flight_dict["TotalStops"] as? Int {
            self.noof_stops = no_stops
        }
        
        // orinign info...
        if let origin_city = flight_dict["Origin_CityName"] as? String {
            self.depart_city = origin_city
        }
        
        if let departTime = flight_dict["Origin_DepartureTime"] as? String {
            self.depart_time = departTime
        }
        
        if let origin_date = flight_dict["Origin__DepartureDate"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: origin_date)
//            self.start_date = originDate
            self.depart_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        
        // destination info...
        if let destin_city = flight_dict["Destination_CityName"] as? String {
            self.arrival_city = destin_city
        }
        
        if let arrivalTime = flight_dict["Destination_ArrivalTime"] as? String {
            self.arrival_time = arrivalTime
        }
        
        if let destin_date = flight_dict["Destination__ArrivalDate"] as? String {
            
            let destinDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: destin_date)
//            self.end_date = destinDate
            self.arrival_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
        }
        if let xyz = flight_dict["Destination_DateTime"] as? String {
            
            let destinxyzDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: xyz)
            self.end_date = destinxyzDate
//            self.arrival_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
        }
        if let abc = flight_dict["Origin_DateTime"] as? String {
            
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: abc)
            self.start_date = destinDate
//            self.arrival_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
        }
        // *** filter purpose ***
        // duration...
        let difference = Calendar.current.dateComponents([.second], from: start_date, to: end_date) //.hour, .minute,
//        duration_seconds = difference.second!
        
        // depart and arrival types...
        depart_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: start_date)
        arrival_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: end_date)
        
        // stop types....
        stop_type = 0
        if noof_stops > 1 {
            stop_type = 2
        }
        else if noof_stops == 1 {
            stop_type = 1
        }
        else {}
    }
}

// MARK: - PassengerBreakupModel
struct PassBreakupModel {
    
    // variable...
    var base_fare: Float = 0.0
    var tax_fare: Float = 0.0
    var passenger_count: Int = 0
    var passenger_type: String?
    
    // static variable...
    static var total_baseFare: Float = 0.0
    static var total_taxFare: Float = 0.0
    static var passengerFare_array: [PassBreakupModel] = []
    
    // initialization...
    init(passengerItem: [String: Any]) {
     
      
        self.base_fare = Float(String.init(describing: passengerItem["BaseFare"]!))!
        self.tax_fare = Float(String.init(describing: passengerItem["Tax"]!))!
        self.passenger_count = Int(String.init(describing: passengerItem["PassengerCount"]!))!
        
//        self.passenger_type = ""
//        if let types = passengerItem["type"] as? String {
//            self.passenger_type = types
//        }
    }
    
    // information adding...
    static func addPassFareBreakup(breakUp: [String: Any]) {
        
        if let adult_dict = breakUp["ADT"] as? [String: Any] {
            var model = PassBreakupModel.init(passengerItem: adult_dict)
            model.passenger_type = "adult"
            self.passengerFare_array.append(model)
        }
        
        if let child_dict = breakUp["CHD"] as? [String: Any] {
            var model = PassBreakupModel.init(passengerItem: child_dict)
            model.passenger_type = "child"
            self.passengerFare_array.append(model)
        }
        
        if let infant_dict = breakUp["INF"] as? [String: Any] {
            var model = PassBreakupModel.init(passengerItem: infant_dict)
            model.passenger_type = "infant"
            self.passengerFare_array.append(model)
        }
    
//        self.total_baseFare = self.total_baseFare + Float(String.init(describing: breakUp["base"]!))!
//        self.total_taxFare = self.total_taxFare + Float(String.init(describing: breakUp["tax"]!))!
//
//        // getting passenger array...
//        if let passengerArray = breakUp["passenger"] as? [Any] {
//            for i in 0 ..< passengerArray.count {
//                if let passDict = passengerArray[i] as? [String: Any] {
//
//                    // create model...
//                    let model = PassBreakupModel.init(passengerItem: passDict)
//                    self.passengerFare_array.append(model)
//                }
//            }
//        }
    }
}

// MARK:- FareBreakupModel
struct FareBreakupModel {
    
    // variable
    static var totalTax: Float = 0.0
    static var totalFare: Float = 0.0
    static var currency = "USD"
    
    // information adding...
    static func addTotalFare(fareItem: [String: Any]) {
        
        self.totalTax = self.totalFare + Float(String.init(describing: fareItem["TotalTax"]!))!
        self.totalFare = self.totalFare + Float(String.init(describing: fareItem["TotalFare"]!))!
        if let currency_str = fareItem["Currency"] as? String {
            self.currency = currency_str
        }
    }
}

// MARK: - DFairRulesModel
struct DFairRulesModel {
    
    // variable...
    var from_city = ""
    var to_city = ""
    var airline_code = ""
    var rules_descript = ""
    
    // initialization...
    init(details: [String: Any]) {
        
        // from and to cities...
        if let origin = details["Origin"] as? String {
            from_city = origin
        }
        if let destination = details["Destination"] as? String {
            to_city = destination
        }
        
        // airline and description...
        if let airline = details["Airline"] as? String {
            airline_code = airline
        }
        if let details = details["FareRules"] as? String {
            rules_descript = details
        }
    }
    
    // create models...
    static func createModel(data_array: [[String: Any]]) -> [DFairRulesModel] {
        
        // rules models...
        var model_array: [DFairRulesModel] = []
        for data_dict in data_array {
            let model = DFairRulesModel.init(details: data_dict)
            model_array.append(model)
        }
        return model_array
    }
}

