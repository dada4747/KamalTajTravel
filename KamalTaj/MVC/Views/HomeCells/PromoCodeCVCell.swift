//
//  PromoCodeCVCell.swift
//  PuranTrip
//
//  Created by Rahul on 21/04/26.
//

import UIKit
protocol ApplyPromoDelegateCVCell: AnyObject {
    func didCopyPromoCode(message: String)
}

class PromoCodeCVCell: UICollectionViewCell {

    @IBOutlet weak var view_bg: GradientButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var offer_descri: UILabel!
    @IBOutlet weak var module: UILabel!
    @IBOutlet weak var promocode: UILabel!
    
    var delegate : ApplyPromoDelegateCVCell?
    var model : DCommonTopOfferItems!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func display(model: DCommonTopOfferItems){
//        self.model = model
//        title.text = "Flat"
//        self.module.text = "On \(model.module ?? "")"
//        self.promocode.text = model.promoCode
//        self.offer_descri.text =  "\(String(format: "%.0f %@", (model.minimum_amount ?? 0.0) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD"))"
//        
//    }
    func display(model: DCommonTopOfferItems){
        self.model = model
        
        title.text = "Flat"
        self.module.text = "On \(model.module ?? "")"
        self.promocode.text = model.promoCode
        
        let value = model.value ?? 0
        let valueType = model.value_type ?? ""
        let minAmount = model.minimum_amount ?? 0
        
        if valueType.lowercased() == "percentage" {
            self.offer_descri.text = "\(value)% off"
            
        } else if valueType.lowercased() == "plus" {
            // Flat discount case
            self.offer_descri.text = "₹\(value) off"
            
            // Optional (better UX)
            if minAmount != 0 {
                self.offer_descri.text = "₹\(value) off on min ₹\(minAmount)"
            }
        } else {
            self.offer_descri.text = ""
        }
    }
    @IBAction func actionCopy(_ sender: UIButton) {
        // Copy promo code text to clipboard
        if let promo = model?.promoCode {
            UIPasteboard.general.string = promo
            
            // Notify Home screen with success message
            delegate?.didCopyPromoCode(message: "Promo code copied successfully")
        }
    }
    
}
