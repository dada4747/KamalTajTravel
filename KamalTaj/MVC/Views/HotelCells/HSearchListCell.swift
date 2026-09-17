//
//  HSearchListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol hSearchListCellDelegate {
    func hotelBooking_Action(sender: UIButton, cell: UITableViewCell)
//    func hotelAddWishlist_Action(sender: UIButton, cell: UITableViewCell)
}


// class...
class HSearchListCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var img_hotel: UIImageView!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    
    @IBOutlet weak var img_wifi: UIImageView!
    @IBOutlet weak var img_breakfast: UIImageView!
    @IBOutlet weak var img_parking: UIImageView!
    @IBOutlet weak var img_swim: UIImageView!
    @IBOutlet weak var rating_view: FloatRatingView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var coll_facilities: UICollectionView!
    
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var btn_wishlist: UIButton!
    
    
    var delegate: hSearchListCellDelegate?
    var facilitiesArray: [String] = []

    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rating_view.type = .floatRatings
        coll_facilities.delegate = self
        coll_facilities.dataSource = self
        
        // register...
        coll_facilities.register(UINib.init(nibName: "FacilityCVCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCVCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_hotelsearchInformation(hModel: DHotelSearchItem) {
        print(hModel.facilitiesArray)
        facilitiesArray = hModel.facilitiesArray
        coll_facilities.reloadData()
        // display information...
//        img_hotel .sd_setImage(with: URL.init(string: hModel.hotel_img!))
        img_hotel.sd_setImage(with: URL(string: hModel.hotel_img!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "ic_placeholder"), completed: nil)

        lbl_hotelName.text = hModel.hotel_name
        lbl_hotelAddress.text = hModel.hotel_address
        
        //amenities...
        img_wifi.alpha = 0.3
        img_breakfast.alpha = 0.3
        img_parking.alpha = 0.3
        img_swim.alpha = 0.3
        if hModel.wifi == true {
            img_wifi.alpha = 1.0
        }
        if hModel.breakfast == true {
            img_breakfast.alpha = 1.0
        }
        if hModel.parking == true {
            img_parking.alpha = 1.0
        }
        if hModel.swim == true {
            img_swim.alpha = 1.0
        }
        rating_view.rating = Double(hModel.hotel_rating)
        lbl_rating.text = "\(Double(hModel.hotel_rating))"
        
        print( DCurrencyModel.currency_saved?.currency_symbol ?? "$")
        print(((hModel.hotel_price + hModel.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        
        lbl_price.text =  String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "$", ((hModel.hotel_price + hModel.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        
        //lbl_refundStatus.text = "Not refundable"
//        btn_wishlist.setImage(UIImage(named: "ic_wishlist"), for: .normal)
//        if hModel.isWishlisted == true {
//            btn_wishlist.setImage(UIImage(named: "ic_wishlist_sel"), for: .normal)
//        }
    }

    
    // MARK:- ButtonAction
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        delegate?.hotelBooking_Action(sender: sender, cell: self)
    }
    @IBAction func addWishlistButtonClicked(_ sender: UIButton) {
//        delegate?.hotelAddWishlist_Action(sender: sender, cell: self)
    }
}


extension HSearchListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = facilitiesArray[indexPath.item]
        label.font = UIFont(name: "Poppins-Medium", size: 10)
        label.sizeToFit()
        
        let cellPadding: CGFloat = 16 // Extra padding for spacing
        let width = label.frame.width + cellPadding
        print(width)
        let height: CGFloat = 20 // Fixed height
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilitiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCVCell", for: indexPath as IndexPath) as! FacilityCVCell
        //best holiday cell
        let item = facilitiesArray[indexPath.row]
        cell.lbl_name.text = item
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
}
