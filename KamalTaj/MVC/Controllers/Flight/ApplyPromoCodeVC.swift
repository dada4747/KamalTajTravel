//
//  ApplyPromoCodeVC.swift
//  EasiTripBooking
//
//  Created by Rahul on 15/04/25.
//

import UIKit

class ApplyPromoCodeVC: UIViewController {
    var promoCodeArray : [DCommonTopOfferItems] = []
    var promoCodeDelegate : PromoCodeDelegate?
    var selectedPromoCode : DCommonTopOfferItems?
    @IBOutlet weak var tbl_promoCode: UITableView!

    @IBOutlet weak var tbl_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_header: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view_header.viewShadow()
        tbl_promoCode.delegate = self
        tbl_promoCode.dataSource = self

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonAction(_ sender : Any){
        self.dismiss(animated: true, completion: nil)

    }
    
    func totalHeightofTableview(){
        var totalHeight: CGFloat = 0

        for section in 0..<tbl_promoCode.numberOfSections {
            for row in 0..<tbl_promoCode.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = tbl_promoCode.cellForRow(at: indexPath) {
                    totalHeight += cell.frame.height
                } else {
                    // If cell is not visible yet, manually calculate height
                    totalHeight += tbl_promoCode.delegate?.tableView?(tbl_promoCode, heightForRowAt: indexPath) ?? tbl_promoCode.rowHeight
                }
            }
        }
        tbl_HConstraint.constant = totalHeight
        tbl_promoCode.reloadData()
    }
}

extension ApplyPromoCodeVC : UITableViewDelegate, UITableViewDataSource , ApplyPromoDelegate {
    func didCopyPromoCode(message: String) {
        
    }
    
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 1
            count = promoCodeArray.count
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTVCell") as? PromoCodeTVCell
        if cell == nil {
            tableView.register(UINib(nibName: "PromoCodeTVCell", bundle: nil), forCellReuseIdentifier: "PromoCodeTVCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTVCell") as? PromoCodeTVCell
        }

        
        cell?.display(model: promoCodeArray[indexPath.row])
        
        cell?.delegate = self
        if self.selectedPromoCode?.promoCode == promoCodeArray[indexPath.row].promoCode {
            cell?.btn_apply.setTitle("Selected", for: .normal)
            cell?.btn_apply.borderColor = UIColor(hexString: "#4CAF50")
            cell?.btn_apply.setTitleColor(UIColor(hexString: "#4CAF50"), for: .normal)
        }else{
            cell?.btn_apply.setTitle("Select", for: .normal)
            cell?.btn_apply.borderColor = UIColor(hexString: "#868686")
            cell?.btn_apply.setTitleColor(UIColor(hexString: "#868686"), for: .normal)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func selectPromoCode(promoCode: DCommonTopOfferItems) {
        promoCodeDelegate?.selectedPromoCode(promoCode: promoCode)
        self.dismiss(animated: true, completion: nil)
    }
}

