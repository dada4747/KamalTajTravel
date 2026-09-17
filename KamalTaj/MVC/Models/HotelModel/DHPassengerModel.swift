//
//  DHPassengerModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

struct DHPassengerModel {
    static var allGuestsArray: [DHPassengerItem] = []

    // static list...
    static var adultArray: [DHPassengerItem] = []
    static var childArray: [DHPassengerItem] = []
    static var email_id = ""
    static var mobile_no = ""
    static var country_code:[String: String] = [:]
}

// MARK:- DPassengerItem
struct DHPassengerItem {
    var title_form: String = ""

    // variables...
    var person_id: String?
    var gender_value: String?
    var title_value: String?
    var person_type: String = "Adult"
    var isSelected = false
    
    var title_name: String?
    var first_name: String?
    var last_name: String?
    var dateOf_birth: String?

    
    init() {
    }
}
