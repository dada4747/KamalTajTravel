//
//  DCommonModel.swift
//  ThrilloTrip
//
//  Created by Nandu on 21/06/23.
//

import UIKit

//MARK: - DCommonModel
struct DCommonModel {
    
    static var trendingHotel_imgPath = ""
    static var trendingbus_imgPath = ""
    static var trendingFlight_imgPath = ""
    static var trendingPackage_imgPath = ""
    static var topOffer_Array: [DCommonTopOfferItems] = []
    static var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    
    static var homeAdsArray: [DHomeAdsItems] = []
    
    static var trendingActivities_Array: [DCommonTrendingActivitiesItems] = []
    static var perfectActivities_Array: [DCommonPerfectActivitiesItems_Packages] = []
    
    
    static var trendingPackage_Array: [DCommonTrendingPackageItem] = []
    static var trendingFligh_Array: [DCommonTrendingFlightItem] = []
    static var trendingBus_Array : [DCommonTrendingBusesItem] = []
    
    static var trendingActivities_imgPath = ""
    static var perfectActivities_imgPath = ""
    
    // clear all search information...
    static func clearDCommomModelInfo() {
        
        trendingHotel_imgPath = ""
        trendingFlight_imgPath = ""
        trendingbus_imgPath = ""
        // remove all array...
        topOffer_Array.removeAll()
        trendingHotel_Array.removeAll()
        trendingPackage_Array.removeAll()
        trendingFligh_Array.removeAll()
        trendingBus_Array.removeAll()
        homeAdsArray.removeAll()
    }
    
    // create search items...
    static func createModels(result_dict: [String: Any]) {
        
        self.trendingHotel_Array.removeAll()
        self.trendingPackage_Array.removeAll()
        self.trendingFligh_Array.removeAll()
        self.trendingBus_Array.removeAll()
        // trending hotel...
//        if let hotel_dict = result_dict["hotel"] as? [String: Any] {
//            
//            if let imagePath = hotel_dict["img_url"] as? String {
//                self.trendingHotel_imgPath = imagePath
//            }
            
            if let hotel_array = result_dict["hotel"] as? [[String: Any]] {
                
                for hotelList in hotel_array {
                    let hotelItem = DCommonTrendingHotelItems.init(details: hotelList)
                    self.trendingHotel_Array.append(hotelItem)
                }
//            }
        }
        //package
        if let bus_dict = result_dict["bus"] as? [String: Any] {
            if let imagePath = bus_dict["img_url"] as? String {
                self.trendingbus_imgPath = imagePath
            }
            if let busArray = bus_dict["list"] as? [[String: Any]]{
                for busItem in busArray {
                    let item = DCommonTrendingBusesItem.init(details: busItem)
                    self.trendingBus_Array.append(item)
                }
                
            }
        }
        //flight
//        if let flight_dict = result_dict["flight"] as? [String: Any] {
//            if let imagePath = flight_dict["img_url"] as? String {
//                self.trendingFlight_imgPath = imagePath
//            }
        if let flightArray = result_dict["flight"] as? [[String: Any]]{
            for flightList in flightArray {
                let flightItem = DCommonTrendingFlightItem.init(details: flightList)
                self.trendingFligh_Array.append(flightItem)
            }
        }
//        }
        
        //package
        if let package_dict = result_dict["package"] as? [String: Any] {
            if let imagePath = package_dict["img_url"] as? String {
                self.trendingPackage_imgPath = imagePath
            }
            if let packageArray = package_dict["list"] as? [[String: Any]]{
                for packageList in packageArray {
                    let packageItem = DCommonTrendingPackageItem.init(details: packageList)
                    self.trendingPackage_Array.append(packageItem)
                }
            }
        }
        
        var loAdsArray: [DHomeAdsItems] = []
        
        if trendingFligh_Array.count != 0 {
            var model = DHomeAdsItems()
            for flight in trendingFligh_Array {
                model.module = "Flight"
                model.flightAds = flight
                loAdsArray.append(model)
            }
        }
        
        if trendingHotel_Array.count != 0 {
            
            var model = DHomeAdsItems()
            for hotel in trendingHotel_Array {
                model.module = "Hotel"
                model.hotelAds = hotel
                loAdsArray.append(model)
            }
        }
        
        if trendingPackage_Array.count != 0 {
            var model = DHomeAdsItems()
            for holiday in trendingPackage_Array {
                model.module = "Holiday"
                model.holidayAds = holiday
                loAdsArray.append(model)
            }
        }
        
        if topOffer_Array.count != 0 {
            var model = DHomeAdsItems()
            for offer in topOffer_Array {
                model.module = "Promo"
                model.offersAds = offer
                loAdsArray.append(model)
            }
        }
        
        homeAdsArray = loAdsArray.shuffled()
        print("homeAdsArray: \(homeAdsArray.count)")
        
    }
    
