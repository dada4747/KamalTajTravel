//
//  HotelMapCVCell.swift
//  EzyAirline
//
//  Created by Rahul on 25/03/25.
//

import UIKit

class HotelMapCVCell: UICollectionViewCell {
    @IBOutlet weak var img_hotel: UIImageView!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var rating_view: FloatRatingView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var bg_view: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(with hModel: DHotelSearchItem, isSelected: Bool) {
        lbl_hotelName.text = hModel.hotel_name
        rating_view.rating = Double(hModel.hotel_rating)
        lbl_price.text =  String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "$", ((hModel.hotel_price + hModel.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        bg_view.borderColor = /*isSelected ?*/ UIColor(hexString: "#FF8A37") //: UIColor.clear
        bg_view.borderWidth = isSelected ?  1 : 0
        img_hotel.sd_setImage(with: URL(string: hModel.hotel_img!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "ic_placeholder"), completed: nil)

//        priceLabel.textColor = isSelected ? .white : .black
    }
}
//141
