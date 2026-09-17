//
//  SearchHotelCitiesVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

// protocol
@objc protocol searchHotelCitiesDelegate {
    @objc optional func searchHotel_info(hotelInfo: [String: Any])
}

// class...
class SearchHotelCitiesVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tbl_search: UITableView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var view_searchHeader: UIView!
    // variables
    var searchMainArray: [[String: Any]] = []
    var searchDisplayArray: [[String: Any]] = []

    var delegate: searchHotelCitiesDelegate?
    
    // MARK:- LifeCycle
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
        tbl_search.estimatedRowHeight = 48
        
        gettingDisplayInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helpers
    func gettingDisplayInformation() {
        
        // getting airline...
        tf_search.placeholder = "Please enter city"
//        if DStorageModel.hotelCitiesArray.count == 0 {
//            DStorageModel.gettingHotelCitiesList()
//        }
//        searchMainArray = DStorageModel.hotelCitiesArray
        textFieldDidChange(tf_search)
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchHotelCitiesVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            gettingAirportCodeList(text: textField.text!)
            // search predicate...
            let predicate: NSPredicate = NSPredicate(format: "(country contains[c] %@) OR (city contains[c] %@)", textField.text!, textField.text!)
            let loArray = (searchMainArray as NSArray).filtered(using: predicate) as NSArray
            searchDisplayArray = loArray as! [[String: String]]
        }
//        else {
//            searchDisplayArray = searchMainArray
//        }
        tbl_search.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension SearchHotelCitiesVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDisplayArray.count
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
        cell?.lbl_citiesName.text = (searchDisplayArray[indexPath.row]["Destination"] as? String ?? "") + ", " + (searchDisplayArray[indexPath.row]["country"] as? String ?? "")
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchHotel_info!(hotelInfo: searchDisplayArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
//https://dreamoura.com/dev/mobile_webservices/mobile/index.php/general/get_hotel_cities
extension SearchHotelCitiesVC {
    func gettingAirportCodeList(text: String) -> Void {
        
        let params: [String: String] = ["city_name": text]
        print(params)
        VKAPIs.shared.getRequestFormdata(params: params, file: "general/get_hotel_cities", httpMethod: .POST)
        { (resultObj, success, error) in

            // success status...
            if success == true {
                print("Airport Code List: \(String(describing: resultObj))")
                
                // Make sure resultObj is an array of dictionaries
                if let dataArray = resultObj as? [[String: Any]] {
                    
                    // Assign directly to your array
                    self.searchMainArray = dataArray
                    self.searchDisplayArray = dataArray
                    // Reload table
                    self.tbl_search.reloadData()
                    
                } else {
                    print("Error: resultObj is not in expected format ([[String: Any]])")
                }
                
            } else {
                print("Airport Code List error: \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
}
