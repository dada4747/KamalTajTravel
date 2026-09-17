

import UIKit

// MARK: - DFlightStopsModel
struct DFlightStopsModel {
    
    // main list for display..
    static var flightTripStops_array: [[DFlightStopsItem]] = []
    static var flightTripHead_array: [DFlightStopsHeadItem] = []
    static var flightTrip_array:[DFlightStopsItem] = []
    static var preBookingItem: DPreBookingStore?
    static var totalTripPoints : String = "0"
    static var usedTripPoints : String = "0"
    static var availableTripPoints: String = "0"
    static var isPassportRequiredAtBook: Bool = false
//    static var activePaymentOptions: [String] = []
    static var activePaymentOptions: [PaymentOption] = []


    init() {
    }
    
    // clear all stops information(price details & stops details)...
    static func clearAll_StopsInformation() {
        
        // clear all trips with stops...
        flightTripStops_array.removeAll()
        flightTripHead_array.removeAll()
        flightTrip_array.removeAll()
        
        // clear passenger break up..
        PassengerBreakupModel.total_baseFare = 0.0
        PassengerBreakupModel.total_taxFare = 0.0
        PassengerBreakupModel.passengerFare_array.removeAll()
        
        // clear final break up...
        FinalBreakupModel.currency = "INR"
        FinalBreakupModel.currencySymbol = "INR"
        FinalBreakupModel.convenienceFare = 0.0
        FinalBreakupModel.baseFare = 0.0
        FinalBreakupModel.discount = 0.0
        FinalBreakupModel.gstFare = 0.0
        FinalBreakupModel.totalTax = 0.0
        FinalBreakupModel.totalFare = 0.0
    }
    
    
    // information adding...
    static func createStopModel(dataDict: [String: Any]) {
        if let paxArray = dataDict["pax_details"] as? [[String: Any]], let firstPax = paxArray.first {
            if let val = firstPax["total_trip_points"] as? String {
                totalTripPoints = val
                
            }
            if let val = firstPax["available_trip_points"] as? String {
                availableTripPoints = val
                
                
            }
            if let val = firstPax["used_trip_points"] as? String {
                usedTripPoints = val
                
            }
            
        }
        
        // total fare...
        if let booking_summery = dataDict["pre_booking_summery"] as? [String: Any] {
            
            if let fare_details = booking_summery["FareDetails"] as? [String: Any] {
                if let b2c_PriceDetails = fare_details["b2c_PriceDetails"] as? [String: Any] {
                    FinalBreakupModel.addTotalTripFare(fareItem: b2c_PriceDetails)
                }
            }
            
            // Stops information...
            if let tripsList = booking_summery["SegmentSummary"] as? [Any] {
                DFlightStopsModel.createTrip_StopsModel(stopsArray: tripsList)
                
                for i in 0 ..< tripsList.count {
                    if let tripDict = tripsList[i] as? [String: Any] {
                        let model = DFlightStopsItem.init(details: tripDict, overlay: false, isTrip: true)
                        flightTrip_array.append(model)
                    }
                }
            }
        }
        if let extra_services = dataDict["extra_services"] as? [String : Any] {
            if let data_dict = extra_services["ExtraServiceDetails"] as? [String: Any] {
                
                DFlightAddOnsModel.createFightAddOnsModel(response_dict: data_dict)
            }
        }
        
//        if let paymentOptions = dataDict["active_payment_options"] as? [String] {
//            self.activePaymentOptions = paymentOptions
//        } else if let paymentOptions = dataDict["active_payment_options"] as? NSArray {
//            self.activePaymentOptions = paymentOptions as? [String] ?? ["PNHB1"]
//        } else {
//            self.activePaymentOptions = ["PNHB1"]
//        }
        if let paymentOptions = dataDict["active_payment_options"] as? [[String: Any]] {
            
            self.activePaymentOptions = paymentOptions.map {
                PaymentOption(
                    name: $0["name"] as? String ?? "",
                    method: $0["method"] as? String ?? "",
                    imgurl: $0["imgurl"] as? String ?? ""
                )
            }
            
        } else {
            
            self.activePaymentOptions = [
                PaymentOption(
                    name: "Razorpay",
                    method: "PNHB1",
                    imgurl: ""
                )
            ]
        }

        if let prebookingparam = dataDict["pre_booking_params"] as? [String: Any] {
            if let token = prebookingparam["token"] as? [Any] {
                if let ftoken = token.first as? [String: Any] {
                    if let att = ftoken["Attr"] as? [String: Any] {
                        if let condition = att["conditions"] as? [String : Any] {
                            print(condition["IsPassportRequiredAtBook"])
                            if let conditionValue = condition["IsPassportRequiredAtBook"] as? Bool {
                                print(conditionValue)
                                DFlightStopsModel.isPassportRequiredAtBook = conditionValue
                            }
                            if let conditionSValue = condition["IsPrepaidFareRequiredAtBook"]  as? String {
//                                DFlightStopsModel.isPassportRequiredAtBook = conditionValue
                            }
                        }
                    }
                }
            }
        }
        // passenger fare breakup...
        if let passFare = dataDict["breakup"] as? [String: Any] {
            PassengerBreakupModel.addPassengersFareBreakup(breakUp: passFare)
        }
        
        // Stops information...
        if let tripsList = dataDict["trips"] as? [Any] {
            DFlightStopsModel.createTrip_StopsModel(stopsArray: tripsList)
        }
        
        // convenience fee...
//        FinalBreakupModel.convenienceFare =  Float(String.init(describing: dataDict["convenience_fees"]!))!
        FinalBreakupModel.convenienceFare = parseAmount(dataDict["convenience_fee"])// Float(String.init(describing: dataDict["convenience_fees"]!))!

        // prebooking store...
        preBookingItem = DPreBookingStore()
        if let token = dataDict["token"] as? String {
            preBookingItem?.token = token
        }
        if let token_key = dataDict["token_key"] as? String {
            preBookingItem?.token_key = token_key
        }
        if let booking_source = dataDict["booking_source"] as? String {
            preBookingItem?.booking_source = booking_source
        }
        if let flight_tableId = dataDict["flight_token_table_id"] as? Int {
            preBookingItem?.flight_token_table_id = "\(flight_tableId)"
        }
        if let search_hash = dataDict["search_hash_ssr"] as? String {
            preBookingItem?.search_hash = search_hash
        }
        if let payment_opt = dataDict["active_payment_options"] as? [Any] {
            if payment_opt.count != 0 {
                if let paymentMethod = payment_opt[0] as? String {
                    preBookingItem?.payment_method = paymentMethod
                }
            }
        }
    }
    
