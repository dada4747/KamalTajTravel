//
//  FlightMealsCell.swift
//  MTM
//
//  Created by Nandu on 22/12/23.
//

import UIKit



class FlightMealsCell: UITableViewCell {
    
    @IBOutlet weak var img_radio: UIImageView!
    @IBOutlet weak var lbl_itemName: UILabel!
    @IBOutlet weak var lbl_itemPrice: UILabel!
    @IBOutlet weak var lbl_sep: UILabel!
    @IBOutlet weak var imgWConstraint: NSLayoutConstraint! // Outlet for width constraint

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayFareDetailMeals(model: FairMealModel){
        lbl_itemName.text = model.mealName
        lbl_itemPrice.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "$", (model.price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)))
        img_radio.isHidden = true
        imgWConstraint.constant = 0
    }
    
    func displayFareBaggage(baggageItem: BaggageItem) {
//        lbl_itemName.text = "\(model.0 )"
//        lbl_itemPrice.text = "\(model.1 )"
        img_radio.isHidden = true
        imgWConstraint.constant = 0
        switch baggageItem.type {
        case "cabin_baggage":
            lbl_itemName.text = "🧳 Free Cabin Baggage: "
            lbl_itemPrice.text = "\(baggageItem.value ?? 0) Kg"
            
        case "no_cabin_baggage":
            lbl_itemName.text = "Maximum Number Of Free Cabin Baggage Allowed: "
            lbl_itemPrice.text = "\(baggageItem.value ?? 0)"
        case "chechin_baggage":
            lbl_itemName.text = baggageItem.value! >= 0 ? "🛄 Free Check-in Baggage: " : ""
            lbl_itemPrice.text = baggageItem.value! >= 0 ?  "\(baggageItem.value ?? 0) Kg" : ""
        case "no_chechin_baggage":
            lbl_itemName.text = baggageItem.value! >= 0 ? "Maximum Number Of Free Check-in Baggage Allowed: " : ""
            lbl_itemPrice.text = baggageItem.value! >= 0 ?  "\(baggageItem.value ?? 0)" : ""
        case "extra_baggage_price":
            lbl_itemName.text = "💰 Extra Baggage Price Per Kg: "
            lbl_itemPrice.text = "\(baggageItem.value ?? 0) \(DCurrencyModel.currency_saved?.currency_symbol ?? "")"
        case "extra_baggage_limit":
            lbl_itemName.text = "(Maximum Limit: )"
            lbl_itemPrice.text = "\(baggageItem.value ?? 0 ) Kg"
        case "checkin_baggage_price":
            lbl_itemName.text = baggageItem.value! >= 0 ? "💼 Check-in Baggage Price:" : ""
            lbl_itemPrice.text = " \(baggageItem.value ?? 0) \(DCurrencyModel.currency_saved?.currency_symbol ?? "")"
        case "checkin_baggage_kg":
            lbl_itemName.text = baggageItem.value! >= 0 ? "(Maximum Limit: )" : ""
            lbl_itemPrice.text = "\(baggageItem.value ?? 0) Kg"
        case "hand_baggage_price":
            lbl_itemName.text = baggageItem.value! >= 0 ? "👜 Free Hand Baggage:" : ""
            lbl_itemPrice.text = "\(baggageItem.value ?? 0) Kg"
        case "weight_limit":
            lbl_itemName.text = baggageItem.value! >= 0 ? "Maximum Baggage Limit Allowed Per Passenger: " : ""
            lbl_itemPrice.text = "\(baggageItem.value ?? 0) Kg"
        default:
            lbl_itemName.text = ""
            lbl_itemPrice.text = ""
        }
    }
    func displayFlightMeals_Info(model: DFlightMealsItem, modelS: DFlightMealsItem) {
        
        lbl_itemName.text = model.descriptionText
        print(model.price)
        lbl_itemPrice.text = String(format: "%.0f %@", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "INR")//baggage_price//.text String(format: "NGN %.2f", model.price)
        
        img_radio.image = UIImage.init(named: "ic_circle")
        if model.code == modelS.code {
            img_radio.image = UIImage.init(named: "ic_circle_fill_white")
        }
    }
    
    func displayFlightBaggage_Info(model: DFlightBaggageItem, modelS: DFlightBaggageItem) {
        
        lbl_itemName.text = "\(model.weight)"
        lbl_itemPrice.text = String(format: "%.0f %@", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)), DCurrencyModel.currency_saved?.currency_symbol ?? "AUD")//baggage_price String(format: "INR %.2f", model.value!)
        
        img_radio.image = UIImage.init(named: "ic_circle")
        if model.code == modelS.code {
            img_radio.image = UIImage.init(named: "ic_circle_fill_white")
        }
    }
    
    
    
}

