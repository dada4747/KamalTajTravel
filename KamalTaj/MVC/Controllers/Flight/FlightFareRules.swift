//
//  FlightFareRules.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FlightFareRules: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tbl_fairRules: UITableView!
    @IBOutlet weak var view_header: CRView!
    var fairRules_array: [DFairRulesModel] = []
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_header.viewShadow()
//        view.backgroundColor = .appColor
        
        // delegates...
        tbl_fairRules.delegate = self
        tbl_fairRules.dataSource = self
        tbl_fairRules.rowHeight = UITableView.automaticDimension
        tbl_fairRules.estimatedRowHeight = 120
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - ButtonAction
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FlightFareRules: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fairRules_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FFareRulesCell") as? FFareRulesCell
        if cell == nil {
            tableView.register(UINib(nibName: "FFareRulesCell", bundle: nil), forCellReuseIdentifier: "FFareRulesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FFareRulesCell") as? FFareRulesCell
        }
        
        // display information...
        cell?.displayFair_rulesInformation(fairModel: fairRules_array[indexPath.row])
        cell?.selectionStyle = .none
        return cell!
    }
}

