//
//  FSearchListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol fSearchListCellDelegate {
    func flightBooking_Action(sender: UIButton, cell: UITableViewCell)
    func fareRules_Action(sender: UIButton, cell: UITableViewCell)
}

// class...
class FSearchListCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var view_BgView: CardView!
    @IBOutlet weak var lbl_airlineName: UILabel!
    @IBOutlet weak var img_airlineImg: UIImageView!
    @IBOutlet weak var img_stops: UIImageView!
    @IBOutlet weak var lbl_airlineCode: UILabel!
    
    @IBOutlet weak var lbl_departureDate: UILabel!
    @IBOutlet weak var lbl_departureTime: UILabel!
    @IBOutlet weak var lbl_departureCity: UILabel!
    
    @IBOutlet weak var lbl_travelHours: UILabel!
    @IBOutlet weak var lbl_noofStops: UILabel!
    
    @IBOutlet weak var lbl_arrivalDate: UILabel!
    @IBOutlet weak var lbl_arrivalTime: UILabel!
    @IBOutlet weak var lbl_arrivalCity: UILabel!
    
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_refund: UILabel!
    
//    @IBOutlet weak var refund_YContrian: NSLayoutConstraint! // default; -8
    @IBOutlet weak var btn_book: UIButton!
    @IBOutlet weak var bookBtn_HContrain: NSLayoutConstraint! // default : 28
    
    
    // delegate...
    var delegate: fSearchListCellDelegate?
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_information(fightModel: DFlightSearchItem, selectItem: DFlightSearchItem?) {
        print(String(format: "%@%@/%@.gif", Base_Image_URL, DFlightSearchModel.airline_imgUrl, fightModel.airline_img!))
        // display informaiton...
        lbl_airlineName.text = fightModel.airline_name
        img_airlineImg .sd_setImage(with: URL.init(string: String(format: "%@%@/%@.gif", Base_Image_URL, DFlightSearchModel.airline_imgUrl, fightModel.airline_img!)))
        lbl_airlineCode.text = fightModel.airline_code
        
        lbl_departureDate.text = fightModel.depart_date
        lbl_departureTime.text = fightModel.depart_time
        lbl_departureCity.text = fightModel.depart_city
        
        lbl_travelHours.text = fightModel.travel_hours
        lbl_noofStops.text = "\(fightModel.noof_stops) Stops"
        
        if fightModel.noof_stops == 0 {
            img_stops.image = UIImage.init(named: "ic_zeroStop")
            lbl_noofStops.text = "\(fightModel.noof_stops) Stop"
        } else if fightModel.noof_stops == 1 {
            img_stops.image = UIImage.init(named: "ic_onestop")
        } else if fightModel.noof_stops == 2 {
            
            img_stops.image = UIImage.init(named: "ic_onePlusStop")
            
        } else {
            img_stops.image = UIImage.init(named: "ic_nonStop")
        }
        
        lbl_arrivalDate.text = fightModel.arrival_date
        lbl_arrivalTime.text = fightModel.arrival_time
        lbl_arrivalCity.text = fightModel.arrival_city
        
        lbl_currency.text = DCurrencyModel.currency_saved?.currency_symbol ?? ""// fightModel.currency_code
        lbl_price.text = String(format: "%.0f", (fightModel.ticket_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))//String(format: "%.2f", fightModel.ticket_price)
        
        lbl_refund.text = "Not refundable"
        if fightModel.is_refund == true {
            lbl_refund.text = "Refundable"
        }
        
        // corner radios color changes...
        view_BgView.borderColor = UIColor.lightGray
//        view_BgView.borderWidth = 1
        
        // corners color changes...
        if let finalItem = selectItem {
            if finalItem.auth_key == fightModel.auth_key {
                
                view_BgView.borderColor = .appColor
                view_BgView.borderWidth = 2
            }
        }
        
        // frame adjust at round trip...
        if DTravelModel.tripType == .Round {
            
            // booking button hidden...
            btn_book.isHidden = true
            bookBtn_HContrain.constant = 0
//            refund_YContrian.constant = 8
        }
    }
    
    
    // MARK:- ButtonActions
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        delegate?.flightBooking_Action(sender: sender, cell: self)
    }
    
    @IBAction func fareRuleButtonClicked(_ sender: UIButton) {
        delegate?.fareRules_Action(sender: sender, cell: self)
    }
}