    static func createTrip_StopsModel(stopsArray: [Any]) {
        
        // create headers...
        self.createTripsHeaders(trips: stopsArray)
        
        // every signle trip stops..
        var trip_stopsArray: [DFlightStopsItem] = []
        
        // adding new trips with all stops...
        for i in 0 ..< stopsArray.count {
            
            if let tripDict = stopsArray[i] as? [String: Any] {
                
                // adding stops...
                let model = DFlightStopsItem.init(details: tripDict, overlay: false, isTrip: false)
                trip_stopsArray.append(model)
                
                // adding overlay element..
                if ((i+1) < stopsArray.count) {
                    
                    let subModel = DFlightStopsItem.init(details: tripDict, overlay: true, isTrip: false)
                    trip_stopsArray.append(subModel)
                    print("index = \(i+1)")
                    //, (i+1) % 2 == 0
                }
            }
        }
        
        let finalStops_array = self.layoutTimesAdding(tripStops: trip_stopsArray)
        self.flightTripStops_array.append(finalStops_array)
    }
    /*
     static func createTrip_StopsModel(details: [Any]) {
     
     // create headers...
     self.createTripsHeaders(trips: details)
     
     // adding new trips with all stops...
     for i in 0 ..< details.count {
     
     // every signle trip stops..
     var trip_stopsArray: [DFlightStopsItem] = []
     
     if let trip_dict = details[i] as? [String: Any] {
     if let stopsArray = trip_dict["details"] as? [Any] {
     
     // every signle trip stops list...
     for i in 0 ..< stopsArray.count {
     if let tripDict = stopsArray[i] as? [String: Any] {
     
     // adding stops...
     let model = DFlightStopsItem.init(details: tripDict, overlay: false)
     trip_stopsArray.append(model)
     
     // adding overlay element..
     if ((i+1) < stopsArray.count) {
     
     let subModel = DFlightStopsItem.init(details: tripDict, overlay: true)
     trip_stopsArray.append(subModel)
     print("index = \(i+1)")
     //, (i+1) % 2 == 0
     }
     }
     }
     }
     }
     
     let finalStops_array = self.layoutTimesAdding(tripStops: trip_stopsArray)
     self.flightTripStops_array.append(finalStops_array)
     }
     }
     */
    static func layoutTimesAdding(tripStops: [DFlightStopsItem]) -> [DFlightStopsItem] {
        
        // adding time layover...
        var overlayStops = tripStops
        for i in 0 ..< overlayStops.count {
            
            let models = overlayStops[i]
            if models.triptype_index == 1 {
                
                // getting from and to dates...
                let fromString = String(format: "%@ %@", models.arrival_date!, models.arrival_time!)
                let fromDate = DateFormatter.getDate(formate: "dd MMM yyyy HH:mm",
                                                     date: fromString)
                
                
                let secondModel = overlayStops[i+1]
                let toString = String(format: "%@ %@", secondModel.depart_date!, secondModel.depart_time!)
                let toDate = DateFormatter.getDate(formate: "dd MMM yyyy HH:mm",
                                                   date: toString)
                
                print("overLay : \(DateFormatter.getHoursMinsBetweenDates(fromDate: toDate, toDate: fromDate))")
                overlayStops[i].layOver_time = DateFormatter.getHoursMinsBetweenDates(fromDate: fromDate, toDate: toDate)
            }
        }
        
        return overlayStops
    }
    
