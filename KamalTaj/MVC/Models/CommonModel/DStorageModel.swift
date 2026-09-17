//
//  DStorageModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

struct DStorageModel {

    // MARK:- Variables
    static var airlineArray: [[String: String]] = []
    static var hotelCitiesArray: [[String: String]] = []
    static var countriesISO_array: [[String: String]] = []
    static var currency_array: [CurrencyModel] = []
    static var prefferedAirlines: [[String: String]] = []
    static var states : [[String: String]] = []
    static var busCitiesArray: [[String: String]] = []
    static var carCitiesArray: [[String: String]] = []

    // MARK:- API's
    static func gettingAirlinesList() {
        
        if DStorageModel.airlineArray.count == 0 {
            
            var airlinesList: [[String: String]] = []
            let csvFilePath = Bundle.main.path(forResource: "flight_airport_list", ofType: "csv")
            do {
                
                let csvFileDataStr = try String.init(contentsOfFile: csvFilePath!, encoding: .utf8)
                let citysArray = csvFileDataStr.components(separatedBy: "\n")
                print("Airlines count before: \(citysArray.count)")
                
                for csvString in citysArray {
                    
                    let finalString = csvString.replacingOccurrences(of: "\"", with: "")
                    let citysFinalArray = finalString.components(separatedBy: ",")
                    
                    if citysFinalArray.count >= 5 {
                        
                        let airlineFullName = "\(citysFinalArray[2]), \(citysFinalArray[3]), \(citysFinalArray[4])"
                        let hCityDict:[String: String] = ["airline_id": citysFinalArray[0],
                                                          "airline_code": citysFinalArray[1],
                                                          "airline_name": citysFinalArray[2],
                                                          "airline_fullName": airlineFullName,
                                                          "airline_city": citysFinalArray[3],
                                                          "airline_country": citysFinalArray[4],
                                                          "airline_top_destination": citysFinalArray[5]]
                        airlinesList.append(hCityDict)
                    }
                    else {
                        print("Count over lap : \(citysFinalArray)")
                    }
                }
                print("Airlines count after: \(airlinesList.count)")
                DStorageModel.airlineArray = airlinesList
            }
            catch {
                print("File Read Error for file \(String(describing: csvFilePath))")
            }
        }
    }
    
    static func gettingHotelCitiesList() {
        
        if DStorageModel.hotelCitiesArray.count == 0 {
            
            var cityList: [[String: String]] = []
            let csvFilePath = Bundle.main.path(forResource: "all_api_city_master_new", ofType: "csv")
            print(csvFilePath)
            do {
                
                let csvFileDataStr = try String.init(contentsOfFile: csvFilePath!, encoding: .utf8)
                let hotelCityArray = csvFileDataStr.components(separatedBy: "\n")
                print("Hotel count before: \(hotelCityArray.count)")
                
                for csvString in hotelCityArray {
                    
                    let finalString = csvString.replacingOccurrences(of: "\"", with: "")
                    let hCitysFinalArray = finalString.components(separatedBy: ",")
                    
                    if hCitysFinalArray.count >= 5 {
                        
                        let hCityDict:[String: String] = ["id": hCitysFinalArray[0],
                                                          "city": hCitysFinalArray[1],
                                                          "country": hCitysFinalArray[2]]
                        cityList.append(hCityDict)
                    }
                    else {
                        print("Hotel Count over lap : \(hCitysFinalArray)")
                    }
                }
                print("Hotel count after: \(cityList.count)")
                DStorageModel.hotelCitiesArray = cityList
            }
            catch {
                print("File Read Error for file \(String(describing: csvFilePath))")
            }
        }
    }
    
