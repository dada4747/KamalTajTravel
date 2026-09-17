//
//  DBusesSearchModel.swift
//  EasiTripBooking
//
//  Created by Admin on 16/10/25.
//

import Foundation

struct DBusSearchModel{
    static var search_id = ""
    static var booking_source = ""
    static var busSearch_array : [DBusesSearchItem] = []
    static func clearModels(){
        busSearch_array.removeAll()
        booking_source = ""
        search_id = ""
    }
    static func createModels(result_dict: [String: Any]){
        busSearch_array.removeAll()
        if let searchId = result_dict["search_id"] as? Int {
            self.search_id = "\(searchId)"
        }
        if let bookingSource = result_dict["booking_source"] as? String {
            self.booking_source = bookingSource
        }
        if let data_list = result_dict["data"] as? [[String: Any]] {
            for bus in data_list {
                let searchItem = DBusesSearchItem.init(details: bus)
                self.busSearch_array.append(searchItem)
            }
        }
    }
}
            
/*{
 "API_Raw_Fare" = 95;
 ArrDateTime = "2026-05-01 01:00:00";
 ArrTime = "01:00";
 ArrivalDate = "01-05-2026";
 AvailableSeats = 8;
 AvailableSingleSeat = 0;
 AvlWindowSeats = "-1";
 BusRoutes = "Bangalore-Hyderabad";
 BusStatus =             {
     BaseFares = "90.00";
     TotalTax = "4.50";
 };
 BusTypeId = 1010;
 BusTypeName = "Bharat benz Non A/C Sleeper Air Suspension (1+1)";
 CacheKey = 25ad1e9df0ccb2e4f40c595bc70feaac;
 CancPolicy =             (
                     {
         charge = "\U20b90 (0%)";
         time = "Before 30 Apr 11:35 AM";
     }
 );
 CommAmount = 0;
 CompanyId = 3;
 CompanyName = "TESTING ACCOUNT";
 CompanySuf = "";
 DepartureDate = "2026-04-30";
 DeptDateTime = "2026-04-30 11:35:00";
 DeptTime = "11:35";
 DiscountAmt = "";
 Dropoffs =             (
                     {
         Address = "A S Rao Nagar";
         Contact = 34345678345678;
         DropArea = "A S Rao Nagar";
         DropoffCode = 157955;
         DropoffName = "A S Rao Nagar";
         DropoffTime = "01:00";
         Landmark = test;
     }
 );
 Duration = "13:25 hrs";
 Fare = 95;
 From = Bangalore;
 HasAC = false;
 HasNAC = true;
 HasSeater = false;
 HasSleeper = true;
 Id = 2000000155980101903;
 IsVolvo = "";
 LiveTrackingAvailable = false;
 Pickups =             (
                     {
         Address = asdasdasdads;
         Contact = 9818649039;
         Landmark = Murgeshpallya;
         PickupArea = "Old Airport Road";
         PickupCode = 252884;
         PickupName = "Old Airport Road";
         PickupTime = "11:35";
     },
                     {
         Address = ADADA;
         Contact = 9818649038;
         Landmark = qee;
         PickupArea = " HSR Layout BDA Complex";
         PickupCode = 256691;
         PickupName = " HSR Layout BDA Complex";
         PickupTime = "12:00";
     },
                     {
         Address = hahahah;
         Contact = 234567890456789;
         Landmark = "Kings landing";
         PickupArea = Domlur;
         PickupCode = 157801;
         PickupName = Domlur;
         PickupTime = "12:30";
     }
 );
 ProvId = 25541201;
 ResultToken = "25ad1e9df0ccb2e4f40c595bc70feaac*_*1*_*8OsploY5tNoa0ijW";
 RouteCode = 2000000100000101903;
 RouteScheduleId = 2000000155980101903;
 SeaterFareAC = 0;
 SeaterFareNAC = 0;
 SemiSeater = "";
 SleeperFareAC = 0;
 SleeperFareNAC = 0;
 To = Hyderabad;
 TripId = "";
 VehicleType = BUS;
 "booking_source" = PTBSID0000000131;
 status = 1;
}*/
struct DBusesSearchItem {
    var CompanyName : String?
    var CompanyId : String?
    var ProvId : String?
    var RouteScheduleId : String?
    var BusTypeName : String?
    var BusLabel : String?
    var RouteCode : String?
    var DeptTime : String?
    var DepartureTime : String?
    var ArrTime : String?
    var ArrivalTime : String?
    var CommAmount : Float = 0.0
    var DiscountAmt : Float = 0.0
    var TripId : String?
    var CompanySuf : String?
    var From : String?
    var To : String?
    var Duration : String?
    var Fare : Float = 0.0
    var AvailableSeats : Int = 0
    var singleSeats : Int = 0
    var ResultToken : String?
    //filters..
    var stop_type: Int = 0
    var depart_type: Int = 0
    var arrival_type: Int = 0
    
