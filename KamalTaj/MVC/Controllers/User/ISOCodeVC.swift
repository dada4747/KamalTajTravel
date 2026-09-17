//
//  ISOCodeVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol countryDailCodeDelegate {
    func countryDailCode(dial_code: [String: String], nationality: [String: Any])
}

class ISOCodeVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var tbl_view: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    
    // variables...
    var delegate: countryDailCodeDelegate?
    
    var countries_array: [[String: String]] = []
    var searchDisplayArray: [[String: String]] = []
    
    var passport_array: [[String: Any]] = []
    var passportDisplay_array: [[String: Any]] = []
    
    var DCatType = catType.ISOCode
    enum catType {
        case ISOCode
        case Nationality
        case ISOCodeProfile
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DCatType == .ISOCode ||  DCatType == .ISOCodeProfile || DCatType == .Nationality {
            searchDisplayArray = countries_array
        }
        else {
            passportDisplay_array = passport_array
        }

        // textfield...
        txt_search.placeholder = "Search by country name"
        txt_search.delegate = self
        txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // delegates...
        tbl_view.delegate = self
        tbl_view.dataSource = self
        
        tbl_view.rowHeight = UITableView.automaticDimension
        tbl_view.estimatedRowHeight = 60
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func hiddenButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension ISOCodeVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            
            if DCatType == .ISOCode || DCatType == .ISOCodeProfile || DCatType == .Nationality {

                // search predicate...
                let predicate: NSPredicate = NSPredicate(format: "(Country contains[c] %@) OR (DialCode contains[c] %@)", textField.text!, textField.text!)
                let loArray = (countries_array as NSArray).filtered(using: predicate) as NSArray
                searchDisplayArray = loArray as! [[String: String]]
            }
            else {
                
                // search predicate...
                let predicate: NSPredicate = NSPredicate(format: "(country_name contains[c] %@)", textField.text!, textField.text!)
                let loArray = (passport_array as NSArray).filtered(using: predicate) as NSArray
                passportDisplay_array = loArray as! [[String: Any]]
            }
        }
        else {
            if DCatType == .ISOCode || DCatType == .ISOCodeProfile || DCatType == .Nationality {
                searchDisplayArray = countries_array
            }
            else {
                passportDisplay_array = passport_array
            }
        }
        tbl_view.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- UITableViewDelegate
extension ISOCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DCatType == .ISOCode || DCatType == .ISOCodeProfile || DCatType == .Nationality {
            return (35 * xScale)
        }
        else {
            return (35 * xScale)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if DCatType == .ISOCode || DCatType == .ISOCodeProfile || DCatType == .Nationality {
            return searchDisplayArray.count
        }
        else {
            return passportDisplay_array.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if DCatType == .Nationality {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            
            let countryName = searchDisplayArray[indexPath.row]["Country"] ?? ""
            cell?.lbl_title.text = countryName
            
            
            cell?.selectionStyle = .none
            return cell!
            
            
        }else{
            
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as? CountryCodeCell
        if cell == nil {
            tableView.register(UINib(nibName: "CountryCodeCell", bundle: nil), forCellReuseIdentifier: "CountryCodeCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as? CountryCodeCell
        }
//        cell?.lbl_countryCode.isHidden = false
//        if DCatType == .ISOCodeProfile {
//            cell?.lbl_countryCode.isHidden = true
//        }
        
        // display elements...
        
        let dialCode = searchDisplayArray[indexPath.row]["DialCode"] ?? ""
        let countryName = searchDisplayArray[indexPath.row]["Country"] ?? ""
        cell?.lbl_countryName.text = countryName + "  " + dialCode

        if DCatType == .Nationality {
            cell?.lbl_countryName.text =  countryName

        }
        
        let img_iso = searchDisplayArray[indexPath.row]["ISOCode"] ?? ""
        cell?.img_flag.image = UIImage.init(named: String.init(format: "%@.png", img_iso.lowercased()))
        
        cell?.selectionStyle = .none
        return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if DCatType == .ISOCode || DCatType == .ISOCodeProfile || DCatType == .Nationality {
            // call delegates...
            delegate?.countryDailCode(dial_code: searchDisplayArray[indexPath.row], nationality: [:])
        }
        else {
            //call delegates..
            //delegate?.countryISOCode(dial_code: [:], nationality: passportDisplay_array[indexPath.row])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

