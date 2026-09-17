//
//  FMultiSearchListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol fMulitSearchListCell {
    func flightBooking_MultiAction(sender: UIButton, cell: UITableViewCell)
    func fareRules_MultiAction(sender: UIButton, cell: UITableViewCell)
}

// class
class FMultiSearchListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    // Outlets...
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_refund: UILabel!
    @IBOutlet weak var tbl_mutliCity: UITableView!
    
    
    // variables...
    var delegate: fMulitSearchListCell?
    var flightStopsArray: [DFlightSearchItem] = []
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // table delegates..
        tbl_mutliCity.delegate = self
        tbl_mutliCity.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_Information(flightArray: [DFlightSearchItem]) {
        
        flightStopsArray = flightArray
        tbl_mutliCity.reloadData()
    }
    
    
    // MARK:- ButtonActions
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        delegate?.flightBooking_MultiAction(sender: sender, cell: self)
    }
    
    @IBAction func fairRulesButtonClicked(_ sender: UIButton) {
        delegate?.fareRules_MultiAction(sender: sender, cell: self)
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightStopsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension// 138
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FMultiSubListCell") as? FMultiSubListCell
        if cell == nil {
            tableView.register(UINib(nibName: "FMultiSubListCell", bundle: nil), forCellReuseIdentifier: "FMultiSubListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FMultiSubListCell") as? FMultiSubListCell
        }
        
        
        // display informaiton...
        cell?.lbl_airlineName.text = flightStopsArray[indexPath.row].airline_name
        cell?.img_airlineImg .sd_setImage(with: URL.init(string: String(format: "%@%@/%@.gif", Base_Image_URL, DFlightSearchModel.airline_imgUrl, flightStopsArray[indexPath.row].airline_img!)))
        cell?.lbl_airlineCode.text = flightStopsArray[indexPath.row].airline_code

        cell?.lbl_departureDate.text = flightStopsArray[indexPath.row].depart_date
        cell?.lbl_departureTime.text = flightStopsArray[indexPath.row].depart_time
        cell?.lbl_departureCity.text = flightStopsArray[indexPath.row].depart_city

        cell?.lbl_travelHours.text = flightStopsArray[indexPath.row].travel_hours
        cell?.lbl_noofStops.text = "\(flightStopsArray[indexPath.row].noof_stops) Stop"

        cell?.lbl_arrivalDate.text = flightStopsArray[indexPath.row].arrival_date
        cell?.lbl_arrivalTime.text = flightStopsArray[indexPath.row].arrival_time
        cell?.lbl_arrivalCity.text = flightStopsArray[indexPath.row].arrival_city

      
        cell?.selectionStyle = .none
        return cell!
    }
}
