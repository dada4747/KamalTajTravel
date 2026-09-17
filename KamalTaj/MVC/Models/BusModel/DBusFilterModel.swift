//
//  DBusFilterModel.swift
//  EasiTripBooking
//
//  Created by Admin on 29/11/25.
//

import Foundation
import AVFoundation
struct DBusFilters {
    
    static var price_default: (Float, Float) = (0, 1)
    static var price_selection: (Float, Float) = (0, 1)
    
    static var noofStops: [Int] = [0, 0, 0, 0]
    static var depart: [Int] = [0, 0, 0, 0]
    static var arrival: [Int] = [0, 0, 0, 0]
    
    static var operator_array: [String] = []
    static var busSelection_array: [String] = []
    
    static var sort_number = -1
    static var currency_code = "AUD"
    
    // clear the filters...
    static func clearAllFilters() {
        
        // fliters
        price_default = (0, 1)
        price_selection = (0, 1)
        
        noofStops = [0, 0, 0, 0]
        depart = [0, 0, 0, 0]
        arrival = [0, 0, 0, 0]
        
        operator_array.removeAll()
        busSelection_array.removeAll()
        
        sort_number = -1
    }
    static func getOperatorAndPrice_fromResponse(){
        var operator_array: [String] = []
        var operatorTicket_array: [Float] = []
        
        for model in DBusSearchModel.busSearch_array {
            operator_array.append(model.CompanyName!)
            operatorTicket_array.append(model.Fare)
            
        }
        self.clearAllFilters()
        
        //final operator names....
        operator_array = DBusFilters().removeDuplicates(array: operator_array)
        for operatorName in operator_array {
            DBusFilters.operator_array.append(operatorName)
            
        }
        print("Operators Name : \(operator_array)")
        
        //min and max
        DBusFilters.price_default = DBusFilters().getMinAndMaxValue(price_array: operatorTicket_array)
        DBusFilters.price_selection = DBusFilters().getMinAndMaxValue(price_array: operatorTicket_array)
        
        print("Min: \(DBusFilters.price_default.0) - Max : \(DBusFilters.price_default.1)")
        
    }
}
extension DBusFilters {
    static func applyAll_filterAndSorting(_depart: [DBusesSearchItem]) -> ([DBusesSearchItem]) {
        print("Normal List = Depart: \(_depart.count)")
        
        // price Filters...
        let price_depart = _depart.filter{ ($0.Fare >= DBusFilters.price_selection.0 && $0.Fare <= DBusFilters.price_selection.1)}
        print("\n After price = depart: \(price_depart)")
        // Bus type filter
        let busTypefilter = type_bus(_depart: price_depart)
        
        // depart filter
        let departFilter = departTiming_filter(_depart: busTypefilter)
//        print("\n After Depart = depart:\(departFilter)")
        let arrivalFilter = arrivalTiming_busFilter(_depart: departFilter)
//        print("After arrival = depart: \(arrivalFilter)")
        let operatorFilter = operatorName_filter(_depart: arrivalFilter)
//        print("\n After operator filter = depart: \(operatorFilter.count)")
        let sortingFilter = sorting_buses(_depart: operatorFilter)
        return sortingFilter
    }
    
}
extension DBusFilters{
    static func sorting_buses(_depart: [DBusesSearchItem]) -> [DBusesSearchItem]{
        
        var depart_array = _depart
        
        if DBusFilters.sort_number == 0 {
            let result = depart_array.sorted(by: {$0.Fare < $1.Fare})
            depart_array = result
            
        }
        else if DBusFilters.sort_number == 1 {
            let result = depart_array.sorted(by: {$0.Fare > $1.Fare})
            depart_array = result

        }
        else if DBusFilters.sort_number == 2 {
            let result = depart_array.sorted(by: {
                $0.start_date.compare($1.start_date) == .orderedAscending
            })
            depart_array = result
        }
        else if DBusFilters.sort_number == 3 {
            let result = depart_array.sorted(by: {
                $0.start_date.compare($1.start_date) == .orderedDescending
            })
            depart_array = result
        }
        else if DBusFilters.sort_number == 4 {
            
            let results = depart_array.sorted(by: { $0.duration_seconds < $1.duration_seconds })
            depart_array = results
            
        }
        else if DBusFilters.sort_number == 5 {
            
            let results = depart_array.sorted(by: { $0.duration_seconds > $1.duration_seconds })
            depart_array = results
            
        }
        else if DBusFilters.sort_number == 6 {
            
            let results_1 = depart_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedAscending })
            depart_array = results_1
            
        }
        else if DBusFilters.sort_number == 7 {
            
            let results_1 = depart_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedDescending })
            depart_array = results_1
            
        }
        else if DBusFilters.sort_number == 8 {
            let result_1 = depart_array.sorted(by: {$0.CompanyName! < $1.CompanyName!})
            depart_array = result_1
            
        } else if DBusFilters.sort_number == 9 {
            let result_1 = depart_array.sorted(by: {$0.CompanyName! > $1.CompanyName!})
            depart_array = result_1
        }
        else {
            print("==>>There is no flight sorting")
        }

        return depart_array
    }
}
extension DBusFilters {
    // MARK:- Stops
    static func type_bus(_depart: [DBusesSearchItem]) -> ( [DBusesSearchItem]) {
        
        // selected or not...
        var stopBool = false
        for value in DBusFilters.noofStops {
            if value == 1 {
                stopBool = true
                break
            }
        }
        
        // there is no stop filters...
        if stopBool == false {
            print("=> There no stops filter")
            return (_depart)
        }
        
        // variables...
        var depart_array: [DBusesSearchItem] = []
        
        // Stop zero elements...
        if DBusFilters.noofStops[0] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 0 }
            depart_array += filter_depart
            print("0 - Depart stops : \(depart_array.count)")
        }
        
        // Stop 1 elements...
        if DBusFilters.noofStops[1] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 1 }
            depart_array += filter_depart
            print("1 - Depart stops : \(depart_array.count)")
        }
        
        // Stop 1+ elements...
        if DBusFilters.noofStops[2] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 2 }
            depart_array += filter_depart
            print("1+ - Depart stops : \(depart_array.count)")
        }
        //stop
        if DBusFilters.noofStops[3] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 3 }
            depart_array += filter_depart
            print("1+ - Depart stops : \(depart_array.count)")
        }
        return (depart_array)
    }
    static func operatorName_filter(_depart: [DBusesSearchItem])->[DBusesSearchItem]{
        //if no filtes
        if self.busSelection_array.count == 0 {
            print("=> there no operator filter")
            return (_depart)
            
        }
        //variable...
        var depart_array : [DBusesSearchItem] = []
        for model in _depart {
            if self.busSelection_array.contains(model.CompanyName!) {
                depart_array.append(model)
            }
        }
        return (depart_array)
    }
    static func departTiming_filter(_depart: [DBusesSearchItem]) -> [DBusesSearchItem]{
        //selected or not...
        var stopBool = false
        for value in DBusFilters.depart {
            if value == 1 {
                stopBool = true
                break
            }
        }
        //there is no stop filters...
        if stopBool == false {
            print("=> There no depart filter")
            return(_depart)
        }
        //variables...
        var depart_array : [DBusesSearchItem] = []
        
        // depart(0-6) elements...
        if DBusFilters.depart[0] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 0 }
            depart_array += filter_depart
            print("0 - Depart Dtime : \(depart_array.count)")
            
        }
        
        // depart(6-12) elements...
        if DBusFilters.depart[1] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 1 }
            depart_array += filter_depart
            print("1 - Depart Dtime : \(depart_array.count)")
            
        }
        
        // depart(12-18) elements...
        if DBusFilters.depart[2] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 2 }
            depart_array += filter_depart
            print("2 - Depart Dtime : \(depart_array.count)")
            
        }
        
        // depart(18-24) elements...
        if DBusFilters.depart[3] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 3 }
            depart_array += filter_depart
            print("3 - Depart Dtime : \(depart_array.count)")
            

        }
        
        
        return (depart_array)
        
    }
    //mark: Arrival
    static func arrivalTiming_busFilter(_depart: [DBusesSearchItem]) -> ([DBusesSearchItem]){
        //selected or not...
        var stopBool = false
        for value in DBusFilters.arrival {
            if value == 1 {
                stopBool = true
                break
            }
        }
        //there is no stop filters...
        if stopBool == false {
            print("There no arrival filter")
            return (_depart)
        }
        //variables...
        var depart_array : [DBusesSearchItem] = []
        // depart(0-6) elements...
        if DBusFilters.arrival[0] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 0 }
            depart_array += filter_depart
            print("0 - Depart Atime : \(depart_array.count)")
            
        }
        
        // depart(6-12) elements...
        if DBusFilters.arrival[1] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 1 }
            depart_array += filter_depart
            print("1 - Depart Atime : \(depart_array.count)")
            
           
        }
        
        // depart(12-18) elements...
        if DBusFilters.arrival[2] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 2 }
            depart_array += filter_depart
            print("2 - Depart Atime : \(depart_array.count)")
            
        }
        
        // depart(18-24) elements...
        if DBusFilters.arrival[3] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 3 }
            depart_array += filter_depart
            print("3 - Depart Atime : \(depart_array.count)")
            
          
        }
        
        return (depart_array)
    }

}
extension DBusFilters {
    func removeDuplicates(array: [String]) -> [String] {
        
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                result.append(value)
            }
        }
        return result
    }
    func getMinAndMaxValue(price_array: [Float]) -> (Float, Float) {
        
        var minValue: Float = 0.0
        var maxValue: Float = 1.0
        
        // first element
        if price_array.count != 0 {
            minValue = price_array[0]
            maxValue = price_array[0]
        }
        
        // final loops...
        for i in 0 ..< price_array.count {
            
            let price = price_array[i]
            if minValue > price {
                minValue = price
            }
            
            if maxValue < price {
                maxValue = price
            }
        }
        return (minValue, maxValue)
    }
}
