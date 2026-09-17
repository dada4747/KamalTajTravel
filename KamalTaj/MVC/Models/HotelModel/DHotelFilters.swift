//
//  DHotelFilters.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// MARK:- DHotelFilters
struct DHotelFilters {
    
    // Fliter variables...
    static var price_default: (Float, Float) = (0, 1)
    static var price_selection: (Float, Float) = (0, 1)
    
    static var star_rating: [Int] = [0, 0, 0, 0, 0]
    static var amenities: [Int] = [0, 0, 0, 0]
    
    static var location_array: [String] = []
    static var locationSelection_array: [String] = []

    // Sort variables...
    static var sort_number = 0
    static var currency_code = "USD"
    
    
    // clear the filters...
    static func clearAllFilters() {
        
        // fliters
        price_default = (0, 1)
        price_selection = (0, 1)
        
        star_rating = [0, 0, 0, 0, 0]
        amenities = [0, 0, 0, 0]
        
        location_array.removeAll()
        locationSelection_array.removeAll()

        // sorts
        sort_number = 0
    }
    
    // MARK:- Price and Hotels
    static func getHotelssAndPrice_fromResponse() {
        
        // getting price list...
        var hotelPrice_array: [Float] = []
        var hotelLocation_array: [String] = []

        // price getting from hotel list...
        for model in DHotelSearchModel.hotelsSearch_array {
            currency_code = model.hotel_currency
            hotelPrice_array.append(model.hotel_price)
            hotelLocation_array.append(model.hotel_location ?? "")
        }
        
        // clear all filters..
        self.clearAllFilters()
    
        // min and max...
        DHotelFilters.price_default = DFlightFilters().getMinAndMaxValue(price_array: hotelPrice_array)
        DHotelFilters.price_selection = DFlightFilters().getMinAndMaxValue(price_array: hotelPrice_array)
        
        print("Min :\(DHotelFilters.price_default.0) - Max :\(DHotelFilters.price_default.1)")
        // final location names...

        hotelLocation_array = DHotelFilters().removeDuplicates(array: hotelLocation_array)
        for location_name in hotelLocation_array {
            DHotelFilters.location_array.append(location_name)
        }
        print("Location list :\(hotelLocation_array)")
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
    
    static func applyAll_filterAndSorting(_hotels: [DHotelSearchItem]) -> [DHotelSearchItem] {
        
        print("Normal list : \(_hotels.count)")
        
        // price filters...
        let hotels_price = _hotels.filter { ($0.hotel_price >= DHotelFilters.price_selection.0 && $0.hotel_price <= DHotelFilters.price_selection.1) }
        print("hotel price filter : \(hotels_price.count)")
        
        let hotels_star = starRating_hotelFilter(_hotels: hotels_price)
        print("hotel Star filter : \(hotels_star.count)")
        
        let hotels_amenities = amenities_hotelFilter(_hotels: hotels_star)
        print("hotel amenities filter : \(hotels_amenities.count)")
        
        let hotels_locations = locations_hotelFilter(_hotels: hotels_amenities)
        print("hotel location filter : \(hotels_locations.count)")

        let hotels_sort = sorting_hotels(_hotels: hotels_locations)
        return hotels_sort
    }
}

extension DHotelFilters {
    
