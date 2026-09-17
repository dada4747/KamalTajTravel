//
//  SliderMenuCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class SliderMenuCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var view_line: UIView!

    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var view_gradient: GradientView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:-
    func display_sideMenuInformation(title_name: String) -> Void {
//        print(title_name.replacingOccurrences(of: " ", with: ""))
        lbl_name.text = title_name
        view_line.isHidden = true
        img_icon.image = UIImage(named: title_name.replacingOccurrences(of: " ", with: ""))
    }
    
}

