//
//  BusHistoryCell.swift
//  EasiTripBooking
//
//  Created by Admin on 25/11/25.
//

import UIKit
protocol BBookingCellDelegate {
    func viewBusBooking(model: DBusHistoryItem)
    func cancelBusBooking(model: DBusHistoryItem)
}
class BusHistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_toTime: UILabel!
    @IBOutlet weak var lbl_from_time: UILabel!
    @IBOutlet weak var lbl_travel_date: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_booking_status: UILabel!
    
    @IBOutlet weak var lblFromCity: UILabel!
    @IBOutlet weak var lbl_toCity: UILabel!
    
    @IBOutlet weak var btncancelbooking: UIButton!
    var busBookingModel : DBusHistoryItem?
    var delegate : BBookingCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayBusList(busModel: DBusHistoryItem){
        busBookingModel = busModel
        lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", busModel.grand_total ?? 0.0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: busModel.arrival_datetime!)
        lbl_toTime.text = DateFormatter.getDateString(formate: "HH:mm", date: destinDate)
        let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: busModel.departure_datetime!)
        lbl_from_time.text = DateFormatter.getDateString(formate: "HH:mm", date: arrDate)
        let travDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: busModel.departure_datetime!)
        
        lbl_travel_date.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: travDate)
        lbl_bookingId.text = busModel.app_reference
        lblFromCity.text = busModel.departure_from
        lbl_toCity.text = busModel.arrival_to
        if busModel.status == "BOOKING_CONFIRMED" {
            btncancelbooking.isHidden = false
            lbl_booking_status.textColor = .systemGreen
            lbl_booking_status.text = busModel.status
        } else {
            btncancelbooking.isHidden = true
            lbl_booking_status.textColor = .black
            lbl_booking_status.text = busModel.status
        }
        
    }
    
    @IBAction func viewAction(_ sender: Any) {
        delegate?.viewBusBooking(model: busBookingModel!)
    }
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelBusBooking(model: busBookingModel!)
    }
}