    // create all trips headers...
    static func createTripsHeaders(trips: [Any]) {
        
        // adding header models...
        let headModel = DFlightStopsHeadItem.init(tripStops: trips)
        self.flightTripHead_array.append(headModel)
        
        /*
         // adding header models...
         for i in 0 ..< trips.count {
         if let trip_dict = trips[i] as? [String: Any] {
         if let stopsArray = trip_dict["details"] as? [Any] {
         
         let headModel = DFlightStopsHeadItem.init(tripStops: stopsArray)
         self.flightTripHead_array.append(headModel)
         }
         }
         } */
    }
}

struct DPreBookingStore {
    
    // varibales...
    var token: String?
    var token_key: String?
    var payment_method: String = "PNHB1"
    var search_hash: String?
    var flight_token_table_id: String?
    var booking_source: String?
    var isRefund = false
    
    init() {
    }
}

// MARK: - DFlightStopsItem
struct DFlightStopsItem {
    
    // variable...
    var airline_code: String?
    var airline_name: String?
    var airline_image: String?
    var travel_hours: String?
    var total_stops: String?
    var baggage: String?
    var cabin_baggage: String?
    
    var depart_city: String?
    var depart_airport: String?
    var depart_airportcode: String?
    var depart_date: String?
    var depart_time: String?
    
    var arrival_city: String?
    var arrival_airport: String?
    var arrival_airportcode: String?
    var arrival_date: String?
    var arrival_time: String?
    var AvailableSeats: String?
    var Baggage: String?

    
    
