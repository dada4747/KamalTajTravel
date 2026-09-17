//
//  BSearchListCell.swift
//  EasiTripBooking
//
//  Created by Admin on 16/10/25.
//

import UIKit

class BSearchListCell: UITableViewCell {

    @IBOutlet weak var lbl_bus_name: UILabel!
    @IBOutlet weak var lbl_bus_type: UILabel!
    
    @IBOutlet weak var lbl_depart_time: UILabel!
    
    @IBOutlet weak var lbl_arrival_time: UILabel!
    
    @IBOutlet weak var lbl_duration: UILabel!
    
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var lbl_seat_count: UILabel!
    @IBOutlet weak var lbl_departDate: UILabel!
    @IBOutlet weak var lbl_arrivalDate: UILabel!
    var onTapCancellationPolicy: (() -> Void)?
    var onTapSelection: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayBusInfo(model: DBusesSearchItem){
        
        self.lbl_bus_name.text = model.CompanyName
        self.lbl_bus_type.text = model.BusTypeName
        self.lbl_depart_time.text = model.DepartureTime
        self.lbl_arrival_time.text = model.ArrivalTime
        self.lbl_departDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: model.start_date)
        
        self.lbl_arrivalDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: model.end_date)

        self.lbl_duration.text = model.Duration
        self.lbl_currency.text = DCurrencyModel.currency_saved?.currency_symbol ?? "AUD"
        self.lbl_price.text = String(format: "%.2f", model.Fare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_seat_count.text = "\(model.AvailableSeats) Seats(\(model.singleSeats) Single)"
    }
    @IBAction func cancellationPolicyButtonTapped(_ sender: UIButton) {
        onTapCancellationPolicy?()
    }
    @IBAction func selectSeatAction(_ sender: UIButton) {
        onTapSelection?()
    }
}
/*
 {
"API_Raw_Fare" = 0;
ArrDateTime = "2026-05-03 09:00:00";
ArrTime = "09:00";
ArrivalDate = "03-05-2026";
AvailableSeats = 40;
AvailableSingleSeat = 0;
AvlWindowSeats = "-1";
BusRoutes = "Bangalore-Hyderabad";
BusStatus =             {
BaseFares = "<null>";
TotalTax = "<null>";
};
BusTypeId = 1101;
BusTypeName = "Isuzu A/C Seater/Sleeper Executive Luxury (1+1)";
CacheKey = 36a85eed346655860a6707125e79e030;
CancPolicy =             (
                {
    charge = "\U20b90 (100%)";
    time = "02 May 08:00 AM - 02 May 08:00 PM";
},
                {
    charge = "\U20b90 (50%)";
    time = "01 May 08:00 PM - 02 May 08:00 AM";
},
                {
    charge = "\U20b90 (10%)";
    time = "Before 01 May 08:00 PM";
}
);
CommAmount = 0;
CompanyId = 3;
CompanyName = "TESTING ACCOUNT";
CompanySuf = "";
DepartureDate = "2026-05-02";
DeptDateTime = "2026-05-02 20:00:00";
DeptTime = "20:00";
DiscountAmt = "";
Dropoffs =             (
                {
    Address = sdfghjn;
    Contact = 908777776;
    DropArea = "A.S Raonagar";
    DropoffCode = 225777;
    DropoffName = "A.S Raonagar (Pickup Bus)";
    DropoffTime = "09:00";
    Landmark = kjmhnbvgcfxz;
}
);
Duration = "13:00 hrs";
Fare = 0;
From = Bangalore;
HasAC = true;
HasNAC = false;
HasSeater = true;
HasSleeper = true;
Id = 2000000156000105832;
IsVolvo = "";
LiveTrackingAvailable = false;
Pickups =             (
                {
    Address = "Indra Nagar";
    Contact = 98765432234;
    Landmark = "Nandana Hotel";
    PickupArea = "Indian Express";
    PickupCode = 263409;
    PickupName = "Indian Express";
    PickupTime = "20:00";
}
);
ProvId = 10419079;
ResultToken = "36a85eed346655860a6707125e79e030*_*1*_*nhzm7VTX3PMHYBDc";
RouteCode = 2000000100000105832;
RouteScheduleId = 2000000156000105832;
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
}
*/
