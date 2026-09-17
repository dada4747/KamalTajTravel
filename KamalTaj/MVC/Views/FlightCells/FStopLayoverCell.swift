//
//  FStopLayoverCell.swift
//  Hoetus
//
//  Created by Rahul on 14/01/24.
//

import UIKit

class FStopLayoverCell: UITableViewCell {

    // Outlets...
    @IBOutlet weak var lbl_airportName: UILabel!
    @IBOutlet weak var lbl_layoverTime: UILabel!
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func displayOverlay_information(overModel: DFlightStopsItem) {
        
        lbl_airportName.text = overModel.arrival_airport
        lbl_layoverTime.text = String(format: "Layover %@", overModel.layOver_time!)
    }
    /*
    func displayOverlayHistory_information(overModel: DFHistoryStopsItem) {
        
        lbl_airportName.text = overModel.arrival_airport
        lbl_layoverTime.text = String(format: "Layover %@", overModel.layOver_time!)
    } */
}