    var layOver_time: String?
    var triptype_index = 0
    var trip_info: [String: Any] = [:]
    
    
    var depart_terminal : String = "0"
    var arrival_terminal : String = "0"
    // initialization...
    init(details: [String: Any], overlay: Bool, isTrip: Bool) {
        
        // default info...
        self.airline_code = ""
        self.airline_name = ""
        self.airline_image = ""
        self.travel_hours = ""
        self.total_stops = "0"
        self.baggage = ""
        self.cabin_baggage = ""
        
        self.depart_city = ""
        self.depart_airport = ""
        self.depart_airportcode = ""
        self.depart_date = ""
        self.depart_time = ""
        
        self.arrival_city = ""
        self.arrival_airport = ""
        self.arrival_airportcode = ""
        self.arrival_date = ""
        self.arrival_time = ""
        
        self.layOver_time = ""
        self.trip_info = details
        self.AvailableSeats = ""
        self.Baggage = ""

        // overlay element...
        if overlay == true {
            self.triptype_index = 1
        }
        
        if isTrip {
            
            // flight info...
            if let hours = details["SegmentDuration"] as? String {
                self.travel_hours = hours
            }
            if let stops = details["TotalStops"] as? Int {
                self.total_stops = "\(stops)"
            }
            
            if let baggag_info = details["Baggage_Info"] as? [String: Any] {
                if let bag = baggag_info["Baggage"] as? String {
                    self.baggage = bag
                }
                if let cabing_bag = baggag_info["CabinBaggage"] as? String {
                    self.cabin_baggage = cabing_bag
                }
            }
            
            if let flight_info = details["AirlineDetails"] as? [String: Any] {
                
                if let airlineName = flight_info["AirlineName"] as? String {
                    self.airline_name = airlineName
                }
                if let flightCode = flight_info["AirlineCode"] as? String {
                    self.airline_image = "\(flightCode)"
                }
                if let flightNo = flight_info["FlightNumber"] {
                    self.airline_code = self.airline_image! + " " + "\(flightNo)"
                }
            }
            
            // orinign info...
            if let origin_info = details["OriginDetails"] as? [String: Any] {
                
                if let origin_city = origin_info["CityName"] as? String {
                    self.depart_city = origin_city
                }
                if let origin_airport_code = origin_info["AirportCode"] as? String {
                    self.depart_airportcode = origin_airport_code
                }
                if let origin_airport_name = origin_info["AirportName"] as? String {
                    self.depart_airport = origin_airport_name
                }
                if let departTime = origin_info["DepartureTime"] as? String {
                    self.depart_time = departTime
                }
                if let origin_date = origin_info["DepartureDate"] as? String {
                    
                    let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: origin_date)
                    self.depart_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
                }
            }
            
            // destination info...
            if let destination_info = details["DestinationDetails"] as? [String: Any] {
                
                if let destin_city = destination_info["CityName"] as? String {
                    self.arrival_city = destin_city
                }
                if let destin_airport_code = destination_info["AirportCode"] as? String {
                    self.arrival_airportcode = destin_airport_code
                }
                if let destin_airport_name = destination_info["AirportName"] as? String {
                    self.arrival_airport = destin_airport_name
                }
                if let arrivalTime = destination_info["ArrivalTime"] as? String {
                    self.arrival_time = arrivalTime
                }
                if let destin_date = destination_info["ArrivalDate"] as? String {
                    
                    let destinDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: destin_date)
                    self.arrival_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
                }
            }
        }
        
        else {
            
            // flight info...
            if let hours = details["SegmentDuration"] as? String {
                self.travel_hours = hours
            }
//            if let AvailableSeats = details["AvailableSeats"] as? Int {
//                self.AvailableSeats = String(AvailableSeats)
//            }
            if let seats = details["AvailableSeats"] as? Int {
                
                self.AvailableSeats = String(seats)

            } else if let seats = details["AvailableSeats"] as? String {
                
                self.AvailableSeats = seats
            }
            if let Baggage = details["Baggage"] as? String {
                self.Baggage = Baggage
            }

            if let stops = details["TotalStops"] as? Int {
                self.total_stops = "\(stops)"
            }
            if let origin_terminal = details["Origin_Terminal"] as? String {
                self.depart_terminal = origin_terminal
            }
            if let destination_terminal = details["Destination_Terminal"] as? String {
                self.arrival_terminal = destination_terminal
            }
//            AvailableSeats
            if let airlineName = details["Airline_AirlineName"] as? String {
                self.airline_name = airlineName
            }
            if let flightCode = details["Airline_AirlineCode"] as? String {
                self.airline_image = "\(flightCode)"
            }
            if let flightNo = details["Airline_FlightNumber"] {
                self.airline_code = self.airline_image! + " " + "\(flightNo)"
            }
            if let bag = details["Baggage"] as? String {
                self.baggage = bag
            }
            if let cabing_bag = details["CabinBaggage"] as? String {
                self.cabin_baggage = cabing_bag
            }
            
            // orinign info...
            if let origin_city = details["Origin_CityName"] as? String {
                self.depart_city = origin_city
            }
            if let origin_airport_code = details["Origin_AirportCode"] as? String {
                self.depart_airportcode = origin_airport_code
            }
            if let origin_airport_name = details["Origin_AirportName"] as? String {
                self.depart_airport = origin_airport_name
            }
            if let departTime = details["Origin_DepartureTime"] as? String {
                self.depart_time = departTime
            }
            if let origin_date = details["Origin__DepartureDate"] as? String {
                
                let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: origin_date)
                self.depart_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
            }
            
            // destination info...
            if let destin_city = details["Destination_CityName"] as? String {
                self.arrival_city = destin_city
            }
            if let destin_airport_code = details["Destination_AirportCode"] as? String {
                self.arrival_airportcode = destin_airport_code
            }
            if let destin_airport_name = details["Destination_AirportName"] as? String {
                self.arrival_airport = destin_airport_name
            }
            if let arrivalTime = details["Destination_ArrivalTime"] as? String {
                self.arrival_time = arrivalTime
            }
            if let destin_date = details["Destination__ArrivalDate"] as? String {
                
                let destinDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: destin_date)
                self.arrival_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
            }
            
        }
    }
}


