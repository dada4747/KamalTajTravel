//
//  HRoomSelectCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocols...
protocol hRoomSelectCellDelegate {
    
    func addroomButton_Action(sender: UIButton, cell: UITableViewCell)
    func cancelroomButton_Action(sender: UIButton, cell: UITableViewCell)
    func updateSelection_information(refresh_array: [AddRoomModel])
}

// class...
class HRoomSelectCell: UITableViewCell {

    // MARK:- Outlet
    @IBOutlet weak var lbl_roomNo: UILabel!
    @IBOutlet weak var btn_addRoom: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
  
    
    @IBOutlet weak var collection_adultView: UICollectionView!
    @IBOutlet weak var collection_childView: UICollectionView!
    
    @IBOutlet weak var view_childAge1: UIView!
    @IBOutlet weak var collection_childAgeView1: UICollectionView!
    @IBOutlet weak var childAge1_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_childAge2: UIView!
    @IBOutlet weak var collection_childAgeView2: UICollectionView!
    @IBOutlet weak var childAge2_HConstraint: NSLayoutConstraint!
    
    
    // variables...
    var tempRooms_modelArray: [AddRoomModel] = []
    var rModel: AddRoomModel?
    var index_row: Int = 0
    var delegate: hRoomSelectCellDelegate?
    
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // collection delegates...
        collection_adultView.delegate = self
        collection_adultView.dataSource = self
        collection_adultView.register(UINib.init(nibName: "NumbersCCell", bundle: nil), forCellWithReuseIdentifier: "NumbersCCell")
        
        collection_childView.delegate = self
        collection_childView.dataSource = self
        collection_childView.register(UINib.init(nibName: "NumbersCCell", bundle: nil), forCellWithReuseIdentifier: "NumbersCCell")
        
        collection_childAgeView1.delegate = self
        collection_childAgeView1.dataSource = self
        collection_childAgeView1.register(UINib.init(nibName: "ChildAgeCCell", bundle: nil), forCellWithReuseIdentifier: "ChildAgeCCell")
        
        collection_childAgeView2.delegate = self
        collection_childAgeView2.dataSource = self
        collection_childAgeView2.register(UINib.init(nibName: "ChildAgeCCell", bundle: nil), forCellWithReuseIdentifier: "ChildAgeCCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func display_roomsInformation(modelsArray: [AddRoomModel], indexRow: Int) {
        
        // reload informations...
        tempRooms_modelArray = modelsArray
        index_row = indexRow
        lbl_roomNo.text = "Room \(indexRow + 1)"
        
        collection_adultView.reloadData()
        collection_childView.reloadData()
        collection_childAgeView1.reloadData()
        collection_childAgeView2.reloadData()
        
        // button hiddens...
        btn_addRoom.isHidden = true
        btn_cancel.isHidden = false
        if (tempRooms_modelArray.count - 1) == indexRow && tempRooms_modelArray.count != 3 {
            btn_addRoom.isHidden = false
            btn_cancel.isHidden = true
        }
        
        // view hidden...
        view_childAge1.isHidden = true
        view_childAge2.isHidden = true
        childAge1_HConstraint.constant = 0
        childAge2_HConstraint.constant = 0
        
        
        rModel = tempRooms_modelArray[indexRow]
        if rModel?.child_count == 1 {
            view_childAge1.isHidden = false
            childAge1_HConstraint.constant = 90
        }
        else if rModel?.child_count == 2 {
            
            view_childAge1.isHidden = false
            childAge1_HConstraint.constant = 90
            
            view_childAge2.isHidden = false
            childAge2_HConstraint.constant = 90
        }
        else {}
    }
    
    // MARK:- ButtonAction
    @IBAction func addRoomButtonClicked(_ sender: UIButton) {
        delegate?.addroomButton_Action(sender: sender, cell: self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        delegate?.cancelroomButton_Action(sender: sender, cell: self)
    }
}

extension HRoomSelectCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collection_childAgeView1 || collectionView == collection_childAgeView2 {
            return CGSize.init(width: 80, height: 40)
        }
        return CGSize.init(width: 40, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  collection_adultView {
            return 4
        } else if collectionView ==  collection_childView {
            return 3
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collection_adultView || collectionView == collection_childView {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumbersCCell", for: indexPath as IndexPath) as! NumbersCCell
            
            // display informations...
            cell.img_Bg.isHidden = true
            cell.lbl_number.textColor = UIColor.black
            if collectionView == collection_adultView {
                
                // un-select color...
                if indexPath.row >= 4 {
                    cell.lbl_number.textColor = UIColor(hexString: "#FF8A37")// UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                }
                
                // adult list...
                cell.lbl_number.text = "\(indexPath.row + 1)"
                if rModel?.adult_count == (indexPath.row + 1) {
                    cell.img_Bg.isHidden = false
                    cell.lbl_number.textColor = UIColor(hexString: "#FF8A37")// UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
                }
            }
            else {
                
                // un-select color...
                if indexPath.row >= 3 {
                    cell.lbl_number.textColor = UIColor(hexString: "#FF8A37")//UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                }
                
                // child list...
                cell.lbl_number.text = "\(indexPath.row)"
                if rModel?.child_count == indexPath.row {
                    cell.img_Bg.isHidden = false
                    cell.lbl_number.textColor = UIColor(hexString: "#FF8A37")//UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
                }
            }
            
            return cell
        }
        else {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildAgeCCell", for: indexPath as IndexPath) as! ChildAgeCCell
            
            // display informations...
            cell.lbl_number.text = "\(indexPath.row + 2)"
            cell.lbl_number.textColor = UIColor.black//init("#88888D")
            cell.lbl_number.backgroundColor = UIColor.white
            
            if collectionView == collection_childAgeView1 {
                
                // child age - 1
                if rModel?.child_age1 == (indexPath.row + 2) {
                    cell.lbl_number.textColor = UIColor.white
                    cell.lbl_number.backgroundColor = UIColor(hexString: "#FF8A37")// UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
                }
            }
            else {

                // child age - 2
                if rModel?.child_age2 == (indexPath.row + 2) {
                    
                    cell.lbl_number.textColor = UIColor.white
                    cell.lbl_number.backgroundColor = UIColor(hexString: "#FF8A37")// UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // selection actions...
        if collectionView == collection_adultView {
            
            if (indexPath.row + 1) <= 4 {
                tempRooms_modelArray[index_row].adult_count = (indexPath.row + 1)
            } else {
                self.makeToast(message: "Maximum adults 4 only")
            }
        }
        else if collectionView == collection_childView {
            
            if indexPath.row <= 2 {
                tempRooms_modelArray[index_row].child_count = indexPath.row
            } else {
                self.makeToast(message: "Maximum children 2 only")
            }
        }
        else if collectionView == collection_childAgeView1 {
            tempRooms_modelArray[index_row].child_age1 = (indexPath.row + 2)
        }
        else if collectionView == collection_childAgeView2 {
            tempRooms_modelArray[index_row].child_age2 = (indexPath.row + 2)
        }
        else {}
        delegate?.updateSelection_information(refresh_array: tempRooms_modelArray)
    }
}
