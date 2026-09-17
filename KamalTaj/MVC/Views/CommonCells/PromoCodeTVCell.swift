//
//  PromoCodeTVCell.swift
//  EasiTripBooking
//
//  Created by Rahul on 15/04/25.
//

import UIKit
protocol ApplyPromoDelegate: AnyObject {
    func selectPromoCode(promoCode: DCommonTopOfferItems)
}
class PromoCodeTVCell: UITableViewCell {

    @IBOutlet weak var lbl_promoCode: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_apply: CRButton!
    
    var delegate : ApplyPromoDelegate?
    var model : DCommonTopOfferItems!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func display(model: DCommonTopOfferItems){
        self.model = model
        self.lbl_promoCode.text = model.promoCode
        self.lbl_description.text = "Get Discount on booking above \(String(format: "%.0f %@", (model.minimum_amount ?? 0.0) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD"))"
        
    }
    @IBAction func applyButtonAction(_ sender: Any) {
        // Copy promo code text to clipboard
//        if let promo = model?.promoCode {
//            UIPasteboard.general.string = promo
//            
//            // Notify Home screen with success message
//            delegate?.didCopyPromoCode(message: "Promo code copied successfully")
//        }
        delegate?.selectPromoCode(promoCode: model)

    }
}
