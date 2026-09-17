////
////  DBookingHistoryModel.swift
////  Internacia
////
////  Created by Admin on 28/10/22.
////
//import UIKit
//
//// MARK:- DBookingHistoryModel
//
//struct DFlightBookingHistoryModel {
//    static var packageID = ""
//    
//    static var past_flight_bookings : [DFlightHistoryItem] = []
//    static var upcoming_flight_bookings : [DFlightHistoryItem] = []
//    static var cancelled_flight_bookings : [DFlightHistoryItem] = []
//    
//    init() {
//    }
//    static func clearAllHistory(){
//        past_flight_bookings.removeAll()
//        upcoming_flight_bookings.removeAll()
//        cancelled_flight_bookings.removeAll()
//    }
//    static func createFlightHistoryModels(result_array: [String: Any]){
//        clearAllHistory()
//        if let data_array = result_array["past_flights"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DFlightHistoryItem.init(details: itemObj)
//                self.past_flight_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["cancel_flights"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DFlightHistoryItem.init(details: itemObj)
//                self.cancelled_flight_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["upcoming_flights"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DFlightHistoryItem.init(details: itemObj)
//                self.upcoming_flight_bookings.append(models)
//            }
//        }
//        
//    }
//}
//
//struct DHotelBookingHistoryModel {
//    static var past_hotel_bookings : [DHotelHistoryItem] = []
//    static var upcoming_hotel_bookings : [DHotelHistoryItem] = []
//    static var cancelled_hotel_bookings : [DHotelHistoryItem] = []
//    
//    init() {
//    }
//    static func clearAllHistory(){
//        past_hotel_bookings.removeAll()
//        upcoming_hotel_bookings.removeAll()
//        cancelled_hotel_bookings.removeAll()
//    }
//    static func createHotelHistoryModels(result_array: [String: Any]){
//        clearAllHistory()
//        if let data_array = result_array["past_hotels"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DHotelHistoryItem.init(details: itemObj)
//                self.past_hotel_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["cencel_hotels"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DHotelHistoryItem.init(details: itemObj)
//                self.cancelled_hotel_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["upcoming_hotels"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DHotelHistoryItem.init(details: itemObj)
//                self.upcoming_hotel_bookings.append(models)
//            }
//        }
//    }}
//struct DBusBookingHistoryModel {
//    static var past_bus_bookings : [DBusHistoryItem] = []
//    static var upcomming_bus_bookings : [DBusHistoryItem] = []
//    static var cancelled_bus_bookings : [DBusHistoryItem] = []
//    init(){}
//    static func clearAllHistory(){
//        past_bus_bookings.removeAll()
//        upcomming_bus_bookings.removeAll()
//        cancelled_bus_bookings.removeAll()
//    }
//    static func createBusHistoryModels(result_array: [String: Any]){
//        clearAllHistory()
//        if let data_array = result_array["upcoming_data"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DBusHistoryItem.init(details: itemObj)
//                self.upcomming_bus_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["past_data"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DBusHistoryItem.init(details: itemObj)
//                self.past_bus_bookings.append(models)
//            }
//        }
//        if let data_array = result_array["cancel_data"] as? [[String: Any]] {
//            for itemObj in data_array {
//                let models = DBusHistoryItem.init(details: itemObj)
//                self.cancelled_bus_bookings.append(models)
//            }
//        }    }
//}
//
//struct DBookingHistoryModel {
//
//    //static info...
//    static var packageId = ""
//
//    static var flightHistory_Array: [DFlightHistoryItem] = []
//    static var hotelHistory_Array: [DHotelHistoryItem] = []
//    static var transferHistory_Array: [DTransferHistoryItem] = []
//
//    init() {
//    }
//
//    // clear all search information...
//    static func clearAll_HistoryInformation() {
//
//        // remove all array...
//        flightHistory_Array.removeAll()
//        hotelHistory_Array.removeAll()
//        transferHistory_Array.removeAll()
//    }
//
//    // funcations...
//    static func createFlightMyBookingsModels(result_array: [[String: Any]]) {
//
//        clearAll_HistoryInformation()
//
//        for itemObj in result_array {
//            let models = DFlightHistoryItem.init(details: itemObj)
//            self.flightHistory_Array.append(models)
//        }
//    }
//
//    static func createHotelMyBookingsModels(result_array: [[String: Any]]) {
//
//        clearAll_HistoryInformation()
//
//        for itemObj in result_array {
//            let models = DHotelHistoryItem.init(details: itemObj)
//            self.hotelHistory_Array.append(models)
//        }
//    }
//    static func createTranferBookingModel(result_array: [[String: Any]]) {
//        clearAll_HistoryInformation()
//        for item in result_array {
//            let model = DTransferHistoryItem.init(details: item)
//            self.transferHistory_Array.append(model)
//        }
//    }
//}
//
//// MARK:- DFlightHistoryItem
//struct DFlightHistoryItem {
//    
//    // elements...
//    var booking_id: String?
//    var depart_city: String?
//    var depart_time: String?
//    var arrival_city: String?
//    var arrival_time: String?
//    var tripType: String?
//    var booking_status: String?
//    var journeyDate: String?
//    var currency_code: String?
//    var flight_price: Float = 0.0
//    var booking_source: String? = ""
//    var origin: String? = ""
//    init(details: [String: Any]) {
//        
//        // default info...
//        self.booking_id = ""
//        self.depart_city = ""
//        self.arrival_city = ""
//        self.tripType = ""
//        self.currency_code = "USD"
//        
//        // holiday details...
//        if let app_reference = details["app_reference"] as? String {
//            self.booking_id = app_reference
//        }
//        if let journey_from = details["journey_from"] as? String {
//            self.depart_city = journey_from
//        }
//        if let journey_to = details["journey_to"] as? String {
//            self.arrival_city = journey_to
//        }
//        if let trip_type = details["trip_type"] as? String {
//            self.tripType = trip_type
//        }
//        if let status = details["status"] as? String {
//            self.booking_status = status
//        }
//        if let bookingSource = details["booking_source"] as? String {
//            self.booking_source = bookingSource
//        }
//        if let origin = details["origin"] as? String {
//            self.origin = origin
//        }
//        if let journey_start = details["journey_start"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
//            self.journeyDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//            
//            self.depart_time = DateFormatter.getDateString(formate: "HH:mm", date: originDate)
//        }
//        
//        if let journey_end = details["journey_end"] as? String {
//             
//             let arrivalDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_end)
//             self.journeyDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrivalDate)
//            
//            self.arrival_time = DateFormatter.getDateString(formate: "HH:mm", date: arrivalDate)
//         }
//        
//        self.flight_price = Float(String.init(describing: details["total_fare"]!)) ?? 0.0
//    }
//    
//}
//
//// MARK:- DHotelHistoryItem
//struct DHotelHistoryItem {
//    
//    // variables...
//    var booking_id: String?
//    var app_reference: String?
//    var check_in: String?
//    var check_out: String?
//    
//    var hotel_name: String?
//    var hotel_address: String?
//    var hotel_img: String?
//    
//    var status_type: String?
//    var reference_id: String?
//    var status: String?
//    
//    var hotel_price: Float = 0.0
//    var hotel_currency = "USD"
//    
//    var checkIn_date = Date()
//    var checkOut_date = Date()
//    var noof_night: Int = 1
//    var hotel_info: [String: Any] = [:]
//    var bookingSource: String? = ""
//    
//    // Initialization...
//    init(details: [String: Any]) {
//        
//        // default...
//        booking_id = ""
//        app_reference = ""
//        
//        check_in = ""
//        check_out = ""
//        
//        hotel_name = ""
//        hotel_address = ""
//        hotel_img = ""
//        
//        status_type = ""
//        reference_id = ""
//        status = ""
//        hotel_info = details
//        
//        // assign...
//        if let hotelBookId = details["booking_id"] as? String {
//            booking_id = hotelBookId
//        }
//        if let bookingSource = details["booking_source"] as? String {
//            self.bookingSource = bookingSource
//        }
//        if let app_ref = details["app_reference"] as? String {
//            app_reference = app_ref
//        }
//
//        if let checkIn = details["hotel_check_in"] as? String {
//            
//            checkIn_date = DateFormatter.getDate(formate: "yyyy-MM-dd", date: checkIn)
//            check_in = DateFormatter.getDateString(formate: "MMM dd, yyyy", date: checkIn_date)
//        }
//        if let checkOut = details["hotel_check_out"] as? String {
//            
//            checkOut_date = DateFormatter.getDate(formate: "yyyy-MM-dd", date: checkOut)
//            check_out = DateFormatter.getDateString(formate: "MMM dd, yyyy", date: checkOut_date)
//        }
//        
//        noof_night = DateFormatter.getDaysBetweenTwoDates(startDate: checkIn_date,
//                                                          endDate: checkOut_date)
//        
//        
//        
//        if let hotelName = details["hotel_name"] as? String {
//            hotel_name = hotelName
//        }
//
//        
//        if let referenceId = details["app_reference"] as? String {
//            reference_id = referenceId
//        }
//        if let statusID = details["status"] as? String {
//            status = statusID
//        }
//        
//        hotel_price = Float(String.init(describing: details["total_fare"]!))!
//        if let hotelCurrency = details["currency"] as? String {
//            hotel_currency = hotelCurrency
//        }
//        if let statusType = details["type"] as? String {
//            status_type = statusType
//        }
//        
//        if let attr = details["attributes"] as? String {
//            
//            if let attr_dict = VKAPIs.getObject(jsonString: attr) as? [String: Any] {
//                print("attr_dict : \(attr_dict)")
//                
//                if let hotelAddress = attr_dict["HotelAddress"] as? String {
//                    hotel_address = hotelAddress
//                }
//                
//                if let HotelImage = attr_dict["HotelImage"] as? String {
//                    hotel_img = HotelImage
//                }
//            }
//        }
//    }
//}
//
struct DBusHistoryItem {
    //variables...
    var app_reference : String? = ""
    var arrival_datetime : String? = ""
    var arrival_to : String? = ""
    var booking_source : String? = ""
    var created_datetime : String? = ""
    var departure_datetime : String? = ""
    var departure_from : String? = ""
    var dropping_at : String? = ""
    var fare : Float? = 0.0
    var journey_datetime : String? = ""
    var operato : String? = ""
    var pnr : String? = ""
    var seat_no : String? = ""
    var seat_type : String? = ""
    var status : String? = ""
    var ticket : String? = ""
    var transaction : String? = ""
    var grand_total: Float? = 0.0
    
    
    init(details: [String: Any]) {
        if let app_reference = details["app_reference"] as? String {
            self.app_reference = app_reference
        }
        if let arrival_datetime = details["arrival_datetime"] as? String {
            self.arrival_datetime = arrival_datetime
        }
        if let arrival_to = details["arrival_to"] as? String {
            self.arrival_to = arrival_to
        }
        if let booking_source = details["booking_source"] as? String {
            self.booking_source = booking_source
        }
        if let created_datetime = details["created_datetime"] as? String {
            self.created_datetime = created_datetime
        }
        if let departure_datetime = details["departure_datetime"] as? String {
            self.departure_datetime = departure_datetime
        }
        if let departure_from = details["departure_from"] as? String {
            self.departure_from = departure_from
        }
        if let dropping_at = details["dropping_at"] as? String {
            self.dropping_at = dropping_at
        }
        
        self.fare = Float(String.init(describing: details["fare"]!))!
        
        if let journey_datetime = details["journey_datetime"] as? String {
            self.journey_datetime = journey_datetime
        }
        if let operato = details["operator" ] as? String {
            self.operato = operato
        }
        if let pnr = details["pnr"] as? String {
            self.pnr = pnr
        }
        if let seat_no = details["seat_no"] as? String {
            self.seat_no = seat_no
        }
        if let seat_type = details["seat_type"] as? String {
            self.seat_type = seat_type
        }
        if let status = details["status"] as? String {
            self.status = status
        }
        if let ticket = details["ticket"] as? String {
            self.ticket = ticket
        }
        if let transaction = details["transaction"] as? String {
            self.transaction = transaction
        }
        if let grand_total = details["grand_total"] as? String {
            self.grand_total = Float(grand_total) //Float(String.init(describing: details["grand_total"]))!
        }
        if let grand_total = details["grand_total"] as? Int {
            self.grand_total = Float(grand_total)
        }
        if let grand_total = details["grand_total"] as? Double {
            self.grand_total = Float(grand_total)
        }
    }
}
//
//struct DTransferHistoryItem {
//
//    var booking_id : String? = ""
//    var star_rating    : String? = ""
//    var travel_date    : String? = ""
//    var currency_conversion_rate   : Float? = 0.0
//    var grade_desc : String? = ""
//    var phone_code : String? = ""
//    var app_reference  : String? = ""
//    var convinence_value   : Float? = 0.0
//    var convinence_per_pax : Float? = 0.0
//    var confirmation_reference : String? = ""
//    var origin : String? = ""
////    var attributes : String? = ""
//    var grade_code : String? = ""
//    var payment_mode   : String? = ""
//    var convinence_amount  : Float? = 0.0
//    var status : String? = ""
//    var promo_code : String? = ""
//    var currency   : String? = ""
//    var booking_source : String? = ""
//    var booking_reference  : String? = ""
//    var alternate_number   : String? = ""
//    var portal : String? = ""
//    var created_by_id  : String? = ""
//    var created_datetime   : String? = ""
//    var phone_number   : String? = ""
//    var total_fare : Float? = 0.0
//    var email  : String? = ""
//    var product_name   : String? = ""
//    var product_code   : String? = ""
//    var discount   : Float? = 0.0
//    var ProductImage   : String? = ""
//
//
//
//    init(details: [String: Any]){
//        
//        if let booking_id = details["booking_id"] as? String {
//            self.booking_id = booking_id
//        }
//        if let star_rating = details["star_rating"] as? String {
//            self.star_rating = star_rating
//        }
//        if let travel_date = details["travel_date"] as? String {
//            var date = Date()
//            date = DateFormatter.getDate(formate: "yyyy-MM-dd", date: travel_date)
//            self.travel_date = DateFormatter.getDateString(formate: "MMM dd, yyyy", date: date)
////            self.travel_date= travel_date
//        }
//        if let currency_conversion_rate = details["currency_conversion_rate"] as? Float {
//            self.currency_conversion_rate = currency_conversion_rate
//        }
//        if let grade_desc = details["grade_desc"] as? String {
//            self.grade_desc = grade_desc
//        }
//        if let phone_code = details["phone_code"] as? String {
//            self.phone_code = phone_code
//        }
//        if let app_reference = details["app_reference"] as? String {
//            self.app_reference = app_reference
//        }
//        if let convinence_value = details["convinence_value"] as? Float {
//            self.convinence_value = convinence_value
//        }
//        if let convinence_per_pax = details["convinence_per_pax"] as? Float {
//            self.convinence_per_pax = convinence_per_pax
//        }
//        if let confirmation_reference = details["confirmation_reference"] as? String {
//            self.confirmation_reference = confirmation_reference
//        }
//        if let origin = details["origin"] as? String {
//            self.origin = origin
//        }
//        if let attributes = details["attributes"] as? String {
//            if let attr_dict = VKAPIs.getObject(jsonString: attributes) as? [String: Any] {
//                if let productImage = attr_dict["ProductImage"] as? String {
//                    print(attr_dict["ProductImage"]!)
//                    print(productImage)
//                    self.ProductImage = productImage
//                }
//            }
//        
//        }
//        
//        if let grade_code = details["grade_code"] as? String {
//            self.grade_code = grade_code
//        }
//        if let payment_mode = details["payment_mode"] as? String {
//            self.payment_mode = payment_mode
//        }
//        if let convinence_amount = details["convinence_amount"] as? Float {
//            self.convinence_amount = convinence_amount
//        }
//        if let status = details["status"] as? String {
//            self.status = status
//        }
//        if let promo_code = details["promo_code"] as? String {
//            self.promo_code = promo_code
//        }
//        if let currency = details["currency"] as? String {
//            self.currency = currency
//        }
//        if let booking_source = details["booking_source"] as? String {
//            self.booking_source = booking_source
//        }
//        if let booking_reference = details["booking_reference"] as? String {
//            self.booking_reference = booking_reference
//        }
//        if let alternate_number = details["alternate_number"] as? String {
//            self.alternate_number = alternate_number
//        }
//        if let portal = details["portal"] as? String {
//            self.portal = portal
//        }
//        if let created_by_id = details["created_by_id"] as? String {
//            self.created_by_id = created_by_id
//        }
//        if let created_datetime = details["created_datetime"] as? String {
//            
//            var date = Date()
//            date = DateFormatter.getDate(formate: "yyyy-MM-dd", date: created_datetime)
//            self.created_datetime = DateFormatter.getDateString(formate: "MMM dd, yyyy", date: date)
////             = created_datetime
//        }
//        if let phone_number = details["phone_number"] as? String {
//            self.phone_number = phone_number
//        }
//        if let total_fare = details["total_fare"] as? String {
//            self.total_fare = Float(total_fare)
//        }
//        if let email = details["email"] as? String {
//            self.email = email
//        }
//        if let product_name = details["product_name"] as? String {
//            self.product_name = product_name
//        }
//        if let product_code = details["product_code"] as? String {
//            self.product_code = product_code
//        }
//        if let discount = details["discount"] as? Float {
//            self.discount = discount
//        }
//   
//    }
//}
//// MARK: - DCarHistoryItem
//struct DCarHistoryItem {
//    // elements...
//    var booking_id: String?
//    var car_name: String?
//    var car_from_Date: String?
//    var car_from_Time: String?
//    
//    var car_to_Date: String?
//    var car_to_Time: String?
//
//    var pickup_Loc: String?
//    var drop_Loc: String?
//
//    var booking_status: String?
//    var bookingDate: String?
//    var currency: String?
//    var total_fare: String?
//    var booking_source: String?
//    
//    var attributes: String?
//    var address: String?
//    var carImg: String?
//    
//    init(details: [String: Any]) {
//        
//        // default info...
//        self.booking_id = ""
//        self.car_name = ""
//        self.car_from_Date = ""
//        self.car_from_Time = ""
//        
//        self.car_to_Date = ""
//        self.car_to_Time = ""
//        
//        self.booking_status = ""
//        self.bookingDate = ""
//        
//        self.currency = "USD"
//        self.booking_source = ""
//        
//        self.attributes = ""
//        self.address = ""
//        self.carImg = ""
//        self.total_fare = ""
//        
//        
//        // holiday details...
//        if let app_reference = details["app_reference"] as? String {
//            self.booking_id = app_reference
//        }
//        
//        if let app_reference = details["hotel_name"] as? String {
//            self.car_name = app_reference
//        }
//        
//        if let app_reference = details["booking_source"] as? String {
//            self.booking_source = app_reference
//        }
//    
//        if let app_reference = details["currency"] as? String {
//            self.currency = app_reference
//        }
//        
//        if let status = details["status"] as? String {
//            self.booking_status = status
//        }
//        
//        if let journey_start = details["created_datetime"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
//            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//        }
//        
//        if let journey_start = details["car_from_date"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_start)
//            self.car_from_Date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//        }
//        
//        if let journey_start = details["pickup_time"] as? String {
//            self.car_from_Time = journey_start
//        }
//        
//        if let journey_end = details["car_to_date"] as? String {
//            
//            let arrivalDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_end)
//            self.car_to_Date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrivalDate)
//        }
//        
//        
//        if let journey_end = details["drop_time"] as? String {
//            self.car_to_Time = journey_end
//        }
//        
//        
//        if let amount = details["total_fare"] as? String {
//            self.total_fare = amount
//        }
//        if let amount = details["car_pickup_lcation"] as? String {
//            self.pickup_Loc = amount
//        }
//        if let amount = details["car_drop_location"] as? String {
//            self.drop_Loc = amount
//        }
//        
//        
//        
//        
//    }
//}
