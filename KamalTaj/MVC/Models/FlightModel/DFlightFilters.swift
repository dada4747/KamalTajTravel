//
//  DFlightFilters.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

// MARK:- DFlightFilters
struct DFlightFilters {
    
    // Fliter variables...
    static var price_default: (Float, Float) = (0, 1)
    static var price_selection: (Float, Float) = (0, 1)
    
    static var noofStops: [Int] = [0, 0, 0, 0]
    static var depart: [Int] = [0, 0, 0, 0]
    static var arrival: [Int] = [0, 0, 0, 0]
    static var fareType: [Int] = [0,0]
    
    static var flight_array: [String] = []
    static var flightSelection_array: [String] = []
    
    // Sort variables...
    static var sort_number = -1
    static var currency_code = "CAD"
    
    // clear the filters...
    static func clearAllFilters() {
        
        // fliters
        price_default = (0, 1)
        price_selection = (0, 1)
        
        noofStops = [0, 0, 0, 0]
        depart = [0, 0, 0, 0]
        arrival = [0, 0, 0, 0]
        fareType = [0, 0]
        
        flight_array.removeAll()
        flightSelection_array.removeAll()
        
        // sorts
        sort_number = -1
    }
}

extension DFlightFilters {
    
    // MARK:- Price and Airlines
    static func getAirlinesAndPrice_fromResponse() {
        
        // getting airlines name list...
        var airline_array: [String] = []
        var airlineTicket_array: [Float] = []
        
        if (DTravelModel.tripType == .Multi)
            || (DTravelModel.tripType == .Round && DFlightSearchModel.is_domestic == false) {
            
            // from mulit city...
            for model in DFlightSearchModel.flightMulti_array {
                
                airlineTicket_array.append(model.ticket_price)
                DFlightFilters.currency_code = model.currency_code
                for sub_model in model.flightsSearch_array {
                    airline_array.append(sub_model.airline_name!)
                }
            }
        }
        else {
            
            // from depart and returns...
            for model in DFlightSearchModel.flightsDepart_array {
                
                DFlightFilters.currency_code = model.currency_code!
                airlineTicket_array.append(model.ticket_price)
                airline_array.append(model.airline_name!)
            }
            for model in DFlightSearchModel.flightsReturn_array {
                
                DFlightFilters.currency_code = model.currency_code!
                airlineTicket_array.append(model.ticket_price)
                airline_array.append(model.airline_name!)
            }
        }
        
        // clear all filters..
        self.clearAllFilters()
        
        // final airlines names...
        airline_array = DFlightFilters().removeDuplicates(array: airline_array)
        for airline_name in airline_array {
            DFlightFilters.flight_array.append(airline_name)
        }
        print("Airline list :\(airline_array)")
        
        // min and max...
        DFlightFilters.price_default = DFlightFilters().getMinAndMaxValue(price_array: airlineTicket_array)
        DFlightFilters.price_selection = DFlightFilters().getMinAndMaxValue(price_array: airlineTicket_array)
        
        print("Min :\(DFlightFilters.price_default.0) - Max :\(DFlightFilters.price_default.1)")
    }
    
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


extension DFlightFilters {
    
    static func applyAll_filterAndSorting(_depart: [DFlightSearchItem],
                                          _return: [DFlightSearchItem],
                                          _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        print("Normal list = depart: \(_depart.count) return: \(_return.count) mulit: \(_mulit.count)")

        
        // price filters...
        let price_depart = _depart.filter { ($0.ticket_price >= DFlightFilters.price_selection.0 && $0.ticket_price <= DFlightFilters.price_selection.1)}
        let price_return = _return.filter { ($0.ticket_price >= DFlightFilters.price_selection.0 && $0.ticket_price <= DFlightFilters.price_selection.1)}
        let price_mulit = _mulit.filter { ($0.ticket_price >= DFlightFilters.price_selection.0 && $0.ticket_price <= DFlightFilters.price_selection.1)}
        print("\n After price = depart: \(price_depart.count) return: \(price_return.count) mulit: \(price_mulit.count)")
    
        
        let stopFilters = stops_flights(_depart: price_depart, _return: price_return, _mulit: price_mulit)
        print("\n After Stops = depart: \(stopFilters.0.count) return: \(stopFilters.1.count) mulit: \(stopFilters.2.count)")
        
        
        let departFilter = departTiming_flightFilter(_depart: stopFilters.0, _return: stopFilters.1, _mulit: stopFilters.2)
        print("\n After Depart = depart: \(departFilter.0.count) return: \(departFilter.1.count) mulit: \(departFilter.2.count)")
        
        let arrivalFilter = arrivalTiming_flightFilter(_depart: departFilter.0, _return: departFilter.1, _mulit: departFilter.2)
        print("\n After Arrival = depart: \(arrivalFilter.0.count) return: \(arrivalFilter.1.count) mulit: \(arrivalFilter.2.count)")
        
        let airlineFilter = airlineName_flights(_depart: arrivalFilter.0, _return: arrivalFilter.1, _mulit: arrivalFilter.2)
        print("\n After Airline = depart: \(airlineFilter.0.count) return: \(airlineFilter.1.count) mulit: \(airlineFilter.2.count)")
        
        let fareTypeFilter = fareType_flightsFilter(_depart: airlineFilter.0, _return: airlineFilter.1, _mulit: airlineFilter.2)
        print("\n After fareType = depart: \(fareTypeFilter.0.count) return: \(fareTypeFilter.1.count) mulit: \(fareTypeFilter.2.count)")
        
        let sortingFilter = sorting_flights(_depart: fareTypeFilter.0, _return: fareTypeFilter.1, _mulit: fareTypeFilter.2)
        return sortingFilter
    }
    
