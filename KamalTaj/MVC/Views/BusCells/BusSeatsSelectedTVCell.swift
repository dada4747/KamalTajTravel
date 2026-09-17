//
//  BusSeatsSelectedTVCell.swift
//  PuranTrip
//
//  Created by Rahul on 28/04/26.
//

import UIKit

class BusSeatsSelectedTVCell: UITableViewCell {

    @IBOutlet weak var lbl_seatName: UILabel!
    @IBOutlet weak var lbl_seatPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displaySelectedSeats(model: SeatDetails ){
        lbl_seatName.text = model.seatName
        lbl_seatPrice.text = "\(model.seatFare)"
    }
}
