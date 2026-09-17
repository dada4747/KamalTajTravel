//
//  CountryCodeCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class CountryCodeCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_countryName: UILabel!

    @IBOutlet weak var img_width: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