    static func gettingBusesCitiesList() {
        
        if DStorageModel.busCitiesArray.count == 0 {
            
            var cityList: [[String: String]] = []
            let csvFilePath = Bundle.main.path(forResource: "bus_stations", ofType: "csv")
            print(csvFilePath)
            do {
                let csvFileDataStr = try String.init(contentsOfFile: csvFilePath!, encoding: .ascii)
                let hotelCityArray = csvFileDataStr.components(separatedBy: "\n")
                print("Buses count before: \(hotelCityArray.count)")
                
                for csvString in hotelCityArray {
                    
                    let finalString = csvString.replacingOccurrences(of: "\"", with: "")
                    let sCitysFinalArray = finalString.components(separatedBy: ",")
                    
                    if sCitysFinalArray.count >= 3 {
                        
                        let sCityDict:[String: String] = ["id": sCitysFinalArray[1],
                                                          "city": sCitysFinalArray[2],
                                                          "state": sCitysFinalArray[3]]
                        cityList.append(sCityDict)
                    }
                    else {
                        print("buses Count over lap : \(sCitysFinalArray)")
                    }
                }
                print("buses count after: \(cityList.count)")
                DStorageModel.busCitiesArray = cityList
            }
            catch {
                print("File Read Error for file \(String(describing: csvFilePath))")
            }
        }
    }
    