    static func starRating_hotelFilter(_hotels: [DHotelSearchItem]) -> [DHotelSearchItem] {
        
        // stars filters...
        var starBool = false
        for value in star_rating {
            if value == 1 {
                starBool = true
                break
            }
        }
        
        // empty star filters...
        if starBool == false  {
            print("==>>There is no hotels STAR filter")
            return _hotels
        }
        
        
        // variables...
        var hotels_array: [DHotelSearchItem] = []
    
        // Star-1 elements...
        if DHotelFilters.star_rating[0] == 1 {
            
            //$0.hotel_rating >= 1 && $0.hotel_rating < 2
            let filter_hotel = _hotels.filter { $0.hotel_rating == 1 }
            hotels_array += filter_hotel
            print("1 Star - hotels : \(hotels_array.count)")
        }
        
        // Star-2 elements...
        if DHotelFilters.star_rating[1] == 1 {
            
            let filter_hotel = _hotels.filter { $0.hotel_rating == 2 }
            hotels_array += filter_hotel
            print("2 Star - hotels : \(hotels_array.count)")
        }
        
        // Star-3 elements...
        if DHotelFilters.star_rating[2] == 1 {
            
            let filter_hotel = _hotels.filter { $0.hotel_rating == 3 }
            hotels_array += filter_hotel
            print("3 Star - hotels : \(hotels_array.count)")
        }
        
        // Star-4 elements...
        if DHotelFilters.star_rating[3] == 1 {
            
            let filter_hotel = _hotels.filter { $0.hotel_rating == 4 }
            hotels_array += filter_hotel
            print("4 Star - hotels : \(hotels_array.count)")
        }
        
        // Star-5 elements...
        if DHotelFilters.star_rating[4] == 1 {
            
            let filter_hotel = _hotels.filter { $0.hotel_rating >= 5 }
            hotels_array += filter_hotel
            print("5 Star - hotels : \(hotels_array.count)")
        }
       
        return hotels_array
    }
    
    static func amenities_hotelFilter(_hotels: [DHotelSearchItem]) -> [DHotelSearchItem] {
        
        // amenities filters...
        var amenitiesBool = false
        for value in amenities {
            if value == 1 {
                amenitiesBool = true
                break
            }
        }
        
        // empty amenities filters...
        if amenitiesBool == false  {
            print("==>>There is no hotels amenities filter")
            return _hotels
        }
        
        
        // variables...
        var filter_hotel = _hotels
        if (amenities[0] == 1) {
            filter_hotel = _hotels.filter { ($0.wifi == true) }
        }
        if (amenities[1] == 1) {
            filter_hotel = _hotels.filter { ($0.breakfast == true) }
        }
        if (amenities[2] == 1) {
            filter_hotel = _hotels.filter { ($0.parking == true) }
        }
        if (amenities[3] == 1) {
            filter_hotel = _hotels.filter { ($0.swim == true) }
        }
        
        print("amenities - hotels : \(filter_hotel.count)")
        return filter_hotel
    }
    static func locations_hotelFilter(_hotels: [DHotelSearchItem]) -> [DHotelSearchItem] {
        
        // if no filters...
        if self.locationSelection_array.count == 0 {
            print("=> There no location filter")
            return (_hotels)
        }
        
        // variables...
        var location_array: [DHotelSearchItem] = []
        
        for model in _hotels {
            if self.locationSelection_array.contains(model.hotel_location!) {
                location_array.append(model)
            }
        }
        return location_array
    }
}

extension DHotelFilters {
    
    // MARK:- Sorting
    static func sorting_hotels(_hotels: [DHotelSearchItem]) -> [DHotelSearchItem] {
        
        var hotels_array = _hotels
     
        // Price sort...
        if DHotelFilters.sort_number == 0 {
            
            let results = hotels_array.sorted(by: { $0.hotel_price < $1.hotel_price })
            hotels_array = results
        }
        else if DHotelFilters.sort_number == 1 {
            
            let results_1 = hotels_array.sorted(by: { $0.hotel_price > $1.hotel_price })
            hotels_array = results_1
        }
        // Star rating sort...
        else if DHotelFilters.sort_number == 2 {
            
            let results = hotels_array.sorted(by: { $0.hotel_rating < $1.hotel_rating })
            hotels_array = results
        }
        else if DHotelFilters.sort_number == 3 {
            
            let results = hotels_array.sorted(by: { $0.hotel_rating > $1.hotel_rating })
            hotels_array = results
        }
        // name sort...
        else if DHotelFilters.sort_number == 4 {
            
            let results = hotels_array.sorted(by: { $0.hotel_name!.localizedCaseInsensitiveCompare($1.hotel_name!) == ComparisonResult.orderedAscending })
            hotels_array = results
        }
        else if DHotelFilters.sort_number == 5 {
            
            let results = hotels_array.sorted(by: { $0.hotel_name!.localizedCaseInsensitiveCompare($1.hotel_name!) == ComparisonResult.orderedDescending })
            hotels_array = results
        }
        else {
            print("==>>There is no hotels sorting")
        }
        
        return hotels_array
    }
}
