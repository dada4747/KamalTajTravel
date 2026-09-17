//
//  DTravelModel.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

// MARK: - DTravelModel
struct DTravelModel {

    // MARK: - Flight
    static var adultCount: Int = 1
    static var childCount: Int = 0
    static var infantCount: Int = 0
    
    static var flight_class = "Economy"
    static var departDate = Date()
    static var returnDate = Date()
    
    static var departAirline: [String: Any] = [:]
    static var destinationAirline: [String: Any] = [:]
    
    static var airlineDepart_id = ""
    static var airlineReturn_id = ""
    
    static var flightArrival_date = Date()
    static var preferedAirLine = ""
    static var moduleType: ModuleType = .Flight

    // trip types...
    static var tripType = TripType.OneWay
    enum TripType {
        case OneWay
        case Round
        case Multi
    }
    
    static func clearAllTraveller() {
        
        adultCount = 1
        childCount = 0
        infantCount = 0
        flight_class = "Economy"
        tripType = TripType.OneWay
        preferedAirLine = ""
    }
    
    static func passengerCount() -> Int {
        return (adultCount + childCount + infantCount)
    }
}
