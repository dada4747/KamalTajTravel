//
//  TablePopView.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol ISOCodeDelegate {
    func countryISOCode(dial_code: [String: String])
}

protocol PassportCountryDelegate {
    func passPortCountry(issued_Country: [String: Any])
}

//protocol AvailableDatesDelegate {
//    func packageAvailableDates(model: DPackageAvailableDatesItem)
//}
protocol TransferAvailableDatesDelegate {
    func TransferAvailable_Dates(selected_date: Any)
}

protocol TravellerTitleDelegate {
    func travellerTitle(title: String)
    
}
protocol  TravellerTitleCellDelegate {
    func travellerTitleForcell(title: String, indexPath: IndexPath)
}
protocol TravellerCategoryDelegate {
    func travellerTypeWithCell(title: String, indexPath: IndexPath)
}
protocol StateDelegates {
    func selectedState(state: [String: String])
}

protocol CustomDelegate {
    func CustomListDropDownSelection(selected_Str: String, selectedIndex: Int)
}

class TablePopView: UIView {

    // MARK:- Outlets
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var tbl_view: UITableView!
    
    // variables...
    var delegate: ISOCodeDelegate?
    var delegate_ppCountry: PassportCountryDelegate?
    var delegate_dates: TransferAvailableDatesDelegate?
    var delegate_title: TravellerTitleDelegate?
    var delegate_titleCell: TravellerTitleCellDelegate?
    var delegate_travellerType: TravellerCategoryDelegate?
    var delegate_stateArray: StateDelegates?
    var delegate_Custom: CustomDelegate?
//    var delegateDates: AvailableDatesDelegate?

    var state_array: [[String: String]] = []
    var countries_array: [[String: String]] = []
    var passport_array: [[String: Any]] = []
    var availableDates_array: [Any] = []
    var title_array: [String] = []
    var customArray: [Any] = []
//    var availableDatesArray: [DPackageAvailableDatesItem] = []

    var position_frame: CGRect = CGRect.zero
    var customIndex: IndexPath?// = 0
    var DType = cateType.CountryISO
    enum cateType {
        case CountryISO
        case PassPortCountry
        
        case AvailableDates
        case Title
        case TitleCell
        case TravellerType
        case State
        case Custom
        case Dates
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // delegates...
        tbl_view.delegate = self
        tbl_view.dataSource = self
        
        tbl_view.rowHeight = UITableView.automaticDimension
        tbl_view.estimatedRowHeight = 60
        
        tbl_view.reloadData()
    }
    
    func changeMainView_Frame(rect: CGRect) -> Void {
        
        var float_height = (40 * xScale * 4)
        
        if DType == .PassPortCountry {
            if passport_array.count < 4 {
                float_height = (40 * xScale * CGFloat(passport_array.count))
            }
        } else if DType == .CountryISO {
            if countries_array.count < 4 {
                
                float_height = (40 * xScale * CGFloat(countries_array.count))
            }
        } else if DType == .Title {
            if title_array.count < 4 {
                float_height = (30 * xScale * CGFloat(title_array.count))
            }
        }else if DType == .TitleCell {
            if title_array.count < 4 {
                float_height = (30 * xScale * CGFloat(title_array.count))
            }
        }else if DType == .TravellerType {
            if title_array.count < 4 {
                float_height = (30 * xScale * CGFloat(title_array.count))
            }
        }else if DType == .State {
            if state_array.count < 4 {
                float_height = (40 * xScale * CGFloat(state_array.count))
            }
        }else if DType == .Custom {
            if customArray.count < 4 {
                float_height = (30 * xScale * CGFloat(customArray.count))
            }
        } else if DType == .Dates {
//            if availableDatesArray.count < 10 {
//                float_height = (40 * xScale * CGFloat(availableDatesArray.count))
//            }
        } else {
            if availableDates_array.count < 10 {
                float_height = (40 * xScale * CGFloat(availableDates_array.count))
            }
        }
       
  
        var y_axis = (rect.origin.y + rect.size.height + 10)
        if self.frame.height <= (y_axis + float_height) {
            y_axis = (rect.origin.y - float_height - 5)
        }
        
        // main view frame changes...
        if DType == .CountryISO {
            let main_rect = CGRect.init(x: rect.origin.x,
                                        y: y_axis,
                                        width: rect.width + 100,
                                        height: float_height)

            view_main.frame = main_rect
        }else{
            let main_rect = CGRect.init(x: rect.origin.x,
                                        y: y_axis,
                                        width: rect.width,
                                        height: float_height)

            view_main.frame = main_rect
        }
    }
    
