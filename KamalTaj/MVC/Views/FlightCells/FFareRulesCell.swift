//
//  FFareRulesCell.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit

class FFareRulesCell: UITableViewCell {
    
    // MARK:- Outlet
    @IBOutlet weak var lbl_fromCity: UILabel!
    @IBOutlet weak var lbl_toCity: UILabel!
    @IBOutlet weak var lbl_airlines: UILabel!
    @IBOutlet weak var lbl_rulesDes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayFair_rulesInformation(fairModel: DFairRulesModel) {
        
        // display information...
        lbl_fromCity.text = fairModel.from_city
        lbl_toCity.text = fairModel.to_city
        lbl_airlines.text = fairModel.airline_code
        
        let final_descript = "<div align=\"justify\">\(fairModel.rules_descript)</div>"
        lbl_rulesDes.attributedText = final_descript.htmlToAttributedString
    }
    
}
