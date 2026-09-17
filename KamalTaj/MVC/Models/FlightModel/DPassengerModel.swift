//
//  DPassengerModel.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

struct DPassengerModel {
    
    // static list...
    var title_form: String = ""
    static var allPassengerArray: [DPassengerItem] = []
    
    static var adultArray: [DPassengerItem] = []
    static var childArray: [DPassengerItem] = []
    static var infantArray: [DPassengerItem] = []
    
    static var email_id = ""
    static var mobile_no = ""
    static var country_code:[String: String] = [:]
}

// MARK: - DPassengerItem
struct DPassengerItem {
    
    // variables...
    var person_id: String?
    var gender_value: String?
    var title_value: String?
    var person_type: String = "Adult"
    var isSelected = true
    var title_form: String = ""

    var title_name: String?
    var first_name: String?
    var last_name: String?
    
    var email_id: String?
    var dateOf_birth: String?
    var ff_number: String?
    
    var passport_no: String?
    var passport_expiry: String?
    var issued_country: String?
    var issued_country_code: String?
    var countryISO_Dict : [String : Any ] = [:]

    var baggage_array: [String?] = []
    var baggageArray: [DFlightBaggageItem] = []
    var baggageItem = DFlightBaggageItem(details: [:])
    
    var meals_array: [String?] = []
    var mealsArray: [DFlightMealsItem] = []
    var mealsItem = DFlightMealsItem.init(details: [:])
    
    var seatsItem: [String: Any] = [:]
    var seatsArray: [[String: Any]] = []
    var isInfant: Bool {
        return person_type.lowercased() == "infant"
    }

    init() {
    }
}
