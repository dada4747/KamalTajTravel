//
//  DPaymentMethodModel.swift
//  PuranTrip
//
//  Created by Rahul on 18/05/26.
//

import Foundation

import Foundation

class PaymentOption {
    
    var name: String
    var method: String
    var imgurl: String
    
    init(name: String, method: String, imgurl: String) {
        self.name = name
        self.method = method
        self.imgurl = imgurl
    }
    
    convenience init(dict: [String: Any]) {
        
        var name = ""
        var method = ""
        var imgurl = ""
        
        if let tempName = dict["name"] as? String {
            name = tempName
        }
        
        if let tempMethod = dict["method"] as? String {
            method = tempMethod
        }
        
        if let tempImgurl = dict["imgurl"] as? String {
            imgurl = tempImgurl
        }
        
        self.init(
            name: name,
            method: method,
            imgurl: imgurl
        )
    }
}
