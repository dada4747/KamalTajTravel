//
//  FStopsHeaderCell.swift
//  Hoetus
//
//  Created by Rahul on 14/01/24.
//

import UIKit

class FStopsHeaderCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lbl_fromCity: UILabel!
    @IBOutlet weak var lbl_toCity: UILabel!
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var lbl_journeyDate: UILabel!
    @IBOutlet weak var lbl_noofPassengers: UILabel!
    @IBOutlet weak var lbl_journeyType: UILabel!
    
    @IBOutlet weak var lbl_duration: UILabel!
    
    @IBOutlet weak var lbl_noofStops: UILabel!
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_information(headModel: DFlightStopsHeadItem) {
        
        lbl_fromCity.text = headModel.from_cityCode
        lbl_toCity.text = headModel.to_cityCode
        lbl_journeyDate.text = headModel.start_date
        lbl_noofPassengers.text = "\(headModel.noof_passengers) travellers"
//        lbl_journeyType.text = headModel.journeyType
//        lbl_noofStops.text = headModel.count
//        lbl_duration.text = headModel.totalDuration
    }
    

}


