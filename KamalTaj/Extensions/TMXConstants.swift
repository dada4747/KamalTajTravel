//
//  TMXConstants.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import Foundation
import UIKit
import SDWebImage

let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate

// size scale...
let xScale = UIScreen.main.bounds.size.width / 320.0
let yScale = UIScreen.main.bounds.size.height / 480.0

let STORYBOARD_MAIN : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let FLIGHT_STORYBOARD = UIStoryboard.init(name: "Flight", bundle: nil)
let HOTEL_STORYBOARD = UIStoryboard.init(name: "Hotel", bundle: nil)
let BUS_STORYBOARD = UIStoryboard.init(name: "Bus", bundle: nil)
let TRANSFERS_STORYBOARD = UIStoryboard.init(name: "Transfers", bundle: nil)
let CAR_STORYBOARD = UIStoryboard.init(name: "Car", bundle: nil)
let ACTIVITIES_STORYBOARD = UIStoryboard.init(name: "Activities", bundle: nil)
let HOLIDAY_STORYBOARD = UIStoryboard.init(name: "Holidays", bundle: nil)


let DEFAULTS = UserDefaults.standard


let appBlueColor: UIColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 235.0/255.0, alpha: 1.0)

let kWindow = getWindow()


// MARK:- Global funactions
func getAppDelegate() -> AppDelegate {
    return appDel
}

func getWindow() -> UIWindow? {
    return appDel.window!
}

func getRootNavigation() -> UINavigationController? {
    
    let windows = getWindow()
    if let navCtr = windows?.rootViewController as? UINavigationController {
        return navCtr
    }
    return nil
}



struct AppColors {
    
//    static let yellow = UIColor.hex(hex: "#f9c02c", alpha: 1.0)
//    static let blue = UIColor.hex(hex: "#063651", alpha: 1.0)
}


// MARK:- STORAGE KEYS
let TMXUser_Profile = "user_profile"
let TMX_LanguageStore = "language"
let TMX_Currency = "currency"
let BASE_CURRENCY = "INR"
let CTG_CurrencyConversion = "currency_conversion"

// MARK:- Notifications...
let Notify_ProfileUpdate = Notification.Name("Notify_ProfileUpdate")
let NOTIFY_HOTEL_MODIFY_SEARCH = Notification.Name("Notify_HotelModifySearch")
let NOTIFY_HOLIDAY_MODIFY_SEARCH = Notification.Name("Notify_HolidayModifySearch")

//let TMX_Base_URL = "https://www.dreamoura.com/mobile_webservices/mobile/index.php"//

let TMX_Base_URL =  "https://provabdev.in/kamaltajtravels/mobile_webservices/mobile/index.php"
let Base_Image_URL = "https://purantrip.com"
let Promo_Image_URL = "https://"
let Base_Airline_URL = "https://purantrip.com"
let Holiday_Image_URL = "https://www.dreamoura.com"
let getPromoCodes = "general/all_promo"
let validatePromoCode = "general/mobile_promocode"

//EZY%20Airlines%20Logo-02_0.png
// MARK:- USER
let USER_Login = "auth/mobile_login"
let USER_Register = "auth/register_on_light_box_mobile"
let User_FBLogin = "user/mob_login_facebook"
let User_GogleLogin = "user/mob_login_google"
let User_ForgotPassword = "general/mobile_forgotpassword"
let User_ChangePassword = "general/mobile_change_password"
let User_UpdateProfile = "user/profile"
let User_GetProfile = "user/get_profile_details"
let User_PrivacyPolicy = "general/privacy_policy"
let User_TermsAndConditions = "general/terms_and_condition"


// MARK:- HOME
let HomePageAdsList = "general/mobile_top_destination_list"
let Get_AllPromo = "general/all_promo"
let Get_CurrencyList = "general/currency_converter"
let Flight_History = "user/flight_transcation_history"
let Hotel_History = "user/hotel_transcation_history"
let Bus_History = "user/bus_transcation_history" 
//let Transfer_History = "user/transfers_transcation_history"


// MARK: - CMS
let CMS_AboutUs = "general/about_us"
let CMS_ContactUs = "general/contact_us"
let CMS_TermsAndConditions = "general/cms_mobile/terms"
let CMS_PrivacyPolicy = "general/cms_mobile/privacy"

// MARK: - FLIGHT
let FLIGHT_Search = "general/pre_flight_search_mobile"
let FLIGHT_FareCalendar = "ajax/fare_list?"
let FLIGHT_FareRules = "flight/get_fare_details"
let FLIGHT_Details = "general/flight_details_mobile"
let FLIGHT_FairQoute = "flight/booking_mobile"
let FLIGHT_PreBooking = "flight/pre_booking_mobile"
let FLIGHT_CancelBooking = "flight/cancel_booking_mobile"
let FLIGHT_ExtraServices = "flight/extraservices_mobile"

// MARK: - HOTEL
let HOTEL_Search = "general/pre_hotel_search_mobile"
let HOTEL_Details = "hotel/mobile_hotel_details"
let HOTEL_Room_List = "hotel/get_hotel_room_list"
let HOTEL_Room_Block = "hotel/mobile_booking"
let HOTEL_Pre_Booking = "hotel/pre_booking_api"

let Cancel_FlightBooking = "flight/cancel_booking_mobile"

//let Hotel_History = "user/hotel_transcation_history"
let Cancel_HotelBooking = "hotel/cancel_booking_mobile"
let BUSES_AutoComplete = "ajax/bus_stations"
