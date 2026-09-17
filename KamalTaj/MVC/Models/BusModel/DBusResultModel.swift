//
//  DBusResultModel.swift
//  EasiTripBooking
//
//  Created by Admin on 20/11/25.
//

import Foundation
struct DBusResultModel {
    
    static var busSeatAttributDetails : [String : Any] = [:]
    static var bus_Selected_Seats_list : [SeatDetails?] = []
    static var bus_final_total_price : Float = 0.0
    static var bus_discount : Float = 0.0
    static var selected_dropOff : DPickupDropItem = DPickupDropItem(details: [:], type: .dropoff)
    static var selected_boarding : DPickupDropItem = DPickupDropItem(details: [:], type: .pickup)
    static var selectedBus : DBusesSearchItem?
    static var convenienceFee : Float = 0.0
    static var gst : Float = 0.0
//    static var activePaymentOptions: [String] = []
    static var activePaymentOptions: [PaymentOption] = []


}
