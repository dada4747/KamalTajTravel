//
//  TopPackageCVCell.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit
protocol TopPackageCellProtocol {
    func topSelectedPAckage(index: Int, cell: UICollectionViewCell)
}
class TopPackageCVCell: UICollectionViewCell {
    @IBOutlet weak var view_image: RoundedImageView!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_packageName: UILabel!
    @IBOutlet weak var lbl_packageAmount: UILabel!
    var index : Int?
    var topPackageCellDelegate: TopPackageCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayTrendingPackageInfo(model: DCommonTrendingPackageItem) {
//        print(model.image)
        let img = model.package_imgUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        view_image.sd_setImage(with: URL.init(string: img!))
        lbl_location.text = model.packageLocation
        lbl_packageName.text = model.packageName
        lbl_packageAmount.text = String(format: "%@ %.0f", DCurrencyModel.currency_saved?.currency_symbol ?? "$", (( model.package_price)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
    }
    
    @IBAction func viewDetailsAction(_ sender: Any) {
        topPackageCellDelegate?.topSelectedPAckage(index: index! , cell: self)
    }
}

