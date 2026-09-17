//
//  FlightTripCVCell.swift
//  MTM
//
//  Created by Nandu on 20/12/23.
//

import UIKit

class FlightTripCVCell: UICollectionViewCell {
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_cityCode: UILabel!
    @IBOutlet weak var img_airline: UIImageView!

    @IBOutlet weak var img_wiidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var img_leftConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with title: String, isSelected: Bool) {
        bg_view.layer.borderWidth = 1
        bg_view.layer.cornerRadius = 5
        self.lbl_cityCode.text = title
        bg_view.backgroundColor = isSelected ? UIColor.appColor : UIColor.init(hexString: "#F4F5F9")
        self.lbl_cityCode.textColor = isSelected ? .white : .black
        bg_view.layer.borderColor = isSelected ? UIColor.appColor.cgColor : UIColor.init(hexString: "#CACACA").cgColor
    }
}
