//
//  PaymentMethodcell.swift
//  EasiTripBooking
//
//  Created by Nandu on 12/02/25.
//

import UIKit

class PaymentMethodcell: UITableViewCell {

    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
