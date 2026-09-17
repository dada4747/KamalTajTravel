//
//  FlightSeatsCVCell.swift
//  MTM
//
//  Created by Nandu on 19/07/23.
//

import UIKit

class FlightSeatsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var img_seats: UIImageView!
    @IBOutlet weak var lbl_seatNo: UILabel!
    @IBOutlet weak var bg_view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureWithSeat(seatKey: String, seat: FSeatDetails, isSelected: Bool) {
        lbl_seatNo.text = seatKey
        bg_view.isHidden = false
        lbl_seatNo.textColor = UIColor.black
        let seatAvailability = seat.flag == "AVA"
        if seatAvailability {
            lbl_seatNo.text = ""
            if isSelected {
//                backgroundColor = UIColor.blue
               img_seats.image = UIImage.init(named: "ic_seat_selected")

            } else {
//                backgroundColor = UIColor.gray
                lbl_seatNo.text = seatKey

                img_seats.image = UIImage.init(named: "ic_seat_available")

            }

        }else{
            img_seats.image = UIImage.init(named: "ic_seat_unavailable")

        }

        
    }
//    func configureWithSeat(seatKey: String, seat: SeatDetails) {
//        lbl_seatNo.text = seatKey
//        contentView.backgroundColor = seat.flag == "AVA" ? UIColor.green.withAlphaComponent(0.6) : UIColor.red.withAlphaComponent(0.6)
//
//        bg_view.isHidden = false
//        //cell.bg_view.backgroundColor = UIColor.ThemeColor_Blue
//        lbl_seatNo.textColor = UIColor.black
//        lbl_seatNo.text = seatKey
//        let seatAvailability = seat.flag == "AVA"
//        img_seats.image = UIImage.init(named: "ic_seat_available_square")
//
//        if seatAvailability {
//            img_seats.image = UIImage.init(named: "ic_seat_unavailable")
//            lbl_seatNo.text = ""
//        }
//    }
    
    func configureAsSpace() {
        lbl_seatNo.text = ""
        contentView.backgroundColor = UIColor.clear
        contentView.layer.borderWidth = 0
        bg_view.backgroundColor = .white
        lbl_seatNo.textColor = .black
        bg_view.isHidden = true
//        self.isUserInteractionEnabled = false
        
    }
    
    func configureAsEmpty() {
        lbl_seatNo.text = "-"
        contentView.backgroundColor = UIColor.lightGray
    }
    func configureWith(seat: Seat, isSelected: Bool) {
        lbl_seatNo.text = ""
        img_seats.image = nil
        isUserInteractionEnabled = true

        switch seat.availablityType {
            
        case -1:
            // Placeholder / aisle
            img_seats.image = nil
            lbl_seatNo.text = ""
            isUserInteractionEnabled = false

        case 3, 0:
            // Unavailable seat
            img_seats.image = UIImage(named: "ic_seat_unavailable")
            lbl_seatNo.text = ""
            isUserInteractionEnabled = false

        case 1:
            // Available / selected seat
            img_seats.image = isSelected
                ? UIImage(named: "ic_seat_selected")
                : UIImage(named: "ic_seat_available")
            lbl_seatNo.text = isSelected
            ? ""
            : seat.seatNumber
            isUserInteractionEnabled = true

        default:
            break
        }
    }
}