    // create promocode search items...
    static func createPromoCodeModels(result_dict: [String: Any]) {
        self.topOffer_Array.removeAll()
        // promocode...
        if let promo_array = result_dict["data"] as? [[String: Any]] {
            
            for promoList in promo_array {
                
                let promoItem = DCommonTopOfferItems.init(details: promoList)
                if promoItem.status == true && promoItem.is_display_homepage == true {
                    self.topOffer_Array.append(promoItem)
                }
            }
        }
    }
}

struct DHomeAdsItems {
    
    var module: String?
    var flightAds: DCommonTrendingFlightItem?
    var hotelAds: DCommonTrendingHotelItems?
    var offersAds: DCommonTopOfferItems?
    var holidayAds: DCommonTrendingPackageItem?
}

// MARK: - DCommonTopOfferItems
struct DCommonTopOfferItems {
    
    //elements...
    var module: String?
    var promoCode: String?
    var promoDescription: String?
    var promo_img_url: String?
    var minimum_amount: Float?
    var expiryDate: String?
    var value: Float?
    var expiry_date: String?
    var value_type: String?
    var is_display_homepage: Bool?
    var status : Bool?
    
    init(details: [String: Any]) {
        
        self.module = ""
        self.promoCode = ""
        self.promoDescription = ""
        self.promo_img_url = ""
        self.minimum_amount = 0.0
        self.expiryDate = ""
        self.value_type = ""
        self.is_display_homepage = false
        self.status = false
        self.value = 0.0
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // USA: Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        
        if let moduleStr = details["module"] as? String {
            self.module = moduleStr
        }
        
        if let promo_code = details["promo_code"] as? String {
            self.promoCode = promo_code
        }
        
        if let promo_descp = details["description"] as? String {
            self.promoDescription = promo_descp
        }
        
        if let expiry_date = details["expiry_date"] as? String {
            
            let expiryDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: expiry_date)
            self.expiryDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: expiryDate)
        }
        
        if let image_url = details["promo_code_image"] as? String {
            self.promo_img_url =  image_url
        }
        if let minimum_amount = details["minimum_amount"] as? String {
            
            //            let number = formatter.number(from: minimum_amount)
            //            self.minimum_amount = Float(truncating: number!)
            self.minimum_amount = Float(String.init(describing: minimum_amount))!
        }
        if let value = details["value"] as? String {
            
            //            let number = formatter.number(from: minimum_amount)
            //            self.value = Float(truncating: number!)
            //
            self.value = Float(String.init(describing: value))!
        }
        
        if let value_type = details["value_type"] as? String {
            self.value_type = value_type
        }
        
        if let expiry_date = details["expiry_date"] as? String {
            
            let expiryDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: expiry_date)
            self.expiry_date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: expiryDate)
        }
        if let is_display_home = details["display_home_page"] as? String{
            self.is_display_homepage = is_display_home == "Yes" ? true : false
        }
        if let status  =  details["status"] as? String {
            print(status)
            if Int(status) == 1 {
                self.status = true
            } else {
                self.status = false
                }
            
        }
    }
}

// MARK: - DCommonTrendingHotelItems
struct DCommonTrendingHotelItems {
    
