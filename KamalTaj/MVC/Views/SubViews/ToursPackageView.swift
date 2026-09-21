//
//  ToursPackageType.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit
//MARK: - Protocols
protocol PackageTypeDelegate {
    func selectedPackage(holidayTypId: String, holidayName: String)
}
protocol PackageDurationDelegate {
    func selectedDuration(duration: String)
}
protocol PackageAmountDelegate {
    func selectedAmount(pkgAmount: String)
}
protocol CountryNamesDelegate {
    func selectedCountry(countryName: String)
}
protocol PromoCodeDelegate {
    func selectedPromoCode(promoCode: DCommonTopOfferItems)
}

//protocol BoardingPointsDelegate{
//    func selectedBoardingPoint(model: DPickupDropItem)
//}
//protocol DropingPointDelegate {
//    func selctedDropPoint(model: DPickupDropItem)
//}

//MARK: - Enums
enum PackageType {
    case AllPackageType
    case PackageDuration
    case PackageAmount
    case CountryNames
    case PromoCodes
    case BoardingPoints
    case DropPoints
    case AllFacilities
    
}

class ToursPackageView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_pakage: UITableView!
    @IBOutlet weak var tbl_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    //MARK: - Variables
    var packageType: PackageType = .AllPackageType
    var packageTypeArray : [[String: Any]] = []
    var packageDurationArray : [Any] = []
    var packageAmountArray : [String] = []
    var facility_array: [String] = []
//    var boardingPointArray : [DPickupDropItem] = []
//    var dropPointArray : [DPickupDropItem] = []

    
    var promoCodeArray : [DCommonTopOfferItems] = []
    var pkgTypDelegate: PackageTypeDelegate?
    var pkgDurationDelegate: PackageDurationDelegate?
    var allTypDelegate: PackageAmountDelegate?
    var countryDelegate : CountryNamesDelegate?
    var promoCodeDelegate : PromoCodeDelegate?
