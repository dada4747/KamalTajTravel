//
//  HomeModulesCVCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class HomeModulesCVCell: UICollectionViewCell {
    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_underline: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
        // Change appearance on selection
        func updateSelection(isSelected: Bool) {
            if isSelected {
                view_underline.backgroundColor = UIColor(hexString: "#003B95") // Change to selected color
                img_icon.tintColor = .white
                lbl_title.textColor = .white
                // Change label text
            } else {
                view_underline.backgroundColor = .white
                img_icon.tintColor = UIColor(hexString: "#292929")
                lbl_title.textColor = UIColor(hexString: "#292929")
                
                // Default color
            }
        }
}
