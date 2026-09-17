//
//  NotificationsCell.swift
//  Internacia
//
//  Created by Admin on 08/11/22.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
//    @IBOutlet weak var lbl_description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayNotifyDetails(){
        
    }
    
}
