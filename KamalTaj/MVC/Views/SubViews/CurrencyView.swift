//
//  CurrencyView.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//


import UIKit

//protocol
protocol CurrencyDelegate {
    func currencyListActions(model: DCurrencyItem)
}

protocol LanguageDelegate {
    func language_Action(lang: String)
}

class CurrencyView: UIView {
    
    // outlets...
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_currency: UITableView!
    @IBOutlet weak var tbl_HConstraint: NSLayoutConstraint!
    
    var language_array: [String] = ["English", "French", "Mandarin", "Spanish"]
    var currencyList_array: [DCurrencyItem] = []
    var delegate: CurrencyDelegate?
    var delegate_lang: LanguageDelegate?
    var isFrom = ""

    // MARK:-
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        print("called: %@", self)
        self.tbl_currency.delegate = self
        self.tbl_currency.dataSource = self
        
        
    }
    
    class func loadViewFromNib() -> UIView {
        
        // load xib view...
        let view = Bundle.main.loadNibNamed("CurrencyView", owner: self, options: nil)?.first as? CurrencyView
        view?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        return view!
    }
    
    func displayInformation() {
        
        // table max height...
        var maxHeight: Float = Float(UIScreen.main.bounds.size.height)
        maxHeight = maxHeight - 60
        
        // current table height...
        var tblHeight = 0
        if isFrom == "Lang" {
            lbl_title.text = "Select Language" //Localization(key: "Select Language")
            tblHeight = (language_array.count * 45) + 50
        } else {
            lbl_title.text = "Select Currency" //Localization(key: "Select Currency")
            currencyList_array = DCurrencyModel.currency_array
            tblHeight = (currencyList_array.count * 45) + 50
        }
        
        if maxHeight >= Float(tblHeight) {
            tbl_HConstraint.constant = CGFloat(tblHeight)
            tbl_currency.isScrollEnabled = false
        }
        else {
            tbl_HConstraint.constant = CGFloat(maxHeight)
            tbl_currency.isScrollEnabled = true
        }
        
        tbl_currency.reloadData()
    }
    
    // MARK:- ButtonActions
    @IBAction func menuHiddenButtonClicked(_ sender: UIButton) {
        self.isHidden = true
    }
}

extension CurrencyView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrom == "Lang" {
            return language_array.count
        } else {
            return currencyList_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyFlagsCell") as? CurrencyFlagsCell
        if cell == nil {
            tableView.register(UINib(nibName: "CurrencyFlagsCell", bundle: nil), forCellReuseIdentifier: "CurrencyFlagsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyFlagsCell") as? CurrencyFlagsCell
        }
        
        if indexPath.row % 2 == 0 {
            cell?.bg_view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        } else {
            cell?.bg_view.backgroundColor = .white
        }
        
        cell?.right_view.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        cell?.right_view.isHidden = false
        
        if isFrom == "Lang" {
            
            // display information...
            let language = language_array[indexPath.row]
            cell?.lbl_countryName.text = language //Localization(key: language)
            cell?.img_flag.image = UIImage.init(named: String.init(format: "%@.png", language))
            
            cell?.right_view.isHidden = true
            
        } else  {
            
            let model = currencyList_array[indexPath.row]
            
            // display information...
            cell?.lbl_countryName.text = model.currency_country
            cell?.img_flag.image = UIImage.init(named: String.init(format: "%@.png", model.currency_country!))
            
            var symbol = model.currency_symbol ?? ""
            if symbol.isEmpty {
                symbol = model.currency_country ?? ""
            }
            
            cell?.lbl_currencySymbol.text = symbol
            
            // selection color...
            cell?.lbl_countryName.textColor = UIColor.black
            
            // downline...
            cell?.lbl_line.isHidden = false
            if (currencyList_array.count - 1) == indexPath.row {
                cell?.lbl_line.isHidden = true
            }
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         // call delegate...
        if isFrom == "Lang" {
            delegate_lang?.language_Action(lang: language_array[indexPath.row])
        } else {
            delegate?.currencyListActions(model: currencyList_array[indexPath.row])
        }
        
        self.isHidden = true

    }
}
