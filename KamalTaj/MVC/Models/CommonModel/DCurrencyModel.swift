//
//  DCurrencyModel.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//


import UIKit

// MARK:- DCurrencyModel
struct DCurrencyModel {
    
    // storage information....
    static var currency_array: [DCurrencyItem] = []
    static var currency_saved: DCurrencyItem?
    
    static func createModel_Currency(result_array: [[String: Any]]) {
        
        currency_array.removeAll()
        for item_currency in result_array {
            let status_key = item_currency["status"] as? String ?? "0"
            if status_key == "1" {
                let model = DCurrencyItem.init(details: item_currency)
                currency_array.append(model)
            }
        }
    }
    
    static func setDefaultCurrency() {
        
        let currency: [String: Any] = ["id": "22",
                                       "country": "INR",
                                       "country_name": "",
                                       "currency_name": "",
                                       "currency_symbol": "\u{20B9}",
                                       "value": "1"]
        
        // covert object to data...
        let user_data = try? JSONSerialization.data(withJSONObject: currency, options: [])
        UserDefaults.standard.set(user_data, forKey: TMX_Currency)
    }
    
    static func saveCurrency(model: DCurrencyItem) {
        
        let currency: [String: Any] = ["id": model.currency_id ?? "",
                                       "country": model.currency_country ?? "",
                                       "country_name": model.currency_countryName ?? "",
                                       "currency_name": model.currency_name ?? "",
                                       "currency_symbol": model.currency_symbol ?? "",
                                       "value": model.currency_value]
        
        // covert object to data...
        let user_data = try? JSONSerialization.data(withJSONObject: currency, options: [])
        UserDefaults.standard.set(user_data, forKey: TMX_Currency)
    }
    
    static func retriveCurrency() -> DCurrencyItem? {
        
        // retrieving currency data to model...
        let data = UserDefaults.standard.data(forKey: TMX_Currency)
        do {
            
            let json_obj = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
            if let user_dict = json_obj as? [String: Any] {
                let curr_saved = DCurrencyItem.init(details: user_dict)
                return curr_saved
            }
        } catch let error as NSError {
            print("currency to load: \(error.localizedDescription)")
        }
        return nil
    }
}

// MARK:- DCurrencyItem
struct DCurrencyItem {
    
    // variables...
    var currency_id: String?
    var currency_country: String?
    var currency_countryName: String?
    var currency_value: Float = 1
    var currency_name: String?
    var currency_symbol: String?
    
    // Initialization...
    init(details: [String: Any]) {
        
        // default...
        currency_id = ""
        currency_country = "INR"
        currency_countryName = ""
        currency_name = ""
        currency_symbol = ""
        
        // assign...
        if let currencyID = details["id"] as? String {
            currency_id = currencyID
        }
        if let currencyCountry = details["country"] as? String {
            currency_country = currencyCountry
        }
        if let currencyCountryName = details["country_name"] as? String {
            currency_countryName = currencyCountryName
        }
        self.currency_value = Float(String.init(describing: details["value"]!))!
        
        if let currencyName = details["currency_name"] as? String {
            currency_name = currencyName
        }
        if let currencySym = details["currency_symbol"] as? String {
            currency_symbol = currencySym
        }
    }
}
