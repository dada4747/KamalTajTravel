//
//  DHTravelModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// MARK:- DHTravelModel
struct DHTravelModel {
    
    // elements...
    static var hotelCity_dict : [String : Any]?

    static var checkin_date = Date()
    static var checkout_date = Date()
    static var noof_nights: Int = 1
    
    static var select_hotel = DHotelSearchItem(details: [:])
    static var select_room = DHotelRoomItem(info: [:])
    static var grand_total: Float = 0.0
    
    static var adult_count = 1
    static var child_count = 0
    
    static var roomCount = 1
}


// MARK:- AddRoomModel
struct AddRoomModel {
    
    // variables...
    var adult_count: Int = 1
    var child_count: Int = 0
    var child_age1: Int = 2
    var child_age2: Int = 2
    
    static var addRooms_array: [AddRoomModel] = []
    
    init() {
    }
    
    // static method...
    static func createModel() -> [AddRoomModel] {
        
        // max rooms = 2
        if self.addRooms_array.count == 3 {
            return self.addRooms_array
        }
        
        // create room models...
        let model = AddRoomModel()
        self.addRooms_array.append(model)
        return  self.addRooms_array
    }
}