    // elements...
    var origin_id: String?
    var city_id: String?
    var cityName: String?
    var countryName: String?
    var countryCode: String? = ""
    var hotelCount: String?
    var hotel_img_url: String?
    var stateCode : String = ""
    var stateName : String = ""
    var id : String? = ""
    
    init(details: [String: Any]) {
        
        self.city_id = ""
        self.origin_id = ""
        self.cityName = ""
        self.countryName = ""
        self.hotelCount = ""
        self.hotel_img_url = ""
        
        if let origin = details["origin"] as? String {
            self.origin_id = origin
        }
        
        if let city = details["city"] as? String {
            self.city_id = city
        }
        
        if let city_name = details["city_name"] as? String {
            self.cityName = city_name
        }
        
        if let country_name = details["country_name"] as? String {
            self.countryName = country_name
        }
        if let country_code = details["country_code"] as? String {
            self.countryCode = country_code
        }
        if let hotel_count = details["cache_hotels_count"] as? String {
            self.hotelCount = hotel_count
        }
        if let id = details["id"] as? String {
            self.id = id
        }
        if let stateCode = details["state_code"] as? String{
            self.stateCode = stateCode
        }
        if let stateName = details["state"] as? String{
            self.stateName = stateName
        }
         if let img_url = details["img_url"] as? String {
            self.hotel_img_url = /*DCommonModel.trendingHotel_imgPath +*/ img_url
        }
        
    }
    
}
class DCommonTrendingFlightItem {
    
    var from_airport_code: String? = ""
    var from_airport_name: String? = ""
    var image: String? = ""
    var origin: String? = ""
    var status: String? = ""
    var to_airport_code: String? = ""
    var to_airport_name: String? = ""
    
    init(details: [String: Any]) {
        
        if let from_airport_code = details["from_airport_code"] as? String{
            self.from_airport_code = from_airport_code
        }
        if let from_airport_name = details["from_airport_name"] as? String{
            self.from_airport_name = from_airport_name
        }
        if let image = details["img_url"] as? String{
            self.image = /*DCommonModel.trendingFlight_imgPath + */image
        }
        if let origin = details["origin"] as? String{
            self.origin = origin
        }
        if let status = details["status"] as? String{
            self.status = status
        }
        if let to_airport_code = details["to_airport_code"] as? String{
            self.to_airport_code = to_airport_code
        }
        if let to_airport_name = details["to_airport_name"] as? String{
            self.to_airport_name = to_airport_name
        }
    }
    
    
    
    
    
}
class DCommonTrendingBusesItem {
    var from_bus_name : String? = ""
    var from_station_id : String? = ""
    var imageStr : String? = ""
    var offer : String? = ""
    var origin : String? = ""
    var to_bus_name : String? = ""
    var to_station_id : String? = ""
    var top_destination : String? = ""
    init(details: [String: Any]) {
        if let from_bus_name = details["from_bus_name"] as? String {
            self.from_bus_name = from_bus_name
        }
        if let from_station_id = details["from_station_id"] as? String {
            self.from_station_id = from_station_id
        }
        if let imageStr = details["image"] as? String {
            self.imageStr = Base_Image_URL + DCommonModel.trendingbus_imgPath + imageStr
        }
        if let offer = details["offer"] as? String {
            self.offer = offer
        }
        if let origin = details["origin"] as? String {
            self.origin = origin
        }
        if let to_bus_name = details["to_bus_name"] as? String {
            self.to_bus_name = to_bus_name
        }
        if let to_station_id = details["to_station_id"] as? String {
            self.to_station_id = to_station_id
        }
        if let top_destination = details["top_destination"] as? String {
            self.top_destination = top_destination
        }
        
    }

}
class DCommonTrendingPackageItem {
    