    var start_date = Date()
    var end_date = Date()
    var duration_seconds: Int = 0
    var canc: [[String: Any]] = [[:]]

    
    init(details: [String :Any]) {
        self.CompanyName = ""
        self.CompanyId = ""
        self.ProvId = ""
        self.RouteScheduleId = ""
        self.BusTypeName = ""
        self.BusLabel = ""
        self.RouteCode = ""
        self.DeptTime = ""
        self.DepartureTime = ""
        self.ArrTime = ""
        self.ArrivalTime = ""
        self.TripId = ""
        self.CompanySuf = ""
        self.From = ""
        self.To = ""
        self.Duration = ""
        self.ResultToken = ""
    
        if let CompanyName = details["CompanyName"] as? String{
            self.CompanyName = CompanyName
        }
        if let CompanyId = details["CompanyId"] as? Int {
            self.CompanyId = "\(CompanyId)"
        }
        else if let CompanyId = details["CompanyId"] as? String {
            self.CompanyId = CompanyId
        }
        if let ProvId = details["ProvId"] as? Int{
            self.ProvId = "\(ProvId)"
        }
        if let RouteScheduleId = details["RouteScheduleId"] as? String{
            self.RouteScheduleId = String(RouteScheduleId)
        }
        if let BusTypeName = details["BusTypeName"] as? String{
            self.BusTypeName = BusTypeName
        }
        if let value = details["CancPolicy"] as? [[String: Any]] {
            self.canc = value
        }
        if let BusLabel = details["BusLabel"] as? String{
            self.BusLabel = BusLabel
        }
        if let RouteCode = details["RouteCode"] as? Int{
            self.RouteCode = String(RouteCode)
        }
        if let RouteCode = details["RouteCode"] as? String{
            self.RouteCode = RouteCode
        }
        if let DeptTime = details["DeptDateTime"] as? String{
            self.DeptTime = DeptTime
            let destDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: DeptTime)
            self.start_date = destDate

        }
        if let DepartureTime = details["DeptTime"] as? String{
            self.DepartureTime = DepartureTime
        }
        if let ArrTime = details["ArrDateTime"] as? String{

            self.ArrTime = ArrTime
            let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: ArrTime)
            self.end_date = arrDate

        }
        if let ArrivalTime = details["ArrTime"] as? String{
            self.ArrivalTime = ArrivalTime
        }
            self.CommAmount =  Float(String.init(describing: details["CommAmount"])) ?? 0.0
        if let DiscountAmt = details["DiscountAmt"] as? String{
            self.DiscountAmt = Float(String.init(describing: DiscountAmt)) ?? 0.0
        }
        if let TripId = details["TripId"] as? String{
            self.TripId = TripId
        }
        if let CompanySuf = details["CompanySuf"] as? String{
            self.CompanySuf = CompanySuf
        }
        if let From = details["From"] as? String{
            self.From = From
        }
        if let To = details["To"] as? String{
            self.To = To
        }
        if let Duration = details["Duration"] as? String{
            self.Duration = Duration
        }
        if let Fare = details["API_Raw_Fare"] as? String{
            self.Fare = Float(String.init(describing: Fare)) ?? 0.0
        }
        if let Fare = details["API_Raw_Fare"] as? Float{
            self.Fare = Float(String.init(describing: Fare)) ?? 0.0
        }
        if let Fare = details["API_Raw_Fare"] as? Double{
            self.Fare = Float(String.init(describing: Fare)) ?? 0.0
        }
        if let availableSeats = details["AvailableSeats"] as? Int {
            self.AvailableSeats = availableSeats
        }
        if let availableSeats = details["AvailableSeats"] as? String {
            self.AvailableSeats = Int(availableSeats) ?? 0
        }
        if let AvailableSingleSeat = details["AvailableSingleSeat"] as? Int {
            self.singleSeats = AvailableSingleSeat
        }
        if let ResultToken = details["ResultToken"] as? String{
            self.ResultToken = ResultToken
        }
        
        depart_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: start_date)
        arrival_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: end_date)

        let difference = Calendar.current.dateComponents([.second], from: start_date, to: end_date) //.hour, .minute,
        self.duration_seconds = difference.second!

        stop_type = 0
        if ((BusTypeName?.contains("A/C")) == true || (BusTypeName?.contains("AC")) == true ) && (BusTypeName?.contains("Seater")) == true && (BusTypeName?.contains("NON")) != true {
         stop_type = 0
        } else if ((BusTypeName?.contains("NON")) == true && (BusTypeName?.contains("Seater")) == true )  {
            stop_type = 1
        }else if ((BusTypeName?.contains("A/C")) == true || (BusTypeName?.contains("AC")) == true ) && (BusTypeName?.contains("Sleeper")) == true && (BusTypeName?.contains("NON")) != true {
            stop_type = 2
        }else if((BusTypeName?.contains("NON")) == true && (BusTypeName?.contains("Sleeper")) == true ) {
            stop_type = 3
        }else{}
    }
}
