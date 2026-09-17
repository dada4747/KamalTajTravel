//
//  FStopsDetailsCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FStopsDetailsCell1: UITableViewCell {

    // Outlets...
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_flightNo: UILabel!
    @IBOutlet weak var lbl_airlineName: UILabel!
    @IBOutlet weak var img_airlineImg: UIImageView!
    
    @IBOutlet weak var lbl_departAirport: UILabel!
    @IBOutlet weak var lbl_departDate: UILabel!
    @IBOutlet weak var lbl_arrivalAirport: UILabel!
    @IBOutlet weak var lbl_arrivalDate: UILabel!
    @IBOutlet weak var bg_view: UIView!
    
    @IBOutlet weak var bottomleftseparatorview: UIView!
    @IBOutlet weak var bottomrightseparatorview: UIView!
    @IBOutlet weak var topleftseparatorview: UIView!
    @IBOutlet weak var toprightseparatorview: UIView!
    
    @IBOutlet weak var img_seat: UIImageView!
    @IBOutlet weak var lbl_seat: UILabel!
    @IBOutlet weak var img_bag: UIImageView!
    @IBOutlet weak var lbl_bag: UILabel!
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
        lbl_duration.text = stopModel.travel_hours
        lbl_flightNo.text = String.init(format: "Flight No. %@",stopModel.airline_code!)
        lbl_airlineName.text = stopModel.airline_name
        img_airlineImg .sd_setImage(with: URL.init(string: String(format: "%@%@/%@.gif", Base_Image_URL, DFlightSearchModel.airline_imgUrl, stopModel.airline_image!)))
        lbl_departAirport.text = stopModel.depart_airport
        lbl_departDate.text = String(format: "%@, %@", stopModel.depart_time!, stopModel.depart_date!)
        
        lbl_arrivalAirport.text = stopModel.arrival_airport
        lbl_arrivalDate.text = String(format: "%@, %@", stopModel.arrival_time!, stopModel.arrival_date!)
        
        img_bag.isHidden = false
        lbl_bag.isHidden = false
//        lbl_bag.text = "\(stopModel.baggage ?? 0)"
//        lbl_seat.text = "\(stopModel.available_seat ?? 0) Seats"
//        
//        if stopModel.baggage! < 1 {
//            img_bag.isHidden = true
//            lbl_bag.isHidden = true
//        }
        
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