    // MARK:- Airline
    static func airlineName_flights(_depart: [DFlightSearchItem],
                                    _return: [DFlightSearchItem],
                                    _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        // if no filters...
        if self.flightSelection_array.count == 0 {
            print("=> There no airline filter")
            return (_depart, _return, _mulit)
        }
        
        // variables...
        var depart_array: [DFlightSearchItem] = []
        var return_array: [DFlightSearchItem] = []
        var mulit_array: [DFlightSearchMultiItem] = []
        
        for model in _depart {
            if self.flightSelection_array.contains(model.airline_name!) {
                depart_array.append(model)
            }
        }
        
        for model in _return {
            if self.flightSelection_array.contains(model.airline_name!) {
                return_array.append(model)
            }
        }
        
        for model in _mulit {
            for child_model in model.flightsSearch_array {
                if self.flightSelection_array.contains(child_model.airline_name!) {
                    mulit_array.append(model)
                    break
                }
            }
        }
        return (depart_array, return_array, mulit_array)
    }
    
    
    // MARK:- Stops
    static func stops_flights(_depart: [DFlightSearchItem],
                              _return: [DFlightSearchItem],
                              _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        // selected or not...
        var stopBool = false
        for value in DFlightFilters.noofStops {
            if value == 1 {
                stopBool = true
                break
            }
        }
        
        // there is no stop filters...
        if stopBool == false {
            print("=> There no stops filter")
            return (_depart, _return, _mulit)
        }
        
        // variables...
        var depart_array: [DFlightSearchItem] = []
        var return_array: [DFlightSearchItem] = []
        var mulit_array: [DFlightSearchMultiItem] = []
        
        // Stop zero elements...
        if DFlightFilters.noofStops[0] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 0 }
            depart_array += filter_depart
            print("0 - Depart stops : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.stop_type == 0 }
            return_array += filter_return
            print("0 - return stops : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.stop_type == 0 }
            mulit_array += filter_mulit
            print("0 - mulit stops : \(mulit_array.count)")
        }
        
        // Stop 1 elements...
        if DFlightFilters.noofStops[1] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type == 1 }
            depart_array += filter_depart
            print("1 - Depart stops : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.stop_type == 1 }
            return_array += filter_return
            print("1 - return stops : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.stop_type == 1 }
            mulit_array += filter_mulit
            print("1 - mulit stops : \(mulit_array.count)")
        }
        
        // Stop 1+ elements...
        if DFlightFilters.noofStops[2] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type > 1 }
            depart_array += filter_depart
            print("1+ - Depart stops : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.stop_type > 1 }
            return_array += filter_return
            print("1+ - return stops : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.stop_type > 1 }
            mulit_array += filter_mulit
            print("1+ - mulit stops : \(mulit_array.count)")
        }
        if DFlightFilters.noofStops[3] == 1 {
            
            let filter_depart = _depart.filter { $0.stop_type > 2 }
            depart_array += filter_depart
            print("1+ - Depart stops : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.stop_type > 2 }
            return_array += filter_return
            print("1+ - return stops : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.stop_type > 2 }
            mulit_array += filter_mulit
            print("1+ - mulit stops : \(mulit_array.count)")
        }
        
        return (depart_array, return_array, mulit_array)
    }
    
    // MARK:- Depart
    static func departTiming_flightFilter(_depart: [DFlightSearchItem],
                                          _return: [DFlightSearchItem],
                                          _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        
        // selected or not...
        var stopBool = false
        for value in DFlightFilters.depart {
            if value == 1 {
                stopBool = true
                break
            }
        }
        
        // there is no stop filters...
        if stopBool == false {
            print("=> There no depart filter")
            return (_depart, _return, _mulit)
        }
        
        // variables...
        var depart_array: [DFlightSearchItem] = []
        var return_array: [DFlightSearchItem] = []
        var mulit_array: [DFlightSearchMultiItem] = []
        
        // depart(0-6) elements...
        if DFlightFilters.depart[0] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 0 }
            depart_array += filter_depart
            print("0 - Depart Dtime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.depart_type == 0 }
            return_array += filter_return
            print("0 - return Dtime : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.depart_type == 0 }
            mulit_array += filter_mulit
            print("0 - mulit Dtime : \(mulit_array.count)")
        }
        
        // depart(6-12) elements...
        if DFlightFilters.depart[1] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 1 }
            depart_array += filter_depart
            print("1 - Depart Dtime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.depart_type == 1 }
            return_array += filter_return
            print("1 - return Dtime : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.depart_type == 1 }
            mulit_array += filter_mulit
            print("1 - mulit Dtime : \(mulit_array.count)")
        }
        
        // depart(12-18) elements...
        if DFlightFilters.depart[2] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 2 }
            depart_array += filter_depart
            print("2 - Depart Dtime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.depart_type == 2 }
            return_array += filter_return
            print("2 - return Dtime : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.depart_type == 2 }
            mulit_array += filter_mulit
            print("2 - mulit Dtime : \(mulit_array.count)")
        }
        
        // depart(18-24) elements...
        if DFlightFilters.depart[3] == 1 {
            
            let filter_depart = _depart.filter { $0.depart_type == 3 }
            depart_array += filter_depart
            print("3 - Depart Dtime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.depart_type == 3 }
            return_array += filter_return
            print("3 - return Dtime : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.depart_type == 3 }
            mulit_array += filter_mulit
            print("3 - mulit Dtime : \(mulit_array.count)")
        }
        
        
        return (depart_array, return_array, mulit_array)
    }
    
    // MARK:- Arrival
    static func arrivalTiming_flightFilter(_depart: [DFlightSearchItem],
                                           _return: [DFlightSearchItem],
                                           _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        // selected or not...
        var stopBool = false
        for value in DFlightFilters.arrival {
            if value == 1 {
                stopBool = true
                break
            }
        }
        
        // there is no stop filters...
        if stopBool == false {
            print("=> There no arrival filter")
            return (_depart, _return, _mulit)
        }
        
        // variables...
        var depart_array: [DFlightSearchItem] = []
        var return_array: [DFlightSearchItem] = []
        var mulit_array: [DFlightSearchMultiItem] = []
        
        // depart(0-6) elements...
        if DFlightFilters.arrival[0] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 0 }
            depart_array += filter_depart
            print("0 - Depart Atime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.arrival_type == 0 }
            return_array += filter_return
            print("0 - return Atime : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.arrival_type == 0 }
            mulit_array += filter_mulit
            print("0 - mulit Atime : \(mulit_array.count)")
        }
        
        // depart(6-12) elements...
        if DFlightFilters.arrival[1] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 1 }
            depart_array += filter_depart
            print("1 - Depart Atime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.arrival_type == 1 }
            return_array += filter_return
            print("1 - return Atime : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.arrival_type == 1 }
            mulit_array += filter_mulit
            print("1 - mulit Atime : \(mulit_array.count)")
        }
        
        // depart(12-18) elements...
        if DFlightFilters.arrival[2] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 2 }
            depart_array += filter_depart
            print("2 - Depart Atime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.arrival_type == 2 }
            return_array += filter_return
            print("2 - return Atime : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.arrival_type == 2 }
            mulit_array += filter_mulit
            print("2 - mulit Atime : \(mulit_array.count)")
        }
        
        // depart(18-24) elements...
        if DFlightFilters.arrival[3] == 1 {
            
            let filter_depart = _depart.filter { $0.arrival_type == 3 }
            depart_array += filter_depart
            print("3 - Depart Atime : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.arrival_type == 3 }
            return_array += filter_return
            print("3 - return Atime : \(return_array.count)")
            
            
            let filter_mulit = _mulit.filter { $0.arrival_type == 3 }
            mulit_array += filter_mulit
            print("3 - mulit Atime : \(mulit_array.count)")
        }
        
        
        return (depart_array, return_array, mulit_array)
    }
    //MARK: - FareType Filter
    static func fareType_flightsFilter(_depart: [DFlightSearchItem],
                                       _return: [DFlightSearchItem],
                                       _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        //selected or not...
        var stopBool = false
        for value in DFlightFilters.fareType{
            if value == 1 {
                stopBool = true
                break
            }
        }
        
        //there is no filters...
        if stopBool == false{
            print("=> there no faretype filter")
            return (_depart, _return, _mulit)
        }
        //variables
        var depart_array: [DFlightSearchItem] = []
        var return_array: [DFlightSearchItem] = []
        var mulit_array: [DFlightSearchMultiItem] = []
//        fareType non refandable
        if DFlightFilters.fareType[0] == 1 {
            let filter_depart = _depart.filter { $0.is_refund == false }
            depart_array += filter_depart
            print("0 - Depart fare type : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.is_refund == false }
            return_array += filter_return
            print("0 - return fare type : \(return_array.count)")
            
            let filter_mulit = _mulit.filter {  $0.is_refund == false }
            mulit_array += filter_mulit
            print("0 - mulit fare type : \(mulit_array.count)")
        }
//        faretype refundable
        if DFlightFilters.fareType[1] == 1 {
            
            let filter_depart = _depart.filter { $0.is_refund == true  }
            depart_array += filter_depart
            print("1 - Depart fare type : \(depart_array.count)")
            
            let filter_return = _return.filter { $0.is_refund == true  }
            return_array += filter_return
            print("1 - return fare type : \(return_array.count)")
            
            let filter_mulit = _mulit.filter { $0.is_refund == true }
            mulit_array += filter_mulit
            print("1 - mulit fare type : \(mulit_array.count)")
        }
//
        return (depart_array, return_array, mulit_array)
    }
    
    // MARK:- Sorting
    static func sorting_flights(_depart: [DFlightSearchItem],
                                _return: [DFlightSearchItem],
                                _mulit: [DFlightSearchMultiItem]) -> ([DFlightSearchItem], [DFlightSearchItem], [DFlightSearchMultiItem]) {
        
        var depart_array = _depart
        var return_array = _return
        var mulit_array = _mulit
        
        // Price sorting...
        if DFlightFilters.sort_number == 0 {
            
            let results_1 = depart_array.sorted(by: { $0.ticket_price < $1.ticket_price })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.ticket_price < $1.ticket_price })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.ticket_price < $1.ticket_price })
            mulit_array = results_3
        }
        else if DFlightFilters.sort_number == 1 {
            
            let results_1 = depart_array.sorted(by: { $0.ticket_price > $1.ticket_price })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.ticket_price > $1.ticket_price })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.ticket_price > $1.ticket_price })
            mulit_array = results_3
        }
            // depart date sort...
        else if DFlightFilters.sort_number == 2 {
            
            let results_1 = depart_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedAscending })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedAscending })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedAscending })
            mulit_array = results_3
        }
        else if DFlightFilters.sort_number == 3 {
            
            let results_1 = depart_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedDescending})
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedDescending })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.start_date.compare($1.start_date) == .orderedDescending })
            mulit_array = results_3
        }
            // duration date sort...
        else if DFlightFilters.sort_number == 4 {
            
            let results_1 = depart_array.sorted(by: { $0.duration_seconds < $1.duration_seconds })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.duration_seconds < $1.duration_seconds })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.duration_seconds < $1.duration_seconds })
            mulit_array = results_3
        }
        else if DFlightFilters.sort_number == 5 {
            
            let results_1 = depart_array.sorted(by: { $0.duration_seconds > $1.duration_seconds })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.duration_seconds > $1.duration_seconds })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.duration_seconds > $1.duration_seconds })
            mulit_array = results_3
        }
            // arrival date sort...
        else if DFlightFilters.sort_number == 6 {
            
            let results_1 = depart_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedAscending })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedAscending })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedAscending })
            mulit_array = results_3
        }
        else if DFlightFilters.sort_number == 7 {
            
            let results_1 = depart_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedDescending })
            depart_array = results_1
            
            let results_2 = return_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedDescending })
            return_array = results_2
            
            let results_3 = mulit_array.sorted(by: { $0.end_date.compare($1.end_date) == .orderedDescending })
            mulit_array = results_3
            
        }
        else if DFlightFilters.sort_number == 8 {
            let result_1 = depart_array.sorted(by: {$0.airline_name! < $1.airline_name!})
            depart_array = result_1
            let result_2 = return_array.sorted(by: {$0.airline_name! < $1.airline_name!})
            return_array = result_2
            let result_3 = mulit_array.sorted(by: {$0.airline_name! < $1.airline_name!})
            mulit_array = result_3
            
        } else if DFlightFilters.sort_number == 9 {
            let result_1 = depart_array.sorted(by: {$0.airline_name! > $1.airline_name!})
            depart_array = result_1
            let result_2 = return_array.sorted(by: {$0.airline_name! > $1.airline_name!})
            return_array = result_2
            let result_3 = mulit_array.sorted(by: {$0.airline_name! > $1.airline_name!})
            mulit_array = result_3
        }
        else {
            print("==>>There is no flight sorting")
        }
        
        return (depart_array, return_array, mulit_array)
    }
}
