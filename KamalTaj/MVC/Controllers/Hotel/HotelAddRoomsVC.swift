//
//  HotelAddRoomsVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

// protocol...
protocol hotelAddRoomsDelegate {
    func hotelAddRoom_SelectionAction()
}

// class...
class HotelAddRoomsVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var tbl_rooms: UITableView!
    @IBOutlet weak var tbl_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_header: UIView!
    
    // variables...
    var roomList_array: [AddRoomModel] = []
    var delegate: hotelAddRoomsDelegate?
    
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_header.viewShadow()
        
        roomList_array = AddRoomModel.addRooms_array
        
        // delegates...
        tbl_rooms.delegate = self
        tbl_rooms.dataSource = self
        tbl_rooms.rowHeight = UITableView.automaticDimension
        tbl_rooms.estimatedRowHeight = 240
        tableHeightCalculation_ReloadInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Helpers
    func tableHeightCalculation_ReloadInformation() {
        
        // relaod table...
        tbl_rooms.reloadData()
        
        // height calculation...
        var heightVal: Float = 0.0
        for model in roomList_array {
            if model.child_count == 1 {
                heightVal = heightVal + 330
            }
            else if model.child_count == 2 {
                heightVal = heightVal + 420
            }
            else {
                heightVal = heightVal + 240
            }
        }
        tbl_HConstraint.constant = CGFloat(heightVal)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        
        // reload room counts...
        AddRoomModel.addRooms_array = roomList_array
        delegate?.hotelAddRoom_SelectionAction()
        self.navigationController?.popViewController(animated: true)
    }
}

extension HotelAddRoomsVC: UITableViewDelegate, UITableViewDataSource, hRoomSelectCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HRoomSelectCell") as? HRoomSelectCell
        if cell == nil {
            tableView.register(UINib(nibName: "HRoomSelectCell", bundle: nil), forCellReuseIdentifier: "HRoomSelectCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HRoomSelectCell") as? HRoomSelectCell
        }
        cell?.delegate = self
        cell?.display_roomsInformation(modelsArray: roomList_array, indexRow: indexPath.row)
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK:- hRoomSelectCellDelegate
    func addroomButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        let model = AddRoomModel()
        roomList_array.append(model)
        tableHeightCalculation_ReloadInformation()
    }
    
    func cancelroomButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // remove elements...
        let indexPath = tbl_rooms .indexPath(for: cell)
        roomList_array.remove(at: (indexPath?.row)!)
        tableHeightCalculation_ReloadInformation()
    }
    
    func updateSelection_information(refresh_array: [AddRoomModel]) {
        roomList_array = refresh_array
        tableHeightCalculation_ReloadInformation()
    }
}

