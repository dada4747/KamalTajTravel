//
//  FStopsDetailsCell.swift
//  Hoetus
//
//  Created by Rahul on 14/01/24.
//

import UIKit

class FStopsDetailsCell: UITableViewCell {

    // Outlets...
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_flightNo: UILabel!
    @IBOutlet weak var lbl_airlineName: UILabel!
    @IBOutlet weak var img_airlineImg: UIImageView!
    
    @IBOutlet weak var lbl_departAirport: UILabel!
    @IBOutlet weak var lbl_departDate: UILabel!
    @IBOutlet weak var lbl_departTime: UILabel!
    @IBOutlet weak var lbl_departCity: UILabel!
    @IBOutlet weak var lbl_departPlatform: UILabel!
    
    @IBOutlet weak var lbl_arrivalAirport: UILabel!
    @IBOutlet weak var lbl_arrivalDate: UILabel!
    @IBOutlet weak var lbl_arrivalTime: UILabel!
    @IBOutlet weak var lbl_arrivalCity: UILabel!
    @IBOutlet weak var lbl_arrivalPlatform: UILabel!
    
    @IBOutlet weak var bg_view: CRView!
    
    @IBOutlet weak var lbl_line: UILabel!
    
    @IBOutlet weak var lbl_stopCount: UILabel!
    
    @IBOutlet weak var img_seat: UIImageView!
    @IBOutlet weak var lbl_seat: UILabel!
    @IBOutlet weak var img_bag: UIImageView!
    @IBOutlet weak var lbl_bag: UILabel!

    @IBOutlet weak var bottomHConstraint: NSLayoutConstraint!
    
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func displayStops_information(stopModel: DFlightStopsItem) {
        bg_view.borderWidth = 0
        lbl_line.isHidden = true
        lbl_duration.text = stopModel.travel_hours
        lbl_flightNo.text = String.init(format: "Flight No. %@",stopModel.airline_code!)
        lbl_airlineName.text = stopModel.airline_name
        img_airlineImg .sd_setImage(with: URL.init(string: String(format: "%@%@/%@.gif", Base_Image_URL, DFlightSearchModel.airline_imgUrl, stopModel.airline_image!)))
        lbl_departAirport.text = stopModel.depart_airport
//        lbl_departDate.text = String(format: "%@, %@", stopModel.depart_time!, stopModel.depart_date!)
        
        lbl_arrivalAirport.text = stopModel.arrival_airport
//        lbl_arrivalDate.text = String(format: "%@, %@", stopModel.arrival_time!, stopModel.arrival_date!)
        
        lbl_departCity.text = stopModel.depart_city
        lbl_arrivalCity.text = stopModel.arrival_city
        lbl_departDate.text = stopModel.depart_date
        lbl_departTime.text = stopModel.depart_time
        lbl_arrivalDate.text = stopModel.arrival_date
        lbl_arrivalTime.text = stopModel.arrival_time
        
        img_bag.isHidden = false
        lbl_bag.isHidden = false
        lbl_seat.text = "Seats: \(stopModel.AvailableSeats ?? "0")"
        lbl_bag.text = "Baggage: \(stopModel.baggage?.replacingOccurrences(of: "Kilograms", with: "KG") ?? "N/A")"

//        if stopModel.baggage! < 1 {
//            img_bag.isHidden = true
//            lbl_bag.isHidden = true
//        }
        lbl_departPlatform.text = "Terminal : \(stopModel.depart_terminal)"
        lbl_arrivalPlatform.text = "Terminal : \(stopModel.arrival_terminal)"
    }
    func displayStops_informationonHotel(stopModel: DFlightStopsItem) {
        bg_view.borderWidth = 1
        bg_view.borderColor = UIColor(hexString: "#E5E5E5")
        bg_view.cornerRadius = 12
        bottomHConstraint.constant = 16
        lbl_line.isHidden = true
        lbl_duration.text = stopModel.travel_hours
        lbl_flightNo.text = String.init(format: "Flight No. %@",stopModel.airline_code!)
        lbl_airlineName.text = stopModel.airline_name
        img_airlineImg.sd_setImage(with: URL.init(string: String(format: "%@/%@",DFlightSearchModel.airline_imgUrl, stopModel.airline_image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        lbl_departAirport.text = stopModel.depart_airport
//        lbl_departDate.text = String(format: "%@, %@", stopModel.depart_time!, stopModel.depart_date!)
        
        lbl_arrivalAirport.text = stopModel.arrival_airport
//        lbl_arrivalDate.text = String(format: "%@, %@", stopModel.arrival_time!, stopModel.arrival_date!)
        
        lbl_departCity.text = stopModel.depart_city
        lbl_arrivalCity.text = stopModel.arrival_city
        lbl_departDate.text = stopModel.depart_date
        lbl_departTime.text = stopModel.depart_time
        lbl_arrivalDate.text = stopModel.arrival_date
        lbl_arrivalTime.text = stopModel.arrival_time
        
        img_bag.isHidden = false
        lbl_bag.isHidden = false
//        lbl_bag.text = "\(stopModel.baggage ?? 0)"
//        lbl_seat.text = "\(stopModel.available_seat ?? 0) Seats"
//        
//        if stopModel.baggage! < 1 {
//            img_bag.isHidden = true
//            lbl_bag.isHidden = true
//        }
        
        lbl_departPlatform.text = "Terminal : \(stopModel.depart_terminal)"
        lbl_arrivalPlatform.text = "Terminal : \(stopModel.arrival_terminal)"
        lbl_seat.text = "Seats: \(stopModel.AvailableSeats ?? "0")"
        lbl_bag.text = "Baggage: \(stopModel.baggage?.replacingOccurrences(of: "Kilograms", with: "KG") ?? "0")"


    }
    /*
    func displayStopsHistory_information(stopModel: DFHistoryStopsItem) {
        
        lbl_duration.text = stopModel.travel_hours
        lbl_flightNo.text = stopModel.airline_code
        lbl_airlineName.text = stopModel.airline_name
        img_airlineImg.sd_setImage(with: URL.init(string: String(format: "%@/%@.gif", kImage_Url, stopModel.airline_image!)))
        
        lbl_departAirport.text = stopModel.depart_airport
        lbl_departDate.text = String(format: "%@, %@", stopModel.depart_time!, stopModel.depart_date!)
        
        lbl_arrivalAirport.text = stopModel.arrival_airport
        lbl_arrivalDate.text = String(format: "%@, %@", stopModel.arrival_time!, stopModel.arrival_date!)
    } */
}


