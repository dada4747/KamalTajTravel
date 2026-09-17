//
//  FBookingCell.swift
//  ThrilloTrip
//
//  Created by Nandu on 19/06/23.
//

import UIKit
protocol FBookingCellDelegate {
    func viewFlighVoucher(model: DFlightHistoryItem)
    func cancelFlightBooking(model: DFlightHistoryItem)
}
class FBookingCell: UITableViewCell {
    
    @IBOutlet weak var flight_img: CRImageView!
    @IBOutlet weak var lbl_journeyDate: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_departTime: UILabel!
    @IBOutlet weak var lbl_departCity: UILabel!
    @IBOutlet weak var lbl_arrivalTime: UILabel!
    @IBOutlet weak var lbl_arrivalCity: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_tripType: UILabel!
    @IBOutlet weak var lbl_bookingStatus: UILabel!
    
    @IBOutlet weak var btn_viewVoucher: CRButton!
    @IBOutlet weak var btn_cancelBooking: CRButton!
    
    var fbookingModel : DFlightHistoryItem?
    var delegate : FBookingCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayFlightHistory_List(historyModel: DFlightHistoryItem) {
        fbookingModel = historyModel
        lbl_journeyDate.text = historyModel.journeyDate
        lbl_bookingId.text = historyModel.booking_id
        lbl_departTime.text = historyModel.depart_time
        lbl_departCity.text = historyModel.depart_city
        lbl_arrivalTime.text = historyModel.arrival_time
        lbl_arrivalCity.text = historyModel.arrival_city
        lbl_price.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", historyModel.flight_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_tripType.text = historyModel.tripType?.uppercased()
        lbl_bookingStatus.text = historyModel.booking_status
        
        if historyModel.booking_status == "BOOKING_CONFIRMED" {
            btn_cancelBooking.isHidden = false
            lbl_bookingStatus.textColor = .systemGreen
        }else{
            btn_cancelBooking.isHidden = true
            lbl_bookingStatus.textColor = .black
        }

    }
    @IBAction func viewVoucherAction(_ sender: Any) {
    print("view voucher button clcked")
        delegate?.viewFlighVoucher(model: fbookingModel!)
    }
    
    @IBAction func cancelBookingAction(_ sender: Any) {
        delegate?.cancelFlightBooking(model: fbookingModel!)
        print("cancel booking clcked")
    }
}

