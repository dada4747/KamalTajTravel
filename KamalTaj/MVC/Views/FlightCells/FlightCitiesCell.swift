//
//  FlightCitiesCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

//MARK:- Cell protocol
protocol flightCitiesCellDelegate {
    
    func departureCity_Action(sender: UIButton, cell: UITableViewCell)
    func destinationCity_Action(sender: UIButton, cell: UITableViewCell)
    func selectDate_Action(sender: UIButton, cell: UITableViewCell)
    func cancelButton_Action(sender: UIButton, cell: UITableViewCell)
}


// MARK:- Class
class FlightCitiesCell: UITableViewCell {

    // outlets...
    @IBOutlet weak var tf_departureCity: UITextField!
    @IBOutlet weak var tf_destinationCity: UITextField!
    @IBOutlet weak var tf_selectDate: UITextField!
    @IBOutlet weak var btn_cancel: UIView!
//    @IBOutlet weak var line_down: UILabel!
    
    // delegate...
    var delegate: flightCitiesCellDelegate?
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK:- ButtonActions
    @IBAction func departureCityClicked(_ sender: UIButton) {
        delegate?.departureCity_Action(sender: sender, cell: self)
    }
    
    @IBAction func destinationCityClicked(_ sender: UIButton) {
        delegate?.destinationCity_Action(sender: sender, cell: self)
    }
    
    @IBAction func selectDateClicked(_ sender: UIButton) {
        delegate?.selectDate_Action(sender: sender, cell: self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        delegate?.cancelButton_Action(sender: sender, cell: self)
    }
    
}
