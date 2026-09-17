//
//  FlightAddOnsCell.swift
//  MTM
//
//  Created by Nandu on 22/12/23.
//

import UIKit

protocol FlightAddMealsDelegate {
    func flightAddMeals(mealsIndex: Int, cell: UITableViewCell)
}

class FlightAddOnsCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_meals: UITableView!
    @IBOutlet weak var hei_tblConstraint: NSLayoutConstraint!
    
    var delegate: FlightAddMealsDelegate?
    var meals_array: [DFlightMealsItem] = []
    var meals_model: DFlightMealsItem?
    var baggage_model: DFlightBaggageItem?
    var baggage_array: [DFlightBaggageItem] = []
    var isFrom = ""
    var token = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tbl_meals.delegate = self
        tbl_meals.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayFlightMeals_Info(loArr:[DFlightMealsItem], model: DFlightMealsItem) {
        
        isFrom = "Meals"
        meals_array = loArr
        meals_model = model
        tbl_meals.reloadData()
 
        hei_tblConstraint.constant = CGFloat(60 * meals_array.count)
    }
    
    func displayFlightBaggage_Info(loArr:[DFlightBaggageItem], model: DFlightBaggageItem) {
        
        isFrom = "Baggage"
        baggage_array = loArr
        baggage_model = model
        tbl_meals.reloadData()
        
        hei_tblConstraint.constant = CGFloat(60 * baggage_array.count)
    }
}


extension FlightAddOnsCell: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFrom == "Baggage" {
            return baggage_array.count
        } else {
            return meals_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FlightMealsCell") as? FlightMealsCell
        if cell == nil {
            tableView.register(UINib(nibName: "FlightMealsCell", bundle: nil), forCellReuseIdentifier: "FlightMealsCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FlightMealsCell") as? FlightMealsCell
        }
        
        if isFrom == "Baggage" {
            
            // display information...
            cell?.displayFlightBaggage_Info(model: baggage_array[indexPath.row], modelS: baggage_model!)
            
            cell?.lbl_sep.isHidden = false
            if (baggage_array.count - 1) == indexPath.row {
                cell?.lbl_sep.isHidden = true
            }
        }
        else {
            
            // display information...
            cell?.displayFlightMeals_Info(model: meals_array[indexPath.row], modelS: meals_model!)
            
            cell?.lbl_sep.isHidden = false
            if (meals_array.count - 1) == indexPath.row {
                cell?.lbl_sep.isHidden = true
            }
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.flightAddMeals(mealsIndex: indexPath.row, cell: self)
    }
}
