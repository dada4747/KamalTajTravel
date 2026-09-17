//
//  CustomorReviewsTVCell.swift
//  Hoetus
//
//  Created by Rahul Adsure on 07/05/24.
//

import UIKit

class CustomorReviewsTVCell: UITableViewCell {

    @IBOutlet weak var img_customer: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var view_rating: FloatRatingView!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func displayReview(model: CReviewItem){
        let url = URL.init(string: model.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        img_customer.sd_setImage(with: url )
        lbl_name.text = "\(model.first_name ?? "") \(model.last_name ?? "")"
        view_rating.rating = model.rating
        let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: model.created_on!)

        lbl_date.text = DateFormatter.getDateString(formate: "MMM dd, yyyy hh:mm", date: destinDate)
        lbl_desc.text = model.review
    }
    func displayReview(model: String){
    }
}