    static func gettingCountryISOList() {
        
        // getting country ios list...
        VKAPIs.shared.getRequest(params: nil, file:"" , httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("ISO countries success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_array = result["data"] as? [[String: String]] {
                            countriesISO_array = data_array
                        }
                    }
                }
                else {
                    print("ISO countries formate : \(String(describing: resultObj))")
                }
            }
            else {
                print("ISO countries error : \(String(describing: error?.localizedDescription))")
            }
            //NotificationCenter.default.post(name: NSNotification.Name(kISONotify), object: nil)
        }
    }
    
    static func gettingCurrencyCountries() {
        
        // getting flag and currency list...
        VKAPIs.shared.getRequest(file:Get_CurrencyList , httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("currency countries success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_array = result["data"] as? [[String: String]] {
                            
                            currency_array.removeAll()
                            for i in 0 ..< data_array.count {
                                let model = CurrencyModel.init(details: data_array[i])
                                currency_array.append(model);
                            }
                        }
                    }
                } else {
                    print("currency countries formate : \(String(describing: resultObj))")
                }
            } else {
                print("currency countries error : \(String(describing: error?.localizedDescription))")
            }
            //NotificationCenter.default.post(name: NSNotification.Name(kCurrencyNotify), object: nil)
        }
    }
    
    static func settingCurrencyCountries(currency_code: String) {
        
        // getting flag and currency list...
        SwiftLoader.show(animated: true)
        let params:[String: String] = ["currency": currency_code]
        
        VKAPIs.shared.getRequestRaw(params: params, file: "", httpMethod: .PUT)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("currency selection success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: String] {
                            
                            // change authorization...
                            if let refresh_token = data_dict["auth_key"] {
                                VKAPIs.shared.headers!["authentication"] =  refresh_token
                            }
                            print("headers : \(String(describing: VKAPIs.shared.headers))")
                                
                            
                            // profile key changes...
                            let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
                            if userProfile is [String: Any] {
                                
                                // change authentication...
                                var tempProfile: [String: Any] = userProfile as! [String: Any]
                                if let refresh_token = data_dict["auth_key"] {
                                    tempProfile["auth_key"] = refresh_token
                                }
                                tempProfile["currency"] = currency_code
                                UserDefaults.standard.set(tempProfile, forKey: TMXUser_Profile)
                            }
                            
                            
                            // selection...
                            for i in 0 ..< currency_array.count {
                                currency_array[i].index = 0
                                if currency_array[i].currency_code == currency_code {
                                    currency_array[i].index = 1
                                }
                            }
                        }
                    }
                } else {
                    print("currency selection formate : \(String(describing: resultObj))")
                }
            } else {
                print("currency selection error : \(String(describing: error?.localizedDescription))")
            }
            
            //NotificationCenter.default.post(name: NSNotification.Name(kCurrencyNotify), object: nil)
            SwiftLoader.hide()
        }
    }
    static func gettingAirlineCodeList() -> Void {
        SwiftLoader.show(animated: true)

        // params...
//        let params: [String: String] = ["name": cityText] //char
//        print(params)÷
        // calling api...
        VKAPIs.shared.getRequest(file: "general/get_airline_code_list", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Airline List: \(String(describing: resultObj))")
                
                // response date...
                if let result_dict = resultObj as? [String: Any] {
                    
                    if let data_array = result_dict["airlinelist"] as? [String: Any] {
                        if let airlist = data_array["data"] as? [[String: String]] {
//                            self.prefferedAirlines.removeAll()
                            DStorageModel.prefferedAirlines = airlist
//                        for i in 0 ..< data_array.count {
//                            let model = AirlineModel.init(details: data_array[i])
//                            currency_array.append(model);
//                        }
//                            self.searchDisplayArray = airlist
//                            self.tbl_search.reloadData()

                        }
                    }
                }
            } else {
                print("Airlines City error : \(String(describing: error?.localizedDescription))")
            }
        }
        SwiftLoader.hide()

    }
    static func gettingStateList(){
        SwiftLoader.show(animated: true)

        // calling api...
        VKAPIs.shared.getRequest(file: "general/get_statelist", httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("State List: \(String(describing: resultObj))")
                
                // response date...
                if let result_dict = resultObj as? [String: Any] {
                    
//                    if let data_array = result_dict["state_list"] as? [String: Any] {
                        if let statelist = result_dict["state_list"] as? [[String: String]] {
//                            self.prefferedAirlines.removeAll()
                            DStorageModel.states = statelist
                        }
//                    }
                }
            } else {
                print("State List error : \(String(describing: error?.localizedDescription))")
            }
            print(DStorageModel.states)
        }
        
        SwiftLoader.hide()

    }
    static func gettingCarAiportsList() {
        
        if DStorageModel.carCitiesArray.count == 0 {
            
            var airlinesList: [[String: String]] = []
            let csvFilePath = Bundle.main.path(forResource: "carnect_aiport_list", ofType: "csv")
            do {
                
                let csvFileDataStr = try String.init(contentsOfFile: csvFilePath!, encoding: .ascii)
                let citysArray = csvFileDataStr.components(separatedBy: "\n")
                print("Airlines count before: \(citysArray.count)")
                
                for csvString in citysArray {
                    
                    let finalString = csvString.replacingOccurrences(of: "\"", with: "")
                    let citysFinalArray = finalString.components(separatedBy: ",")
                    
                    if citysFinalArray.count >= 5 {
                        
                        let airlineFullName = "\(citysFinalArray[1]), \(citysFinalArray[2])"
                        let hCityDict:[String: String] = ["airline_id": citysFinalArray[0],
                                                          "airline_code": citysFinalArray[4],
                                                          "airline_name": citysFinalArray[1],
                                                          "airline_fullName": airlineFullName,
                                                          "airline_city": citysFinalArray[4],
                                                          "airline_country": citysFinalArray[2],
                                                          "airline_top_destination": citysFinalArray[5]]
                        airlinesList.append(hCityDict)
                    }
                    else {
                        print("Count over lap : \(citysFinalArray)")
                    }
                }
                print("Airlines count after: \(airlinesList.count)")
                DStorageModel.carCitiesArray = airlinesList
                
            }
            catch {
                print("File Read Error for file \(String(describing: csvFilePath))")
            }
        }
    }
}

// MARK:- CurrencyModel
struct CurrencyModel {
    
    // variables...
    var currency_code: String?
    var currency_image: String?
    var index: Int = 0

    init(details: [String: Any]) {
        
        currency_code = ""
        currency_image = ""
        
        if let c_code = details["currency"] as? String {
            currency_code = c_code
        }
        if let c_image = details["flag"] as? String {
            currency_image = c_image
        }
        
        // profile key changes...
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // currency compare...
            let tempProfile: [String: Any] = userProfile as! [String: Any]
            if let refresh_token = tempProfile["currency"] as? String {
                if refresh_token == currency_code {
                    index = 1
                }
            }
        }
    }
}
//struct PrefferedAirlineModel{
//    code = Q5;
//    "has_specific_markup" = 0;
//    name = "40 Mile Air";
//    origin = 584;
//}