    // elements...
    var packageId: String?
    var packageCode: String?
    var packageName: String?
    var packageTypeName: String?
    var packageLocation: String?
    var package_duration: String?
    var package_days: String?
    var packageDescription: String?
    var package_imgUrl: String?
    var package_gallery: [String] = []
    var packageCity: String?
    var package_inclusions: String?
    var package_exclusions: String?
    var package_terms: String?
    var package_theme: String?
    var package_tour_type: String?
    var package_policy: String?
    var package_country: String?
    var tours_continent: String?
    var tours_country: String?
    var currency_code: String?
    var from_date: String?
    var to_date: String?
    var package_rating: Int = 0
    var package_price: Float = 0.0
    var package_startCity: String?
    var package_endCity: String?
    var package_coveredCity: String?
    var package_details: [String: Any] = [:]
    
//    var duration : String? = ""
//    var image : String? = ""
//    var package_city : String? = ""
//    var package_code : String? = ""
//    var package_country : String? = ""
//    var package_description : String? = ""
//    var package_id : String? = ""
//    var package_location : String? = ""
//    var package_name : String? = ""
//    var package_type : String? = ""
//    var price : String? = ""
//    var rating : String? = ""
//    var status : String? = ""
//    var top_destination : String? = ""
//    var package_gallery: [String] = []
    

    init(details: [String: Any]) {
        
        package_details = details
        
//        if let duration = details["duration"] as? String{
//            self.duration = duration
//        }
//        if let image = details["banner_image"] as? String{
//           self.image = DCommonModel.trendingPackage_imgPath + image
//        }
//        if let package_city = details["package_city"] as? String{
//            self.package_city = package_city
//        }
//        if let package_code = details["package_code"] as? String{
//            self.package_code = package_code
//        }
//        if let package_country = details["package_country"] as? String{
//            self.package_country = package_country
//        }
//        if let package_description = details["package_description"] as? String{
//            self.package_description = package_description
//        }
//        if let package_id = details["package_id"] as? String{
//            self.package_id = package_id
//        }
//        if let package_location = details["package_location"] as? String{
//            self.package_location = package_location
//        }
//        if let package_name = details["package_name"] as? String{
//            self.package_name = package_name
//        }
//        if let package_type = details["package_type"] as? String{
//            self.package_type = package_type
//        }
//        if let price = details["price"] as? String{
//            self.price = price
//        }
//        if let rating = details["rating"] as? String{
//            self.rating = rating
//        }
//        if let status = details["status"] as? String{
//            self.status = status
//        }
//        if let top_destination = details["top_destination"] as? String{
//            self.top_destination = top_destination
//        }
//
//        if let img_str = details["gallery"] as? String {
//            let imgStr_arr = img_str.split(separator: ",")
//            var loArray:[String] = []
//            for i in 0 ..< imgStr_arr.count {
//                let loImg = imgStr_arr[i]
//                loArray.append(String(DHolidaySearchModel.img_url + loImg))
//                self.package_gallery = loArray
//            }
//            //self.package_gallery = imgStr_arr
//            print("Count: \(package_gallery.count)")
//        }
        
        
        // default info...
        self.packageId = ""
        self.packageCode = ""
        self.packageName = ""
        self.packageTypeName = ""
        self.packageLocation = ""
        self.package_duration = ""
        self.package_days = ""
        self.packageDescription = ""
        self.package_imgUrl = ""
        self.packageCity = ""
        self.package_inclusions = ""
        self.package_exclusions = ""
        self.currency_code = "USD"
        self.from_date = ""
        self.to_date = ""
        self.package_country = ""
        self.tours_continent = ""
        self.tours_country = ""
        self.package_tour_type = ""
        self.package_startCity = ""
        self.package_endCity = ""
        self.package_coveredCity = ""
        
        // holiday details...
        if let package_id = details["id"] as? String {
            self.packageId = package_id
        }
        if let package_code = details["package_code"] as? String {
            self.packageCode = package_code
        }
        if let package_name = details["package_name"] as? String {
            self.packageName = package_name
        }
        
        if let tour_type = details["tour_type"] as? String {
            self.package_tour_type = tour_type
        }
        
        if let tours_continent = details["tours_continent"] as? String {
            self.tours_continent = tours_continent
        }
        
        if let tours_country = details["tours_country"] as? String {
            self.tours_country = tours_country
        }
        
        if let theme = details["module_type"] as? String {
            self.package_theme = theme
        }
        
        if let start_city = details["start_city"] as? String {
            self.package_startCity = start_city
        }
        
        if let end_city = details["end_city"] as? String {
            self.package_endCity = end_city
        }
        
        if let palces_covered = details["palces_covered"] as? String {
            self.package_coveredCity = palces_covered
        }
        
        if let package_type_name = details["package_type_name"] as? String {
            
            //let stringWithSpaces = " The Akbar khan code "
            let trimmedString = package_type_name.trimmingCharacters(in: .whitespaces)
            self.packageTypeName = trimmedString
        }
        
        if let from_date = details["from_date"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: from_date)
            self.from_date = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: originDate)
        }
        
        if let to_date = details["to_date"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: to_date)
            self.to_date = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: originDate)
        }
        
        if let duration = details["duration"] as? String {
            
            var days = Int(duration) ?? 1
            var nights = 0
            if days > 1 {
                nights = days - 1
                self.package_days = "\(duration) Days / \(nights) Nights"
            } else {
                self.package_days = "\(duration) Days"
            }
            
            
            self.package_duration = duration
        }
        
        if let name = details["name"] as? String {
            self.package_country = name
        }
        
        if let package_description = details["package_description"] as? String {
            self.packageDescription = package_description
        }
        if let img_url = details["banner_image"] as? String {
            self.package_imgUrl = DCommonModel.trendingPackage_imgPath + img_url
        }
        
        if let img_str = details["gallery"] as? String {
            let imgStr_arr = img_str.split(separator: ",")
            var loArray:[String] = []
            for i in 0 ..< imgStr_arr.count {
                let loImg = imgStr_arr[i]
                loArray.append(String(DCommonModel.trendingPackage_imgPath + loImg))
                self.package_gallery = loArray
            }
            //self.package_gallery = imgStr_arr
            print("Count: \(package_gallery.count)")
        }
        if let inclusions = details["inclusions"] as? String {
            self.package_inclusions = inclusions
        }
        if let exclusions = details["exclusions"] as? String {
            self.package_exclusions = exclusions
        }
        if let terms = details["terms"] as? String {
            self.package_terms = terms
        }
        if let policy = details["policy"] as? String {
            self.package_policy = policy
        }
        
        if let packageRating = details["star_rating"] as? String {
            self.package_rating = Int(packageRating)!
        }
        
        self.package_price = Float(String.init(describing: details["total_price"] ?? 0.0)) ?? 0.0
    }
}

