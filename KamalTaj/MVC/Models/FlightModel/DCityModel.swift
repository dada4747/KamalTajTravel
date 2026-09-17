//
//  DCityModel.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

struct DCityModel {
    
    // elements...
    var depart_cityId: String?
    var depart_cityName: String?
    var depart_cityCode: String?
    
    var arrival_cityId: String?
    var arrival_cityName: String?
    var arrival_cityCode: String?
    
    var noof_days: String?
    var start_date: String?
    var end_date: String?
   
    static var mulityCitiesArray: [DCityModel] = []
    
    // initialization...
    init() {
        
        self.depart_cityId = ""
        self.depart_cityName = ""
        self.depart_cityCode = ""
        
        self.arrival_cityId = ""
        self.arrival_cityName = ""
        self.arrival_cityCode = ""
        
        self.noof_days = ""
        self.start_date = ""
        self.end_date = ""
    }
    
    // static method...
    static func createModel() -> [DCityModel] {
        
        // max multi cities = 5
        if self.mulityCitiesArray.count == 5 {
            return self.mulityCitiesArray
        }
        
        // create city models...
        var model = DCityModel()
        model.arrival_cityName = ""
        model.depart_cityName = ""
        model.start_date = ""
        model.arrival_cityCode = ""
        model.depart_cityCode = ""
        model.arrival_cityId = ""
        model.depart_cityId = ""
        self.mulityCitiesArray.append(model)
        return  self.mulityCitiesArray
    }
}
