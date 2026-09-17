//
//  BSearchCitiesVC.swift
//  EasiTripBooking
//
//  Created by Admin on 07/11/25.
//

import UIKit

// protocol
@objc protocol searchBusesCitiesDelegate {
    @objc optional func searchBus_info(busInfo: [String: Any])
}

class BSearchCitiesVC: UIViewController {
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tbl_search: UITableView!
    @IBOutlet weak var view_header: UIView!
    
    var searchMainArray: [[String: Any]] = []
    var searchDisplayArray: [[String: Any]] = []
    
    var delegate: searchBusesCitiesDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        gettingDisplayInformation()
        
        getBusesCityAutoComplete(cityText: "")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helpers
    func gettingDisplayInformation() {
        
        // getting airline...
        tf_search.placeholder = "Please enter city"
        if DStorageModel.busCitiesArray.count == 0 {
            DStorageModel.gettingBusesCitiesList()
        }
        searchMainArray = DStorageModel.busCitiesArray
        textFieldDidChange(tf_search)
        
        tbl_search.reloadData()
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
}
extension BSearchCitiesVC : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            getBusesCityAutoComplete(cityText: textField.text!)
        }
        else {
            getBusesCityAutoComplete(cityText: "")
        }
        tbl_search.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension BSearchCitiesVC :  UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
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
        cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["label"] as? String ?? ""
     
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchBus_info!(busInfo: searchDisplayArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

extension BSearchCitiesVC {
    
    //MARK: - Api's
    func getBusesCityAutoComplete(cityText: String) -> Void {
        
        // params...
        let params: [String: String] = ["term": cityText]
        
        // calling api...
        VKAPIs.shared.getRequest(params: params, file: BUSES_AutoComplete, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Show Around City List: \(String(describing: resultObj))")
                
                if let result_array = resultObj as? [[String: Any]] {
                    
                    self.searchMainArray = result_array
                    self.searchDisplayArray = result_array
                    self.tbl_search.reloadData()
                }
                else {
                    print("Show Around City response formate : \(String(describing: resultObj))")
                }
            } else {
                print("Show Around City error : \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
