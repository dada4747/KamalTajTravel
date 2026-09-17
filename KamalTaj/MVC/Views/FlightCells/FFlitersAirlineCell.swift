//
//  FFlitersAirlineCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol flitersAirlineCellDelegate {
    func selectAirlineButton_Action(sender: UIButton, cell: UITableViewCell)
}

// class...
class FFlitersAirlineCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var lbl_airlineName: UILabel!
    @IBOutlet weak var btn_checkMark: UIButton!
    
    var delegate: flitersAirlineCellDelegate?
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func displayAirline_infomration(airline_name: String, selection_array: [String]) {
        
        // display airline names....
        lbl_airlineName.text = airline_name
        btn_checkMark.tintColor = UIColor(hexString: "#555555")
        btn_checkMark.setImage(UIImage.init(named: "ic_uncheck"), for: .normal)
        if selection_array .contains(airline_name) {
            btn_checkMark.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    
    
    // MARK:- ButtonActions
    @IBAction func selectAirline_ButtonClicked(_ sender: UIButton) {
        delegate?.selectAirlineButton_Action(sender: sender, cell: self)
    }
}


