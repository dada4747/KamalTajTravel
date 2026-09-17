//
//  CurrencyFlagsCell.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//


import UIKit

class CurrencyFlagsCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_countryName: UILabel!
    @IBOutlet weak var lbl_line: UILabel!
    @IBOutlet weak var lbl_currencySymbol: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var right_view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
