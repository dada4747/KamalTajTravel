//
//  FMultiSubListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FMultiSubListCell: UITableViewCell {
    
    // Outlets...
    @IBOutlet weak var lbl_airlineName: UILabel!
    @IBOutlet weak var img_airlineImg: UIImageView!
    @IBOutlet weak var lbl_airlineCode: UILabel!
    
    @IBOutlet weak var lbl_departureDate: UILabel!
    @IBOutlet weak var lbl_departureTime: UILabel!
    @IBOutlet weak var lbl_departureCity: UILabel!
    
    @IBOutlet weak var lbl_travelHours: UILabel!
    @IBOutlet weak var lbl_noofStops: UILabel!
    
    @IBOutlet weak var lbl_arrivalDate: UILabel!
    @IBOutlet weak var lbl_arrivalTime: UILabel!
    @IBOutlet weak var lbl_arrivalCity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