// MARK: - DFlightStopsHeadItem
struct DFlightStopsHeadItem {
    
    // variable...
    var from_city: String?
    var from_cityCode: String?
    var from_airport: String?
    
    var to_city: String?
    var to_cityCode: String?
    var to_airport: String?
    
    var start_date: String?
    var start_time: String?
    var end_date: String?
    var end_time: String?
    
    var noof_passengers: Int = 0
    
    var noof_stops: Int = 0
    
    // initialization...
    init(tripStops: [Any]) {
        
        self.from_city = ""
        self.from_cityCode = ""
        self.from_airport = ""
        
        self.to_city = ""
        self.to_cityCode = ""
        self.to_airport = ""
        
        self.start_date = ""
        self.start_time = ""
        self.end_date = ""
        self.end_time = ""
        self.noof_stops = 0
        self.noof_passengers = (DTravelModel.adultCount + DTravelModel.childCount + DTravelModel.infantCount)
        
        // trips details...
        print(tripStops)
        if tripStops.count != 0 {
            
            // oringin...
            if let startDict = tripStops[0] as? [String: Any] {
                
                // city and airline city code...
                if let origin_city = startDict["Origin_CityName"] as? String {
                    self.from_city = origin_city
                }
                if let airport_code = startDict["Origin_AirportCode"] as? String {
                    self.from_cityCode = airport_code
                }
                if let airport_name = startDict["Origin_AirportName"] as? String {
                    self.from_airport = airport_name
                }
                // times...
                if let startTime = startDict["Origin_DepartureTime"] as? String {
                    self.start_time = startTime
                }
                // dates...
                if let origin_date = startDict["Origin__DepartureDate"] as? String {
                    
                    let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: origin_date)
                    self.start_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
                }
            }
            
            // destination...
            if let endDict = tripStops[tripStops.count-1] as? [String: Any] {
                
                // city and airline city code...
                if let destinaiton_city = endDict["Destination_CityName"] as? String {
                    self.to_city = destinaiton_city
                }
                if let airport_code = endDict["Destination_AirportCode"] as? String {
                    self.to_cityCode = airport_code
                }
                if let airport_name = endDict["Destination_AirportName"] as? String {
                    self.to_airport = airport_name
                }
                
                // times...
                if let endTime = endDict["Destination_ArrivalTime"] as? String {
                    self.end_time = endTime
                }
                
                // dates...
                if let desti_date = endDict["Destination__ArrivalDate"] as? String {
                    
                    let destinationDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: desti_date)
                    self.end_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinationDate)
                }
            }
        }
    }
}


