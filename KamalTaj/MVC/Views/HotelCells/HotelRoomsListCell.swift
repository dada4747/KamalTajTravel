//
//  HotelRoomsListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol hRoomsListCellDelegate {
    func roomSeletion_Action(sender: UIButton, cell: UITableViewCell)
    func cancelPolicy_Action(sender: UIButton, cell: UITableViewCell)
}


// class...
class HotelRoomsListCell: UITableViewCell {

    // MARK:- Outlet
    @IBOutlet weak var img_room: CRImageView!
    @IBOutlet weak var lbl_roomName: UILabel!
    @IBOutlet weak var lbl_amenties: UILabel!
    @IBOutlet weak var lbl_refundStatus: UILabel!

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_noofNights: UILabel!
    @IBOutlet weak var view_background: CardView!
    @IBOutlet weak var view_selected: CRView!
    @IBOutlet weak var img_selectImg: UIImageView!
    @IBOutlet weak var lbl_select: UILabel!
    @IBOutlet weak var guest_count: UILabel!
    
    @IBOutlet weak var no_of_room: UILabel!
    //    @IBOutlet weak var lblSelect_XConstrint: NSLayoutConstraint! // default 32... 25
    
    var delegate: hRoomsListCellDelegate?
    var defaultColor = UIColor.init(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultColor = lbl_price.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
//    func displayRooms_information(rModel: DHotelRoomItem) {
//        
//        // room info...
//        lbl_roomName.text = rModel.room_name
//        lbl_amenties.text = ""
//        if rModel.amenities_array.count != 0 {
//            lbl_amenties.text = "♨ " + rModel.facilities.joined(separator: "\n♨ ")
//        }
//        
//        // selection buttons...
////        view_selected.addGradientWithColor(color1: .clear, color: .clear)
////        view_selected.backgroundColor = UIColor.white
//
////        lbl_select.textColor = UIColor(hexString: "#F29652")// defaultColor
////        img_selectImg.isHidden = true
////        lblSelect_XConstrint.constant = 25
//        img_room.sd_setImage(with: URL(string: rModel.room_image ?? ""))
//        // price info....
//        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "$",(rModel.room_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator()) // String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", rModel.room_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", rModel.currency, rModel.room_price)
//        lbl_noofNights.text = "( \(DHTravelModel.noof_nights) Nights )"
////        guest_count.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests"
//        let adults = DHTravelModel.adult_count
//        let children = DHTravelModel.child_count
//
//        var guestText = ""
//
//        if adults > 0 {
//            guestText += "\(adults) Adult" + (adults > 1 ? "s" : "")
//        }
//
//        if children > 0 {
//            if !guestText.isEmpty { guestText += ", " } // add comma if adults already added
//            guestText += "\(children) Child" + (children > 1 ? "ren" : "")
//        }
//
//        guest_count.text = guestText
//        no_of_room.text = "No Of Rooms: \(DHTravelModel.roomCount)"
//        
//        lbl_refundStatus.text = "Not Refundable"
//        if rModel.is_refundable == true {
//            lbl_refundStatus.text = "Refundable"
//        }
//    }
    
    func displayRooms_information(rModel: DHotelRoomItem) {
        
        // room info...
        lbl_roomName.text = rModel.room_name
        lbl_amenties.text = ""
        if rModel.amenities_array.count != 0 {
            lbl_amenties.text = "♨ " + rModel.amenities_array.joined(separator: "\n♨ ")
        }else{
            lbl_amenties.text = "Room Only"
        }
        
//        img_room.sd_setImage(with: URL(string: rModel. ?? ""))

        lbl_price.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "AUD", rModel.room_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))

        lbl_noofNights.text = "( \(DHTravelModel.noof_nights) Nights )"

        let adults = DHTravelModel.adult_count
        let children = DHTravelModel.child_count

        var guestText = ""

        if adults > 0 {
            guestText += "\(adults) Adult" + (adults > 1 ? "s" : "")
        }

        if children > 0 {
            if !guestText.isEmpty { guestText += ", " } // add comma if adults already added
            guestText += "\(children) Child" + (children > 1 ? "ren" : "")
        }

        guest_count.text = guestText
        no_of_room.text = "No Of Rooms: \(DHTravelModel.roomCount)"
        
        lbl_refundStatus.text = "Not Refundable"
        if rModel.is_refundable == true {
            lbl_refundStatus.text = "Refundable"
        }
    }
    
    // MARK:- ButtonActions
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        delegate?.roomSeletion_Action(sender: sender, cell: self)
    }
    
    @IBAction func cancelPolicyButtonClicked(_ sender: UIButton) {
        delegate?.cancelPolicy_Action(sender: sender, cell: self)
    }
}


