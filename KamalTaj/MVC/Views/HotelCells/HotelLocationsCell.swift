//
//  HotelLocationsCell.swift
//  HotelsHeroes
//
//  Created by Anand S on 23/05/23.
//

import UIKit

// protocol...
protocol flitersHotelLocationCellDelegate {
    func selectLocationButton_Action(sender: UIButton, cell: UITableViewCell)
}

class HotelLocationsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lbl_locationName: UILabel!
    @IBOutlet weak var btn_checkMark: UIButton!
    @IBOutlet weak var img_checkMark: UIImageView!
    
    var delegate: flitersHotelLocationCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayLocation_infomration(location_name: String, selection_array: [String]) {
        
        // display airline names....
        lbl_locationName.text = location_name
        //btn_checkMark.setImage(UIImage.init(named: "ic_check"), for: .normal)
        img_checkMark.image = UIImage.init(named: "ic_uncheck")
        if selection_array .contains(location_name) {
            img_checkMark.image = UIImage.init(named: "ic_check")
            //btn_checkMark.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
    }
    
    // MARK:- ButtonActions
    @IBAction func selectLocation_ButtonClicked(_ sender: UIButton) {
        delegate?.selectLocationButton_Action(sender: sender, cell: self)
    }
    
}
