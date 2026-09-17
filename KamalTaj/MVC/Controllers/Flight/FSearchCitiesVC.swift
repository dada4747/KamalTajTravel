//
//  FSearchCitiesVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol
@objc protocol searchCitiesDelegate {
    
    @objc optional func searchAirport_info(airlineInfo: [String: String])
    @objc optional func searchCountry_info(countryInfo: [String: String])
    @objc optional func searchAirline_info(airlineInfo:[String: Any])
}

// class...
class FSearchCitiesVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tbl_search: UITableView!
    @IBOutlet weak var view_header: CRView!
    
    // variables
    var searchMainArray: [[String: String]] = []
    var searchDisplayArray: [[String: String]] = []
    
    var airlineMainArray: [[String: Any]] = []
    var airlineDisplayArray: [[String: Any]] = []
    
    var isComing = comingType.Airline
    enum comingType {
        case Airline
        case Passenger
        case ISO
        case PrefferAirline
    }
    var delegate: searchCitiesDelegate?
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_header.viewShadow()
        
        // textfield...
        tf_search.delegate = self
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // table deleagtes...
        tbl_search.delegate = self
        tbl_search.dataSource = self
        tbl_search.rowHeight = UITableView.automaticDimension
        tbl_search.estimatedRowHeight = 30.0
        
        // getting display information...
        gettingDisplayInformation()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(countryListGettingNotification(notification:)),
                                               //name: NSNotification.Name(rawValue: CTG_ISONotify), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    func gettingDisplayInformation() {
        
        // getting airline...
        if isComing == .Airline {
            
            tf_search.placeholder = "Please enter airport/city"
            if DStorageModel.airlineArray.count == 0 {
                DStorageModel.gettingAirlinesList()
            }
            searchMainArray = DStorageModel.airlineArray
            textFieldDidChange(tf_search)
        }
        else if isComing == .Passenger || isComing == .ISO {
            
            tf_search.placeholder = "Please enter country"
            if DStorageModel.countriesISO_array.count == 0 {
                
                SwiftLoader.show(animated: true)
                DStorageModel.gettingCountryISOList()
            }
            searchMainArray = DStorageModel.countriesISO_array
            searchDisplayArray = searchMainArray
        }
        else if isComing == .PrefferAirline {
            
            tf_search.placeholder = "Please enter Airline"

            if DStorageModel.prefferedAirlines.count == 0 {
                SwiftLoader.show(animated: true)
                DStorageModel.gettingAirlineCodeList()
            }
                
            airlineMainArray = DStorageModel.prefferedAirlines
            textFieldDidChange(tf_search)

        }
        else {}
            self.tbl_search.reloadData()
        }
    
    @objc func countryListGettingNotification(notification: Notification) {
        
        // display information...
        searchMainArray = DStorageModel.countriesISO_array
        searchDisplayArray = searchMainArray
        
        tbl_search.reloadData()
        
        SwiftLoader.hide()
    }
    
    // MARK: - ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
}

extension FSearchCitiesVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            
            if isComing == .Airline {
                
                // search predicate...
                let predicate: NSPredicate = NSPredicate(format: "(airline_fullName contains[c] %@) OR (airline_code contains[c] %@)", textField.text!, textField.text!)
                let loArray = (searchMainArray as NSArray).filtered(using: predicate) as NSArray
                searchDisplayArray = loArray as! [[String: String]]
            }
            else if isComing == .Passenger || isComing == .ISO {
                
                // search predicate...
                let predicate: NSPredicate = NSPredicate(format: "(name contains[c] %@) OR (isd contains[c] %@)", textField.text!, textField.text!)
                let loArray = (searchMainArray as NSArray).filtered(using: predicate) as NSArray
                searchDisplayArray = loArray as! [[String: String]]
            } else if isComing == .PrefferAirline {
                
//                gettingTransferCitiesList(cityText: textField.text!)
                
                let predicate: NSPredicate = NSPredicate(format: "(name contains[c] %@) OR (code contains[c] %@)", textField.text!, textField.text!)
                let loArray = (airlineMainArray as NSArray).filtered(using: predicate) as NSArray
                airlineDisplayArray = loArray as! [[String: Any]]
            }
            else{}
        }
        else {
            
            if isComing == .Airline {
                
                // search predicate...
                let predicate: NSPredicate = NSPredicate(format: "(airline_top_destination contains[c] %@) OR (airline_top_destination contains[c] %@)", "6", "5")
                let loArray = (searchMainArray as NSArray).filtered(using: predicate) as NSArray
                searchDisplayArray = loArray as! [[String: String]]
                
            } else {
                searchDisplayArray = searchMainArray
            }
        }
        tbl_search.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FSearchCitiesVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == .PrefferAirline {
            return airlineDisplayArray.count
        }
        else {
            return searchDisplayArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchCitiesCell", bundle: nil), forCellReuseIdentifier: "SearchCitiesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        }
        
        // display information...
        if isComing == .Airline {
            cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["airline_city"]! + " (\(searchDisplayArray[indexPath.row]["airline_code"]!))"
        }
        else if isComing == .Passenger {
            cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["name"]
        }
        else if isComing == .ISO {
            cell?.lbl_citiesName.text = "\(String(describing: searchDisplayArray[indexPath.row]["isd"]!)) \(String(describing: searchDisplayArray[indexPath.row]["name"]!))"
        } else if isComing == .PrefferAirline {
            
            cell?.lbl_citiesName.text = "\(String(describing: airlineDisplayArray[indexPath.row]["name"]!)) (\(String(describing: airlineDisplayArray[indexPath.row]["code"]!)))"
        }
        else {}
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isComing == .Airline {
            delegate?.searchAirport_info!(airlineInfo: searchDisplayArray[indexPath.row])
        }
        else if isComing == .Passenger || isComing == .ISO {
            delegate?.searchCountry_info!(countryInfo: searchDisplayArray[indexPath.row])
        }else if isComing == .PrefferAirline {
            
            delegate?.searchAirline_info?(airlineInfo: airlineDisplayArray[indexPath.row])
        }
        else {}
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: false)
    }
    
}
//extension FSearchCitiesVC {
//    func gettingTransferCitiesList(cityText: String) -> Void {
//
//        // params...
//        let params: [String: String] = ["name": cityText] //char
//        print(params)
//        // calling api...
//        VKAPIs.shared.getRequestFormdata(params: params, file: "general/get_airline_code_list", httpMethod: .POST)
//        { (resultObj, success, error) in
//
//            // success status...
//            if success == true {
//                print("Airline List: \(String(describing: resultObj))")
//
//                // response date...
//                if let result_dict = resultObj as? [String: Any] {
//
//                    if let data_array = result_dict["airlinelist"] as? [String: Any] {
//                        if let airlist = data_array["data"] as? [[String: String]] {
//
//                            self.searchMainArray = airlist
//                            self.searchDisplayArray = airlist
////                            self.tbl_search.reloadData()
//
//                        }
//                    }
//                }
//            } else {
//                print("Transfer City error : \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }
//}