// MARK: - PassengerBreakupModel
struct PassengerBreakupModel {
    
    // variable...
    var base_fare: Float = 0.0
    var tax_fare: Float = 0.0
    var passenger_count: Int = 0
    var passenger_type: String?
    
    // static variable...
    static var total_baseFare: Float = 0.0
    static var total_taxFare: Float = 0.0
    static var passengerFare_array: [PassengerBreakupModel] = []
    
    // initialization...
    init(passengerItem: [String: Any]) {
        
        
        self.base_fare = Float(String.init(describing: passengerItem["base"]!))!
        self.tax_fare = Float(String.init(describing: passengerItem["tax"]!))!
        self.passenger_count = Int(String.init(describing: passengerItem["count"]!))!
        
        self.passenger_type = ""
        if let types = passengerItem["type"] as? String {
            self.passenger_type = types
        }
    }
    
    // information adding...
    static func addPassengersFareBreakup(breakUp: [String: Any]) {
        
        self.total_baseFare = self.total_baseFare + Float(String.init(describing: breakUp["base"]!))!
        self.total_taxFare = self.total_taxFare + Float(String.init(describing: breakUp["tax"]!))!
        
        // getting passenger array...
        if let passengerArray = breakUp["passenger"] as? [Any] {
            for i in 0 ..< passengerArray.count {
                if let passDict = passengerArray[i] as? [String: Any] {
                    
                    // create model...
                    let model = PassengerBreakupModel.init(passengerItem: passDict)
                    self.passengerFare_array.append(model)
                }
            }
        }
    }
}

struct GSTModel {
    var gst_number : String = ""
    var gst_company_name : String = ""
    var gst_email : String = ""
    var gst_phone : String = ""
    var gst_address : String = ""
    var gst_state : String = ""
}
// MARK: - FinalBreakupModel
struct FinalBreakupModel {
    
    // variable
    static var totalFare: Float = 0.0
    static var currency = "INR"
    static var currencySymbol = "A$"
    static var baseFare: Float = 0.0
    static var totalTax: Float = 0.0
    static var convenienceFare: Float = 0.0
    static var gstFare: Float = 0.0
    static var discount: Float = 0.0
    static var extraServicecharge: Float = 0.0
    static var baggageFare: Float = 0.0
    static var mealsFare: Float = 0.0
    static var seatsFare: Float = 0.0
    static var promoCode: String = ""
    
    static var rewardDiscount: Float = 0.0
    static var reward_promo_code : String = ""
    static var reward_total_fare: Float = 0.0
    static var total_used_points: Float = 0.0
    
    static var gstDetails: GSTModel = GSTModel()
    // information adding...
    static func addTotalTripFare(fareItem: [String: Any]) {
        
        self.baseFare = self.baseFare + Float(String.init(describing: fareItem["BaseFare"]!))!
        self.totalTax = self.totalTax + Float(String.init(describing: fareItem["TotalTax"]!))!
        self.totalFare = self.totalFare + Float(String.init(describing: fareItem["TotalFare"]!))!
        self.gstFare = self.gstFare + Float(String.init(describing: fareItem["GST"]!))!
        
        if let currency_str = fareItem["Currency"] as? String {
            self.currency = currency_str
        }
        if let currencySym = fareItem["CurrencySymbol"] as? String {
            self.currencySymbol = currencySym
        }
    }
}

