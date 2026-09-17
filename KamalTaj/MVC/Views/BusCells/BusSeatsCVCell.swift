//
//  BusSeatsCVCell.swift
//  MTM
//
//  Created by Nandu on 31/01/25.
//

import UIKit

class BusSeatsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSeats: UIImageView!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblSeatsTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reset() {
        imgSeats.image = nil
        imgSeats.isHidden = true
        lblSeats.text = ""
    }

}
