//
//  TransferItineraryCell.swift
//  ExtactTravel
//
//  Created by Admin on 22/08/22.
//

import UIKit

class TransferItineraryCell: UITableViewCell {
    
    // MARK:- Outlet
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var view_title_HContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
