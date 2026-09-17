//
//  HotelBookingTVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 23/06/21.
//

import UIKit

class HotelBookingTVCell: UITableViewCell {
    @IBOutlet weak var lbl_hotel_name: UILabel!
    @IBOutlet weak var lbl_hotel_address: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_noOfRooms: UILabel!
    @IBOutlet weak var lbl_checkin: UILabel!
    @IBOutlet weak var lbl_checkout: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var img_hotel: UIImageView!
    @IBOutlet weak var btn_voucher: GradientButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayHotelBooking(model: DHotelHistoryItem) {
        
//        // display information...
//        img_hotel.sd_setImage(with: URL.init(string: model.hotelImg!))
//        lbl_checkin.text = model.hotel_check_in
//        lbl_checkout.text = model.hotel_check_out
//        lbl_bookingId.text = model.booking_id
//        lbl_hotel_name.text = model.hotel_name
//        lbl_hotel_address.text = model.address
//        lbl_status.text = model.booking_status
//        if model.booking_status == "BOOKING_CONFIRMED"{
//            self.btn_cancel.alpha = 1
//        }else{
//            self.btn_cancel.alpha = 0
//        }
//        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (model.total_fare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
//        //lbl_noOfRooms.text = String(format: "%d Days", model.noof_night)
        
    }
    
}
