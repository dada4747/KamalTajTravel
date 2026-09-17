//
//  TopDestinationCVCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
class TopDestinationCVCell: UICollectionViewCell {
    
    @IBOutlet weak var image_hotel: UIImageView!
    @IBOutlet weak var lbl_hotelCity: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_exp: UILabel!
    @IBOutlet weak var lbl_fromTo: UILabel!
    var buttonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    // MARK:- Helpers
    func displayTrendingHotelInformation(model: DCommonTrendingHotelItems) {
        // display information...
        image_hotel.sd_setImage(with: URL.init(string: model.hotel_img_url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
//        print(model.hotel_img_url)
        lbl_hotelCity.text = model.cityName
        lbl_exp.text = "( " + model.hotelCount! + " hotels )"
        lbl_fromTo.isHidden = true
    }
   
    @IBAction func btnSelectAction(_ sender: UIButton) {

        buttonAction?()

    }

}