    @IBAction func hiddenButtonClicked(_ sender: UIButton) {
        
        self.removeFromSuperview()
    }
    
}

// MARK:- UITableViewDelegate
extension TablePopView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (30 * xScale)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if DType == .PassPortCountry {
            return passport_array.count
        } else if DType == .CountryISO {
            return countries_array.count
        } else if DType == .Title {
            return title_array.count
        } else if DType == .TitleCell {
            return title_array.count
        } else if DType == .TravellerType {
            return title_array.count
        }else if DType == .State {
            return state_array.count
        }else if DType == .Custom{
            return customArray.count
        }  else if DType == .Dates {
            return 0//availableDatesArray.count
        } else {
            return availableDates_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as? CountryCodeCell
        if cell == nil {
            tableView.register(UINib(nibName: "CountryCodeCell", bundle: nil), forCellReuseIdentifier: "CountryCodeCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as? CountryCodeCell
        }
        
        if DType == .PassPortCountry {
            
            cell?.selectionStyle = .none
            return cell!
            
        } else if DType == .CountryISO {
            
            // display elements...
            let country_name = countries_array[indexPath.row]["Country"] ?? "India"
            let dail_code = countries_array[indexPath.row]["DialCode"] ?? "+91"
            cell?.lbl_countryName.text = String.init(format: "%@ (%@)", country_name, dail_code)
            //cell?.lbl_countryCode.text = countries_array[indexPath.row]["DialCode"]
            
            let img_iso = countries_array[indexPath.row]["ISOCode"] ?? ""
            cell?.img_flag.image = UIImage.init(named: String.init(format: "%@.png", img_iso.lowercased()))
            cell?.selectionStyle = .none
            return cell!
            
        } else if DType == .Title {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            
            cell?.lbl_title.text = title_array[indexPath.row]
            return cell!
            
        } else if DType == .TitleCell {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            
            cell?.lbl_title.text = title_array[indexPath.row]
            return cell!
            
        }else if DType == .TravellerType {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            
            cell?.lbl_title.text = title_array[indexPath.row]
            return cell!
            
        }else if DType == .State {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            cell?.lbl_title.text = "\(state_array[indexPath.row]["name"] ?? "") (\(state_array[indexPath.row]["code"] ?? ""))"
            return cell!
        }else if DType == .Custom{
            cell?.lbl_countryName.textAlignment = .center
            cell?.img_width.constant = 0
            cell?.lbl_countryName.text = customArray[indexPath.row] as? String ?? ""
            return cell!
        }else if DType == .Dates {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            
//            cell?.lbl_title.text = availableDatesArray[indexPath.row].dep_date ?? ""
            cell?.selectionStyle = .none
            return cell!
        }
        else {
            
            cell?.lbl_countryName.text = availableDates_array[indexPath.row] as? String ?? ""
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //call delegates..
        if DType == .CountryISO {
            delegate?.countryISOCode(dial_code: countries_array[indexPath.row])
            
        } else if DType == .PassPortCountry {
            delegate_ppCountry?.passPortCountry(issued_Country: passport_array[indexPath.row])
            
        } else if DType == .Title {
            delegate_title?.travellerTitle(title: title_array[indexPath.row])
        } else if DType == .TitleCell {
            delegate_titleCell?.travellerTitleForcell(title: title_array[indexPath.row], indexPath: customIndex!)
        } else if DType == .TravellerType {
            delegate_travellerType?.travellerTypeWithCell(title: title_array[indexPath.row], indexPath: customIndex!)
        } else if DType == .State {
            delegate_stateArray?.selectedState(state: state_array[indexPath.row])
        } else if DType == .Custom {
            delegate_Custom?.CustomListDropDownSelection(selected_Str: customArray[indexPath.row] as? String ?? "", selectedIndex: indexPath.row)
        } else if DType == .Dates {
//            delegateDates?.packageAvailableDates(model: availableDatesArray[indexPath.row])
        }else {
            delegate_dates?.TransferAvailable_Dates(selected_date: availableDates_array[indexPath.row] as? String ?? "")
        }
        
        self.removeFromSuperview()
    }
}




