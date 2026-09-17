//
//  DBTravelModel.swift
//  EasiTripBooking
//
//  Created by Admin on 14/11/25.
//

import Foundation

struct DBTravelModel {
    static var departDate = Date()
    static var sourceCity: [String : Any] = [:]
    static var destinationCity: [String: Any] = [:]
    static var selectdBus = DBusesSearchItem(details: [:])
    static var selectedSeats : [SeatDetails] = []
    static var boardingPoint = DPickupDropItem(details: [:], type: .pickup)
    static var dropPoint = DPickupDropItem(details: [:], type: .dropoff)
    static var bookingType = "Other"
    static func clearAllTraveller(){
        
    }

}