//    var boardingDelegate : BoardingPointsDelegate?
//    var droppingDelegate : DropingPointDelegate?

    //MARK: - Override Methods
    override func draw(_ rect: CGRect) {
        print("called : %@", self)
        self.tbl_pakage.delegate = self
        self.tbl_pakage.dataSource = self
    }
    
    class func loadViewFromNib() -> UIView {
        // load xib view...
        let view = Bundle.main.loadNibNamed("ToursPackageView", owner: self, options: nil)?.first as? ToursPackageView
        view?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        return view!
    }
    
    //MARK: - IB Actions
    @IBAction func hide_viewButton(_ sender: UIButton) {
        self.isHidden = true
    }
    @IBAction func close_ButtonClicked(_ sender: UIButton) {
        self.isHidden = true
    }
    //MARK: - Display Information
    func displayInfo() {
        var maxHeight: Float = Float(UIScreen.main.bounds.size.height)
        maxHeight = maxHeight - 100
        // current table height...
        var tblHeight = 0
        if packageType == .AllPackageType {
            lbl_title.text = "Select Package Type" //Localization(key: "Select Language")
            tblHeight = (packageTypeArray.count * 60) + 90
            viewWidth.constant = self.bounds.width - 40
        } else if packageType == .PackageDuration {
            lbl_title.text = "Select Duration" //Localization(key: "Select Currency")
            tblHeight = (packageDurationArray.count * 60) + 90
        } else if packageType == .PackageAmount {
            lbl_title.text = "Select Budget"
            tblHeight = (packageAmountArray.count * 60) + 90
        } else if packageType == .CountryNames {
            lbl_title.text = "Countries"
//            tblHeight = (countryArray.count * 45) + 50
            viewWidth.constant = self.bounds.width - 40
        } else if packageType == .PromoCodes {
            lbl_title.text = "Select PromoCode"
            tblHeight = (promoCodeArray.count * 45) + 90
        }else if  packageType == .AllFacilities {
            lbl_title.text = "Facilities"
            tblHeight = (facility_array.count * 45) + 50

        }
//        else if packageType == .BoardingPoints {
//            lbl_title.text = "Select Boarding Point"
//            tblHeight =  (boardingPointArray.count * 70) + 90
//            viewWidth.constant = self.bounds.width - 40
//
//        }else if packageType == .DropPoints {
//            lbl_title.text = "Select Dropping Point"
//            tblHeight = (dropPointArray.count * 70) + 90
//            viewWidth.constant = self.bounds.width - 40
//        }
        if maxHeight >= Float(tblHeight) {
            tbl_HConstraint.constant = CGFloat(tblHeight)
            tbl_pakage.isScrollEnabled = false
        }
        else {
            tbl_HConstraint.constant = CGFloat(maxHeight)
            tbl_pakage.isScrollEnabled = true
        }
        
        tbl_pakage.reloadData()
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension ToursPackageView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 1
        if packageType == .AllPackageType {
            count = packageTypeArray.count
        } else if packageType == .PackageDuration {
            count = packageDurationArray.count
        } else if packageType == .PackageAmount {
            count = packageAmountArray.count
        } else if packageType == .CountryNames {
//            count = countryArray.count
        } else if packageType == .PromoCodes {
            count = promoCodeArray.count
        } else if packageType == .AllFacilities{
            count = facility_array.count

        }
//          else if packageType == .BoardingPoints {
//            count = boardingPointArray.count
//        } else if packageType == .DropPoints {
//            count = dropPointArray.count
//        }
        else {
            count = 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if packageType == .PromoCodes {
            return 45
        }else if packageType == .BoardingPoints || packageType == .DropPoints {
            return UITableView.automaticDimension
            
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if packageType == .AllFacilities {
//            var cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
//            if cell == nil {
//                tableView.register(UINib(nibName: "FacilityCell", bundle: nil), forCellReuseIdentifier: "FacilityCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
//            }
//            cell?.lbl_facility.text = facility_array[indexPath.row]
//            cell?.selectionStyle = .none
//            return cell!
            return UITableViewCell()
    }else{
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchCitiesCell", bundle: nil), forCellReuseIdentifier: "SearchCitiesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        }
        
        if packageType == .AllPackageType {
            cell?.lbl_citiesName.text = packageTypeArray[indexPath.row]["package_types_name"] as? String
        }else if packageType == .PackageDuration {
            cell?.lbl_citiesName.text = packageDurationArray[indexPath.row] as? String
        } else if packageType == .PackageAmount {
            cell?.lbl_citiesName.text = packageAmountArray[indexPath.row]
        } else if packageType == .CountryNames {
//            cell?.lbl_citiesName.text = countryArray[indexPath.row].name
        } else if packageType == .PromoCodes {
            cell?.lbl_citiesName.text = promoCodeArray[indexPath.row].promoCode
        }
//        else if packageType == .BoardingPoints {
//            cell?.lbl_citiesName.numberOfLines = 0
//            cell?.lbl_citiesName.text = "\( boardingPointArray[indexPath.row].time ?? "") - \(boardingPointArray[indexPath.row].name ?? "")"
//        }else if packageType == .DropPoints {
//            cell?.lbl_citiesName.numberOfLines = 0
//            cell?.lbl_citiesName.text = "\( dropPointArray[indexPath.row].time ?? "") - \(dropPointArray[indexPath.row].name ?? "")"
//        }
            cell?.selectionStyle = .none
            return cell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if packageType == .AllPackageType {
            pkgTypDelegate?.selectedPackage(holidayTypId: (packageTypeArray[indexPath.row]["package_types_id"] as? String)!, holidayName: (packageTypeArray[indexPath.row]["package_types_name"] as? String)!)
            self.isHidden = true

        } else if packageType == .PackageDuration {
            pkgDurationDelegate?.selectedDuration(duration: (packageDurationArray[indexPath.row] as? String)!)
            self.isHidden = true

        } else if packageType == .PackageAmount {
            allTypDelegate?.selectedAmount(pkgAmount: packageAmountArray[indexPath.row])
            self.isHidden = true

        } else if packageType == .CountryNames {
//            countryDelegate?.selectedCountry(countryName: countryArray[indexPath.row].name)
            self.isHidden = true
        } else if packageType == .PromoCodes {
            promoCodeDelegate?.selectedPromoCode(promoCode: promoCodeArray[indexPath.row])
            self.isHidden = true
        }
//        else if packageType == .BoardingPoints {
//            boardingDelegate?.selectedBoardingPoint(model: boardingPointArray[indexPath.row])
//            self.isHidden = true
//        }else if packageType == .DropPoints {
//            droppingDelegate?.selctedDropPoint(model: dropPointArray[indexPath.row])
//            self.isHidden = true
//
//        }
    }
}