// MARK: - DCommonTrendingActivitiesItems
struct DCommonTrendingActivitiesItems {
    
    // elements...
    var origin_id: String? = ""
    var destination_id: String? = ""
    var destination_name: String? = ""
    var image_activity: String? = ""
    var home_status: String? = ""
    
    init(details: [String: Any]) {
        

        if let origin = details["origin"] as? String {
            self.origin_id = origin
        }
        
        if let city_name = details["destination_id"] as? String {
            self.destination_id = city_name
        }
        
        if let country_name = details["destination_name"] as? String {
            self.destination_name = country_name
        }
        
        if let hotel_count = details["home_status"] as? String {
            self.home_status = hotel_count
        }
        
        if let img_url = details["image_activity"] as? String {
            //self.image = Base_Image_URL + DCommonModel.trendingFlight_imgPath + img_url
            self.image_activity = DCommonModel.trendingActivities_imgPath + img_url

        }
    }
    
}

// MARK:- Perfect Packages
struct DCommonPerfectActivitiesItems_Packages {
    
    // elements...
    var package_name: String? = ""
    var home_status: String? = ""
    var banner_image: String? = ""
    
    init(details: [String: Any]) {
        

        if let country_name = details["package_name"] as? String {
            self.package_name = country_name
        }
        
        if let hotel_count = details["home_status"] as? String {
            self.home_status = hotel_count
        }
        if let img_url = details["banner_image"] as? String {
            self.banner_image = DCommonModel.perfectActivities_imgPath + img_url
        }
        
    }
    
}
