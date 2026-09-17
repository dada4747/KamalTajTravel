//
//  HotelGuestTVCell.swift
//  Dreamora
//
//  Created by Rahul on 04/08/25.
//

import UIKit
protocol guestFormCellDelegate {
    
    func dobButton_Action(sender: UIButton, cell: UITableViewCell)
    func textFieldDidChange(textField:UITextField, cell: UITableViewCell)
    
    func didTapReturn(textField:UITextField, cell: UITableViewCell)
}
class HotelGuestTVCell: UITableViewCell {
    @IBOutlet weak var lblPaxType: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDob: UITextField!

    @IBOutlet weak var btnDOB: UIButton!

    @IBOutlet weak var view_title: CRView!
    @IBOutlet weak var buttonStackView: UIStackView!
//    var selectedIndex = 0
    var onTitleChanged: ((String) -> Void)?
    var delegate: guestFormCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtFirstName.returnKeyType = .next
        txtLastName.returnKeyType = .next
        txtDob.returnKeyType = .done
        txtFirstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtLastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//setDefaultTitle()
    }

    func getTitleGenderValue(for title: String) -> (titleValue: String, genderValue: String)? {
        switch title.trimmingCharacters(in: .whitespaces) {
        case "Mr":     return ("1", "1")
        case "Ms":     return ("2", "2")
        case "Miss":   return ("3", "2")
        case "Master", "Mstr": return ("4", "1") // Choose either one for consistency
        case "Mrs":    return ("5", "2")
        default:       return nil
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func textFieldDidChange(_ textField:UITextField){
        delegate?.textFieldDidChange(textField: textField, cell: self)
    }
    
    func displayGuest_information(model: DHPassengerItem) {
        
        txtFirstName.text = model.first_name ?? ""
        txtLastName.text = model.last_name ?? ""
//        txtDob.text = model.dateOf_birth ?? ""
        if model.dateOf_birth != nil {
            
            let displayDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: model.dateOf_birth ?? "")
            txtDob.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: displayDate)
        }
    }

    @IBAction func dobBtnClicked(_ sender: UIButton) {
        delegate?.dobButton_Action(sender: sender, cell: self)
    }
    func configure(with titles: [String], selected: String? = nil) {
            buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for (index, title) in titles.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
                style(button, isSelected: title == selected || (selected == nil && index == 0))
                buttonStackView.addArrangedSubview(button)
            }
        }

        @objc private func titleTapped(_ sender: UIButton) {
            for case let button as UIButton in buttonStackView.arrangedSubviews {
                style(button, isSelected: button == sender)
            }
            onTitleChanged?(sender.title(for: .normal) ?? "")
        }
    private func style(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .appColor : .clear
            button.setTitleColor(isSelected ? .white : .appColor, for: .normal)
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.appColor.cgColor
            button.clipsToBounds = true
        }
}
extension HotelGuestTVCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.didTapReturn(textField: textField, cell: self)
        return false // prevent default behavior
    }
}
